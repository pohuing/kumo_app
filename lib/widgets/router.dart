import 'package:flutter/material.dart';
import 'package:kumo_app/widgets/common_app_bar.dart';
import 'package:kumo_app/widgets/nested_explorer.dart';
import 'package:kumo_app/widgets/sign_in_form.dart';
import 'package:kumo_app/widgets/sign_up_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: CommonAppBar(title: 'Sign-in'),
              body: SignInForm(),
            );
          },
        );
      case '/explore':
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => Scaffold(
              appBar: CommonAppBar(
                title: args,
              ),
              body: NestedExplorer(path: args)),
        );
      case '/signup':
        return MaterialPageRoute(
          builder: (context) => SignUpScreen(),
        );
      default:
        return MaterialPageRoute(
            builder: (context) => Text(settings.toString()));
    }
  }
}
