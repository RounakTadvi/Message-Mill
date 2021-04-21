// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:message_mill/app/app.dart';
import 'package:message_mill/core/env/env.dart';

/// Common Configuration For All the Environments
Future<void> mainCommon(String env) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  await Firebase.initializeApp();
  late String appTitle;
  if (env == Environment.dev) {
    appTitle = 'Message Mill Dev';

    debugPrint('Flavor: $appTitle');
  } else if (env == Environment.stg) {
    appTitle = 'Message Mill Stg';

    debugPrint('Flavor: $appTitle');
  } else if (env == Environment.prod) {
    appTitle = 'Message Mill ';

    debugPrint('Flavor: $appTitle');
  }

  runApp(
    MultiProvider(
      // ignore: always_specify_types
      providers: [
        Provider<String>.value(
          value: appTitle,
        ),
      ],
      child: const App(),
    ),
  );
}
