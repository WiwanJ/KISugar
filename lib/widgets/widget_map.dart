// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WidgetMap extends StatelessWidget {
  const WidgetMap({
    Key? key,
    required this.lat,
    required this.lng,
    this.myLocationEnable,
  }) : super(key: key);
  final double lat;
  final double lng;
  final bool? myLocationEnable;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, lng),
        zoom: 16,
      ),
      onMapCreated: (controller) {},
      myLocationEnabled: myLocationEnable ?? false,
    );
  }
}
