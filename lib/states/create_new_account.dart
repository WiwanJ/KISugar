import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helloflutter/widgets/widget_button.dart';
import 'package:helloflutter/widgets/widget_form.dart';
import 'package:helloflutter/widgets/widget_icon_button.dart';
import 'package:helloflutter/widgets/widget_image_asset.dart';
import 'package:helloflutter/widgets/widget_text.dart';

class CreateNewAccount extends StatelessWidget {
  const CreateNewAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(data: 'Create New Account'),
      ),
      body: ListView(
        children: [
          displayImage(),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: Get.width*0.8,
                child: Column(
                  children: [
                    WidgetForm(labelWidget: WidgetText(data: 'Dispaly Name'),),
                    WidgetForm(labelWidget: WidgetText(data: 'Email'),),
                    WidgetForm(labelWidget: WidgetText(data: 'Password'),),
                    WidgetButton(
                      label: 'Create New Account',
                      pressFunc: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row displayImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: Get.width * 0.4,
          height: Get.width * 0.4,
          child: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: WidgetImageAsset(
                  path: "images/Avatar.png",
                  //size: Get.width * 0.4,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: WidgetIconButton(
                  iconData: Icons.photo_camera,
                  pressFunc: () {},
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
