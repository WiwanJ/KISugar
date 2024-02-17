import 'dart:io';

import 'package:get/get.dart';

class AppController extends GetxController {
  RxBool redEye = true.obs;
  RxList<File> files = <File>[].obs;

  RxInt indexBody = 0.obs;
}
