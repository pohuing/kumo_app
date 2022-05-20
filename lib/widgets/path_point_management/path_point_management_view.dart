import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/path_point_cubit.dart';
import 'package:kumo_app/widgets/path_point_management/add_button.dart';
import 'package:kumo_app/widgets/path_point_management/save_button.dart';

import '../general_purpose/common_app_bar.dart';

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
        appBar: CommonAppBar(title: 'Manage Path Points', actions: [
          if (!Theme.of(context).useMaterial3) SaveButton(cubit: cubit),
        ]),
        floatingActionButton:
            !Theme.of(context).useMaterial3 ? AddButton(cubit: cubit) : null,
        bottomNavigationBar: Theme.of(context).useMaterial3
            ? BottomAppBar(
                child: Row(
                  children: [
                    SaveButton(cubit: cubit),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AddButton(cubit: cubit),
                    ),
                  ],
                ),
              )
            : null,
        body: BlocBuilder<PathPointManagementCubit, PathPointManagementState>(
          bloc: cubit,
          builder: (context, state) => RefreshIndicator(
            onRefresh: cubit.loadPoints,
            child: ListView.builder(
              primary: true,
              itemBuilder: (context, index) => ExpansionTile(
                key: Key(state.pathPoints[index].id),
                title: Text(state.pathPoints[index].path),
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
                                  value: state.pathPoints[index].isRoot,
                                  onChanged: (v) => null,
                                ),
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
