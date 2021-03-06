import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/systems/communication_manager.dart';

import '../models/path_point.dart';

class PathPointManagementCubit extends Cubit<PathPointManagementState> {
  PathPointManagementCubit(super.initialState);

  get anyChanged {
    var any = state.pathPoints
        .any((element) => element.isDirty || element.toBeDeleted);
    log(any.toString(), name: '$runtimeType.anyChanged');
    return any;
  }

  Future<bool> addPoint(String path, bool isRoot) async {
    return CommunicationManager.instance.addPoint(path, isRoot);
  }

  Future<void> loadPoints() async {
    final points = await CommunicationManager.instance.getPathPoints();
    emit(PathPointManagementState(points));
  }

  Future<void> save() async {
    List<Future> futures = [];
    futures.addAll(
      state.pathPoints
          .where((element) => element.toBeDeleted)
          .map((e) => e.delete())
          .toList(),
    );

    futures.addAll(
      state.pathPoints
          .where((element) => element.isDirty && !element.toBeDeleted)
          .map((e) => e.update())
          .toList(),
    );

    await Future.wait(futures);
    await loadPoints();
  }

  void toggleDeletePoint(String id) {
    final oldPoint = state.pathPoints.firstWhere((element) => element.id == id);
    final newPoint = oldPoint.copyWith(toBeDeleted: !oldPoint.toBeDeleted);
    final newPathPoints = state.pathPoints.map((e) => e).toList();
    final index = newPathPoints.indexOf(oldPoint);
    newPathPoints.replaceRange(index, index + 1, [newPoint]);
    emit(PathPointManagementState(newPathPoints));
  }

  void togglePoint(String id) {
    final oldPoint = state.pathPoints.firstWhere((element) => element.id == id);
    final newPoint = oldPoint.copyWith(isRoot: !oldPoint.isRoot, isDirty: true);
    final newPathPoints = state.pathPoints.map((e) => e).toList();
    final index = newPathPoints.indexOf(oldPoint);
    newPathPoints.replaceRange(index, index + 1, [newPoint]);
    emit(PathPointManagementState(newPathPoints));
  }
}

class PathPointManagementState extends Equatable {
  final List<PathPoint> pathPoints;

  const PathPointManagementState(this.pathPoints);

  @override
  List<Object?> get props => [pathPoints];
}
