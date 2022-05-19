import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/path_point_cubit.dart';

import 'general_purpose/common_app_bar.dart';

class PathPointManagementView extends StatefulWidget {
  const PathPointManagementView({Key? key}) : super(key: key);

  @override
  State<PathPointManagementView> createState() =>
      _PathPointManagementViewState();
}

class _PathPointManagementViewState extends State<PathPointManagementView> {
  late PathPointManagementCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(title: 'Manage Path Points'),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              BlocBuilder<PathPointManagementCubit, PathPointManagementState>(
                bloc: cubit,
                builder: (context, state) => IconButton(
                    onPressed: cubit.anyChanged ? () {} : null,
                    icon: const Icon(Icons.save)),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  elevation: Theme.of(context).useMaterial3 ? 0 : null,
                  onPressed: () {},
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder<PathPointManagementCubit, PathPointManagementState>(
          bloc: cubit,
          builder: (context, state) => ListView.builder(
            primary: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) => ExpansionTile(
              title: Text(state.pathPoints[index].path),
              children: [
                ButtonBar(
                  children: [
                    MaterialButton(
                        child: Row(
                          children: [
                            const Text('Is Root:'),
                            Icon(
                              state.pathPoints[index].isRoot
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                        onPressed: () {
                          log('Tried to toggle root path property ${state.pathPoints[index]}');
                          cubit.togglePoint(state.pathPoints[index].id);
                        }),
                    MaterialButton(
                        child: Row(
                          children: [
                            const Text('Delete:'),
                            Icon(
                              state.pathPoints[index].toBeDeleted
                                  ? Icons.cancel
                                  : Icons.delete_forever,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          ],
                        ),
                        onPressed: () {
                          log('Wanted to delete ${state.pathPoints[index]}');
                          cubit.toggleDeletePoint(state.pathPoints[index].id);
                        })
                  ],
                ),
              ],
            ),
            itemCount: state.pathPoints.length,
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    cubit = PathPointManagementCubit(const PathPointManagementState([]));
    cubit.loadPoints();
  }
}
