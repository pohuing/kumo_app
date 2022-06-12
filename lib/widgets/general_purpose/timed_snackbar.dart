import 'dart:math';

import 'package:flutter/material.dart';

void showTimedSnackBar(BuildContext context, String message) {
  {
    final duration = max(4000, message.length * 100);
    final endTime = DateTime.now().add(Duration(milliseconds: duration));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: duration),
        content: IgnorePointer(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(message),
              const SizedBox(height: 16),
              // TODO: This can probably done in a more efficient manner on every frame instead of scheduled for time
              StreamBuilder<int>(
                stream: Stream.periodic(
                  const Duration(microseconds: 69),
                  (computationCount) =>
                      (endTime.difference(DateTime.now())).inMilliseconds,
                ).takeWhile(
                  (tick) => 0 > DateTime.now().compareTo(endTime),
                ),
                builder: (context, snapshot) => snapshot.hasData
                    ? LinearProgressIndicator(
                        value: snapshot.data! / duration,
                      )
                    : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
