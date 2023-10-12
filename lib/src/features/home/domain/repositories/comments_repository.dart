import 'package:commentree/src/core/utils/error/failures.dart';
import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CommentsRepository {
  Future<Either<Failure, List<CommentEntity>>> fetchComments();
}
