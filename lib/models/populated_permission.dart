import 'package:kumo_app/models/path_point.dart';
import 'package:kumo_app/models/permission.dart';
import 'package:kumo_app/models/role.dart';

class PopulatedPermission {
  final Permission permission;
  final Role role;
  final PathPoint pathPoint;

  PopulatedPermission(this.permission, this.role, this.pathPoint);
}
