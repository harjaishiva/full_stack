import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/screens/api_urls/urls.dart';
import "package:http/http.dart" as http;

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  reqOtp(String email) async {
    String urlStr = baseUrl+requestotp;
    final url = Uri.parse(urlStr);

    Map map = {"email": email};

    try {
      emit(state.copyWith(loading: true));
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: jsonEncode(map));
      final data = jsonDecode(response.body);
      if(response.statusCode == 200){
        emit(state.copyWith(emailSuccess: true,otpSuccess: false,passSuccess: false,loading: false,message:data['message'] ));
      }
      else{
        emit(state.copyWith(emailSuccess: false,otpSuccess: false,passSuccess: false,loading: false,message:data['message'] ));
      }
    } catch (e) {
      log("Error while making api call :===> $e");
    }
  }

  verifyOtp(String email,String otp) async {
    String urlStr = baseUrl+verifyotp;
    final url = Uri.parse(urlStr);

    Map map = {"email": email, "otp":otp};

    try {
      emit(state.copyWith(loading: true));
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: jsonEncode(map));
      final data = jsonDecode(response.body);
      if(response.statusCode == 200){
        emit(state.copyWith(emailSuccess: false,otpSuccess: true,passSuccess: false,loading: false,message:data['message'] ));
      }
      else{
        emit(state.copyWith(emailSuccess: false,otpSuccess: false,passSuccess: false,loading: false,message:data['message'] ));
      }
    } catch (e) {
      log("Error while making api call :===> $e");
    }
  }

  updatePass(String email,String pass) async {
    String urlStr = baseUrl+updatePassword;
    final url = Uri.parse(urlStr);

    Map map = {"email": email, "pass":pass};

    try {
      emit(state.copyWith(loading: true));
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: jsonEncode(map));
      final data = jsonDecode(response.body);
      if(response.statusCode == 200){
        emit(state.copyWith(emailSuccess: false,otpSuccess: false,passSuccess: true,loading: false,message:data['message'] ));
      }
      else{
        emit(state.copyWith(emailSuccess: false,otpSuccess: false,passSuccess: false,loading: false,message:data['message'] ));
      }
    } catch (e) {
      log("Error while making api call :===> $e");
    }
  }
}
