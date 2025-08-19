import 'package:e_commerce_app/screens/home_screen/cubit/home_screen_cubit.dart';
import 'package:e_commerce_app/screens/home_screen/home_view.dart';
import 'package:e_commerce_app/screens/orders_screen/cubit/orders_cubit.dart';
import 'package:e_commerce_app/screens/orders_screen/orders_view.dart';
import 'package:e_commerce_app/screens/profile_screen/profile_view.dart';
import 'package:e_commerce_app/utils/constants/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget bottomNavigationBar({required int index, required BuildContext context}){
  return BottomNavigationBar(
            currentIndex: index,
            onTap: (index) {
              _onItemTapped(index,context);
            },
            selectedItemColor: themeColor,
            unselectedItemColor: Colors.grey,
            selectedFontSize: 16,
            unselectedFontSize: 12,
            
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: "Home" ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), label: "Cart"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
            ],
          );
}

void _onItemTapped(int index , BuildContext context) {
    switch(index){
      case 0:{
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=>BlocProvider(create:(context)=>HomeScreenCubit(),child:const HomeScreen())), (route) => false);
      }
      case 1:{
        Navigator.push(context, MaterialPageRoute(builder:(context)=> BlocProvider(create:(_)=>OrdersCubit(),child:const OrdersScreen())));
      }
      case 2:{
        Navigator.push(context, MaterialPageRoute(builder:(context)=> const ProfileScreen()));
      }
    }
  }