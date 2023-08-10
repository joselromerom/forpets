import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:papets_app/models/comments.dart';

class PointComments {
  Future<void> addComment(Comment myComment) {
    return FirebaseFirestore.instance
        .collection('comments')
        .add({
          'userId': myComment.userId,
          'name': myComment.name,
          'photoUrl': myComment.photoUrl,
          'markerId': myComment.markerId,
          'comment': myComment.comment,
          'stars': myComment.stars,
        })
        // ignore: avoid_print
        .then((value) => print("Se agrego el comentario"))
        .catchError(
            // ignore: avoid_print
            (error) => print("error al agregar el comentario: $error"));
  }

  Future<void> updateComment(Comment myCommentOld, Comment myComment) async {
    return FirebaseFirestore.instance
        .collection('comments')
        .where(
          'userId',
          isEqualTo: myCommentOld.userId,
        )
        .where(
          'markerId',
          isEqualTo: myCommentOld.markerId,
        )
        .where(
          'comment',
          isEqualTo: myCommentOld.comment,
        )
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({
          'userId': myComment.userId,
          'name': myComment.name,
          'photoUrl': myComment.photoUrl,
          'markerId': myComment.markerId,
          'comment': myComment.comment,
          'stars': myComment.stars,
        });
      }
      // ignore: avoid_print, invalid_return_type_for_catch_error
    }).catchError((err) => print("Failed to update comment: $err"));
  }

  Future<void> deleteComment(Comment myComment) async {
    return FirebaseFirestore.instance
        .collection('comments')
        .where(
          'userId',
          isEqualTo: myComment.userId,
        )
        .where(
          'markerId',
          isEqualTo: myComment.markerId,
        )
        .where(
          'comment',
          isEqualTo: myComment.comment,
        )
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
      // ignore: avoid_print, invalid_return_type_for_catch_error
    }).catchError((err) => print("Failed to delete comment: $err"));
  }
}
