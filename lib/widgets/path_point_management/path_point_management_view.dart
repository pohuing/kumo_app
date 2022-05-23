import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/path_point_cubit.dart';
import 'package:kumo_app/widgets/general_purpose/common_fab.dart';
import 'package:kumo_app/widgets/general_purpose/material_adaptive_scaffold.dart';
import 'package:kumo_app/widgets/path_point_management/addition_form.dart';
import 'package:kumo_app/widgets/path_point_management/path_point_management_view_expansion_tile.dart';
import 'package:kumo_app/widgets/path_point_management/save_button.dart';

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
    return MaterialAdaptiveScaffold(
      actions: [
        SaveButton(cubit: cubit),
      ],
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
      title: 'Manage PathPoints',
      fab: _AddButton(cubit: cubit),
    );
  }

  @override
  void initState() {
    super.initState();
    cubit = PathPointManagementCubit(const PathPointManagementState([]));
    cubit.loadPoints();
  }
}

class _AddButton extends CommonFAB {
  final PathPointManagementCubit cubit;

  const _AddButton({required this.cubit});

  @override
  Icon get icon => const Icon(Icons.add);

  @override
  void Function(BuildContext context) get action => (context) async {
        return showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          builder: (context) {
            return BottomSheet(
              onClosing: () {},
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              builder: (context) {
                return AdditionForm(cubit: cubit);
              },
            );
          },
        );
      };
}
