part of 'orders_cubit.dart';

class OrdersState {
  const OrdersState({this.success=false,this.message="",this.model});

  final bool success;
  final String message;
  final OrdersModel? model;

  OrdersState copyWith({
    bool success = false,
    String message = "",
    OrdersModel? model
  }) {
    return OrdersState(
      success: success,
      message: message,
      model: model ?? this.model,
    );
  }
}

final class OrdersInitial extends OrdersState {}
