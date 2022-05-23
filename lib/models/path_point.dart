import 'package:equatable/equatable.dart';
import 'package:kumo_app/systems/communication_manager.dart';

class PathPoint extends Equatable {
  final String id;
  final String path;
  final bool isRoot;
  final bool toBeDeleted;
  final bool isDirty;

  const PathPoint(
    this.id,
    this.path,
    this.isRoot, [
    this.toBeDeleted = false,
    this.isDirty = false,
  ]);

  @override
  List<Object?> get props => [id, path, isRoot, toBeDeleted, isDirty];

  PathPoint copyWith({
    String? id,
    String? path,
    bool? isRoot,
    bool? toBeDeleted,
    bool? isDirty,
  }) {
    return PathPoint(
      id ?? this.id,
      path ?? this.path,
      isRoot ?? this.isRoot,
      toBeDeleted ?? this.toBeDeleted,
      isDirty ?? this.isDirty,
    );
  }

  Future<bool> delete() async {
    return await CommunicationManager.instance.deletePathPoint(this);
  }

  @override
  String toString() {
    return 'PathPoint{id: $id, path: $path, isRoot: $isRoot, toBeDeleted: $toBeDeleted, isDirty: $isDirty}';
  }

  Future<PathPoint?> update() async {
    final result = await CommunicationManager.instance.updatePathPoint(this);

    if (result) {
      return PathPoint(id, path, isRoot);
    }

    return null;
  }

  static PathPoint fromJSON(Map<String, dynamic> e) {
    final id = e['id'];
    final path = e['path'];
    final bool isRoot = e['isRoot'];

    return PathPoint(id, path, isRoot);
  }
}
