import 'package:commentree/src/core/utils/error/failures.dart';
import 'package:commentree/src/core/utils/usecase/usecase.dart';
import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';
import 'package:dartz/dartz.dart';

///Marker for usecases for home feature
///
abstract class HomeUsecase {}

abstract class FetchComments extends HomeUsecase
    implements Usecase<List<CommentEntity>, NoParams> {
  @override
  Future<Either<Failure, List<CommentEntity>>> call(NoParams params);
}
