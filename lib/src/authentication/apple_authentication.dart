import 'package:firebase_service/firebase_service.dart';
import 'package:firebase_service/src/authentication/auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthentication extends AppleAuth {
  AppleAuthentication._();

  final String _providerId = 'apple.com';

  static AppleAuthentication get instance => AppleAuthentication._();

  @override
  Future<AuthResult> signIn() async {
    AuthResult result = AuthResult(status: false);
    try {
      AuthorizationCredentialAppleID appleIdCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: AppleIDAuthorizationScopes.values,
      );
      OAuthProvider oAuthProvider = OAuthProvider(_providerId);

      OAuthCredential credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      return result.copyWith(status: true, user: userCredential.user);
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
