import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kumo_app/systems/communication_manager.dart';

import '../../models/populated_permission.dart';
import '../../systems/communication_manager.dart';

class PermissionManagementView extends StatefulWidget {
  const PermissionManagementView({Key? key}) : super(key: key);

  @override
  State<PermissionManagementView> createState() =>
      _PermissionManagementViewState();
}

class _PermissionManagementViewState extends State<PermissionManagementView> {
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

        final data = snapshot.data;
        if (data != null) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) => ExpansionTile(
              title: Text(data[index].role.name),
              children: [
                ListTile(
                  title: Text(data[index].pathPoint.path),
                ),
                SwitchListTile.adaptive(
                  value: data[index].permission.delete,
                  onChanged: (v) {},
                  title: const Text('Delete'),
                ),
                SwitchListTile.adaptive(
                  value: data[index].permission.modifyRoot,
                  onChanged: (v) {},
                  title: const Text('ModifyRoot'),
                ),
                SwitchListTile.adaptive(
                  value: data[index].permission.read,
                  onChanged: (v) {},
                  title: const Text('Read'),
                ),
                SwitchListTile.adaptive(
                  value: data[index].permission.write,
                  onChanged: (v) {},
                  title: const Text('Write'),
                ),
                const ListTile(
                  title: Text('Delete'),
                  trailing: Icon(Icons.delete_forever),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    future = CommunicationManager.instance.getPopulatedPermissions();
  }
}
