import 'package:flutter/material.dart';
import 'dart:async';
import 'package:crime_no_more_geolocation2/authentication/login_screen.dart';
import 'package:crime_no_more_geolocation2/global/global.dart';
import 'package:crime_no_more_geolocation2/mainScreens/main_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      //send user to home screen
      if (await fAuth.currentUser != null) {
        currentFirebaseUser = fAuth.currentUser!;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    }); // Timer
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset("assets/images/crime_no_more_logo.png"),
            const SizedBox(height: 10),
            const Text('Real Time Location Tracking and Crime Reporting',
                style: TextStyle(
                    color: Color.fromARGB(255, 20, 20, 98),
                    fontSize: 17,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold)),
          ]),
        ),
      ),
    );
  }
}
