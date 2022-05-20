import 'package:flutter/material.dart';
import 'package:kumo_app/widgets/general_purpose/app_bar_overflow.dart';

class CommonAppBar extends AppBar {
  final String _title;

  CommonAppBar({Key? key, required String title, List<Widget>? actions})
      : _title = title,
        super(
          key: key,
          actions: [
            ...?actions,
            const AppBarOverflow(),
          ],
        );

  @override
  Widget get title => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: Text(_title),
      );
}
