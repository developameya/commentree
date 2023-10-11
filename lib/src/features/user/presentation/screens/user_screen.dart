import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()

///Displays user info and recently viewed comments.
///
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('User'),
      ),
    );
  }
}
