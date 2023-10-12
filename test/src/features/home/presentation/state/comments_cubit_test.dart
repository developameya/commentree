import 'package:commentree/src/core/utils/error/failures.dart';
import 'package:commentree/src/core/utils/state/app_state.dart';
import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';
import 'package:commentree/src/features/home/domain/usecases/home_usecases.dart';
import 'package:commentree/src/features/home/presentation/state/comments_cubit.dart';
import 'package:commentree/src/features/home/presentation/state/comments_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'comments_cubit_test.mocks.dart';

@GenerateNiceMocks(
    [MockSpec<FetchComments>(onMissingStub: OnMissingStub.throwException)])
void main() {
  MockFetchComments? mockUsecase;
  CommentsCubit? sut;

  final List<CommentEntity> testComments = List.generate(
      10,
      (index) => CommentEntity(
          postId: "1-$index",
          id: index.toString(),
          name: "name - $index",
          email: "email- $index",
          body:
              "This is the body of the comment, it can be very long, longer than you expect.- $index"));

  setUp(() {
    mockUsecase = MockFetchComments();
    sut = CommentsCubit(fetchComments: mockUsecase);
  });

  tearDown(() {
    sut = null;
    mockUsecase = null;
  });

  test('initial state.', () {
    //ARRANGE
    const expectedResult = CommentsState();

    //ACT
    final result = sut!.state;

    //ASSERT
    expect(expectedResult, result);
  });

  test(
      'when error occurs while fetching comments, emits error state with message.',
      () async {
    //ARRANGE
    const errorMessage = 'this is error';
    const expectedResult =
        CommentsState(status: AppState.error, errorMessage: errorMessage);

    //ACT
    when(mockUsecase!.call(any)).thenAnswer(
        (_) => Future.value(left(const CacheFailure(message: errorMessage))));

    sut!.fetchComments();

    await untilCalled(mockUsecase!.call(any));

    final result = sut!.state;

    //ASSERT
    expect(result, expectedResult);
  });

  test(
      'when comments are fetched successfully, emits success state with list of comments.',
      () async {
    final expectedResult =
        CommentsState(status: AppState.success, comments: testComments);

    //ACT
    when(mockUsecase!.call(any))
        .thenAnswer((_) => Future.value(right(testComments)));

    sut!.fetchComments();

    await untilCalled(mockUsecase!.call(any));

    final result = sut!.state;

    //ASSERT
    expect(result, expectedResult);
  });

  test(
      'when comments are fetched successfully, remove error message from state.',
      () async {
    //1
    //ARRANGE
    const errorMessage = 'this is error';
    const expectedResult =
        CommentsState(status: AppState.error, errorMessage: errorMessage);

    //ACT
    when(mockUsecase!.call(any)).thenAnswer(
        (_) => Future.value(left(const CacheFailure(message: errorMessage))));

    sut!.fetchComments();

    await untilCalled(mockUsecase!.call(any));

    final result = sut!.state;

    //ASSERT
    expect(result, expectedResult);

    //2
    final expectedResult2 =
        CommentsState(status: AppState.success, comments: testComments);

    //ACT
    when(mockUsecase!.call(any))
        .thenAnswer((_) => Future.value(right(testComments)));

    sut!.fetchComments();

    await untilCalled(mockUsecase!.call(any));

    final result2 = sut!.state;

    //ASSERT
    expect(result2, expectedResult2);
  });
}
