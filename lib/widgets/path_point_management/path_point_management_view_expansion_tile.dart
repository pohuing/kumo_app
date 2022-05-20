import 'package:flutter/material.dart';
import 'package:kumo_app/blocs/path_point_cubit.dart';

class PathPointManagementViewExpansionTile extends StatelessWidget {
  final String path;
  final bool isRoot;
  final bool toBeDeleted;
  final String id;

  final PathPointManagementCubit cubit;

  const PathPointManagementViewExpansionTile({
    Key? key,
    required this.cubit,
    required this.path,
    required this.isRoot,
    required this.toBeDeleted,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(path),
      children: [
        ButtonBar(
          children: [
            MaterialButton(
              child: Row(
                children: [
                  const Text('Is Root:'),
                  IgnorePointer(
                    child: Checkbox(
                      visualDensity: VisualDensity.compact,
                      value: isRoot,
                      // ignore: avoid_returning_null_for_void
                      onChanged: (v) => null,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                cubit.togglePoint(id);
              },
            ),
            MaterialButton(
              child: Row(
                children: [
                  const Text('Delete:'),
                  Icon(
                    toBeDeleted ? Icons.cancel : Icons.delete_forever,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                ],
              ),
              onPressed: () {
                cubit.toggleDeletePoint(id);
              },
            )
          ],
        ),
      ],
    );
  }
}
