import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/screens/api_urls/urls.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  registerUser(
      BuildContext context, String name, String email, String pass) async {
        String urlStr = baseUrl+signup;
    final url = Uri.parse(urlStr);
    log("API URL = $url");
    Map map = {"name": name, "email": email, "password": pass};
    log("API PARAMETERS : $map");
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: jsonEncode(map));

      final rdata = jsonDecode(response.body);

      log("API RESPONSE = $rdata");

      if (response.statusCode == 200) {
        emit(state.copywith(success: true, data: rdata));
      } else {
        emit(state.copywith(success: false, data: rdata));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
