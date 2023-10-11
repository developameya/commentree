import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

///Asks for optional user crendentials.
///- Note:
/// All data is stored locally.
@RoutePage()
class WelcomeScreen extends StatelessWidget {
  //Provides a result for first use.
  final Function(bool)? onResult;

  const WelcomeScreen({super.key, this.onResult});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome'),
        //TODO: add a warning to not input any sensitive data.
      ),
    );
  }
}
