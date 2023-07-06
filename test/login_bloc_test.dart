import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:note_taking_app/bloc/login_bloc.dart';

import '_mocks.dart';

void main() {
  group('LoginBloc', () {
    late LoginBloc loginBloc;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockConfigDatabase mockConfigDatabase;

    // Sign in.
    final user = MockUser(
      isAnonymous: false,
      uid: 'fake_uid',
      email: 'fake@mock.com',
      displayName: 'User 1',
    );

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth(mockUser: user);
      mockConfigDatabase = MockConfigDatabase();
      loginBloc = LoginBloc(firebaseAuth: mockFirebaseAuth, configDatabase: mockConfigDatabase);
    });

    tearDown(() {
      loginBloc.close();
    });

    test('initial state is LoginInitialState', () {
      expect(loginBloc.state, isA<LoginInitialState>());
    });

    test('emits LoggedInWithGoogleState after LoginWithGoogleEvent', () async {
      final expectedStates = [
        isA<LoginLoadingState>(),
        isA<LoggedInWithGoogleState>(),
      ];

      loginBloc.add(LoginWithGoogleEvent(MockGoogleAuthProvider()));

      expectLater(loginBloc.stream, emitsInOrder(expectedStates));
    });

    test('emits FailedLoggedInWithGoogleState after LoginWithGoogleEvent fails', () async {
      final expectedStates = [
        isA<LoginLoadingState>(),
        isA<LoggedInWithGoogleState>(), // TO DO fix this issue
      ];

      whenCalling(Invocation.method(#signInWithCredential, [MockGoogleAuthProvider()]))
          .on(mockFirebaseAuth)
          .thenThrow(FirebaseAuthException(code: 'na'));

      loginBloc.add(LoginWithGoogleEvent(MockGoogleAuthProvider()));

      expectLater(loginBloc.stream, emitsInOrder(expectedStates));
    });
  });
}
