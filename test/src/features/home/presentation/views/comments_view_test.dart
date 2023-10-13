import 'package:commentree/src/core/utils/state/app_state.dart';
import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';
import 'package:commentree/src/features/home/domain/usecases/home_usecases.dart';
import 'package:commentree/src/features/home/presentation/state/comments_cubit.dart';
import 'package:commentree/src/features/home/presentation/views/comments_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mockito/mockito.dart';

class MockStorage extends Mock implements Storage {
  @override
  Future<void> write(String key, dynamic value) async {}
}

void initHydratedBloc() {
  final hydratedStorage = MockStorage();
  TestWidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = hydratedStorage;
}

class MockFetchComments extends Mock implements FetchComments {}

class FakeCommentsCubit extends CommentsCubit {
  FakeCommentsCubit() : super(fetchComments: MockFetchComments());
  @override
  void fetchComments() {
    debugPrint("testing cubit");
  }
}

void main() {
  initHydratedBloc();
  final List<CommentEntity> testComments = List.generate(
      55,
      (index) => CommentEntity(
          postId: index.toString(),
          id: (index + 10).toString(),
          name: "name - $index",
          email: "email- $index",
          body:
              "This is the body of the comment, it can be very long, longer than you expect.- $index"));

  FakeCommentsCubit? fakeCubit;
  Widget? sut;

  Widget materialAppWrapper(Widget child, CommentsCubit mockCubit,
          [ThemeData? theme]) =>
      BlocProvider(
        create: (context) => mockCubit,
        child: MaterialApp(
          theme: theme,
          home: Scaffold(body: child),
        ),
      );

  setUp(() {
    fakeCubit = FakeCommentsCubit();
    sut = CommentsView();
  });

  tearDown(() {
    sut = null;
    fakeCubit!.close();
    fakeCubit = null;
  });
  group("initial state tests: ", () {
    testWidgets("when in intial state, a list view is present.",
        (tester) async {
      //ARRANGE
      await tester.pumpWidget(materialAppWrapper(sut!, fakeCubit!));

      //ACT
      final findListView = find.byType(ListView);

      //ASSERT
      expect(findListView, findsOneWidget);
    });

    testWidgets("when in intial state, no loading indicator is displayed.",
        (tester) async {
      //ARRANGE
      await tester.pumpWidget(materialAppWrapper(sut!, fakeCubit!));

      //ACT
      final findListView = find.byType(CircularProgressIndicator);

      //ASSERT
      expect(findListView, findsNothing);
    });

    testWidgets("when in intial state, no item in list is displayed.",
        (tester) async {
      //ARRANGE
      await tester.pumpWidget(materialAppWrapper(sut!, fakeCubit!));

      //ACT
      final findListView = find.byType(GFCard);

      //ASSERT
      expect(findListView, findsNothing);
    });
  });

  group('error state tests: ', () {
    const message = "VERY HUGE AND BIG ERROR!!!";
    testWidgets('when in error state, no loading indicator is displayed.',
        (tester) async {
      //ARRANGE
      final testInput = fakeCubit!.state
          .copyWith(status: AppState.error, errorMessage: message);

      await tester.pumpWidget(materialAppWrapper(sut!, fakeCubit!));

      //ACT
      fakeCubit!.emit(fakeCubit!.state.copyWith(status: AppState.loading));

      await tester.pump();

      final findLoadingIndicator = find.byType(CircularProgressIndicator);

      fakeCubit!.emit(testInput);

      await tester.pumpAndSettle(const Duration(seconds: 10));

      //ASSERT
      expect(findLoadingIndicator, findsNothing);
      await tester.pumpAndSettle(const Duration(seconds: 10));
    });

    testWidgets('when in error state, displays a banner with error message.',
        (tester) async {
      //ARRANGE
      final testInput = fakeCubit!.state
          .copyWith(status: AppState.error, errorMessage: message);

      await tester.pumpWidget(materialAppWrapper(sut!, fakeCubit!));

      //ACT
      fakeCubit!.emit(testInput);
      await tester.pump();

      final findBanner = find.byWidgetPredicate((widget) =>
          widget is MaterialBanner && (widget.content as Text).data == message);

      //ASSERT
      expect(findBanner, findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 10));
      await tester.pumpAndSettle(const Duration(seconds: 10));
    });

    testWidgets(
        'if data is displayed and state changes to error, old data is still displayed.',
        (tester) async {
      //1
      //ARRANGE
      await tester.pumpWidget(materialAppWrapper(sut!, fakeCubit!));

      //ACT
      fakeCubit!.emit(fakeCubit!.state.copyWith(
          status: AppState.success,
          comments: testComments,
          itemCount: testComments.length));
      await tester.pump();

      final findCard = find.byType(GFCard, skipOffstage: false);

      //ASSERT
      expect(findCard, findsWidgets);

      //2
      //ARRANGE
      final testInput = fakeCubit!.state
          .copyWith(status: AppState.error, errorMessage: message);

      //ACT
      fakeCubit!.emit(testInput);
      await tester.pump();

      final findBanner = find.byWidgetPredicate((widget) =>
          widget is MaterialBanner && (widget.content as Text).data == message);

      //ASSERT
      expect(findCard, findsWidgets);
      expect(findBanner, findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 10));
      await tester.pumpAndSettle(const Duration(seconds: 10));
    });
  });

  group('success state tests: ', () {
    testWidgets('when in success state, no loading indicator is displayed.',
        (tester) async {
      //ARRANGE
      final testInput = fakeCubit!.state.copyWith(
          status: AppState.success,
          errorMessage: '',
          comments: testComments,
          itemCount: testComments.length);

      await tester.pumpWidget(materialAppWrapper(sut!, fakeCubit!));

      //ACT
      fakeCubit!.emit(fakeCubit!.state.copyWith(status: AppState.loading));

      await tester.pump();

      final findLoadingIndicator = find.byType(CircularProgressIndicator);

      fakeCubit!.emit(testInput);

      await tester.pump();

      //ASSERT
      expect(findLoadingIndicator, findsNothing);
    });
    testWidgets('when in success state, displays the list of comments.',
        (tester) async {
      //ARRANGE
      final testInput = fakeCubit!.state.copyWith(
          status: AppState.success,
          comments: testComments,
          itemCount: testComments.length);
      await tester.pumpWidget(materialAppWrapper(sut!, fakeCubit!));

      //ACT
      fakeCubit!.emit(testInput);
      await tester.pump();

      final findCard = find.byType(GFCard, skipOffstage: false);

      //ASSERT
      expect(findCard, findsWidgets);
    });

    testWidgets(
        'if error had occured and state changes to success, old error is still displayed till timeout.',
        (tester) async {
      //1
      //ARRANGE
      const message = 'error';

      await tester.pumpWidget(materialAppWrapper(sut!, fakeCubit!));

      //ACT
      fakeCubit!.emit(fakeCubit!.state
          .copyWith(status: AppState.error, errorMessage: message));
      await tester.pump();

      final findBanner = find.byWidgetPredicate((widget) =>
          widget is MaterialBanner && (widget.content as Text).data == message);

      //ASSERT
      expect(findBanner, findsOneWidget);

      //2
      //ARRANGE
      final testInput = fakeCubit!.state.copyWith(
          status: AppState.success,
          comments: testComments,
          itemCount: testComments.length);
      await tester.pumpWidget(materialAppWrapper(sut!, fakeCubit!));

      //ACT
      fakeCubit!.emit(testInput);
      await tester.pump();

      final findCard = find.byType(GFCard, skipOffstage: false);

      //ASSERT
      expect(findCard, findsWidgets);
      expect(findBanner, findsOneWidget);

      //3
      //ACT
      await tester.pumpAndSettle(const Duration(seconds: 10));

      //ASSERT
      expect(findBanner, findsNothing);
    });
  });
}
