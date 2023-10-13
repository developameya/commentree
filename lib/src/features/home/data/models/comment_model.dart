import 'dart:convert';

import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';

///Contains methods to transform the data recieved from remote source,
///to [CommentEntity].
///
class CommentModel extends CommentEntity {
  const CommentModel({
    required super.postId,
    required super.id,
    required super.name,
    required super.email,
    required super.body,
  });

  ///Converts the json string to [CommentEntity].
  ///
  factory CommentModel.fromRawJson(String jsonStr) =>
      CommentModel.fromJson(json.decode(jsonStr));

  ///Converts a map in json format string to [CommentEntity].
  ///
  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        postId: (json["postId"] as int).toString(),
        id: (json["id"] as int).toString(),
        name: json["name"],
        email: json["email"],
        body: json["body"],
      );

  ///Converts a [CommentEntity] to map in json format.
  ///
  Map<String, dynamic> toJson() => {
        "postId": int.parse(postId),
        "id": int.parse(id),
        "name": name,
        "email": email,
        "body": body,
      };
}
