import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/exploration_cubit.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExplorationCubit, ExplorationState>(
      builder: (context, state) {
        if (state is ExplorationStateLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        final s = state as ExplorationStateLoaded;
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(s.items[index].name),
              onTap: () => context
                  .read<ExplorationCubit>()
                  .explore(s.items[index].absolutePath),
            );
          },
          itemCount: s.items.length,
        );
      },
    );
  }

  @override
  void initState(){
    super.initState();
    context.read<ExplorationCubit>().explore('');
  }
}
