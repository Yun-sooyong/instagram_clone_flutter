import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/models/post.dart';
import 'package:instagram_clone_flutter/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ANCHOR upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = 'some error occored';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          postId: postId,
          username: username,
          dataPublished: DateTime.now(),
          postUrl: photoUrl,
          profileImage: profileImage,
          likes: []);

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // ANCHOR like post
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      // likes 에 이미 uid가 있을경우 likes list 에서 해당 uid 삭제
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  // ANCHOR post comment
  Future<void> postComment(String postId, String text, String uid, String name,
      String profileImage) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profileImage,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch (err) {
      print(err.toString());
    }
  }

  // ANCHOR delete post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  // ANCHOR follow user
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      // following list 에 입력받은 followId 가 있으면
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }
}
