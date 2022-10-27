/*import 'package:flutter/material.dart';
import 'package:crime_no_more_geolocation2/mainScreens/main_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crime_no_more_geolocation2/widgets/progress_dialog.dart';
import 'package:crime_no_more_geolocation2/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    // for email
    if (emailTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Email is required");
    } else if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email is invalid");
    }

    //for password
    else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required");
    } else {
      saveGuardInfoNow();
    }
  }

  //save the Guard info into the database
  saveGuardInfoNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(
          message: "Authenticating, Please wait...",
        );
      },
    );

    final User? firebaseUser = (await fAuth
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      Map GuardMap = {
        "id": firebaseUser.uid,
        "name": "Michael",
        "phone": "+14084791231",
        "email": emailTextEditingController.text.trim(),
        "password": passwordTextEditingController.text.trim(),
      };
      //save all the guards info into under the name called "guards"
      DatabaseReference guardsRef =
          FirebaseDatabase.instance.ref().child("guards");
      guardsRef.child(firebaseUser.uid).set(GuardMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "New user account has been created.");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "New user account has not been created.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 66, 166, 248),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 0.1),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset("assets/images/crime_no_more_logo.png"),
              ),
              const SizedBox(height: 1),
              const Text(
                "Login as a security guard",
                style: TextStyle(
                    fontSize: 26,
                    color: Color.fromARGB(255, 253, 254, 255),
                    fontWeight: FontWeight.bold),
              ),
              // For Email
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),

              //for password
              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 30),
              // for button
              ElevatedButton(
                onPressed: () {
                  validateForm();
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const MainScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 82, 178, 202),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ], // children
          ),
        ),
      ),
    );
  }
}
 */