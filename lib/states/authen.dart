import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:helloflutter/states/create_new_account.dart';
import 'package:helloflutter/utility/app_constant.dart';
import 'package:helloflutter/utility/app_controller.dart';
import 'package:helloflutter/widgets/widget_button.dart';
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
//key ที่ใช้ในการเช็ค validate

  final formKey = GlobalKey<FormState>();
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        displayLogoAppName(),
                        EmailForm(),
                        PasswordForm(),
                        LoginButton()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: WidgetButton(
        label: "Create New Account",
        pressFunc: () {
          Get.to(const CreateNewAccount());
        },
        gfButtonType: GFButtonType.transparent,
      ),
    );
  }

  Container LoginButton() {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(top: 8),
      child: WidgetButton(
        label: "Login",
        pressFunc: () {
          //check validate
          if (formKey.currentState!.validate()) {
            
          }
        },
      ),
    );
  }

  Obx PasswordForm() {
    return Obx(() => WidgetForm(
          validateFunc: (p0) {
            if (p0?.isEmpty ?? true) {
              return "Please fill password";
            } else {
              return null;
            }
          },
          hint: 'Password',
          obsecu: appController.redEye.value,
          sufficwidget: WidgetIconButton(
            iconData: appController.redEye.value
                ? Icons.remove_red_eye
                : Icons.remove_red_eye_outlined,
            pressFunc: () {
              appController.redEye.value = !appController.redEye.value;
            },
          ),
        ));
  }

  WidgetForm EmailForm() {
    return WidgetForm(
      validateFunc: (p0) {
        if (p0?.isEmpty ?? true) {
          return "Please Fill Email";
        } else {
          return null;
        }
      },
      hint: 'Email',
      sufficwidget: Icon(Icons.email),
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
