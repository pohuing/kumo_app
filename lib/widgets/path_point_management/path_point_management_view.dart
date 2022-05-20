import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/path_point_cubit.dart';
import 'package:kumo_app/widgets/path_point_management/add_button.dart';
import 'package:kumo_app/widgets/path_point_management/path_point_management_view_expansion_tile.dart';
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
      appBar: CommonAppBar(
        title: 'Manage Path Points',
        actions: [
          if (!Theme.of(context).useMaterial3) SaveButton(cubit: cubit),
        ],
      ),
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
            itemBuilder: (context, index) {
              var point = state.pathPoints[index];
              return PathPointManagementViewExpansionTile(
                cubit: cubit,
                path: point.path,
                isRoot: point.isRoot,
                id: point.id,
                toBeDeleted: point.toBeDeleted,
              );
            },
            itemCount: state.pathPoints.length,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    cubit = PathPointManagementCubit(const PathPointManagementState([]));
    cubit.loadPoints();
  }
}
