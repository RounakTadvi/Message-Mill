// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:message_mill/features/auth/pages/register_page.dart';

/// Register Button
class RegisterButton extends StatelessWidget {
  // ignore: public_member_api_docs
  const RegisterButton({
    required double deviceHeight,
    required double deviceWidth,
    Key? key,
  })  : _deviceHeight = deviceHeight,
        _deviceWidth = deviceWidth,
        super(key: key);

  final double _deviceHeight;
  final double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {        
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => RegisterPage(),
          ),
        );
      },
      child: Container(
        height: _deviceHeight * 0.06,
        width: _deviceWidth,
        child: Text(
          'REGISTER',
          style: GoogleFonts.rubik(
            fontSize: 15.0,
            fontWeight: FontWeight.w700,
            color: Colors.white60,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
