import 'package:flutter/material.dart';

class AppConstant {
  //field ลด ความจาง ด้วย withOpacity
  static Color fieldColor = Colors.grey.withOpacity(0.25);

  //method
  TextStyle h1Style() {
    return const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle h2Style() {
    return const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle h3Style() {
    return const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
    );
  }
}
