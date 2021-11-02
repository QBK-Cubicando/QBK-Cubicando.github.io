import 'package:firebase_auth/firebase_auth.dart';
import 'package:qbk_simple_app/models/user.dart';

///Documentated
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///create user obj based on FirebaseUser

  UserData _userFromFirebaseUser(User user) {
    return user != null ? UserData(uid: user.uid) : null;
  }

  ///auth change user stream

  Stream<UserData> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<UserData> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  ///register email and password

  Future<UserData> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///sign Out

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
