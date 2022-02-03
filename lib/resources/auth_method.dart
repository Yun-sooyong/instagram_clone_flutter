import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone_flutter/resources/storage_method.dart';
import 'package:instagram_clone_flutter/models/user.dart' as model;

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ANCHOR Provider get User detail data
  // 현재 유저 정보를 model의 fromSnap 에 담아서 전달
  Future<model.User> getUserDetailS() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('user').doc(currentUser.uid).get();

    print(model.User.fromSnap(documentSnapshot));
    return model.User.fromSnap(documentSnapshot);
  }

  // SECTION sign up user
  // Future는 에러처리와 함께 해야함
  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    // error try catch
    late String res;
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // resister user
        // createUserWithEmailAndPassword : email, password 로 회원가입
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        print(userCredential.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        /** NOTE collection set/add
         * _firestore.collection(collectionID).doc(docID).set({field1: 'value1', field2: 'value2})
         * set(), add() 둘 다 문서를 추가해 주는 기능
         * set() => 문서 추가, 덮어쓰기 가능, doc(docID) 지정
         * add() => 문서 추가, doc(docID) 미지정(자동 생성)
         */
        // ANCHOR add user to database
        model.User user = model.User(
          username: username,
          uid: userCredential.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());
        res = 'success';
      }
      // 중복 email , password 6자리 검사
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  // !SECTION

  // SECTION logining in user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error occurred';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the field';
      }
      // NOTE on FirebaseAuthException() 으로 에러 메세지 커스텀이 가능
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = '올바른 ID를 입력해 주세요';
      } else if (e.code == 'wrong-password') {
        res = '비밀번호를 확인해 주세요';
      } else if (e.code == 'user-not-found') {
        res = '회원정보를 찾을 수 없습니다';
      } else {
        res = e.toString();
      }
    }
    return res;
  }
  // !SECTION
}
