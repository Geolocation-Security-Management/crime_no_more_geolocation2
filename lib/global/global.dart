import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import '../models/user_model.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;

User currentFirebaseUser = fAuth.currentUser!;
UserModel? userModelCurrentInfo;
late StreamSubscription<Position> streamSubscriptionPosition;
Position? guardCurrentPosition;
