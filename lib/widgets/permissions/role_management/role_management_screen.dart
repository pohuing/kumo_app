import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/widgets/general_purpose/common_fab.dart';
import 'package:kumo_app/widgets/permissions/role_management/roles_listing.dart';
import 'package:provider/provider.dart';

import '../../../blocs/fab_action.dart';
import '../../general_purpose/common_app_bar.dart';
import '../permission_management_view.dart';
import '../user_management_view.dart';

class RoleManagementScreen extends StatefulWidget {
  const RoleManagementScreen({Key? key}) : super(key: key);

  @override
  State<RoleManagementScreen> createState() => _RoleManagementScreenState();
}

class _RoleManagementScreenState extends State<RoleManagementScreen> {
  int currentScreenIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    late final Widget body;

    switch (currentScreenIndex) {
      case 0:
        body = const RolesListing();
        break;
      case 1:
        body = const UserManagementView();
        break;
      case 2:
        body = const PermissionManagementView();
        break;
      default:
        body = Text(currentScreenIndex.toString());
    }

    return Provider<FabActionCubit>(
      create: (BuildContext context) {
        return FabActionCubit(null);
      },
      child: Scaffold(
        appBar: CommonAppBar(title: currentScreen),
        body: body,
        floatingActionButton:
            BlocBuilder<FabActionCubit, void Function(BuildContext context)?>(
          builder: (BuildContext context, state) => state != null
              ? CommonFAB(icon: const Icon(Icons.add), action: state)
              : Container(),
        ),
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
