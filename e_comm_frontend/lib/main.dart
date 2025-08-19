import 'package:e_commerce_app/screens/splash_screen/cubit/splash_screen_cubit.dart';
import 'package:e_commerce_app/screens/splash_screen/splash_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocProvider(create: (context)=>SplashScreenCubit(),child: const SplashScreen()),
      ),
    );
  }
}