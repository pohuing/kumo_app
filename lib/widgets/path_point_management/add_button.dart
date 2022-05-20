import 'package:flutter/material.dart';
import 'package:kumo_app/blocs/path_point_cubit.dart';
import 'package:kumo_app/widgets/path_point_management/addition_form.dart';

class AddButton extends StatefulWidget {
  final PathPointManagementCubit cubit;

  const AddButton({Key? key, required this.cubit}) : super(key: key);

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: Theme.of(context).useMaterial3 ? 0 : null,
      onPressed: () async {
        return showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          builder: (context) {
            return AdditionForm(cubit: widget.cubit);
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
