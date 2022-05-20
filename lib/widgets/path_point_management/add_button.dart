import 'package:flutter/material.dart';
import 'package:kumo_app/blocs/path_point_cubit.dart';

class AddButton extends StatelessWidget {
  final PathPointManagementCubit cubit;

  const AddButton({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: Theme.of(context).useMaterial3 ? 0 : null,
      onPressed: () {},
      child: const Icon(Icons.add),
    );
  }
}
