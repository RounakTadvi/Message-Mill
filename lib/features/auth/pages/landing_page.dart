// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:message_mill/features/auth/pages/login_page.dart';
import 'package:message_mill/features/home/home_page.dart';
import 'package:message_mill/services/firebase_auth_service.dart';

/// Landing Page
class LandingPage extends StatelessWidget {
  // ignore: public_member_api_docs
  const LandingPage({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final AuthBase _auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
      stream: _auth.onAuthStateChanges,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return LoginPage();
          }
          
          return const HomePage();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
