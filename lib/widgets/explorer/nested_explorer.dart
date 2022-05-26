import 'package:flutter/material.dart';
import 'package:kumo_app/models/explore_result.dart';
import 'package:kumo_app/systems/communication_manager.dart';
import 'package:kumo_app/widgets/explorer/tappable_crubs.dart';
import 'package:kumo_app/widgets/general_purpose/app_bar_overflow.dart';
import 'package:tuple/tuple.dart';

import 'file_widget.dart';

class NestedExplorer extends StatefulWidget {
  final String path;

  const NestedExplorer({Key? key, required this.path}) : super(key: key);

  @override
  State<NestedExplorer> createState() => _NestedExplorerState();
}

class _NestedExplorerState extends State<NestedExplorer> {
  late final Future<List<ExploreResult>> future;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              title: widget.path.isNotEmpty
                  ? TappableCrumbs(
                      path: widget.path,
                    )
                  : const Text('Explorer'),
              actions: const [
                AppBarOverflow(),
              ],
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: refreshAction,
          child: FutureBuilder<List<ExploreResult>>(
            future: future,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                case ConnectionState.done:
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: true,
                    itemBuilder: (context, index) => FileWidget(
                      data: snapshot.data![index],
                    ),
                    itemCount: snapshot.data!.length,
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    future = CommunicationManager.instance.explore(widget.path);
  }

  Future<void> refreshAction() async {
    await Navigator.pushReplacementNamed(
      context,
      'explore',
      arguments: Tuple2(widget.path, true),
    );
  }
}
