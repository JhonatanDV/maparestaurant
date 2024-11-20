import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  AuthService() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get currentUser => _user;
  bool get isAuthenticated => _user != null;

  // Sign up method to create a new user
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required bool isRestaurantOwner,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user info in Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'isRestaurantOwner': isRestaurantOwner,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in method to log in an existing user
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign out method to log out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Check if the current user is a restaurant owner
  Future<bool> isRestaurantOwner() async {
    if (_user == null) return false;
    
    final doc = await _firestore
        .collection('users')
        .doc(_user!.uid)
        .get();
    
    return doc.data()?['isRestaurantOwner'] ?? false;
  }
}
