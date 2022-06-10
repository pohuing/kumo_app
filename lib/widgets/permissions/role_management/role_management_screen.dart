import 'package:flutter/material.dart';
import 'package:kumo_app/widgets/permissions/role_management/role_management_view.dart';

import '../../general_purpose/common_app_bar.dart';
import '../permission_management_view.dart';
import '../user_management_view.dart';

class RoleManagementScreen extends StatefulWidget {
  const RoleManagementScreen({Key? key}) : super(key: key);

  @override
  State<RoleManagementScreen> createState() => _RoleManagementScreenState();
}

class _RoleManagementScreenState extends State<RoleManagementScreen> {
  String get currentScreen {
    switch (currentScreenIndex) {
      case 0:
        return 'Roles';
      case 1:
        return 'Users';
      case 2:
        return 'Permissions';
      default:
        return 'Unknown page';
    }
  }

  int currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    late final Widget body;

    switch (currentScreenIndex) {
      case 0:
        body = RoleManagementView();
        break;
      case 1:
        body = UserManagementView();
        break;
      case 2:
        body = PermissionManagementView();
        break;
      default:
        body = Text(currentScreenIndex.toString());
    }

    return Scaffold(
      appBar: CommonAppBar(title: currentScreen),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentScreenIndex,
        onTap: (value) => setState(() => currentScreenIndex = value),
        items: const [
          BottomNavigationBarItem(
            label: 'Roles',
            icon: Icon(Icons.category),
          ),
          BottomNavigationBarItem(
            label: 'Users',
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'Permissions',
            icon: Icon(Icons.security),
          ),
        ],
      ),
    );
  }
}
