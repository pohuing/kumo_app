import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/fab_action.dart';
import 'package:kumo_app/models/populated_permission.dart';
import 'package:kumo_app/systems/communication_manager.dart';
import 'package:kumo_app/systems/handle_async.dart';

class RolesListing extends StatefulWidget {
  const RolesListing({Key? key}) : super(key: key);

  @override
  State<RolesListing> createState() => _RolesListingState();
}

class _RolesListingState extends State<RolesListing> {
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
            return ListTile(
              title: Text(snapshot.data![index].role.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).pushNamed(
                '/manageRole',
                arguments: <PopulatedPermission>[
                  ...snapshot.data!.where(
                    (element) =>
                        element.role.id == snapshot.data![index].role.id,
                  )
                ],
              ),
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
    context.read<FabActionCubit>().changeAction((context) {
      log('Hello from the roles listing');
    });
  }
}
