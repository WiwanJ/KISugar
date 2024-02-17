import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:getwidget/getwidget.dart';
import 'package:helloflutter/utility/app_controller.dart';
import 'package:helloflutter/utility/app_dialog.dart';
import 'package:helloflutter/utility/app_service.dart';
import 'package:helloflutter/widgets/widget_button.dart';
import 'package:helloflutter/widgets/widget_form.dart';
import 'package:helloflutter/widgets/widget_icon_button.dart';
import 'package:helloflutter/widgets/widget_image_asset.dart';
import 'package:helloflutter/widgets/widget_image_file.dart';
import 'package:helloflutter/widgets/widget_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CreateNewAccount extends StatefulWidget {
  const CreateNewAccount({super.key});

  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  AppController appController = Get.put(AppController());
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

//ทำงานเป็นตัวแรก
  @override
  void initState() {
    super.initState();
    if (appController.files.isNotEmpty) {
      appController.files.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: WidgetText(data: 'Create New Account'),
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ListView(
            children: [
              displayImage(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Get.width * 0.8,
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          WidgetForm(
                            textEditingController: nameController,
                            validateFunc: (p0) {
                              if (p0?.isEmpty ?? true) {
                                return "โปรดกรอก ชื่อ";
                              } else {
                                return null;
                              }
                            },
                            labelWidget: WidgetText(data: 'Display Name'),
                          ),
                          WidgetForm(
                            textEditingController: emailController,
                            validateFunc: (p0) {
                              if (p0?.isEmpty ?? true) {
                                return 'โปรดกรอก  email';
                              } else {
                                return null;
                              }
                            },
                            labelWidget: WidgetText(data: 'Email'),
                          ),
                          WidgetForm(
                            textEditingController: passwordController,
                            validateFunc: (p0) {
                              if (p0?.isEmpty ?? true) {
                                return 'โปรดกรอก password';
                              } else {
                                return null;
                              }
                            },
                            labelWidget: WidgetText(data: 'Password'),
                          ),
                          WidgetButton(
                            label: 'Create New Account',
                            pressFunc: () {
                              if (appController.files.isEmpty) {
                                //
                                Get.snackbar(
                                  "ไม่มีรูป",
                                  'เลือกรูป',
                                  backgroundColor: GFColors.DANGER,
                                  colorText: GFColors.WHITE,
                                );
                              } else if (formKey.currentState!.validate()) {

                                context.loaderOverlay.show();

                                AppService().processCreateNewAccount(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    context: context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
              Obx(() => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: appController.files.isEmpty
                        ? const WidgetImageAsset(
                            path: "images/Avatar.png",
                            //size: Get.width * 0.4,
                          )
                        : WidgetImageFile(
                            file: appController.files.last,
                            radius: Get.width * 0.4 * 0.5,
                          ),
                  )),
              Positioned(
                right: 0,
                bottom: 0,
                child: WidgetIconButton(
                  iconData: Icons.photo_camera,
                  pressFunc: () {
                    AppDialog().narmalDialog(
                        title: 'Camera or Gallory',
                        iconWidget: const WidgetImageAsset(
                          path: 'images/takeimage.png',
                          size: 150,
                        ),
                        contentWidget: const WidgetText(
                            data: 'โปรดเลือก Camera หรือ Gallery'),
                        firstWidget: WidgetButton(
                          label: 'Camera',
                          pressFunc: () {
                            Get.back();
                            AppService().processTakePhoto(
                                imageSource: ImageSource.camera);
                          },
                        ),
                        secontWidget: WidgetButton(
                          label: 'Gallery',
                          pressFunc: () {
                            Get.back();
                            AppService().processTakePhoto(
                                imageSource: ImageSource.gallery);
                          },
                        ));
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
