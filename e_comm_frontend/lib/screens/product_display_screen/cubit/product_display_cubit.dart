import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/screens/product_display_screen/modal/product_display_modal.dart';
import 'package:e_commerce_app/utils/constants/methods.dart';
import 'package:e_commerce_app/utils/constants/variables.dart';
import 'package:http/http.dart' as http;

part 'product_display_state.dart';

class ProductDisplayCubit extends Cubit<ProductDisplayState> {
  ProductDisplayCubit() : super(ProductDisplayInitial());

  ProductDisplayModal? _model;

  getData(int id) async {
    final url = Uri.parse("http://10.0.2.2:5000/api/sign/getOneItem/$id");

    log("API URL = $url");

    if (id == 0) {
      log("error no id provided");
      emit(state.copyWith(loading: false,gsuccess: false, asuccess: false));
    } else {
      try {
        final result = await http.get(url);
        log("API RESPONSE = ${result.body}");
        _model = ProductDisplayModal.fromJson(jsonDecode(result.body));
        if (result.statusCode == 200) {
          emit(state.copyWith(
            loading: false,
              gsuccess: true,
              asuccess: false,
              message: _model?.message ?? "",
              model: _model));
        } else {
          emit(state.copyWith(
            loading: false,
              gsuccess: false,
              asuccess: false,
              message: _model?.message ?? "",
              model: _model));
        }
      } catch (e) {
        log("error--------------------------------${e.toString()}");
      }
    }
  }

  addToCart(int itemId, String image, String category, int quantity, String price, String tprice,
      String title) async {
    final url = Uri.parse("http://10.0.2.2:5000/api/sign/addToCart");
    log("API URL = $url");

    String userid = SharedPreferencesClass.pref.getString(userId) ?? "";

    Map map = {
      "user_id": userid,
      "item_id": itemId,
      "image": image,
      "category": category,
      "quantity": quantity,
      "price": price,
      "totalPrice": tprice,
      "title": title
    };

    log("API PARAMETERS = $map");
    try {
      final result = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: jsonEncode(map));
      final data = jsonDecode(result.body);
      log("API RESPONSE = $data");
      if (result.statusCode == 200) {
        emit(state.copyWith(
            loading: false, gsuccess: false, asuccess: true, message: data['message']));
      } else {
        emit(state.copyWith(
            loading: false, gsuccess: false, asuccess: false, message: data['message']));
      }
    } catch (e) {
      log("error---------------------------${e.toString()}");
    }
  }
}
