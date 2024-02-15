import 'package:flutter/material.dart';
import 'package:helloflutter/utility/app_constant.dart';
import 'package:helloflutter/widgets/widget_form.dart';
import 'package:helloflutter/widgets/widget_image_asset.dart';
import 'package:helloflutter/widgets/widget_text.dart';

class Authen extends StatelessWidget {
  const Authen({super.key});

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
                      WidgetForm(
                        hint: 'Password',
                        obsecu: true,
                      ),
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
