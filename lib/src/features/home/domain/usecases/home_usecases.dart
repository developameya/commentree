import 'package:commentree/src/core/utils/error/failures.dart';
import 'package:commentree/src/core/utils/usecase/usecase.dart';
import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

///Marker for usecases for home feature
///
abstract class HomeUsecase {}

///Fetches comments from the repository.
///
abstract class FetchComments extends HomeUsecase
    implements Usecase<List<CommentEntity>, CommentsQueryParams> {
  @override
  Future<Either<Failure, List<CommentEntity>>> call(CommentsQueryParams params);
}

class CommentsQueryParams extends Equatable {
  final int page;
  final int count;

  const CommentsQueryParams({
    required this.page,
    required this.count,
  });

  @override
  List<Object?> get props => [page, count];
}
