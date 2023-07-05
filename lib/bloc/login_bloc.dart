import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_taking_app/data/config_database.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth firebaseAuth;
  final ConfigDatabase configDatabase;

  bool get isLoggedIn {
    return configDatabase.getUserId() != null;
  }

  LoginBloc({required this.firebaseAuth, required this.configDatabase}) : super(LoginInitialState()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoginWithGoogleEvent) {
        await _loginWithGoogle(emit);
      }
    });
  }

  Future _loginWithGoogle(Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      final userCredential = await firebaseAuth.signInWithProvider(GoogleAuthProvider());
      if (userCredential.user != null) {
        configDatabase.setUserId(userCredential.user!.uid);

        emit(LoggedInWithGoogleState(userCredential.user!));
      } else {
        emit(const FailedLoggedInWithGoogleState('Failed to sign in with Google'));
      }
    } catch (e) {
      emit(const FailedLoggedInWithGoogleState('Failed to sign in with Google. An error occurred'));
    }
  }
}
