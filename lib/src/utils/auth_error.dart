import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_service/src/models/auth_result.dart';

mixin AuthError {
  AuthResult exception(FirebaseAuthException e) {
    late String message;
    switch (e.code) {
      case 'account-exists-with-different-credential':
        message = 'Account is already registered with different credential.';
        break;
      case 'invalid-credential':
        message = 'Invalid Credential.';
        break;
      case 'user-disabled':
        message =
            'Your account has been blocked or disabled. Contact our support team to unlock it, then try again.';
        break;
      default:
        message = nullOrValue<String>(e.message);
        break;
    }
    return AuthResult(status: false, message: message);
  }
}

T nullOrValue<T>(dynamic value) => value;