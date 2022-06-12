import 'package:flutter/material.dart';

/// Convenience function to show a loading icon or the error text for use in [FutureBuilder]
Widget futureBuilderHandler({
  required AsyncSnapshot snapshot,
  Widget Function(AsyncSnapshot snapshot)? onLoading,
  required Widget Function(AsyncSnapshot snapshot) onFinished,
  Widget Function(AsyncSnapshot snapshot)? onError,
}) {
  if (snapshot.hasError) {
    return onError?.call(snapshot) ??
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.error),
            Text(snapshot.error.toString()),
          ],
        );
  }
  if (!snapshot.hasData) {
    return onLoading?.call(snapshot) ??
        const Center(child: CircularProgressIndicator.adaptive());
  }
  return onFinished(snapshot);
}
