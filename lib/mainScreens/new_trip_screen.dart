import 'dart:async';

import 'package:crime_no_more_geolocation2/global/global.dart';
import 'package:crime_no_more_geolocation2/models/event_request_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../assistants/assistant_methods.dart';
import '../widgets/progress_dialog.dart';

class NewTripScreen extends StatefulWidget {
  EventRequestInformation? eventRequestDetails;

  NewTripScreen({this.eventRequestDetails});
  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  late GoogleMapController newTripGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  String? buttonTitle = "Arrived";
  Color? buttonColor = Colors.green;

  Set<Marker> setOfMarkers = Set<Marker>();
  Set<Circle> setOfCircle = Set<Circle>();
  Set<Polyline> setOfPolyline = Set<Polyline>();
  List<LatLng> polyLinePositionCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  double mapPadding = 0;
  BitmapDescriptor? iconAnimatedMarker;
  var geoLocator = Geolocator();
  Position? onlineGuardCurrentPosition;
  //1. originLatLng = guard current location
  //2. destinationLatLng = crime scene location
  Future<void> drawPolyLineFromOriginToDestination(
      LatLng originLatLng, LatLng destinationLatLng) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);

    Navigator.pop(context);

    print("These are points = ");
    print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo.e_points!);

    polyLinePositionCoordinates.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        polyLinePositionCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setOfPolyline.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.purpleAccent,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polyLinePositionCoordinates,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      setOfPolyline.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newTripGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      setOfMarkers.add(originMarker);
      setOfMarkers.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      setOfCircle.add(originCircle);
      setOfCircle.add(destinationCircle);
    });
  }

  createDriverIconMarker() {
    if (iconAnimatedMarker == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car.png")
          .then((value) {
        iconAnimatedMarker = value;
      });
    }
  }

  getGuardsLocationUpdatesAtRealTime() {
    streamSubscriptionGuardLivePosition =
        Geolocator.getPositionStream().listen((Position position) {
      guardCurrentPosition = position;
      onlineGuardCurrentPosition = position;
      LatLng latLngLiveGuardPosition = LatLng(
          onlineGuardCurrentPosition!.latitude,
          onlineGuardCurrentPosition!.longitude);

      Marker animatingMarker = Marker(
        markerId: const MarkerId("AnimatedMarker"),
        position: latLngLiveGuardPosition,
        icon: iconAnimatedMarker!,
        infoWindow: const InfoWindow(title: "This is your Position"),
      );
      setState(() {
        CameraPosition cameraPosition =
            CameraPosition(target: latLngLiveGuardPosition, zoom: 16);
        newTripGoogleMapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        setOfMarkers.removeWhere(
            (element) => element.markerId.value == "AnimatedMarker");
        setOfMarkers.add(animatingMarker);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    createDriverIconMarker();
    return Scaffold(
      body: Stack(
        children: [
          //google map
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            markers: setOfMarkers,
            circles: setOfCircle,
            polylines: setOfPolyline,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newTripGoogleMapController = controller;
              setState(() {
                mapPadding = 270;
              });
              var guardCurrentLatLng = LatLng(guardCurrentPosition!.latitude,
                  guardCurrentPosition!.longitude);

              var destinationLatLng =
                  widget.eventRequestDetails!.destinationLatLng;

              drawPolyLineFromOriginToDestination(
                  guardCurrentLatLng, destinationLatLng!);
            },
          ),

          //ui
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 18,
                    spreadRadius: 0.5,
                    offset: Offset(0.6, 0.6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 18,
                  ),
                  //duration
                  Text(
                    "18 mins",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),
                  //divider
                  const Divider(
                    height: 2,
                    thickness: 8,
                  ),

                  //Crime scene location with icon
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/location.png",
                        width: 50,
                        height: 50,
                      ),
                      //display the location
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.eventRequestDetails!.destinationLatLng!
                                .toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //crime scene details
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/details.png",
                        width: 50,
                        height: 50,
                      ),
                      //display the location
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.eventRequestDetails!.details!.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  //crime scene region
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/region.png",
                        width: 50,
                        height: 50,
                      ),
                      //display the location
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.eventRequestDetails!.region!.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  //crime scene severity
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/severity_level.png",
                        width: 50,
                        height: 50,
                      ),
                      //display the location
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.eventRequestDetails!.severity_level!
                                .toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  //divider
                  const Divider(
                    height: 2,
                    thickness: 8,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                    ),
                    icon: const Icon(
                      Icons.directions_car,
                      color: Colors.white,
                      size: 25,
                    ),
                    label: Text(
                      buttonTitle!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
