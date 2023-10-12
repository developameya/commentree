// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:commentree/src/core/utils/state/app_state.dart';
import 'package:commentree/src/core/utils/usecase/copyable.dart';
import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';
import 'package:equatable/equatable.dart';

///Represents the state of the comments view.
//
class CommentsState extends Equatable implements Copyable<CommentsState> {
  ///Current state of data retrival.
  ///Defaults to 'inital' AppState.
  final AppState status;

  ///The data that to be displayed when data is fetched successfully.
  ///Default is empty list.
  final List<CommentEntity> comments;

  ///Error message in case an error occurs.
  ///Defaults to an empty string.
  final String errorMessage;

  const CommentsState({
    this.status = AppState.initial,
    this.comments = const [],
    this.errorMessage = "",
  });

  @override
  CommentsState copyWith({
    AppState? status,
    List<CommentEntity>? comments,
    String? errorMessage,
  }) {
    return CommentsState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, comments, errorMessage];

  @override
  CommentsState copy() => const CommentsState();
}
