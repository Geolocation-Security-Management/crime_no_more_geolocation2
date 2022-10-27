import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventRequestInformation {
  LatLng? destinationLatLng;
  String? details;
  String? region;
  String? severity_level;
  String? status;

  EventRequestInformation(
      {this.destinationLatLng,
      this.details,
      this.region,
      this.severity_level,
      this.status});
}
