import 'package:flutter/material.dart';
import 'package:crime_no_more_geolocation2/global/global.dart';
import 'package:crime_no_more_geolocation2/splashScreen/splash_screen.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text(
          "Sign Out",
        ),
        onPressed: () {
          fAuth.signOut();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MySplashScreen()));
        },
      ),
    );
  }
}
