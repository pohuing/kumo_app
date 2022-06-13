import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/fab_action.dart';
import 'package:kumo_app/blocs/role_management_cubit.dart';
import 'package:kumo_app/models/populated_permission.dart';
import 'package:kumo_app/systems/communication_manager.dart';
import 'package:kumo_app/widgets/permissions/role_management/role_addition_form.dart';

class RolesListing extends StatefulWidget {
  const RolesListing({Key? key}) : super(key: key);

  @override
  State<RolesListing> createState() => _RolesListingState();
}

class _RolesListingState extends State<RolesListing> {
  late Future<List<PopulatedPermission>> future;
  final RoleManagementCubit cubit =
      RoleManagementCubit(RoleManagementStateLoading());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleManagementCubit, RoleManagementState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is RoleManagementStateLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final state2 = state as RoleManagementStateLoaded;
        return ListView.builder(
          itemCount: state.roles.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(state2.roles[index].name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed(
              '/manageRole',
              arguments: state2.roles[index].id,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    future = CommunicationManager.instance.getPopulatedPermissions();
    cubit.loadRoles();
    context.read<FabActionCubit>().changeAction(
          (ctx) => showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            builder: (context) {
              return BottomSheet(
                onClosing: () {},
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                builder: (context) {
                  return RoleAdditionForm(cubit: cubit);
                },
              );
            },
            context: ctx,
          ),
        );
  }
}
