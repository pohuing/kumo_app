import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class TappableCrumbs extends StatelessWidget {
  final String path;

  const TappableCrumbs({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: path
            .split(RegExp(r'[\\/]+'))
            .where((e) => e.isNotEmpty)
            .map(
              (e) => MaterialButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) {
                    if (route.settings.arguments == null) return true;

                    final settings =
                        route.settings.arguments as Tuple2<String, bool>;
                    if (settings.item2) {
                      return true;
                    }
                    var last2 = settings.item1.split(RegExp(r'[\\/]+')).last;
                    log(last2, name: runtimeType.toString());
                    if (last2 == e) {
                      return true;
                    }
                    return false;
                  });
                },
                child: Text(e),
              ),
            )
            .toList(),
      ),
    );
  }
}
