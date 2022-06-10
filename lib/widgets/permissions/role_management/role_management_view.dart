import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kumo_app/models/populated_permission.dart';
import 'package:kumo_app/systems/communication_manager.dart';

class RoleManagementView extends StatefulWidget {
  const RoleManagementView({Key? key}) : super(key: key);

  @override
  State<RoleManagementView> createState() => _RoleManagementViewState();
}

class _RoleManagementViewState extends State<RoleManagementView> {
  late Future<List<PopulatedPermission>> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PopulatedPermission>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log(snapshot.error.toString(), name: runtimeType.toString());
          return Center(child: Text(snapshot.toString()));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(snapshot.data![index].role.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).pushNamed(
                '/manageRole',
                arguments: [
                  ...snapshot.data!.where((element) =>
                      element.role.id == snapshot.data![index].role.id)
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    future = CommunicationManager.instance.getPopulatedPermissions();
  }
}
