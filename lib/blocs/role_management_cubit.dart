import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/models/populated_permission.dart';
import 'package:kumo_app/systems/communication_manager.dart';

class RoleManagementCubit extends Cubit<RoleManagementState> {
  RoleManagementCubit(super.initialState);

  Future<void> loadRoles() async {
    emit(RoleManagementStateLoading());
    final perms = await CommunicationManager.instance.getPopulatedPermissions();
    emit(RoleManagementStateLoaded(perms));
  }

  Future<void> addRole(String name) async {
    emit(RoleManagementStateLoading());
    // TODO handle errors
    final res = await CommunicationManager.instance.createNewRole(name);
    await loadRoles();
  }
}

class RoleManagementState {}

class RoleManagementStateLoading extends RoleManagementState {}

class RoleManagementStateLoaded extends RoleManagementState {
  final List<PopulatedPermission> perms;

  RoleManagementStateLoaded(this.perms);
}
