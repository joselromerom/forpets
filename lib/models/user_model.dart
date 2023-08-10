import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String username;
  final String photoUrl;
  final String email;
  final DateTime birthday;
  final List pets;
  final bool isActive;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime lastLogin;
  final List followers;
  final List following;

  UserModel({
    required this.uid,
    required this.name,
    required this.username,
    required this.photoUrl,
    required this.email,
    required this.birthday,
    required this.pets,
    required this.isActive,
    required this.emailVerified,
    required this.createdAt,
    required this.lastLogin,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "username": username,
        "photoUrl": photoUrl,
        "email": email,
        "birthday": birthday,
        "pets": pets,
        "isActive": isActive,
        "emailVerified": emailVerified,
        "createdAt": createdAt,
        "lastLogin": lastLogin,
        "followers": followers,
        "following": following,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot['uid'],
      name: snapshot['name'],
      username: snapshot['username'],
      photoUrl: snapshot['photoUrl'],
      email: snapshot['email'],
      birthday: snapshot['birthday'].toDate(),
      pets: snapshot['pets'],
      isActive: snapshot['isActive'],
      emailVerified: snapshot['emailVerified'],
      createdAt: snapshot['createdAt'].toDate(),
      lastLogin: snapshot['lastLogin'].toDate(),
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
