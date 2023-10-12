// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:commentree/src/core/utils/usecase/copyable.dart';
import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable implements Copyable<CommentEntity> {
  final String postId;
  final String id;
  final String name;
  final String email;
  final String body;

  const CommentEntity({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  @override
  List<Object> get props {
    return [
      postId,
      id,
      name,
      email,
      body,
    ];
  }

  @override
  CommentEntity copyWith({
    String? postId,
    String? id,
    String? name,
    String? email,
    String? body,
  }) {
    return CommentEntity(
      postId: postId ?? this.postId,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      body: body ?? this.body,
    );
  }

  @override
  CommentEntity copy() => CommentEntity(
        postId: postId,
        id: id,
        name: name,
        email: email,
        body: body,
      );
}
