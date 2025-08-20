import 'dart:io';

import 'package:e_commerce_app/screens/forget_password/cubit/forget_password_cubit.dart';
import 'package:e_commerce_app/screens/forget_password/forget_password_view.dart';
import 'package:e_commerce_app/screens/on_oarding_screen/view.dart';
import 'package:e_commerce_app/screens/profile_screen/cubit/profile_screen_cubit.dart';
import 'package:e_commerce_app/utils/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:e_commerce_app/utils/constants/methods.dart';
import 'package:e_commerce_app/utils/constants/variables.dart';
import 'package:e_commerce_app/utils/popup_message/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int screenIndex = 2;
  final double pictureSize = 170;

  Map<String, dynamic> user = {};

  String nAME = "Name";
  String eMAIL = "Email";
  String iMAGE = "Image";

  List<String> titles = [
    'Edit Profile',
    'Order History',
    'Shipping Details',
    'All Coupons',
    'Change Password',
    'Logout'
  ];
  List<Icon> icon = [
    const Icon(Icons.manage_accounts),
    const Icon(Icons.shopping_bag),
    const Icon(Icons.location_on),
    const Icon(Icons.card_giftcard),
    const Icon(Icons.password),
    const Icon(Icons.logout)
  ];

  List<int> caseNumber = [1, 2, 3, 4, 5, 6];

  final ImagePicker pick = ImagePicker();

  @override
  void initState() {
    super.initState();
    setString();
  }

  setString() {
    nAME = SharedPreferencesClass.pref.getString(name) ?? "Name";
    eMAIL = SharedPreferencesClass.pref.getString(email) ?? "Email";
    iMAGE = SharedPreferencesClass.pref.getString(image) ?? "Image";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
      builder: (context, state) {
        setString();
        //state.image = SharedPreferencesClass.pref.getString(image) ?? "Image";
        return Scaffold(
          appBar: AppBar(
            leading: const SizedBox(),
            centerTitle: true,
            title: const Text("Profile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w600)),
            backgroundColor: themeColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Stack(children: [
                  Center(
                    child: Container(
                        height: pictureSize,
                        width: pictureSize,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(pictureSize),
                            border: Border.all(color: buttonColor, width: 5)),
                        child: ClipOval(
                            child: (iMAGE.isEmpty ||
                                    iMAGE.toLowerCase() == "image")
                                ? Image.asset("assets/images/profile_pic.jpeg",
                                    fit: BoxFit.cover,
                                    width: pictureSize,
                                    height: pictureSize)
                                : Image.network(iMAGE,
                                    fit: BoxFit.cover,
                                    width: pictureSize,
                                    height: pictureSize))),
                  ),
                  Positioned(
                    right: ((MediaQuery.of(context).size.width * 0.34)),
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        showAlertTwoMessage(
                            context: context,
                            message:
                                "Upload picture from Gallery or click from Camera",
                            yes: "Gallery",
                            no: "Camera",
                            onTapYes: () {
                              pickImage(ImageSource.gallery);
                            },
                            onTapNo: () {
                              pickImage(ImageSource.camera);
                            });
                        // pickImage(ImageSource.camera);
                      },
                      child: Container(
                          height: 45,
                          width: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 209, 208, 208),
                              borderRadius: BorderRadius.circular(45)),
                          child: const Icon(Icons.edit)),
                    ),
                  )
                ]),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(nAME,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 8),
                Container(
                  alignment: Alignment.center,
                  child: Text(eMAIL,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 40),
                SizedBox(
                    height: 400,
                    child: ListView.builder(
                        itemCount: titles.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              switch (caseNumber[index]) {
                                case 5:
                                  {
                                    showAlertTwoMessage(
                                        context: context,
                                        message:
                                            "Are you sure, you want to chnage your password?",
                                        onTapYes: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BlocProvider(
                                                        create: (_) =>
                                                            ForgetPasswordCubit(),
                                                        child:
                                                            const ForgetPasswordScreen(),
                                                      )));
                                        });
                                  }
                                case 6:
                                  {
                                    showAlertTwoMessage(
                                        context: context,
                                        message:
                                            "Are you sure, you want to logout?",
                                        onTapYes: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const OnBoardingScreen()),
                                              (route) => false);
                                        });
                                  }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: themeColor, width: 2)),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 5),
                                    SizedBox(child: icon[index]),
                                    const SizedBox(width: 10),
                                    Text(titles[index],
                                        style: const TextStyle(fontSize: 22)),
                                    const Spacer(),
                                    const Icon(
                                      Icons.keyboard_arrow_right,
                                      textDirection: TextDirection.rtl,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
              ],
            ),
          ),
          bottomNavigationBar:
              bottomNavigationBar(index: screenIndex, context: context),
        );
      },
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? img = await pick.pickImage(source: source);

    setState(() {
      if (img != null) {
        context.read<ProfileScreenCubit>().uploadImage(File(img.path));
      } else {
        showAlertMessage(context: context, message: "No image selected");
      }
    });
  }
}
