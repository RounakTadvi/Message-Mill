// Flutter imports:
import 'package:flutter/services.dart';

// Project imports:
import 'package:message_mill/core/platform_widgets/platform_alert_dialog.dart';

/// Displays a Dialog depending on the exception occured
class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  // ignore: public_member_api_docs
  PlatformExceptionAlertDialog(
      {required String title, required PlatformException exception})
      : super(
          title: title,
          content: message(exception),
          defaultActionText: 'OK',
        );

  /// Message
  static String message(PlatformException exception) {
    if (exception.message == 'FIRFirestoreErrorDomain') {
      if (exception.code == 'Code 7') {
        // This happens when we get a
        // "Missing or insufficient permissions" error
        return 'This operation could not be completed due to a server error';
      }
      return exception.details;
    }
    return errors[exception.code]!;
  }

  /// NOTE: The full list of FirebaseAuth errors is stored here:
  // https://github.com/firebase/firebase-ios-sdk/blob/2e77efd786e4895d50c3788371ec15980c729053/Firebase/Auth/Source/FIRAuthErrorUtils.m
  // These are just the most relevant for email & password sign in:
  static Map<String, String> errors = <String, String>{
    'ERROR_WEAK_PASSWORD': 'The password must be 8 characters long or more.',
    'ERROR_INVALID_CREDENTIAL': 'The email address is badly formatted.',
    'ERROR_EMAIL_ALREADY_IN_USE':
        'The email address is already registered. Sign in instead?',
    'ERROR_INVALID_EMAIL': 'The email address is badly formatted.',
    'ERROR_WRONG_PASSWORD': 'The password is incorrect. Please try again.',
    'ERROR_USER_NOT_FOUND':
        'The email address is not registered. Need an account?',
    'ERROR_TOO_MANY_REQUESTS':
        // ignore: lines_longer_than_80_chars
        'We have blocked all requests from this device due to unusual activity. Try again later.',
    'ERROR_OPERATION_NOT_ALLOWED':
        'This sign in method is not allowed. Please contact support.',
  };
}
