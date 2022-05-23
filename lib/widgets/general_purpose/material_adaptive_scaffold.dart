import 'package:flutter/material.dart';
import 'package:kumo_app/widgets/general_purpose/common_app_bar.dart';
import 'package:kumo_app/widgets/general_purpose/common_fab.dart';

/// A scaffold which shows actions in a bottom app bar if the current theme uses
class MaterialAdaptiveScaffold extends StatelessWidget {
  final List<Widget>? actions;
  final CommonFAB fab;
  final String title;
  final Widget body;

  const MaterialAdaptiveScaffold({
    Key? key,
    this.actions,
    required this.fab,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: title,
        actions: [
          if (!Theme.of(context).useMaterial3) ...?actions,
        ],
      ),
      floatingActionButton: !Theme.of(context).useMaterial3 ? fab : null,
      bottomNavigationBar: Theme.of(context).useMaterial3
          ? BottomAppBar(
              child: Row(
                children: [
                  ...?actions,
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: fab,
                  ),
                ],
              ),
            )
          : null,
      body: body,
    );
  }
}
