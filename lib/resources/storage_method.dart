import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ANCHOR adding image to firebase storage
  // NOTE 이미지를 firebase storage 에 저장하는 method 로 profile picture 와 post 에서도 사용하도록 함. 구분을 위해 bool 타입의 isPost를 받음
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    // NOTE ref() => pointer to the file in storage
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // NOTE UploadTask similar future but
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }
}
