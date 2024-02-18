import 'package:flutter/material.dart';
import 'package:helloflutter/widgets/body_list_area.dart';
import 'package:helloflutter/widgets/body_location.dart';
import 'package:helloflutter/widgets/body_profile.dart';

class AppConstant {
  //field ลด ความจาง ด้วย withOpacity

  static List<String> title = <String>[
    'List Area',
    'My Location',
    'Profile',
  ];

  static List<IconData> iconData = <IconData>[
    Icons.list,
    Icons.map,
    Icons.person
  ];

  static List<Widget> bodys = <Widget>[
    const BodyListArea(),
    const BodyLocation(),
    const BodyProfile(),
  ];

  static Color fieldColor = Colors.grey.withOpacity(0.25);
  static String urlAPI = 'http://110.164.149.104:9295/fapi/userFlutter';
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
