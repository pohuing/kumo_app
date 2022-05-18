import 'package:flutter/material.dart';
import 'package:kumo_app/widgets/general_purpose/app_bar_overflow.dart';


class CommonAppBar extends AppBar {
  final String _title;

  CommonAppBar({Key? key, required String title})
      : _title = title,
        super(key: key, actions: [
          const AppBarOverflow(),
        ]);

  @override
  Widget get title => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: Text(_title),
      );
}
