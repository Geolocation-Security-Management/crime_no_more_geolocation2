import 'package:crime_no_more_geolocation2/global/global.dart';
import 'package:crime_no_more_geolocation2/models/event_request_information.dart';
import 'package:crime_no_more_geolocation2/push_notification/notification_dialog_box.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async {
    //1. Terminated state
    //When the app is completely closed and opened directly from the push notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //display the guards request information - the location and the crime details
        readControlRoomEventRequestInformation(
            remoteMessage.data["eventRequestId"], context);
      }
    });
    //2. Foreground state
    //When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      //display the guards request information - the location and the crime details
      readControlRoomEventRequestInformation(
          remoteMessage?.data["eventRequestId"], context);
    });

    //3. Background state
    //When the app is in the background and opened directly from the push notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      //display the guards request information - the location and the crime details
      readControlRoomEventRequestInformation(
          remoteMessage?.data["eventRequestId"], context);
    });
  }

  readControlRoomEventRequestInformation(
      String eventRequestId, BuildContext context) {
    //specific eventRequestId in the realtime database
    FirebaseDatabase.instance
        .ref()
        .child("event")
        .child(eventRequestId)
        .once()
        .then((snapData) {
      if (snapData.snapshot.value != null) {
        // coordinates of the crime
        double destinationLat = double.parse(
            (snapData.snapshot.value! as Map)["coordinate"]["lat"].toString());
        double destinationLng = double.parse(
            (snapData.snapshot.value! as Map)["coordinate"]["lng"].toString());
        String details =
            (snapData.snapshot.value! as Map)["details"].toString();
        String region = (snapData.snapshot.value! as Map)["region"].toString();
        String severity_level =
            (snapData.snapshot.value! as Map)["severity_level"].toString();
        String status = (snapData.snapshot.value! as Map)["status"].toString();

        EventRequestInformation eventRequestDetails = EventRequestInformation();

        eventRequestDetails.destinationLatLng =
            LatLng(destinationLat, destinationLng); //coordinates of the crime
        eventRequestDetails.details = details;
        eventRequestDetails.region = region;
        eventRequestDetails.severity_level = severity_level;
        eventRequestDetails.status = status;

        showDialog(
          context: context,
          builder: (BuildContext context) => NotificationDialogBox(
            eventRequestDetails: eventRequestDetails,
          ),
        );
      } else {
        Fluttertoast.showToast(msg: "This event Request ID does not exist");
      }
    });
  }

  Future generateAndGetToken() async {
    String? registrationToken = await messaging.getToken();
    print("FCM Registration Token: $registrationToken");
    FirebaseDatabase.instance
        .ref()
        .child("guards")
        .child(currentFirebaseUser.uid)
        .child("token")
        .set(registrationToken);

    messaging.subscribeToTopic("allGuards");
    messaging.subscribeToTopic("controlRoom");
  }
}
