import 'package:commentree/src/core/utils/error/failures.dart';
import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';
import 'package:dartz/dartz.dart';

///Queries the datasource for the list of comments.
///
abstract class CommentsRepository {
  ///On successful query provides the list of comments as [CommentEntity]
  ///or returns a [Failure],
  ///
  Future<Either<Failure, List<CommentEntity>>> fetchComments(
      {required int page, required int count});
}
