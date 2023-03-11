import 'package:apple_sign_in_safety/apple_sign_in.dart';
import 'package:firebase_service/firebase_service.dart';
import 'package:firebase_service/src/authentication/auth.dart';

class AppleAuthentication extends AppleAuth {
  AppleAuthentication._();

  final String _providerId = 'apple.com';

  static AppleAuthentication get instance => AppleAuthentication._();

  @override
  Future<AuthResult> signIn() async {
    AuthResult result = AuthResult(status: false);
    try {
      final AuthorizationResult authResult = await AppleSignIn.performRequests([
        const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (authResult.status) {
        case AuthorizationStatus.authorized:
          OAuthProvider oAuthProvider = OAuthProvider(_providerId);

          OAuthCredential credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(
                authResult.credential?.identityToken ?? []),
            accessToken: String.fromCharCodes(
                authResult.credential?.authorizationCode ?? []),
          );
          UserCredential userCredential =
              await firebaseAuth.signInWithCredential(credential);

          User? user = userCredential.user;
          result = result.copyWith(status: true, user: user);
          break;
        case AuthorizationStatus.error:
          result = result.copyWith(
            status: false,
            message: authResult.error?.localizedFailureReason,
          );
          break;
        case AuthorizationStatus.cancelled:
          result = result.copyWith(status: false, message: 'Cancelled');
          break;
        default:
      }
      return result;
    } on FirebaseAuthException catch (e) {
      return exception(e);
    } catch (e) {
      return result.copyWith(status: false, message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }

  @override
  Future<AuthResult> delete() async {
    try {
      UserCredential? credential = await firebaseAuth.currentUser
          ?.reauthenticateWithProvider(AppleAuthProvider());
      await credential?.user?.delete();
      return AuthResult(status: true);
    } on FirebaseAuthException catch (e) {
      return exception(e);
    }
  }
}
