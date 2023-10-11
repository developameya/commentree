import 'package:commentree/src/core/common/routing/app_router.dart';
import 'package:commentree/src/core/common/routing/route_notfier.dart';
import 'package:commentree/src/core/common/services/service_locator/service_locator.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: add a listener for first use hydrated bloc, and update the route notifier.
    return MaterialApp.router(
      theme: ThemeData.dark(useMaterial3: true),
      routerConfig: sl<AppRouter>().config(reevaluateListenable: routeNotfier),
    );
  }
}
