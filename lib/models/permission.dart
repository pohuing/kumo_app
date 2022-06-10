import 'package:equatable/equatable.dart';

class Permission extends Equatable {
  final String roleId;
  final String pathPointId;
  final bool read;
  final bool write;
  final bool delete;
  final bool modifyRoot;

  const Permission(
    this.roleId,
    this.pathPointId,
    this.read,
    this.write,
    this.delete,
    this.modifyRoot,
  );

  @override
  List<Object?> get props => [
        roleId,
        pathPointId,
        read,
        write,
        delete,
        modifyRoot,
      ];

  static Permission? fromJson(Map<String, dynamic> json) {
    return Permission(
      json['roleId'],
      json['pathPointId'],
      json['read'],
      json['write'],
      json['delete'],
      json['modifyRoot'],
    );
  }
}
