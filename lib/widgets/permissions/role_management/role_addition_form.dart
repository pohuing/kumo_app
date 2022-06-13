import 'package:flutter/material.dart';
import 'package:kumo_app/blocs/role_management_cubit.dart';

class RoleAdditionForm extends StatefulWidget {
  final RoleManagementCubit cubit;

  const RoleAdditionForm({Key? key, required this.cubit}) : super(key: key);

  @override
  State<RoleAdditionForm> createState() => _RoleAdditionFormState();
}

class _RoleAdditionFormState extends State<RoleAdditionForm> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add a new role',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Role name:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: (value) => name = value,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final res = await widget.cubit.addRole(name);
                  if (res) {
                    Navigator.of(context).pop(true);
                  }
                },
                child: const Text('Confirm'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
