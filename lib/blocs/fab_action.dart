import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FabActionCubit extends Cubit<void Function(BuildContext context)?> {
  FabActionCubit(super.initialState);

  void changeAction(void Function(BuildContext context)? action) {
    emit(action);
  }
}
