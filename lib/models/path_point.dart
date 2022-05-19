import 'package:equatable/equatable.dart';

class PathPoint extends Equatable {
  final String id;
  final String path;
  final bool isRoot;
  final bool toBeDeleted;
  final bool isDirty;

  @override
  String toString() {
    return 'PathPoint{id: $id, path: $path, isRoot: $isRoot, toBeDeleted: $toBeDeleted, isDirty: $isDirty}';
  }

  const PathPoint(this.id, this.path, this.isRoot,
      [this.toBeDeleted = false, this.isDirty = false]);

  @override
  List<Object?> get props => [id, path, isRoot, toBeDeleted, isDirty];

  PathPoint copyWith(
      {String? id,
      String? path,
      bool? isRoot,
      bool? toBeDeleted,
      bool? isDirty}) {
    return PathPoint(id ?? this.id, path ?? this.path, isRoot ?? this.isRoot,
        toBeDeleted ?? this.toBeDeleted, isDirty ?? this.isDirty);
  }

  static PathPoint fromJSON(Map<String, dynamic> e) {
    final id = e['id'];
    final path = e['path'];
    final bool isRoot = e['isRoot'];

    return PathPoint(id, path, isRoot);
  }
}
