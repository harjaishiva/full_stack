import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/screens/home_screen/model/model_class.dart';
import 'package:e_commerce_app/utils/constants/methods.dart';
import 'package:e_commerce_app/utils/constants/variables.dart';
import 'package:e_commerce_app/utils/popup_message/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(HomeScreenInitial());

  getData(BuildContext context) async{
    var url = Uri.parse("http://10.0.2.2:5000/api/sign/getData");
    log("API URL = $url");

    String tok = SharedPreferencesClass.pref.getString(token) ?? "";
    log("TOKEN = $tok");

    try{
      var response = await http.get(url,headers:{"Content-Type": "application/json","Authorization":"Bearer $tok"});

      log("API RESPONSE = ${jsonDecode(response.body)}");

      switch(response.statusCode){
        case 200:{
           GetData getdata = GetData.fromJson(jsonDecode(response.body));
           emit(state.copyWith(getData:getdata,loading:false));
        }
        break;
        default :{
          var getdata = jsonDecode(response.body);
          log("error not 200 -- Request to api failed");
          emit(state.copyWith(loading:false));
          showAlertMessage(context: context, message: getdata['message']);
        }
      }
    } catch(e){
      log("Error ------ $e");
      emit(state.copyWith(loading:false));
      log("error ------ $e");
    }
  }
}

