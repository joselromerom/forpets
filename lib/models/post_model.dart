import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String owner;
  final List pictures;
  final String title;
  final String content;
  final List tags;
  final int likes;
  final DateTime createdAt;

  PostModel({
    required this.owner,
    required this.pictures,
    required this.title,
    required this.content,
    required this.tags,
    required this.likes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        "owner": owner,
        "pictures": pictures,
        "title": title,
        "content": content,
        "tags": tags,
        "likes": likes,
        "createdAt": createdAt,
      };

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
      owner: snapshot['owner'],
      pictures: snapshot['pictures'],
      title: snapshot['title'],
      content: snapshot['content'],
      tags: snapshot['tags'],
      likes: snapshot['likes'],
      createdAt: snapshot['createdAt'],
    );
  }
}
