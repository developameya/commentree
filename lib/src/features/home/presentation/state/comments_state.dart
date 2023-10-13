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

  ///Length of the list of items to be displayed.
  ///Defaults to 0.
  final int itemCount;

  ///Current page number.
  ///Defaults to 0.
  final int pageNumber;

  //Whether the list has reached the end.
  ///Defaults to false.
  final bool hasReachedEndOfResults;

  const CommentsState({
    this.status = AppState.initial,
    this.comments = const [],
    this.itemCount = 0,
    this.pageNumber = 0,
    this.errorMessage = "",
    this.hasReachedEndOfResults = false,
  });

  @override
  CommentsState copyWith({
    AppState? status,
    List<CommentEntity>? comments,
    String? errorMessage,
    int? itemCount,
    int? pageNumber,
    bool? hasReachedEndOfResults,
  }) {
    return CommentsState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      itemCount: itemCount ?? this.itemCount,
      pageNumber: pageNumber ?? this.pageNumber,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedEndOfResults:
          hasReachedEndOfResults ?? this.hasReachedEndOfResults,
    );
  }

  @override
  List<Object> get props => [
        status,
        comments,
        itemCount,
        pageNumber,
        errorMessage,
        hasReachedEndOfResults,
      ];

  @override
  CommentsState copy() => const CommentsState();
}
