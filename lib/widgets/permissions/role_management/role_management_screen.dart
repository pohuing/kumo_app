import 'package:flutter/material.dart';
import 'package:kumo_app/widgets/general_purpose/common_fab.dart';
import 'package:kumo_app/widgets/general_purpose/material_adaptive_scaffold.dart';

class RoleManagementScreen extends StatefulWidget {
  const RoleManagementScreen({Key? key}) : super(key: key);

  @override
  State<RoleManagementScreen> createState() => _RoleManagementScreenState();
}

class _RoleManagementScreenState extends State<RoleManagementScreen> {
  final dummyData = ['Videos', 'Documents'];

  @override
  Widget build(BuildContext context) {
    return MaterialAdaptiveScaffold(
      title: 'Manage Permissions',
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.save)),
      ],
      fab: const CommonFAB(icon: Icon(Icons.add)),
      body: ListView.builder(
        primary: true,
        itemBuilder: (BuildContext context, int index) => ListTile(
          title: Text(dummyData[index]),
        ),
        itemCount: dummyData.length,
      ),
    );
  }
}
