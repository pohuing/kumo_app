import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kumo_app/widgets/general_purpose/common_app_bar.dart';
import 'package:kumo_app/widgets/nested_explorer.dart';
import 'package:kumo_app/widgets/path_point_management_view.dart';
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
              body: const SignInForm(),
            );
          },
        );
      case '/explore':
      case 'explore':
        final args = (settings.arguments ?? '') as String;
        if (!kIsWeb && Platform.isIOS) {
          return CupertinoPageRoute(
            builder: (context) => Scaffold(
                appBar: CommonAppBar(
                  title: args,
                ),
                body: NestedExplorer(path: args)),
          );
        }
        return PageRouteBuilder(
          pageBuilder: (context, a1, a2) => Scaffold(
              appBar: CommonAppBar(
                title: args,
              ),
              body: NestedExplorer(path: args)),
          transitionsBuilder: (context, a1, a2, child) {
            const begin = Offset(1, 0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final offsetAnimation = a1.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      case '/managePathPoints':
        return MaterialPageRoute(
            builder: (context) => const PathPointManagementView());
      case '/signup':
        return MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        );
      default:
        return MaterialPageRoute(
            builder: (context) => Text(settings.toString()));
    }
  }
}
