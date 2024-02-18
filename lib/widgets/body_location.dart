import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helloflutter/utility/app_controller.dart';
import 'package:helloflutter/utility/app_service.dart';
import 'package:helloflutter/widgets/widget_icon_button.dart';
import 'package:helloflutter/widgets/widget_map.dart';
import 'package:helloflutter/widgets/widget_text.dart';

class BodyLocation extends StatefulWidget {
  const BodyLocation({super.key});

  @override
  State<BodyLocation> createState() => _BodyLocationState();
}

class _BodyLocationState extends State<BodyLocation> {
  AppController appController = Get.put(AppController());
  @override
  void initState() {
    super.initState();

    AppService().processFindLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => appController.pisitopns.isEmpty
        ? const SizedBox()
        : SizedBox(
            width: Get.width,
            height: Get.height,
            child: Stack(
              children: [
                WidgetMap(
                  lat: appController.pisitopns.last.latitude,
                  lng: appController.pisitopns.last.longitude,
                  myLocationEnable: true,
                ),
                Positioned(
                  top: 32,
                  left: 32,
                  child: WidgetIconButton(
                    iconData: Icons.add,
                    pressFunc: () {
                      AppService().processFindLocation().then((value) {
                        print(appController.pisitopns.last.toString());

                        MarkerId markerId =
                            MarkerId('id${appController.mapMarkers.length}');
                        Marker marker = Marker(
                            markerId: markerId,
                            position: LatLng(
                                appController.pisitopns.last.latitude,
                                appController.pisitopns.last.longitude));

                        appController.mapMarkers[markerId] = marker;
                      });
                    },
                    size: GFSize.MEDIUM,
                    gfButtonType: GFButtonType.outline,
                  ),
                )
              ],
            ),
          ));
  }
}
