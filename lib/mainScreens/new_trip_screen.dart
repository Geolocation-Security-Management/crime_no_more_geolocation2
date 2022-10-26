import 'dart:async';

import 'package:crime_no_more_geolocation2/models/event_request_information.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //google map
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newTripGoogleMapController = controller;
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
