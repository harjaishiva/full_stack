part of 'forget_password_cubit.dart';

class ForgetPasswordState {
  const ForgetPasswordState({
    this.emailSuccess = false,
    this.otpSuccess = false,
    this.passSuccess = false,
    this.loading = false,
    this.message = ""
  });

  final bool emailSuccess;
  final bool otpSuccess;
  final bool passSuccess;
  final bool loading;
  final String message;

  ForgetPasswordState copyWith({
    bool emailSuccess = false,
    bool otpSuccess = false,
    bool passSuccess = false,
    bool loading = false,
    String message = "",
  }){
    return ForgetPasswordState(
      emailSuccess: emailSuccess,
      otpSuccess: otpSuccess,
      passSuccess: passSuccess,
      loading: loading,
      message: message
    );
  }
}

final class ForgetPasswordInitial extends ForgetPasswordState {}
