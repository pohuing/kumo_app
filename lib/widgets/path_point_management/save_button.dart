import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/path_point_cubit.dart';

class SaveButton extends StatelessWidget {
  final PathPointManagementCubit cubit;

  const SaveButton({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PathPointManagementCubit, PathPointManagementState>(
      bloc: cubit,
      builder: (context, state) => IconButton(
          onPressed: cubit.anyChanged ? cubit.save : null,
          icon: const Icon(Icons.save)),
    );
  }
}
