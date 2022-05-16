import 'package:flutter/material.dart';
import 'package:kumo_app/CommunicationManager.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData)
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        return Text(snapshot.data!.toString());
      },
      future: CommunicationManager.instance.explore('C:/Users/patri'),
    );
  }
}
