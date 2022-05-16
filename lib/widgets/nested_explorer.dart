import 'package:flutter/material.dart';
import 'package:kumo_app/CommunicationManager.dart';
import 'package:kumo_app/models/explore_result.dart';

class NestedExplorer extends StatefulWidget {
  final String path;

  const NestedExplorer({Key? key, required this.path}) : super(key: key);

  @override
  State<NestedExplorer> createState() => _NestedExplorerState();
}

class _NestedExplorerState extends State<NestedExplorer> {
  late final future;

  @override
  void initState(){
    super.initState();
    future = CommunicationManager.instance.explore(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExploreResult>>(
      future: future,
      builder: (context, snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator.adaptive(),);
          case ConnectionState.done:
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  onTap: () => Navigator.of(context).pushNamed('/explore', arguments: snapshot.data![index].absolutePath),
                );
              },
              itemCount: snapshot.data!.length,
            );
        }
      },
    );

  }
}
