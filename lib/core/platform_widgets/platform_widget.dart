// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

/// Base Class For Platform Widgets (Material and Cupertino Widgets)
abstract class PlatformWidget extends StatelessWidget {
  // ignore: public_member_api_docs
  const PlatformWidget({
    Key? key,
  }) : super(
          key: key,
        );

  /// Builds Cupertino Widgets (Native iOS Widgets)
  Widget buildCupertinoWidget(BuildContext context);

  /// Builds Material Widgets (Native Android Widgets)
  Widget buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return buildCupertinoWidget(context);
    }
    return buildMaterialWidget(context);
  }
}
