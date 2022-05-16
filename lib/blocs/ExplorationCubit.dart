import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/CommunicationManager.dart';
import 'package:kumo_app/models/explore_result.dart';

class ExplorationCubit extends Cubit<ExplorationState>{
  ExplorationCubit() : super(ExplorationStateLoading(''));

  Future<void> explore(String path) async {
    emit(ExplorationStateLoading(path));
    final result = await CommunicationManager.instance.explore(path);
    emit(ExplorationStateLoaded(result));
  }
}

class ExplorationStateLoading extends ExplorationState {
  final String path;

  ExplorationStateLoading(this.path);
}

abstract class ExplorationState {
}

class ExplorationStateLoaded extends ExplorationState{
  final List<ExploreResult> items;

  ExplorationStateLoaded(this.items);
}

class ExplorationStateRoot extends ExplorationState{}