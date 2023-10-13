import 'package:commentree/src/core/common/services/service_locator/service_locator.dart';
import 'package:commentree/src/core/utils/error/failures.dart';
import 'package:commentree/src/core/utils/state/app_state.dart';
import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';
import 'package:commentree/src/features/home/domain/usecases/home_usecases.dart';
import 'package:commentree/src/features/home/presentation/state/comments_state.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final FetchComments _usecase;
  final int _queryCount = 10;
  CommentsCubit({FetchComments? fetchComments})
      : _usecase = fetchComments ?? sl<FetchComments>(),
        super(const CommentsState());

  void fetchComments() {
    if (state.hasReachedEndOfResults) {
      return;
    }
    emit(state.copyWith(status: AppState.loading));

    _usecase(
            CommentsQueryParams(page: state.pageNumber + 1, count: _queryCount))
        .then((result) => result.fold(_ifLeft, _ifRight));
  }

  _ifLeft(Failure failure) => emit(state.copyWith(
        status: AppState.error,
        errorMessage: failure.message,
      ));

  _ifRight(List<CommentEntity> data) {
    if (data.length < _queryCount) {
      emit(state.copyWith(hasReachedEndOfResults: true));
    }

    if (data.isEmpty) {
      emit(state.copyWith(status: AppState.success));
      return;
    }

    final resultList = [...state.comments, ...data];

    emit(
      state.copyWith(
        status: AppState.success,
        comments: resultList,
        pageNumber: state.pageNumber + 1,
        itemCount: state.hasReachedEndOfResults
            ? resultList.length
            : resultList.length + 1,
        errorMessage: '',
      ),
    );
    debugPrint(
        'page: ${state.pageNumber}, resultLength: ${state.comments.length}, itemCount: ${state.itemCount}, lastResult: ${state.hasReachedEndOfResults}');
  }
}
