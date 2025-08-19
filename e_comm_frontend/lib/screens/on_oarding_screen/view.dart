import 'package:e_commerce_app/screens/sign_in_screen/cubit/sign_in_cubit.dart';
import 'package:e_commerce_app/screens/sign_in_screen/sign_in_view.dart';
import 'package:e_commerce_app/screens/sign_up_screen/cubit/sign_up_cubit.dart';
import 'package:e_commerce_app/screens/sign_up_screen/sign_up_view.dart';
import 'package:e_commerce_app/utils/constants/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      body: Column(
        children: [
          const SizedBox(height: 70),
          Container(
              alignment: Alignment.center,
              child: const Text("Shoping",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w500))),
          const SizedBox(height: 50),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 20),
              child: const Text("Buy new  for",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontWeight: FontWeight.w400))),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 20),
              child: const Text("friends & family",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontWeight: FontWeight.w600))),
          const SizedBox(height: 20),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                  "Gifting is the perfect way to stay  connected with friends and family.",
                  style: TextStyle(color: Colors.white, fontSize: 22))),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
                height: 2, color: const Color.fromARGB(255, 152, 152, 152)),
          ),
          const SizedBox(height: 20),
          GestureDetector(
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder:(context)=>BlocProvider(create:(context)=>SignUpCubit(),child:const SignUpScreen())));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Text("Sign Up with mail",
                        style: TextStyle(
                            color: themeColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500))),
              )),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Existing account?",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w300)),
              const SizedBox(width: 5),
              GestureDetector(
                onTap:(){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> BlocProvider(create:(context)=>SignInCubit(),child:const SignInScreen())));
                },
                child: const Text("Log in",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
