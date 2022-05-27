import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kumo_app/blocs/authentication_bloc.dart';
import 'package:kumo_app/blocs/theme_cubit.dart';
import 'package:kumo_app/systems/dev_http_overrides.dart';
import 'package:kumo_app/systems/router.dart';
import 'package:kumo_app/systems/url_strategy/url_strategy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<void> main({List<String>? args, bool? runningAsTest = false}) async {
  runningAsTest ??= false;
  if (kDebugMode || true) {
    HttpOverrides.global = DevHttpOverrides();
  }
  usePathUrlStrategy();

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

      var hydratedStorage = await HydratedStorage.build(
        storageDirectory: kIsWeb
            ? HydratedStorage.webStorageDirectory
            : await getApplicationDocumentsDirectory(),
      );

      if (runningAsTest!) await hydratedStorage.clear();
      return hydratedStorage;
    },
  );
}

class MyApp extends StatefulWidget with WidgetsBindingObserver {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late WidgetsBinding binding;
  late FlutterWindow window;

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

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    context
        .read<ThemeCubit>()
        .systemChangedBrightness(window.platformDispatcher.platformBrightness);
  }

  @override
  void initState() {
    super.initState();
    binding = WidgetsBinding.instance;
    binding.addObserver(this);
    window = binding.window;
    context
        .read<ThemeCubit>()
        .systemChangedBrightness(window.platformDispatcher.platformBrightness);
  }
}
