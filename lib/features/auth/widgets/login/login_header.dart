// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:message_mill/core/constants/constants.dart';

/// Login Page Header Widget
class LoginHeaderWidget extends StatelessWidget {
  /// constructor
  const LoginHeaderWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Constants.welcome,
            style: GoogleFonts.rubik(
              fontSize: 35.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            Constants.login,
            style: GoogleFonts.rubik(
              fontSize: 25.0,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
    );
  }
}
