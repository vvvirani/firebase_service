import 'package:firebase_service/firebase_service.dart';
import 'package:firebase_service/src/authentication/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication extends GoogleAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<AuthResult> signIn() async {
    AuthResult result = AuthResult(status: false);
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      if (googleSignInAuthentication != null) {
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);
        return result.copyWith(status: true, user: userCredential.user);
      } else {
        return result.copyWith(status: false, message: 'Canceled');
      }
    } on FirebaseAuthException catch (e) {
      return exception(e);
    } catch (e) {
      return result.copyWith(status: false, message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Future<AuthResult> delete() async {
    try {
      await firebaseAuth.currentUser
          ?.reauthenticateWithProvider(GoogleAuthProvider())
          .then((credential) => credential.user?.delete());
      return AuthResult(status: true);
    } on FirebaseAuthException catch (e) {
      return exception(e);
    }
  }
}
