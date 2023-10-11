import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()

///Displays all the comments in a list.
///
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
