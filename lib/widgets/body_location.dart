import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helloflutter/utility/app_controller.dart';
import 'package:helloflutter/utility/app_service.dart';
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
        : WidgetText(data: appController.pisitopns.last.toString()));
  }
}
