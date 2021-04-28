// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

// Project imports:
import 'package:message_mill/core/constants/constants.dart';

/// Password TF
class PasswordTF extends StatelessWidget {
  // ignore: public_member_api_docs
  const PasswordTF({
    required this.passController,
    required this.onChanged,
    Key? key,
  }) : super(
          key: key,
        );

  /// Password Controller
  final TextEditingController passController;

  /// Callback is fired every time an character is entered in textfield
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: passController,
      autocorrect: false,
      obscureText: true,
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      decoration: const InputDecoration(
          hintText: Constants.passwordHintText,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
    );
  }
}
