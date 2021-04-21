// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:message_mill/core/constants/constants.dart';

/// Register Header
class RegisterHeader extends StatelessWidget {
  // ignore: public_member_api_docs
  const RegisterHeader({
    Key? key,
  }) : super(
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
            Constants.register,
            style: GoogleFonts.rubik(
              fontSize: 35.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            Constants.enterDetails,
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
