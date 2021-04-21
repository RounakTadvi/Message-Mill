// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// Project imports:

import 'package:message_mill/features/auth/widgets/login/email_text_field.dart';
import 'package:message_mill/features/auth/widgets/login/login_header.dart';
import 'package:message_mill/features/auth/widgets/login/password_text_field.dart';
import 'package:message_mill/features/auth/widgets/login/register_button.dart';
import 'package:message_mill/services/database_service.dart';
import 'package:message_mill/services/firebase_auth_service.dart';
import '../../../services/snack_bar_service.dart';
import '../../shared/spacers.dart';

/// Login Page
class LoginPage extends StatefulWidget {
  /// Constructor
  LoginPage({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  String get email => _emailController.text;
  String get password => _passController.text;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Align(
        alignment: Alignment.center,
        child: _buildLoginPage(),
      ),
    );
  }

  Widget _buildLoginPage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.10),
      alignment: Alignment.center,
      height: _deviceHeight * 60,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const LoginHeaderWidget(),
          _buildLoginForm(),
        ],
      ),
    );
  }

  /// Login Form
  Widget _buildLoginForm() {
    return Container(
      //height: _deviceHeight * 0.16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          EmailTF(
            emailController: _emailController,
            onChanged: (_) => _updateState(),
          ),
          MMSpacers.height16,
          PasswordTF(
            passController: _passController,
            onChanged: (_) => _updateState(),
          ),
          MMSpacers.height32,
          _buildLoginButton(),
          MMSpacers.height32,
          RegisterButton(
            deviceHeight: _deviceHeight,
            deviceWidth: _deviceWidth,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    final RegExp _emailRegExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );

    bool submitValid = _emailRegExp.hasMatch(
          email,
        ) &&
        password.length >= 6;

    return Container(
      height: _deviceHeight * 0.06,
      width: _deviceWidth,
      child: Platform.isIOS
          ? CupertinoButton(
              onPressed: submitValid ? login : null,
              color: Colors.blue,
              child: const Text('Login'),
            )
          : MaterialButton(
              onPressed: submitValid ? login : null,
              color: Colors.blue,
              child: const Text(
                'LOGIN',
              ),
            ),
    );
  }

  void _updateState() {
    setState(() {});
  }

  Future<void> login() async {
    final AuthBase _auth = Provider.of<AuthBase>(context, listen: false);
    try {
      final User? user = await _auth.loginWithEmailAndPassword(email, password);
      await DBService.instance.updateUserLastSeen(user?.uid);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'network-request-failed') {
        SnackBarService.instance.showSnackBarError(
          context,
          'Network unreachable. Check your connection',
        );
      }
      if (e.code == 'invalid-email') {
        SnackBarService.instance.showSnackBarError(
          context,
          'Invalid Email',
        );
      }
      if (e.code == 'user-not-found') {
        SnackBarService.instance.showSnackBarError(
          context,
          'Email is not registered',
        );
      }
      if (e.code == 'wrong-password') {
        SnackBarService.instance.showSnackBarError(
          context,
          'Incorrect Password',
        );
      }
    } catch (e) {
      SnackBarService.instance.showSnackBarError(
        context,
        e.toString(),
      );
      debugPrint(e.toString());
    }
  }
}
