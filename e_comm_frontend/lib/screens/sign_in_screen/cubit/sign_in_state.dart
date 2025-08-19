part of 'sign_in_cubit.dart';

class SignInState {
  const SignInState({this.success = false,this.data});

  final bool success;
  final dynamic data;

  SignInState copyWith({
    bool success = false,
    dynamic data
  }){
    return SignInState(
      success : success,
      data: data ?? this.data,
    );
  }
}

final class SignInInitial extends SignInState {}
