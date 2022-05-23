import 'package:flutter/material.dart';
import 'package:kumo_app/blocs/path_point_cubit.dart';

class AdditionForm extends StatefulWidget {
  final PathPointManagementCubit cubit;

  const AdditionForm({Key? key, required this.cubit}) : super(key: key);

  @override
  State<AdditionForm> createState() => _AdditionFormState();
}

class _AdditionFormState extends State<AdditionForm> {
  bool isRoot = false;
  String path = '';
  bool saveFailed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add a path point',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Path',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: (value) => path = value,
          ),
          if (saveFailed) const Text('You can\'t pick this path'),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Is Root:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Checkbox(
                value: isRoot,
                onChanged: (v) {
                  setState(() => isRoot = !isRoot);
                },
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final res = await widget.cubit.addPoint(path, isRoot);
                  setState(() => saveFailed = !res);
                  if (res) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    await widget.cubit.loadPoints();
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
