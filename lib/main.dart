import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/AuthenticationBloc.dart';
import 'package:kumo_app/blocs/ThemeCubit.dart';
import 'package:kumo_app/widgets/landing_page.dart';
import 'package:kumo_app/widgets/sign_in_form.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider.value(value: ThemeCubit()),
      Provider.value(value: AuthenticationBloc())
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
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () =>
                      setState(() => context.read<ThemeCubit>().switchTheme()),
                  child: Row(
                    children: [
                      Text('Toggle Theme'),
                      Spacer(),
                      BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (context, state) => state.isBright
                            ? Icon(Icons.brightness_2_outlined)
                            : Icon(Icons.brightness_1_outlined),
                      )
                    ],
                  ),
                ),
                if (context.read<AuthenticationBloc>().state is SignedInState)
                  PopupMenuItem(
                    onTap: () => context.read<AuthenticationBloc>().signOut(),
                    child: Row(
                      children: [
                        Text('Sign out'),
                        Spacer(),
                        Icon(Icons.logout)
                      ],
                    ),
                  ),
              ];
            },
          )
        ],
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        buildWhen: (previous, current) {
          return previous is SigningInState && current is SignedInState ||
              previous is SignedInState && !(current is SignedInState);
        },
        builder: (context, state) {
          if (state is SignedInState)
            return LandingPage();
          else
            return SignInForm();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ThemeCubit>().switchTheme();
        },
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
