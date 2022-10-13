import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<UserCredential> signupUser(
      {required String email, required String password}) async {
    try {
      final user = FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserCredential> signInUser(
      {required String email, required String password}) async {
    try {
      final user = FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString();
    }
  }
}
