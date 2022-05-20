import 'package:equatable/equatable.dart';

class ExploreResult extends Equatable {
  final String name;
  final String absolutePath;
  final bool canWrite;
  final bool canDelete;
  final FileSystemEntryType fileSystemEntityType;

  const ExploreResult(this.name, this.absolutePath, this.canWrite,
      this.canDelete, this.fileSystemEntityType);

  @override
  List<Object?> get props => [name, absolutePath, canWrite, canDelete];

  static ExploreResult fromJSON(Map<String, dynamic> data) {
    var name = data['name'];
    var absolutePath = data['absolutePath'];
    var canWrite = data['canWrite'] ?? false;
    var canDelete = data['canDelete'] ?? false;
    var fileSystemEntryType =
        FileSystemEntryType.values[data['fileSystemEntryType']];

    return ExploreResult(
        name, absolutePath, canWrite, canDelete, fileSystemEntryType);
  }
}

enum FileSystemEntryType { unknown, directory, file }
