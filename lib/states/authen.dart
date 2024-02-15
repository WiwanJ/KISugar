import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helloflutter/utility/app_constant.dart';
import 'package:helloflutter/utility/app_controller.dart';
import 'package:helloflutter/widgets/widget_form.dart';
import 'package:helloflutter/widgets/widget_icon_button.dart';
import 'package:helloflutter/widgets/widget_image_asset.dart';
import 'package:helloflutter/widgets/widget_text.dart';

class Authen extends StatefulWidget {
  const Authen({super.key});

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  // call controller จากอีก ไฟล์นึง
  AppController appController = Get.put(AppController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 64),
                  width: 250,
                  child: Column(
                    children: [
                      displayLogoAppName(),
                      WidgetForm(
                        hint: 'Email',
                        sufficwidget: Icon(Icons.email),
                      ),
                      Obx(() => WidgetForm(
                            hint: 'Password',
                            obsecu: appController.redEye.value,
                            sufficwidget: WidgetIconButton(
                              iconData:appController.redEye.value ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
                              pressFunc: () {
                                appController.redEye.value =
                                    !appController.redEye.value;
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row displayLogoAppName() {
    return Row(
      children: [
        displayImage(),
        WidgetText(
          data: 'wiwan',
          textStyle: AppConstant().h1Style(),
        )
      ],
    );
  }

  WidgetImageAsset displayImage() {
    return WidgetImageAsset(
      path: "images/logo.png",
      size: 64,
    );
  }
}
