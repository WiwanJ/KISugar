import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helloflutter/models/area_model.dart';
import 'package:helloflutter/models/respon_Model.dart';
import 'package:helloflutter/models/user_api_model.dart';
import 'package:helloflutter/models/user_model.dart';
import 'package:helloflutter/states/main_home.dart';
import 'package:helloflutter/utility/app_constant.dart';
import 'package:helloflutter/utility/app_controller.dart';
import 'package:helloflutter/utility/app_dialog.dart';
import 'package:helloflutter/widgets/widget_button.dart';
import 'package:helloflutter/widgets/widget_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';
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

  void processCheckLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      context.loaderOverlay.hide();
      Get.offAll(const MainHome());
      Get.snackbar("Authen success", 'welcome');
    }).catchError((onError) {
      context.loaderOverlay.hide();
      Get.snackbar(onError.code, onError.message,
          backgroundColor: GFColors.DANGER, colorText: GFColors.WHITE);
    });
  }

  Future<void> processFindLocation() async {
    //check ว่า Location เปิดหรือไม่
    bool locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      //เปิด Locaion serivice
      //check ว่า เคื่อง user เปิด locaion แบบไหน
      LocationPermission locationPermission =
          await Geolocator.checkPermission();
      if (locationService == LocationPermission.deniedForever) {
        //deniedForever ไม่อนุญาตเลย ให้ ไปหน้าขอเปิด location
        dialogCallPermission();
      } else {
        //denied   Alway , one หาพิกัดได้เลย
        if (locationPermission == LocationPermission.denied) {
          //denieda
          locationPermission = await Geolocator.requestPermission();
          if ((locationPermission != LocationPermission.always) &&
              (locationPermission != LocationPermission.whileInUse)) {
            dialogCallPermission();
          } else {
            Position position = await Geolocator.getCurrentPosition();
            appController.pisitopns.add(position);
          }
        } else {
          // Alway , one หาพิกัดได้เลย
          Position position = await Geolocator.getCurrentPosition();
          appController.pisitopns.add(position);
        }
      }
    } else {
      //ปิด location service
      AppDialog().narmalDialog(
          title: 'open service',
          contentWidget: const WidgetText(data: 'please open service'),
          secontWidget: WidgetButton(
            label: 'open serice',
            pressFunc: () async {
              //เปิดหน้า location ให้ user แบบ อัตโนมัต
              await Geolocator.openLocationSettings();
              exit(0);
            },
          ));
    }
  }

  void dialogCallPermission() {
    AppDialog().narmalDialog(
        title: 'open permission',
        secontWidget: WidgetButton(
          label: 'open permission',
          pressFunc: () async {
            await Geolocator.openAppSettings();
            exit(0);
          },
        ));
  }

  Future<void> processSaveArea(
      {required String nameArea, required List<LatLng> latlngs}) async {
    var geoPoints = <GeoPoint>[];
    for (var element in latlngs) {
      geoPoints.add(GeoPoint(element.latitude, element.longitude));

      AreaModel areaModel = AreaModel(
        nameArea: nameArea,
        timestamp: Timestamp.fromDate(DateTime.now()),
        geoPoints: geoPoints,
        qrCode: 'ki${Random().nextInt(100000)}',
      );

      var user = FirebaseAuth.instance.currentUser;
      String uidLogin = user!.uid;

      print('## uid.Login --> $uidLogin');
      print('## areaModel--> ${areaModel.toMap()}');

      //ต้องทำเป็น async mathod ก่นอ

      await FirebaseFirestore.instance
          .collection('user')
          .doc(uidLogin)
          .collection('area')
          .doc()
          .set(areaModel.toMap())
          .then((value) {
        Get.snackbar('add succcess', 'thankyou');
        appController.indexBody.value = 0;
      });
    }
  }

  Future<void> processReadAllArea() async {
    var user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('area').orderBy('timestamp',descending: true)
        .get()
        .then((value) {
      if (appController.areaModels.isNotEmpty) {
        appController.areaModels.clear();
      }
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          AreaModel areaModel = AreaModel.fromMap(element.data());
          appController.areaModels.add(areaModel);
        }
      }
    });
  }

  String convertTimeToString({required Timestamp timestamp}) {
    DateFormat dateFormat = DateFormat('dd MM yyyy HH:mm');
    String result = dateFormat.format(timestamp.toDate());
    return result;
  }
}
