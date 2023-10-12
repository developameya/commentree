import 'dart:async';

import 'package:flutter/material.dart';

///Creates a banner to display error.
///
MaterialBanner buildNoticeBanner(BuildContext context, [String? message]) {
  return MaterialBanner(
      content: Text(message ?? "unknown error"),
      onVisible: () {
        Timer(const Duration(seconds: 5),
            () => ScaffoldMessenger.of(context).clearMaterialBanners());
      },
      actions: [
        TextButton(
          onPressed: () => ScaffoldMessenger.of(context).clearMaterialBanners(),
          child: const Text('DISMISS'),
        )
      ]);
}
