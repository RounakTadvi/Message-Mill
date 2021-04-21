// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:message_mill/core/constants/constants.dart';
import 'package:message_mill/services/firebase_auth_service.dart';

/// Login Button
class LoginButton extends StatelessWidget {
  // ignore: public_member_api_docs
  const LoginButton({
    required this.deviceHeight,
    required this.deviceWidth,
    required this.submitValid,
    required this.email,
    required this.password,
    Key? key,
  }) : super(key: key);

  /// User's Device Height
  final double deviceHeight;

  /// User's Device Width
  final double deviceWidth;

  /// Provides info about validated data
  final bool submitValid;

  /// Email text
  final String email;

  /// password text
  final String password;

  @override
  Widget build(BuildContext context) {
    final AuthBase _auth = Provider.of<AuthBase>(context, listen: false);
    return Container(
      height: deviceHeight * 0.06,
      width: deviceWidth,
      child: Platform.isIOS
          ? CupertinoButton(
              onPressed: submitValid
                  ? () {
                      _auth.loginWithEmailAndPassword(email, password);
                    }
                  : null,
              color: Colors.blue,
              child: const Text('Login'),
            )
          : MaterialButton(
              onPressed: submitValid
                  ? () {
                      _auth.loginWithEmailAndPassword(email, password);
                    }
                  : null,
              color: Colors.blue,
              child: const Text(
                'LOGIN',
              ),
            ),
    );
  }
}

/// Email TextFiled
class EmailTF extends StatelessWidget {
  // ignore: public_member_api_docs
  const EmailTF({
    required this.emailController,
    required this.onChanged,
    Key? key,
  }) : super(
          key: key,
        );

  /// Email Controller
  final TextEditingController emailController;

  /// Callback is fired every time an character is entered in textfield
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return PlatformTextField(
      onChanged: onChanged,
      controller: emailController,
      autocorrect: false,
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      material: (_, __) => MaterialTextFieldData(
        decoration: const InputDecoration(
          hintText: Constants.emailHintText,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
