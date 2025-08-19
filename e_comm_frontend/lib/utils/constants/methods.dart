import 'package:e_commerce_app/utils/constants/variables.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bullet extends StatelessWidget {
  const Bullet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
              color: themeColor, borderRadius: BorderRadius.circular(8))),
    );
  }
}

Widget divider() {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Container(color: themeColor, height: 2, width: double.infinity),
  );
}

OutlineInputBorder borderStyle() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(width: 2, color: Colors.grey),
  );
}

class SharedPreferencesClass{
  static late SharedPreferences pref;
  static initialisePrefs() async{
    pref = await SharedPreferences.getInstance();
  }
}


