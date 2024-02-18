import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helloflutter/utility/app_controller.dart';
import 'package:helloflutter/utility/app_dialog.dart';
import 'package:helloflutter/utility/app_service.dart';
import 'package:helloflutter/widgets/widget_button.dart';
import 'package:helloflutter/widgets/widget_form.dart';
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
  var latlngs = <LatLng>[];

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();

    appController.displaySave.value = false;
    appController.displayAddMarker.value = true;
    if (appController.mapMarkers.isNotEmpty) {
      appController.mapMarkers.clear();

      if (appController.setPolygons.isNotEmpty) {
        appController.setPolygons.clear();
      }
    }
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
                  child: Column(
                    children: [
                      Obx(() => appController.displayAddMarker.value
                          ? WidgetIconButton(
                              iconData: Icons.add,
                              pressFunc: () {
                                AppService()
                                    .processFindLocation()
                                    .then((value) {
                                  print(
                                      appController.pisitopns.last.toString());
                                  //จุดที่จะลากเส้น
                                  latlngs.add(LatLng(
                                      appController.pisitopns.last.latitude,
                                      appController.pisitopns.last.longitude));

                                  //จุดที่ปักหมุดสีแดง
                                  MarkerId markerId = MarkerId(
                                      'id${appController.mapMarkers.length}');
                                  Marker marker = Marker(
                                      markerId: markerId,
                                      position: LatLng(
                                          appController.pisitopns.last.latitude,
                                          appController
                                              .pisitopns.last.longitude));

                                  appController.mapMarkers[markerId] = marker;
                                });
                              },
                              size: GFSize.MEDIUM,
                              gfButtonType: GFButtonType.outline,
                            )
                          : const SizedBox()),
                      const SizedBox(
                        height: 8,
                      ),
                      Obx(() => appController.mapMarkers.length >= 3
                          ? WidgetIconButton(
                              iconData: Icons.select_all,
                              pressFunc: () {
                                appController.displayAddMarker.value = false;

                                print(
                                    'ขนาดของจุดที่ต้องเขียนเส้น ---> ${latlngs.length}');

                                //วาดเส้น
                                appController.setPolygons.add(
                                  Polygon(
                                    polygonId: const PolygonId('id'),
                                    points: latlngs,
                                    fillColor: Colors.green.withOpacity(0.25),
                                    strokeColor: Colors.green.shade800,
                                    strokeWidth: 2,
                                  ),
                                );
                                // เอา marker ออก
                                appController.mapMarkers.clear();

                                appController.displaySave.value = true;

                                setState(() {});
                              },
                              size: GFSize.MEDIUM,
                              gfButtonType: GFButtonType.outline,
                            )
                          : const SizedBox()),
                      Obx(() => appController.displaySave.value
                          ? WidgetIconButton(
                              iconData: Icons.save,
                              size: GFSize.MEDIUM,
                              gfButtonType: GFButtonType.outline,
                              pressFunc: () {
                                AppDialog().narmalDialog(
                                    title: 'confirm save',
                                    contentWidget: Form(
                                      key: formKey,
                                      child: WidgetForm(
                                        textEditingController: nameController,
                                        validateFunc: (p0) {
                                          if (p0?.isEmpty ?? true) {
                                            return 'กรุณากรอกชื่อพื้นที่';
                                          } else {
                                            return null;
                                          }
                                        },
                                        labelWidget: const WidgetText(
                                            data: 'ชื่อพื้นที่'),
                                      ),
                                    ),
                                    firstWidget: WidgetButton(
                                      label: 'Save',
                                      pressFunc: () {
                                        if (formKey.currentState!.validate()) {
                                          Get.back();
                                          AppService().processSaveArea(
                                              nameArea: nameController.text,
                                              latlngs: latlngs);
                                        }
                                      },
                                    ));
                              },
                            )
                          : const SizedBox()),
                    ],
                  ),
                )
              ],
            ),
          ));
  }
}
