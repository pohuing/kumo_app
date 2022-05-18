import 'dart:developer';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kumo_app/communication_manager.dart';

class AuthenticationCubit extends HydratedCubit<AuthenticationState>{
  AuthenticationCubit() : super(SignedOutState());

  @override
  AuthenticationState? fromJson(Map<String, dynamic> json) {
    log(json.toString(), name: '$runtimeType.fromJson');

    if(json.containsKey('type')){
      return AuthenticationState(json);
    }

    return null;
  }

  Future<bool> signIn(String email, String password) async {
    if (state is SignedInState) {
      log('Tried signing in despite being signed in', name: '$runtimeType.signIn()');
    }
    emit(SigningInState());

    final res = await CommunicationManager.instance.signIn(email, password);
    if(res) {
      emit(SignedInState(email, CommunicationManager.instance.token!));
    } else {
      emit(SignInErrorState('Login failed'));
    }
    return res;
  }

  Future<void> signOut() async {
    CommunicationManager.instance.token = null;
    emit(SignedOutState());
  }

  Future<bool> signUp(String email, String password) async {
    if(state is SignedInState) {
      log('Tried creating a new account despite already being signed in');
    }
    emit(SigningInState());
    final res = await CommunicationManager.instance.signUp(email, password);

    if(res) {
      emit(SignedOutState());
    } else {
      emit(SignInErrorState('Failed'));
    }

    return res;
  }

  @override
  Map<String, dynamic>? toJson(AuthenticationState state) {
    log(state.toString(), name: '$runtimeType.toJson');
    return state.toJson();
  }
}

abstract class AuthenticationState {
  factory AuthenticationState(Map<String, dynamic> json){
    log(json.toString(), name: '${AuthenticationState}factory');

    if (json['type'] == (SignedInState).toString()){
      return SignedInState.fromJson(json);
    }else{
      return SignedOutState.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();
}
class SignedInState implements AuthenticationState{
  final String email;
  final String token;

  SignedInState(this.email, this.token);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': (SignedInState).toString(),
      'email': email,
      'token': token,
    };
  }

  static AuthenticationState fromJson(Map<String, dynamic> json) {
    log('hit', name: '$SignedInState.fromJson');
    CommunicationManager.instance.token = json['token'];
    return SignedInState(json['email'], json['token']);
  }
}

class SignedOutState implements AuthenticationState{
  @override
  Map<String, dynamic> toJson() {
    return {'type': (SignedOutState).toString(),};
  }

  static SignedOutState fromJson(Map json){
    return SignedOutState();
  }
}

class SignInErrorState implements AuthenticationState {
  final String cause;

  SignInErrorState(this.cause);

  SignInErrorState fromJson(Map<String, dynamic> json){
    return SignInErrorState(json['cause']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': (SignedOutState).toString(),};
  }

  @override
  String toString() {
    return 'SignInErrorState{cause: $cause}';
  }
}

class SigningInState implements AuthenticationState{
  @override
  Map<String, dynamic> toJson() {
    return {'type': (SignedOutState).toString(),};
  }
}