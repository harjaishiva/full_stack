import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import "package:http/http.dart" as http;

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  reqOtp(String email) async {
    final url = Uri.parse("http://10.0.2.2:5000/api/sign/requestOtp");

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
    final url = Uri.parse("http://10.0.2.2:5000/api/sign/verifyOtp");

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
    final url = Uri.parse("http://10.0.2.2:5000/api/sign/updatePassword");

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
