import 'package:commentree/src/core/utils/error/failures.dart';
import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';
import 'package:commentree/src/features/home/domain/repositories/comments_repository.dart';
import 'package:commentree/src/features/home/domain/usecases/home_usecases.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: FetchComments)
class FetchCommentsImpl extends FetchComments {
  final CommentsRepository _repo;

  FetchCommentsImpl({required CommentsRepository repo}) : _repo = repo;

  @override
  Future<Either<Failure, List<CommentEntity>>> call(
      CommentsQueryParams params) {
    return _repo.fetchComments(page: params.page, count: params.count);
  }
}
