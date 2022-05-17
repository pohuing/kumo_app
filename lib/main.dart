import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/authentication_bloc.dart';
import 'package:kumo_app/blocs/exploration_cubit.dart';
import 'package:kumo_app/blocs/theme_cubit.dart';
import 'package:kumo_app/dev_http_overrides.dart';
import 'package:kumo_app/widgets/router.dart';
import 'package:provider/provider.dart';

void main() {
  if(kDebugMode) {
    HttpOverrides.global = DevHttpOverrides();
  }
  runApp(MultiProvider(
    providers: [
      Provider.value(value: ThemeCubit()),
      Provider.value(value: AuthenticationBloc()),
      Provider.value(value: ExplorationCubit()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (BuildContext context, state) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: state.data,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
