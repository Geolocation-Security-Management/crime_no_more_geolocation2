import 'package:crime_no_more_geolocation2/assistants/assistant_methods.dart';
import 'package:crime_no_more_geolocation2/global/global.dart';
import 'package:crime_no_more_geolocation2/mainScreens/new_trip_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

import '../models/event_request_information.dart';

class NotificationDialogBox extends StatefulWidget {
  EventRequestInformation? eventRequestDetails;

  NotificationDialogBox({this.eventRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/crime_scene_logo.png",
              width: 140,
            ),
            const SizedBox(
              height: 2,
            ),
            const Text(
              "New Crime Scene Detected!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            //divider
            const Divider(
              height: 2,
              thickness: 8,
            ),
            //crime scene details
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //location with icon
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

                  //add space
                  const SizedBox(
                    height: 20,
                  ),
                  //details with icon
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

                  //add space
                  const SizedBox(
                    height: 20,
                  ),
                  //region with icon
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
                  //severity level with icon
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
                ],
              ),
            ),

            //divider
            const Divider(
              height: 2,
              thickness: 8,
            ),
            //buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //accept button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      //accept the request
                      acceptEventRequest(context);
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 40.0,
                  ),
                  // cancel button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      //cancel the request
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  acceptEventRequest(BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("guards")
        .child(currentFirebaseUser.uid)
        .child("newEventStatus")
        .set("accepted");

    AssistantMethods.pauseLiveLocationUpdates();
    //trip started now - send driver to new tripScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewTripScreen(
          eventRequestDetails: widget.eventRequestDetails,
        ),
      ),
    );
  }
}
