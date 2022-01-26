import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ANCHOR sign up user
  // Future는 에러처리와 함께 해야함
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    //required Uint8List file
  }) async {
    // error try catch
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
              password.isNotEmpty ||
              username.isNotEmpty ||
              bio.isNotEmpty
          //|| file != null
          ) {
        // resister user
        // createUserWithEmailAndPassword : email password 로 회원가입
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        print(userCredential.user!.uid);
        // ANCHOR add user to database
        /** NOTE collection set/add
         * _firestore.collection(collectionID).doc(docID).set({field1: 'value1', field2: 'value2})
         * set(), add() 둘 다 문서를 추가해 주는 기능
         * set() => 문서 추가, 덮어쓰기 가능, doc(docID) 지정
         * add() => 문서 추가, doc(docID) 미지정(자동 생성)
         */
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': username,
          'uid': userCredential.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
        });
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
