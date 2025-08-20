import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/screens/api_urls/urls.dart';
import 'package:e_commerce_app/utils/constants/methods.dart';
import 'package:e_commerce_app/utils/constants/variables.dart';
import "package:http/http.dart" as http;

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit() : super(SplashScreenInitial());

  tokenVerification() async {
    try{
      String urlStr = baseUrl+verifytoken;
      final url = Uri.parse(urlStr);
    log("API URL = $url");
    final tok = SharedPreferencesClass.pref.getString(token);
    log("TOKEN = $tok");

    dynamic response ;

    if(tok != " " || tok?.isNotEmpty == true){
       response = await http.get(url,
    headers:{
      "Content-Type":"application/json",
      "Authorization":"Bearer $tok"
    });

    var data = jsonDecode(response.body);

    log("API RESPONSE = $data");
    if(response.statusCode == 200){
      emit(state.copyWith(verified: true));
    }
    else{
      emit(state.copyWith(verified: false));
    }
    }
    else{
      emit(state.copyWith(verified: false));
    }

    

    }catch(e){
      log("Error in Token verification : $e");
    }
  }
}
