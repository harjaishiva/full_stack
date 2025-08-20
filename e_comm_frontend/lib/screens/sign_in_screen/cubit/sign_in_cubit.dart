import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/screens/api_urls/urls.dart';
import 'package:http/http.dart' as http;

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  loginUser(String email, String pass) async {
    String urlStr = baseUrl+signin;
    final url = Uri.parse(urlStr);
    log("API URL = $url");
    Map map = {"email": email, "password": pass};
    log("API PARAMETERS = $map");

    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: jsonEncode(map));

      final rdata = jsonDecode(response.body);

      log("API RESPONSE = $rdata");

      if (response.statusCode == 200) {
        
        emit(state.copyWith(success: true, data: rdata));
      } else {
        emit(state.copyWith(success: false, data: rdata));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
