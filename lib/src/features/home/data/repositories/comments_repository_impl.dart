import 'package:commentree/src/core/common/constants/constants.dart';
import 'package:commentree/src/core/utils/error/failures.dart';
import 'package:commentree/src/features/home/data/datasources/comments_datasource.dart';
import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';
import 'package:commentree/src/features/home/domain/repositories/comments_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CommentsRepository)
class CommentsRepositoryImpl extends CommentsRepository {
  final CommentsDatasource _remoteDatasource;
  final CommentsDatasource _localDatasource;

  CommentsRepositoryImpl({
    @Named(remoteDatsourceKey) required CommentsDatasource remoteDatasource,
    @Named(localDatasourceKey) required CommentsDatasource localDatasource,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource;
  @override
  Future<Either<Failure, List<CommentEntity>>> fetchComments(
      {required int count, required int page}) async {
    late Future<Either<Failure, List<CommentEntity>>> response;

    try {
      //try to fetch data from the local datasource.
      final Either<Failure, List<CommentEntity>> localResponse =
          await _localDatasource.fetchComments(page: page, count: count);

      //if local data is available, return the data, else get data from remote.
      if (localResponse.isRight()) {
        localResponse.fold(
          (l) => null,
          (result) => response = Future.value(right(result)),
        );
      } else {
        response = _remoteDatasource.fetchComments(page: page, count: count);
      }
    } on Exception {
      return Future.value(left(
          const CacheFailure(message: 'error occured while fetching data.')));
    }

    return response;
  }
}
