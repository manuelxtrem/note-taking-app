// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app/bloc/login_bloc.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/styles.dart';
import 'package:note_taking_app/res/utils.dart';
import 'package:note_taking_app/ui/common/dialogs.dart';
import 'package:note_taking_app/ui/pages/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with DidBuildMixin {
  late LoginBloc _loginBloc;

  @override
  Future<void> didBuild(BuildContext context) async {
    // check cache login after some time
    await Future.delayed(const Duration(seconds: 1));

    if (_loginBloc.isLoggedIn) {
      Navigator.of(context).pushReplacement(Utils.pageRoute(const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    _loginBloc = context.read();

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoggedInWithGoogleState) {
          Navigator.of(context).pushReplacement(Utils.pageRoute(const HomeScreen()));
        } else if (state is FailedLoggedInWithGoogleState) {
          Dialogs.showSingleOptionDialog(context, state.message);
        }
      },
      builder: (context, state) {
        final loading = state is LoginLoadingState;

        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Image.asset('assets/image/anaya-katlego-unsplash.jpg'),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                    ],
                    stops: [0.6, 1],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'note.',
                        style: AppStyle.headline2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'The note-taking app that\'s always there for you',
                        style: AppStyle.body5,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: loading
                              ? [
                                  const CupertinoActivityIndicator(),
                                ]
                              : [
                                  Image.asset('assets/image/google.png', width: 24),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Sign in with Google',
                                    style: AppStyle.body4.copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                        ),
                        onPressed: () {
                          if (!loading) {
                            _loginBloc.add(LoginWithGoogleEvent(GoogleAuthProvider()));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
