import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(),
  );

  static const bool m3Default = true;

  ThemeCubit()
      : super(
          const ThemeState(seed: Colors.white, isBright: true, m3: m3Default),
        );

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    log(json.toString(), name: '$ThemeCubit.fromJson');
    return ThemeState.fromJson(json);
  }

  void setM3(bool m3) {
    emit(state.copyWith(m3: m3));
  }

  void setSeed(Color color) {
    emit(state.copyWith(seed: color));
  }

  void setTheme(
    Color seed, {
    required bool m3,
    required bool isBright,
    required bool respectSystemTheme,
  }) {
    emit(
      state.copyWith(
        seed: seed,
        isBright: isBright,
        m3: m3,
        respectSystemBrightness: respectSystemTheme,
      ),
    );
  }

  void switchBrightTheme() {
    emit(
      state.copyWith(isBright: !state.isBright, respectSystemBrightness: false),
    );
  }

  void systemChangedBrightness(Brightness platformBrightness) {
    if (state.respectSystemBrightness) {
      emit(state.copyWith(isBright: platformBrightness == Brightness.light));
    }
  }

  void toggleM3() {
    emit(state.copyWith(m3: !state.m3));
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    log(state.toString(), name: '$runtimeType.toJson');
    return {...?state.toJson()};
  }

  static ThemeData getTheme({
    required bool isBright,
    required Color seed,
    required bool m3,
  }) {
    return ThemeData(
      useMaterial3: m3,
      inputDecorationTheme: inputDecorationTheme,
      colorSchemeSeed: seed,
      brightness: isBright ? Brightness.light : Brightness.dark,
    );
  }

  static ThemeData getThemeFromState(ThemeState state) {
    return getTheme(isBright: state.isBright, seed: state.seed, m3: state.m3);
  }
}

class ThemeState extends Equatable {
  final Color seed;
  final bool respectSystemBrightness;
  final bool isBright;
  final bool m3;

  const ThemeState({
    required this.seed,
    this.isBright = true,
    this.m3 = ThemeCubit.m3Default,
    this.respectSystemBrightness = true,
  });

  ThemeData get data => ThemeCubit.getThemeFromState(this);

  @override
  List<Object?> get props => [seed, isBright, m3, respectSystemBrightness];

  ThemeState copyWith({
    Color? seed,
    bool? isBright,
    bool? m3,
    bool? respectSystemBrightness,
  }) {
    return ThemeState(
      seed: seed ?? this.seed,
      isBright: isBright ?? this.isBright,
      m3: m3 ?? this.m3,
      respectSystemBrightness:
          respectSystemBrightness ?? this.respectSystemBrightness,
    );
  }

  Map<String, dynamic>? toJson() {
    log(toString(), name: '$runtimeType.toJson');
    return {
      'isBright': isBright,
      'm3': m3,
      'respectSystemBrightness': respectSystemBrightness,
      'seed': seed.value,
    };
  }

  static ThemeState? fromJson(Map<String, dynamic> json) {
    log(json.toString(), name: '$ThemeState.fromJson');
    return ThemeState(
      isBright: json['isBright'],
      m3: json['m3'],
      respectSystemBrightness: json['respectSystemBrightness'],
      seed: Color(json['seed']),
    );
  }
}
