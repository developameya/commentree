import 'package:flutter/foundation.dart';

final routeNotfier = FirstUseNotifier();

class FirstUseNotifier extends ValueNotifier<bool> {
  FirstUseNotifier() : super(false);
}
