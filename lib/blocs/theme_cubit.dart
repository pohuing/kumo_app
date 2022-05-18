import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(),
  );
  ThemeCubit() : super(getTheme());


  void switchTheme() {
    emit(
      getTheme(isBright: state.isBright),
    );
  }

  static ThemeState getTheme({bool isBright = true}) {
    return ThemeState(
      ThemeData(
        inputDecorationTheme: inputDecorationTheme,
        colorSchemeSeed: Colors.white,
        brightness: isBright ? Brightness.dark : Brightness.light,
      ),
      isBright: !isBright,
    );
  }
}

class ThemeState extends Equatable {
  final ThemeData data;
  final bool isBright;

  const ThemeState(this.data, {this.isBright = false});

  @override
  List<Object?> get props => [data];
}
