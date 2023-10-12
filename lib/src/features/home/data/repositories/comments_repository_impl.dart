import 'package:commentree/src/core/utils/error/failures.dart';
import 'package:commentree/src/features/home/data/datasources/comments_datasource.dart';
import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';
import 'package:commentree/src/features/home/domain/repositories/comments_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CommentsRepository)
class CommentsRepositoryImpl extends CommentsRepository {
  final CommentsDatasource _datasource;

  CommentsRepositoryImpl({required CommentsDatasource datasource})
      : _datasource = datasource;
  @override
  Future<Either<Failure, List<CommentEntity>>> fetchComments() {
    return _datasource.fetchComments();
  }
}
