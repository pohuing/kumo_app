import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kumo_app/models/populated_permission.dart';
import 'package:kumo_app/widgets/explorer/nested_explorer.dart';
import 'package:kumo_app/widgets/general_purpose/common_app_bar.dart';
import 'package:kumo_app/widgets/general_purpose/theme_screen.dart';
import 'package:kumo_app/widgets/path_point_management/path_point_management_view.dart';
import 'package:kumo_app/widgets/permissions/role_management/role_management_screen.dart';
import 'package:kumo_app/widgets/sign_in_form.dart';
import 'package:kumo_app/widgets/sign_up_screen.dart';
import 'package:tuple/tuple.dart';

import '../widgets/permissions/role_management/manage_role_screen.dart';

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
        final args = (settings.arguments ?? const Tuple2('', false))
            as Tuple2<String, bool>;

        if (!kIsWeb && Platform.isIOS) {
          return CupertinoPageRoute(
            settings: settings,
            builder: (context) => NestedExplorer(path: args.item1),
          );
        }
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, a1, a2) => NestedExplorer(path: args.item1),
          transitionsBuilder: (context, a1, a2, child) {
            final begin =
                !args.item2 ? const Offset(1, 0) : const Offset(0, -1);
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
          builder: (context) => const PathPointManagementView(),
        );
      case '/managePermissions':
        return MaterialPageRoute(
          builder: (context) => const RoleManagementScreen(),
        );
      case '/manageRole':
        assert(settings.arguments is List<PopulatedPermission>);
        return MaterialPageRoute(
          builder: (context) => ManageRoleScreen(
              points: (settings.arguments as List<PopulatedPermission>)),
        );
      case '/signup':
        return MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        );
      case '/theme':
        return MaterialPageRoute(
          builder: (context) => const ThemeScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Text(settings.toString()),
        );
    }
  }
}
