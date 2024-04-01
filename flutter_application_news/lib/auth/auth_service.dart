import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_get_api_news/modules/favorite.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailPasword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'uid': email.split('@')[0],
        'username': email.split('@')[0],
        'bio': 'Empty bio'
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> addNewFavoriteItem(
      String idUser,
      String idNews,
      String title,
      String author,
      String name,
      String urlToImage,
      String publishedAt,
      String content) async {
    try {
      FirebaseFirestore.instance
          .collection('Favorites')
          .doc('Favorite $idNews')
          .set({
        'idUser': idUser,
        'idNews': idNews,
        'title': title,
        'author': author,
        'name': name,
        'urlToImage': urlToImage,
        'publishedAt': publishedAt,
        'content': content,
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> removeFavoriteItem(String favoriteItemId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Favorites')
          .doc('Favorite $favoriteItemId')
          .delete();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await auth.signOut();
  }
}
