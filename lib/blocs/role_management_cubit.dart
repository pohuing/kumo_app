import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/systems/communication_manager.dart';

import '../models/role.dart';

class RoleManagementCubit extends Cubit<RoleManagementState> {
  RoleManagementCubit(super.initialState);

  Future<void> loadRoles() async {
    emit(RoleManagementStateLoading());
    final perms = await CommunicationManager.instance.getRoles();
    emit(RoleManagementStateLoaded(perms));
  }

  Future<bool> addRole(String name) async {
    emit(RoleManagementStateLoading());
    // TODO handle errors
    final res = await CommunicationManager.instance.createNewRole(name);
    loadRoles();
    return res;
  }
}

class RoleManagementState {}

class RoleManagementStateLoading extends RoleManagementState {}

class RoleManagementStateLoaded extends RoleManagementState {
  final List<Role> roles;

  RoleManagementStateLoaded(this.roles);
}
