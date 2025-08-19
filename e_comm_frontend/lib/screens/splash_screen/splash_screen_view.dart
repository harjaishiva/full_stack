import 'package:e_commerce_app/screens/home_screen/cubit/home_screen_cubit.dart';
import 'package:e_commerce_app/screens/home_screen/home_view.dart';
import 'package:e_commerce_app/screens/on_oarding_screen/view.dart';
import 'package:e_commerce_app/screens/splash_screen/cubit/splash_screen_cubit.dart';
import 'package:e_commerce_app/utils/constants/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SharedPreferencesClass.initialisePrefs();
    Future.delayed(const Duration(seconds: 3),(){
      context.read<SplashScreenCubit>().tokenVerification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashScreenCubit, SplashScreenState>(
      listener: (context, state) {
        if(state.verified){
          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context)=>BlocProvider(create: (context) => HomeScreenCubit(),child: const HomeScreen())),(route)=>false);
        }
        else{
           Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context)=>const OnBoardingScreen()),(route)=>false);
        }
      },
      child: Scaffold(
        body: Center(
          child: Container(
              alignment: Alignment.center,
              height: 400,
              width: double.infinity,
              child: Image.asset(
                "assets/images/splash_screen_logo.png",
                fit: BoxFit.fill,
              )),
        ),
      ),
    );
  }
}
