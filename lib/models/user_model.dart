import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/util/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Firestore firestore = Firestore.instance;

  FirebaseUser firebaseUser;

  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String password,
      @required VoidCallback success,
      @required VoidCallback fail}) {
    _startLoading();

    _auth
        .createUserWithEmailAndPassword(
      email: userData[userEmailField],
      password: password,
    )
        .then((user) async {
      firebaseUser = user;

      await _saveUserData(userData);

      _stopLoading(on: success);
    }).catchError((e) {
      _stopLoading(on: fail);
    });
  }

  void signIn(
      {@required String email,
      @required String password,
      @required VoidCallback success,
      @required VoidCallback fail}) {
    _startLoading();

    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {
      firebaseUser = user;

      await _loadCurrentUser();

      _stopLoading(on: success);
    }).catchError((e) {
      _stopLoading(on: fail);
    });
  }

  Future<Null> signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  void recoverPassword(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  bool isNotLoggedIn() {
    return !this.isLoggedIn();
  }

  void _startLoading({Function on}) {
    if (on != null) on();

    isLoading = true;
    notifyListeners();
  }

  void _stopLoading({Function on}) {
    if (on != null) on();

    isLoading = false;
    notifyListeners();
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await firestore
        .collection(usersCollection)
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) {
      firebaseUser = await _auth.currentUser();
    }
    if (this.isLoggedIn()) {
      if (userData[userNameField] == null) {
        DocumentSnapshot documentSnapshot = await firestore
            .collection(usersCollection)
            .document(firebaseUser.uid)
            .get();
        userData = documentSnapshot.data;
      }
    }

    notifyListeners();
  }
}
