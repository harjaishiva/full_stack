import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/utils/constants/methods.dart';
import 'package:e_commerce_app/utils/constants/variables.dart';
import "package:http/http.dart" as http;

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit() : super(SplashScreenInitial());

  tokenVerification() async {
    try{final url = Uri.parse("http://10.0.2.2:5000/api/sign/verifyToken");
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
