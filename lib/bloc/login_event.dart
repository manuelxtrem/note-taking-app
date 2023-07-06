part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginWithGoogleEvent extends LoginEvent {
  final GoogleAuthProvider provider;

  const LoginWithGoogleEvent(this.provider);

  @override
  List<Object> get props => [provider];
}

