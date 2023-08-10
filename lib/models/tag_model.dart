import 'package:cloud_firestore/cloud_firestore.dart';

class TagModel {
  final String id;
  final String name;
  final String color;

  TagModel({
    required this.id,
    required this.name,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
      };

  static TagModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return TagModel(
      id: snapshot['id'],
      name: snapshot['name'],
      color: snapshot['color'],
    );
  }
}
