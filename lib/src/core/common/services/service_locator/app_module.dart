import 'package:commentree/src/core/common/routing/app_router.dart';
import 'package:injectable/injectable.dart';

///Registers external dependacies with the service locator.
///
@module
abstract class AppModule {
  @singleton
  AppRouter get appRouter => AppRouter();
}
