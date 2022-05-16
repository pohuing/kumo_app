import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/CommunicationManager.dart';

class AuthenticationBloc extends Cubit<AuthenticationState>{
  AuthenticationBloc() : super(SignedOutState());

  Future<bool> signIn(String email, String password) async {
    if (state is SignedInState) {
      log('Tried signing in despite being signed in', name: runtimeType.toString() + 'signIn()');
    }
    emit(SigningInState());

    final res = await CommunicationManager.instance.signIn(email, password);
    if(res)
      emit(SignedInState(email));
    else
      emit(SignedOutState());
    return res;
  }

  Future<bool> signUp(String email, String password) async {
    if(state is SignedInState) {
      log('Tried creating a new account despite already being signed in');
    }
    emit(SigningInState());
    final res = await CommunicationManager.instance.signUp(email, password);

    if(res)
      emit(SignedOutState());
    else
      emit(SigninErrorState('Failed'));

    return res;
  }

  Future<void> signOut() async {
    CommunicationManager.instance.token = null;
    emit(SignedOutState());
  }
}

class SigninErrorState implements AuthenticationState {
  final String cause;

  SigninErrorState(this.cause);
}

abstract class AuthenticationState {

}

class SignedInState implements AuthenticationState{
  final String email;

  SignedInState(this.email);
}

class SigningInState implements AuthenticationState{}

class SignedOutState implements AuthenticationState{}