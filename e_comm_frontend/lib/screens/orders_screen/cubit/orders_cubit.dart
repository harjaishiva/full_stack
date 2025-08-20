import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/screens/api_urls/urls.dart';
import 'package:e_commerce_app/screens/orders_screen/model/orders_model.dart';
import 'package:e_commerce_app/utils/constants/methods.dart';
import 'package:e_commerce_app/utils/constants/variables.dart';
import 'package:http/http.dart' as http;

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());

  OrdersModel? _model;

  update(){
    emit(state.copyWith(success: false));
  }

  callApi(){
    if(state.model?.data?[0].category == null || state.model?.data?[0].category?.isEmpty == true){
      getCart();
    }
  }

  getCart() async {
    final id = SharedPreferencesClass.pref.getString(userId);
    String urlStr = "$baseUrl$getcart/$id";
    final url = Uri.parse(urlStr);
    log("API URL = $url");
    

    final result = await http.get(url);

     _model = OrdersModel.fromJson(jsonDecode(result.body));
    log("API RESPONSE = ${result.body}");

    if(result.statusCode == 200){
      emit(state.copyWith(success: true, message: _model?.message ?? "", model: _model));
    }
    else{
      emit(state.copyWith(success: false, message: _model?.message ?? "", model: _model));
    }
  }

  deleteFromCart(int id) async {
    String urlStr = "$baseUrl$deletefromcart/$id";
    final url = Uri.parse(urlStr);
    log("API URL = $url");

    final result = await http.delete(url);
    

    if(result.statusCode == 200){
      //log("API RESPONSE = ${jsonDecode(result.body)}");
      emit(state.copyWith(success: true, message: _model?.message ?? ""));
      getCart();
    }
    else{
     // log("API RESPONSE = ${jsonDecode(result.body)}");
      emit(state.copyWith(success: false, message: _model?.message ?? ""));
    }
  }
}
