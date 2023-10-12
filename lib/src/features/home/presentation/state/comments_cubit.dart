import 'package:commentree/src/features/home/presentation/state/comments_state.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit() : super(const CommentsState());

  void fetchComments() {
    debugPrint("comments are fetched");
  }
}
