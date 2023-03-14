library firebase_service;

export 'package:firebase_auth/firebase_auth.dart';

export 'src/authentication/auth.dart'
    hide Auth, AppleAuth, EmailAuth, AnonymousAuth, FacebookAuth, GoogleAuth;
export 'src/models/auth_result.dart';
export 'src/utils/auth_error.dart';

export 'src/authentication/email_authentication.dart';
export 'src/authentication/google_authentication.dart';
export 'src/authentication/apple_authentication.dart';
export 'src/authentication/facebook_authentication.dart';
export 'src/authentication/guest_authentication.dart';
