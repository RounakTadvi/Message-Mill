// Package imports:
import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Auth Contract
abstract class AuthBase {
  /// Get Current User
  User? get currentUser;

  /// Login With Credentials
  Future<User?> loginWithEmailAndPassword(
    String email,
    String password,
  );

  /// Sign Up with credentials
  Future<User?> createAccountWithEmailAndPassword(
    String email,
    String password,
  );

  /// Sign out the current User
  Future<void> signOut();

  /// Firebase User Stream
  Stream<User?> get onAuthStateChanges;
}

/// AuthBase Implementation
class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<User?> createAccountWithEmailAndPassword(
      String email, String password) async {
    final UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    final UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  @override
  Stream<User?> get onAuthStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
