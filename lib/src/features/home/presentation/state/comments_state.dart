// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:commentree/src/core/utils/state/app_state.dart';
import 'package:commentree/src/core/utils/usecase/copyable.dart';
import 'package:commentree/src/features/home/data/models/comment_model.dart';
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
    this.errorMessage = "",
    this.itemCount = 0,
    this.pageNumber = 0,
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
      errorMessage: errorMessage ?? this.errorMessage,
      itemCount: itemCount ?? this.itemCount,
      pageNumber: pageNumber ?? this.pageNumber,
      hasReachedEndOfResults:
          hasReachedEndOfResults ?? this.hasReachedEndOfResults,
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      comments,
      errorMessage,
      itemCount,
      pageNumber,
      hasReachedEndOfResults,
    ];
  }

  @override
  CommentsState copy() => const CommentsState();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status.toString(),
      'comments': comments
          .map(
            (entity) => CommentModel(
                    postId: entity.postId,
                    id: entity.id,
                    name: entity.name,
                    email: entity.email,
                    body: entity.body)
                .toJson(),
          )
          .toList(),
      'errorMessage': errorMessage,
      'itemCount': itemCount,
      'pageNumber': pageNumber,
      'hasReachedEndOfResults': hasReachedEndOfResults,
    };
  }

  factory CommentsState.fromMap(Map<String, dynamic> map) {
    return CommentsState(
      status: AppState.getAppStateFromString(map['status']) ?? AppState.initial,
      comments: (map['comments'] as List)
          .map((element) => CommentModel.fromJson(element))
          .toList(),
      errorMessage: map['errorMessage'] as String,
      itemCount: map['itemCount'] as int,
      pageNumber: map['pageNumber'] as int,
      hasReachedEndOfResults: map['hasReachedEndOfResults'] as bool,
    );
  }

  @override
  bool get stringify => true;
}
