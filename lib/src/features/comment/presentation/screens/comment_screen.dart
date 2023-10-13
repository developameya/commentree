import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()

///Displays all the details of a comment.
///
class CommentScreen extends StatelessWidget {
  const CommentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Comments'),
      ),
    );
  }
}
