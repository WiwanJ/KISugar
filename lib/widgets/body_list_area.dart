import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helloflutter/utility/app_constant.dart';
import 'package:helloflutter/utility/app_controller.dart';
import 'package:helloflutter/utility/app_service.dart';
import 'package:helloflutter/widgets/widget_text.dart';

class BodyListArea extends StatefulWidget {
  const BodyListArea({super.key});

  @override
  State<BodyListArea> createState() => _BodyListAreaState();
}

class _BodyListAreaState extends State<BodyListArea> {
  AppController appController = Get.put(AppController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AppService().processReadAllArea();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => appController.areaModels.isEmpty
        ? const SizedBox()
        : ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: appController.areaModels.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                WidgetText(
                  data: appController.areaModels[index].nameArea,
                  textStyle: AppConstant().h2Style(),
                ),
                WidgetText(
                    data: AppService().convertTimeToString(
                        timestamp: appController.areaModels[index].timestamp)),
                        const Divider(color: Colors.grey)
              ],
            ),
          ));
  }
}
