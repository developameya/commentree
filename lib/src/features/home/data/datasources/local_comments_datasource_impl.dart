import 'package:commentree/src/core/common/constants/constants.dart';
import 'package:commentree/src/core/utils/error/failures.dart';
import 'package:commentree/src/features/home/data/datasources/comments_datasource.dart';
import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

///Implementation of [CommentsDatasource].
///
@Named(localDatasourceKey)
@LazySingleton(as: CommentsDatasource)
class LocalCommentsDatasourceImpl extends CommentsDatasource {
  @override
  Future<Either<Failure, List<CommentEntity>>> fetchComments(
      {required int count, required int page}) {
    debugPrint('reached local datasource');
    //TODO: implement
    return Future.value(left(const CacheFailure()));
  }
}
