part of 'splash_screen_cubit.dart';

class SplashScreenState {
  SplashScreenState({this.verified = false});

  final bool verified;

  SplashScreenState copyWith({
    bool verified = false
  }){
    return SplashScreenState(
      verified : verified
    );
  }
}

final class SplashScreenInitial extends SplashScreenState {}
