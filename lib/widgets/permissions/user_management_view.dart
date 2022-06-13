import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/fab_action.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({Key? key}) : super(key: key);

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  @override
  Widget build(BuildContext context) {
    return ListView();
  }

  @override
  void initState() {
    super.initState();
    context.read<FabActionCubit>().changeAction((context) {
      log('Hello from the user management view');
    });
  }
}
