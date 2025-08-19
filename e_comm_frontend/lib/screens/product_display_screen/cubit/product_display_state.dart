part of 'product_display_cubit.dart';

class ProductDisplayState {
  const ProductDisplayState({this.loading=true,this.gsuccess = false,this.asuccess = false,this.message = "",this.model});

  final bool loading;
  final bool gsuccess;
  final bool asuccess;
  final String message;
  final ProductDisplayModal? model;

  ProductDisplayState copyWith({
    bool loading = true,
    bool gsuccess = false,
    bool asuccess = false,
    String message = "",
    ProductDisplayModal? model,
  }){
    return ProductDisplayState(
      loading: loading,
      gsuccess: gsuccess,
      asuccess : asuccess,
      message: message,
      model: model ?? this.model
    );
  }
}

final class ProductDisplayInitial extends ProductDisplayState {}
