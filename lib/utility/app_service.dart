import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:helloflutter/models/respon_Model.dart';
import 'package:helloflutter/models/user_api_model.dart';
import 'package:helloflutter/models/user_model.dart';
import 'package:helloflutter/utility/app_constant.dart';
import 'package:helloflutter/utility/app_controller.dart';
import 'package:helloflutter/utility/app_dialog.dart';
import 'package:helloflutter/widgets/widget_button.dart';
import 'package:helloflutter/widgets/widget_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:loader_overlay/loader_overlay.dart';

class AppService {
  AppController appController = Get.put(AppController());

  Future<void> processTakePhoto({required ImageSource imageSource}) async {
    var result = await ImagePicker()
        .pickImage(source: imageSource, maxHeight: 890, maxWidth: 800);

    if (result != null) {
      appController.files.add(File(result.path));
    }
  }

  Future<void> processCreateNewAccount({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      String uid = value.user!.uid;
      print("uid ที่ได้จากการสมัคร มีค่าเท่ากับ ==> $uid ");

      // process upload image to Storage
      String nameFile = '$uid.jpg';
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      Reference reference = firebaseStorage.ref().child("avatar/$nameFile");
      UploadTask uploadTask = reference.putFile(appController.files.last);

      await uploadTask.whenComplete(() async {
        String? urlImage = await reference.getDownloadURL();
        print("Upload $urlImage Success");
        UserModel userModel = UserModel(
            uid: uid,
            name: name,
            email: email,
            password: password,
            urlImage: urlImage);

        //ตั้งชื่อกระดาษที่จะทำงานเป็น User เป็นการ save
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .set(userModel.toMap())
            .then((value) async {
          print("insert succcess");

          //insert data to api
          UserApiMedel userApiMedel = UserApiMedel(
              name: name,
              email: email,
              password: password,
              fuidstr: uid,
              bod: DateTime.now().toString(),
              picurl: urlImage);

          await dio.Dio()
              .post(AppConstant.urlAPI, data: userApiMedel.toMap())
              .then((value) {
            if (value.statusCode == 200) {
              ResponModel responModel = ResponModel.fromMap(value.data);
              AppDialog().narmalDialog(
                title: 'create account success',
                contentWidget: WidgetText(data: responModel.message),
                secontWidget: WidgetButton(
                  label: 'Thank you',
                  pressFunc: () {
                    context.loaderOverlay.hide();
                    Get.back();
                    Get.back();
                  },
                ),
              );
            } else {}
          });
        });
      });
    }).catchError((onError) {
      context.loaderOverlay.hide();
      Get.snackbar(onError.code, onError.message,
          backgroundColor: GFColors.DANGER, colorText: GFColors.WHITE);
    });
  }
}
