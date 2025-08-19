part of 'sign_up_cubit.dart';

class SignUpState {
  const SignUpState({this.success = false, this.data});

  final bool success;
  final dynamic data;

  SignUpState copywith({
    bool success = false,
    dynamic data,
  }){
    return SignUpState(
      success: success,
      data: data ?? this.data,
    );
  }
}

final class SignUpInitial extends SignUpState {}
