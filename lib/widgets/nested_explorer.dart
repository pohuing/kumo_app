import 'package:flutter/material.dart';
import 'package:kumo_app/communication_manager.dart';
import 'package:kumo_app/models/explore_result.dart';
import 'package:kumo_app/widgets/general_purpose/accent_color_picker.dart';

class NestedExplorer extends StatefulWidget {
  final String path;

  const NestedExplorer({Key? key, required this.path}) : super(key: key);

  @override
  State<NestedExplorer> createState() => _NestedExplorerState();
}

class _NestedExplorerState extends State<NestedExplorer> {
  late final Future<List<ExploreResult>> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExploreResult>>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          case ConnectionState.done:
            return ListView.builder(
              itemBuilder: (context, index) => FileWidget(
                  data: snapshot.data![index],
                ),
              itemCount: snapshot.data!.length,
            );
        }
      },
    );
  }

  Future<void> showColorPicker() async {
    await showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return const AccentColorPicker();
        });
  }

  @override
  void initState() {
    super.initState();
    future = CommunicationManager.instance.explore(widget.path);
  }
}

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
      dense: true,
      leading: icon,
      title: Text(data.name),
      onTap: data.fileSystemEntityType == FileSystemEntryType.directory
          ? () => Navigator.of(context)
              .pushNamed('/explore', arguments: data.absolutePath)
          : null,
    );
  }
}
