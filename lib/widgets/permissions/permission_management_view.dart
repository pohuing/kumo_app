import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/fab_action.dart';
import 'package:kumo_app/systems/communication_manager.dart';
import 'package:kumo_app/systems/handle_async.dart';

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
      builder: (context, snapshot) => futureBuilderHandler(
        snapshot: snapshot,
        onFinished: (snapshot) => ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            final data = snapshot.data!;
            return ExpansionTile(
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
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    future = CommunicationManager.instance.getPopulatedPermissions();
    context.read<FabActionCubit>().changeAction(
        null); //(context) {log('Hello from permission manager');});
  }
}
