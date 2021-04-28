// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:message_mill/core/palette/palette.dart';
import 'package:message_mill/features/auth/pages/landing_page.dart';
import 'package:message_mill/services/firebase_auth_service.dart';

/// Main Entry Point of Application
/// Everything in Flutter is a Widget so our App
/// is also an widget
class App extends StatelessWidget {
  /// constructor
  const App({
    Key? key,
  }) : super(
          key: key,
        );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // ignore: always_specify_types
      providers: [
        Provider<AuthBase>(
          create: (_) => FirebaseAuthService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Provider.of<String>(context, listen: false),
        theme: Palette.appTheme,
        home: const LandingPage(),
      ),
    );
  }
}
