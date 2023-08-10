import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:papets_app/services/auth/auth_service.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Adding an image to Firebase Storage
  Future<String> uploadImageToStorage({
    required String childName,
    required Uint8List file,
    bool isPost = false,
  }) async {
    Reference ref =
        _storage.ref().child(AuthService().getCurrentUserId()).child(childName);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }
}
