part of 'home_screen_cubit.dart';

class HomeScreenState {
   HomeScreenState({
    this.getData,
    this.loading = true,
});

  GetData? getData;
  bool loading;

  HomeScreenState copyWith({
    GetData? getData,
    bool loading = true,
  }){
    return HomeScreenState(
      getData : getData ?? this.getData,
      loading : loading,
  );
  }
}



final class HomeScreenInitial extends HomeScreenState {}
