import 'package:flutter/material.dart';
import 'package:kumo_app/models/explore_result.dart';
import 'package:tuple/tuple.dart';

class FileWidget extends StatelessWidget {
  final ExploreResult data;

  const FileWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final Widget icon;
    switch (data.fileSystemEntityType) {
      case FileSystemEntryType.unknown:
        icon = const Icon(Icons.question_mark);
        break;
      case FileSystemEntryType.directory:
        icon = const Icon(Icons.folder);
        break;
      case FileSystemEntryType.file:
        icon = const Icon(Icons.file_open);
        break;
    }

    return ListTile(
      dense: false,
      leading: icon,
      title: Text(data.name),
      onTap: data.fileSystemEntityType == FileSystemEntryType.directory
          ? () => Navigator.of(context).pushNamed(
                '/explore',
                arguments: Tuple2(data.absolutePath, false),
              )
          : null,
    );
  }
}
