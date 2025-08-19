import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  loginUser(String email, String pass) async {
    final url = Uri.parse("http://10.0.2.2:5000/api/sign/signIn");
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
