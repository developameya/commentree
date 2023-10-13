import 'package:auto_route/annotations.dart';
import 'package:commentree/src/features/home/presentation/state/comments_cubit.dart';
import 'package:commentree/src/features/home/presentation/views/comments_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()

///Displays all the comments in a list.
///
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentsCubit()..fetchComments(),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(title: const Text("Home")),
        body: CommentsView(),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () =>
                  BlocProvider.of<CommentsCubit>(context).fetchComments(),
              child: const Icon(Icons.refresh),
            );
          },
        ),
      ),
    );
  }
}
