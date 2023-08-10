import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:papets_app/models/user_model.dart';
import 'package:papets_app/services/auth/auth_service.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getCurrentUserData() async {
    DocumentSnapshot snap = await _firestore
        .collection('users')
        .doc(AuthService().getCurrentUserId())
        .get();

    return UserModel.fromSnap(snap);
  }
}
