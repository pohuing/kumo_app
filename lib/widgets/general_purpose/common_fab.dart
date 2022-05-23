import 'package:flutter/material.dart';

class CommonFAB extends StatelessWidget {
  final void Function(BuildContext context)? action;
  final Widget? icon;

  const CommonFAB({Key? key, this.action, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: Theme.of(context).useMaterial3 ? 0 : null,
      onPressed: action != null ? () => action!(context) : null,
      child: icon,
    );
  }
}
