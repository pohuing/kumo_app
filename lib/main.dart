import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kumo_app/blocs/authentication_bloc.dart';
import 'package:kumo_app/blocs/theme_cubit.dart';
import 'package:kumo_app/dev_http_overrides.dart';
import 'package:kumo_app/widgets/router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  if (kDebugMode || true) {
    HttpOverrides.global = DevHttpOverrides();
  }

  HydratedBlocOverrides.runZoned(
    () => runApp(
      MultiProvider(
        providers: [
          Provider.value(value: ThemeCubit()),
          Provider.value(value: AuthenticationCubit()),
        ],
        child: const MyApp(),
      ),
    ),
    createStorage: () async {
      WidgetsFlutterBinding.ensureInitialized();

      return await HydratedStorage.build(
        storageDirectory: kIsWeb
            ? HydratedStorage.webStorageDirectory
            : await getApplicationDocumentsDirectory(),
      );
    },
  );
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
          initialRoute:
              context.read<AuthenticationCubit>().state is SignedInState
                  ? 'explore'
                  : '/',
        );
      },
    );
  }
}
