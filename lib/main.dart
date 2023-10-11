import 'package:commentree/src/app.dart';
import 'package:commentree/src/core/common/services/service_locator/service_locator.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MainApp());
}
