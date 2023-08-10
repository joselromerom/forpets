import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:papets_app/models/user_model.dart';
import 'package:papets_app/services/storage/storage_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String getCurrentUserId() {
    return _auth.currentUser!.uid;
  }

  Future<String> signUpWithEmail({
    required String email,
    required String password,
    required String username,
    required String name,
    required Uint8List? file,
  }) async {
    String response = "";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          name.isNotEmpty) {
        // SignUp user with credentials
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // Save profile picture on FirebaseStorage
        String photoUrl = await StorageService()
            .uploadImageToStorage(childName: 'profilePic', file: file!);

        UserModel user = UserModel(
          uid: cred.user!.uid,
          name: name,
          username: username,
          photoUrl: photoUrl,
          email: email,
          birthday: DateTime.now(),
          pets: [],
          isActive: true,
          emailVerified: false,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
          followers: [],
          following: [],
        );

        _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

        response = "success";
      }
    } on FirebaseAuthException catch (error) {
      if (kDebugMode) {
        if (error.toString() ==
            "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {}
        response = "Existe un problema con el correo ingresado.";
        print(error);
      }
    } catch (error) {
      if (kDebugMode) {
        response = error.toString();
        print(error);
      }
    }

    return response;
  }

  /// Login a User with Email and Password
  ///
  /// Throws an [FirebaseAuthException] if there is an errror with [email] or
  /// [password]. Returns success string when the credentials are in order.
  Future<String> signInWithEmail(
      {required String email, required String password}) async {
    String response =
        "Ups! Ha ocurrido un error, por favor intentalo de nuevo.";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        response = 'success';
      } else {
        if (email.isEmpty) {
          response =
              "Ups! Ha ocurrido un error con el correo, por favor intentelo de nuevo.";
        }
        if (password.isEmpty) {
          response =
              "Ups! Ha ocurrido un error con la contraseña, por favor intentelo de nuevo.";
        }
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found' || error.code == 'wrong-password') {
        response =
            "¡Ups! Ha ocurrido un error, usuario o contraseña incorrectos por favor inténtelo de nuevo.";
      } else if (error.code == 'invalid-email') {
        response = "El correo electrónico digitado no es valido";
      } else {
        if (kDebugMode) {
          print(error.code);
        }
      }
    } catch (error) {
      // Something with the app is happening
      // Do we need to save this error on Firestore ?
      if (kDebugMode) {
        print(error.toString());
      }
    }

    return response;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
