import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(),
  );

  static Color seed = Colors.white;

  ThemeCubit() : super(ThemeState(getTheme(), isBright: true));

  void switchTheme() {
    emit(
      ThemeState(getTheme(isBright: !state.isBright),
          isBright: !state.isBright),
    );
  }

  static ThemeData getTheme({bool isBright = true, Color? seed}) {
    return ThemeData(
      inputDecorationTheme: inputDecorationTheme,
      colorSchemeSeed: seed ?? ThemeCubit.seed,
      brightness: isBright ? Brightness.light : Brightness.dark,
    );
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    log(json.toString(), name: '$ThemeCubit.fromJson');
    seed = Color(json['seed']);
    return ThemeState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    log(state.toString(), name: '$runtimeType.toJson');
    return {'seed': seed.value, ...?state.toJson()};
  }

  void setSeed(Color color) {
    seed = color;
    emit(ThemeState(getTheme(isBright: state.isBright),
        isBright: state.isBright));
  }
}

class ThemeState extends Equatable {
  final ThemeData data;
  final bool isBright;

  const ThemeState(this.data, {this.isBright = false});

  @override
  List<Object?> get props => [data, isBright];

  static ThemeState? fromJson(Map<String, dynamic> json) {
    log(json.toString(), name: '$ThemeState.fromJson');
    return ThemeState(ThemeCubit.getTheme(isBright: json['isBright']),
        isBright: json['isBright']);
  }

  Map<String, dynamic>? toJson() {
    log(toString(), name: '$runtimeType.toJson');
    return {'isBright': isBright};
  }
}
