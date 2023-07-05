part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoggedInWithGoogleState extends LoginState {
  final User user;

  const LoggedInWithGoogleState(this.user);
}

class FailedLoggedInWithGoogleState extends LoginState {
  final String message;

  const FailedLoggedInWithGoogleState(this.message);
}
