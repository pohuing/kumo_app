import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(),
  );
  ThemeCubit() : super(getTheme());


  void switchTheme() {
    emit(
      getTheme(isBright: !state.isBright),
    );
  }

  static ThemeState getTheme({bool isBright = true}) {
    return ThemeState(
      ThemeData(
        inputDecorationTheme: inputDecorationTheme,
        colorSchemeSeed: Colors.white,
        brightness: isBright ? Brightness.dark : Brightness.light,
      ),
      isBright: isBright,
    );
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    log(json.toString(), name: '$ThemeCubit.fromJson');
    return ThemeState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    log(state.toString(), name: '$runtimeType.toJson');
    return state.toJson();
  }
}

class ThemeState extends Equatable {
  final ThemeData data;
  final bool isBright;

  const ThemeState(this.data, {this.isBright = false});

  @override
  List<Object?> get props => [data];

  static ThemeState? fromJson(Map<String, dynamic> json) {
    log(json.toString(), name: '$ThemeState.fromJson');
    return ThemeCubit.getTheme(isBright: json['isBright']);
  }

  Map<String, dynamic>? toJson() {
    log(toString(), name: '$runtimeType.toJson');
    return {'isBright': isBright};
  }
}
