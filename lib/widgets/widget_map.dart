// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helloflutter/utility/app_controller.dart';

class WidgetMap extends StatefulWidget {
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
  State<WidgetMap> createState() => _WidgetMapState();
}

class _WidgetMapState extends State<WidgetMap> {
  AppController appController = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.lat, widget.lng),
            zoom: 16,
          ),
          onMapCreated: (controller) {},
          myLocationEnabled: widget.myLocationEnable ?? false,
          markers: appController.mapMarkers.isEmpty
              ? <Marker>{}
              : Set<Marker>.of(appController.mapMarkers.values),
              polygons: appController.setPolygons,
        ));
  }
}
