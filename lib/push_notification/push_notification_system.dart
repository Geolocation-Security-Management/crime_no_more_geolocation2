import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging() async {
    //1. Terminated state
    //When the app is completely closed and opened directly from the push notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //display the guards request information - the location and the crime details

      }
    });
    //2. Foreground state
    //When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      //display the guards request information - the location and the crime details
    });

    //3. Background state
    //When the app is in the background and opened directly from the push notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      //display the guards request information - the location and the crime details
    });
  }
}
