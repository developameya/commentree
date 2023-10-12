import 'package:commentree/src/core/common/services/service_locator/service_locator.dart';
import 'package:commentree/src/core/utils/state/app_state.dart';
import 'package:commentree/src/core/utils/usecase/usecase.dart';
import 'package:commentree/src/features/home/domain/usecases/home_usecases.dart';
import 'package:commentree/src/features/home/presentation/state/comments_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final FetchComments _usecase;
  CommentsCubit({FetchComments? fetchComments})
      : _usecase = fetchComments ?? sl<FetchComments>(),
        super(const CommentsState());

  void fetchComments() {
    emit(state.copyWith(status: AppState.loading));

    _usecase.call(NoParams()).then(
          (data) => data.fold(
            (failure) => emit(
              state.copyWith(
                  status: AppState.error, errorMessage: failure.message),
            ),
            (data) => emit(state.copyWith(
                status: AppState.success, comments: data, errorMessage: '')),
          ),
        );
  }
}
