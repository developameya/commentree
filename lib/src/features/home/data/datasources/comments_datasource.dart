import 'package:commentree/src/core/utils/error/failures.dart';
import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';
import 'package:dartz/dartz.dart';

///Fetches the list of comments from the datasource.
abstract class CommentsDatasource {
  ///On successful query provides the list of comments as [CommentEntity]
  ///or returns a [Failure] on error while fetching the comments.
  ///
  Future<Either<Failure, List<CommentEntity>>> fetchComments(
      {required int page, required int count});
}
