import 'dart:async';

import 'package:crime_no_more_geolocation2/push_notification/push_notification_system.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late GoogleMapController newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Position? guardCurrentPosition;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  String statusText = "Now Offline";
  Color buttonColor = Colors.grey;
  bool isGuardActive = false;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateGuardPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    guardCurrentPosition = position;
    LatLng latLngPosition =
        LatLng(guardCurrentPosition!.latitude, guardCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            guardCurrentPosition!, context);
    print("This is the human readable address: $humanReadAddress");
  }

  readCurrentDriverInformation() async {
    currentFirebaseUser = fAuth.currentUser!;
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging();
    pushNotificationSystem.generateAndGetToken();
  }

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
    readCurrentDriverInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locateGuardPosition();
          },
        ),

        //UI for online offline driver
        statusText != "Now Online"
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.black87,
              )
            : Container(),

        //button for online offline driver
        Positioned(
          top: statusText != "Now Online"
              ? MediaQuery.of(context).size.height * 0.46
              : 25,
          left: 0,
          right: 0,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                if (isGuardActive != true) //offline
                {
                  GuardIsOnlineNow();
                  updateGuardsLocationAtRealTime();

                  setState(() {
                    statusText = "Now Online";
                    isGuardActive = true;
                    buttonColor = Colors.transparent;
                  });

                  //display Toast
                  Fluttertoast.showToast(msg: "you are Online now");
                } else {
                  guardIsOfflineNow();
                  setState(() {
                    statusText = "Now Offline";
                    isGuardActive = false;
                    buttonColor = Colors.grey;
                  });

                  //display Toast
                  Fluttertoast.showToast(msg: "you are Offline now");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: statusText != "Now Online"
                  ? Text(
                      statusText,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.phonelink_ring,
                      color: Colors.white,
                      size: 26,
                    ),
            )
          ]),
        ),
      ],
    );
  }

  GuardIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    guardCurrentPosition = pos;
    // same name as the node in realtime database node
    Geofire.initialize("activeGuards");
    Geofire.setLocation(currentFirebaseUser.uid, guardCurrentPosition!.latitude,
        guardCurrentPosition!.longitude);

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("guards")
        .child(currentFirebaseUser.uid)
        .child("newEventStatus"); // newEvents is the node name for the crime

    ref.set("idle"); //searching for crime to attend to
    ref.onValue.listen((event) {});
  }

  updateGuardsLocationAtRealTime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      guardCurrentPosition = position;
      if (isGuardActive == true) {
        Geofire.setLocation(currentFirebaseUser.uid,
            guardCurrentPosition!.latitude, guardCurrentPosition!.longitude);
      }

      LatLng latLng = LatLng(
          guardCurrentPosition!.latitude, guardCurrentPosition!.longitude);

      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  guardIsOfflineNow() {
    Geofire.removeLocation(currentFirebaseUser.uid);
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("guards")
        .child(currentFirebaseUser.uid)
        .child("newEventStatus");

    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(const Duration(milliseconds: 2000), () {
      //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      SystemNavigator.pop();
    });
  }
}
