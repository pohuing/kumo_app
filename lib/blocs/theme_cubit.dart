import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(),
  );

  static Color seed = Colors.white;
  static const bool m3Default = true;

  ThemeCubit() : super(ThemeState(getTheme(), isBright: true, m3: m3Default));

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    log(json.toString(), name: '$ThemeCubit.fromJson');
    seed = Color(json['seed']);
    return ThemeState.fromJson(json);
  }

  void setTheme(Color seed, {required bool m3, required bool isBright}) {
    ThemeCubit.seed = seed;
    emit(
      ThemeState(
        getTheme(isBright: isBright, m3: m3, seed: seed),
        isBright: isBright,
        m3: m3,
      ),
    );
  }

  void setSeed(Color color) {
    seed = color;
    emit(
      ThemeState(
        getTheme(isBright: state.isBright, m3: state.m3),
        isBright: state.isBright,
        m3: state.m3,
      ),
    );
  }

  void switchTheme() {
    emit(
      ThemeState(
        getTheme(
          isBright: !state.isBright,
          m3: state.m3,
        ),
        isBright: !state.isBright,
        m3: state.m3,
      ),
    );
  }

  void setM3(bool m3) {
    emit(
      ThemeState(
        getTheme(
          isBright: state.isBright,
          seed: ThemeCubit.seed,
          m3: m3,
        ),
        isBright: state.isBright,
        m3: m3,
      ),
    );
  }

  void toggleM3() {
    emit(
      ThemeState(
        getTheme(
          isBright: state.isBright,
          seed: ThemeCubit.seed,
          m3: !state.m3,
        ),
        isBright: state.isBright,
        m3: !state.m3,
      ),
    );
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    log(state.toString(), name: '$runtimeType.toJson');
    return {'seed': seed.value, ...?state.toJson()};
  }

  static ThemeData getTheme({
    bool isBright = true,
    Color? seed,
    bool? m3 = m3Default,
  }) {
    return ThemeData(
      useMaterial3: m3,
      inputDecorationTheme: inputDecorationTheme,
      colorSchemeSeed: seed ?? ThemeCubit.seed,
      brightness: isBright ? Brightness.light : Brightness.dark,
    );
  }
}

class ThemeState extends Equatable {
  final ThemeData data;
  final bool isBright;
  final bool m3;

  const ThemeState(
    this.data, {
    this.isBright = false,
    this.m3 = ThemeCubit.m3Default,
  });

  @override
  List<Object?> get props => [data, isBright, m3];

  Map<String, dynamic>? toJson() {
    log(toString(), name: '$runtimeType.toJson');
    return {'isBright': isBright, 'm3': m3};
  }

  static ThemeState? fromJson(Map<String, dynamic> json) {
    log(json.toString(), name: '$ThemeState.fromJson');
    return ThemeState(
      ThemeCubit.getTheme(isBright: json['isBright'], m3: json['m3']),
      isBright: json['isBright'],
      m3: json['m3'],
    );
  }
}
