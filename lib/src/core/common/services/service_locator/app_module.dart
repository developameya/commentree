import 'package:commentree/src/core/common/routing/app_router.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

///Registers external dependacies with the service locator.
///
@module
abstract class AppModule {
  @injectable
  Dio get dio => Dio();

  @singleton
  AppRouter get appRouter => AppRouter();
}
