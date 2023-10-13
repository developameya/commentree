import 'package:commentree/src/core/utils/error/failures.dart';
import 'package:commentree/src/core/utils/state/app_state.dart';
import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';
import 'package:commentree/src/features/home/domain/usecases/home_usecases.dart';
import 'package:commentree/src/features/home/presentation/state/comments_cubit.dart';
import 'package:commentree/src/features/home/presentation/state/comments_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'comments_cubit_test.mocks.dart';

class MockStorage extends Mock implements Storage {
  @override
  Future<void> write(String key, dynamic value) async {}
}

void initHydratedBloc() {
  final hydratedStorage = MockStorage();
  TestWidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = hydratedStorage;
}

@GenerateNiceMocks(
    [MockSpec<FetchComments>(onMissingStub: OnMissingStub.throwException)])
void main() {
  initHydratedBloc();
  MockFetchComments? mockUsecase;
  CommentsCubit? sut;

  final List<CommentEntity> testComments = List.generate(
      55,
      (index) => CommentEntity(
          postId: index.toString(),
          id: (index + 10).toString(),
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
    final resultList = testComments.take(10).toList();
    final expectedResult = CommentsState(
      status: AppState.success,
      comments: resultList,
      pageNumber: 1,
      itemCount: (resultList.length + 1),
    );

    //ACT
    when(mockUsecase!.call(any))
        .thenAnswer((_) => Future.value(right(resultList)));

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
    //ARRANGE
    final resultList = testComments.take(10).toList();
    final expectedResult2 = CommentsState(
      status: AppState.success,
      comments: resultList,
      pageNumber: 1,
      itemCount: (resultList.length + 1),
    );

    //ACT
    when(mockUsecase!.call(any))
        .thenAnswer((_) => Future.value(right(resultList)));

    sut!.fetchComments();

    await untilCalled(mockUsecase!.call(any));

    final result2 = sut!.state;

    //ASSERT
    expect(result2, expectedResult2);
  });

  test(
      'when paged data is fetched successfully, the page number in the state increments, comments list is updated and listLength is updated.',
      () async {
    //ARRANGE
    final testInputList = testComments.take(10).toList();
    final resultList = testComments.take(20).toList();
    final expectedResult = CommentsState(
      status: AppState.success,
      comments: resultList,
      pageNumber: 2,
      itemCount: (resultList.length + 1),
    );

    final testInput = CommentsState(
      status: AppState.success,
      comments: testInputList,
      pageNumber: 1,
      itemCount: (testInputList.length + 1),
    );

    //ACT
    sut!.emit(testInput);

    when(mockUsecase!.call(any)).thenAnswer(
        (_) => Future.value(right(testComments.getRange(10, 20).toList())));

    sut!.fetchComments();

    await untilCalled(mockUsecase!.call(any));

    final result = sut!.state;

    //ASSERT
    expect(result, expectedResult);
  });

  test(
      'when the last batch of results are recieved, the item count equates to the length of all the results.',
      () async {
    //ARRANGE
    final testInputList = testComments.take(10).toList();
    final testInput = CommentsState(
      status: AppState.success,
      comments: testInputList,
      pageNumber: 1,
      itemCount: (testInputList.length + 1),
    );

    final resultList = testComments.take(15).toList();
    final expectedResult = CommentsState(
        status: AppState.success,
        comments: resultList,
        pageNumber: 2,
        itemCount: resultList.length,
        hasReachedEndOfResults: true);

    //ACT
    sut!.emit(testInput);

    when(mockUsecase!.call(any)).thenAnswer(
        (_) => Future.value(right(testComments.getRange(10, 15).toList())));

    sut!.fetchComments();

    await untilCalled(mockUsecase!.call(any));

    final result = sut!.state;

    //ASSERT
    expect(result, expectedResult);
  });

  test(
    'json de-serialisation works as intended.',
    () {
      //ARRANGE
      final expectedResult = sut!.state;
      final testInput = sut!.toJson(expectedResult)!;

      //ACT
      final result = sut!.fromJson(testInput);

      //ASSERT
      expect(result, expectedResult);
    },
  );

  test('json serialisation works as intended', () {
    //ARRANGE
    final Map<String, dynamic> expectedResult = sut!.state.toMap();
    final testInput = sut!.state;

    //ACT
    final result = sut!.toJson(testInput);

    //ASSERT
    expect(result, expectedResult);
  });
}
