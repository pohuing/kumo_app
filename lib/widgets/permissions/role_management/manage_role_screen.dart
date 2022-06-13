import 'package:flutter/material.dart';
import 'package:kumo_app/widgets/general_purpose/common_fab.dart';

import '../../../models/populated_permission.dart';
import '../../general_purpose/material_adaptive_scaffold.dart';

class ManageRoleScreen extends StatefulWidget {
  final List<PopulatedPermission> points;

  const ManageRoleScreen({Key? key, required this.points}) : super(key: key);

  @override
  State<ManageRoleScreen> createState() => _ManageRoleScreenState();
}

class _ManageRoleScreenState extends State<ManageRoleScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialAdaptiveScaffold(
      fab: const CommonFAB(icon: Icon(Icons.add)),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
      body: ListView.builder(
        primary: true,
        itemCount: widget.points.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(widget.points[index].pathPoint.path),
            children: [
              SwitchListTile.adaptive(
                value: widget.points[index].permission.delete,
                onChanged: (v) {},
                title: const Text('Delete'),
              ),
              SwitchListTile.adaptive(
                value: widget.points[index].permission.modifyRoot,
                onChanged: (v) {},
                title: const Text('ModifyRoot'),
              ),
              SwitchListTile.adaptive(
                value: widget.points[index].permission.read,
                onChanged: (v) {},
                title: const Text('Read'),
              ),
              SwitchListTile.adaptive(
                value: widget.points[index].permission.write,
                onChanged: (v) {},
                title: const Text('Write'),
              ),
              const ListTile(
                title: Text('Delete'),
                trailing: Icon(Icons.delete_forever),
              ),
            ],
          );
        },
      ),
      title: widget.points.first.role.name,
    );
  }
}
