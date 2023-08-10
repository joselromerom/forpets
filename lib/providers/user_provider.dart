import 'package:flutter/material.dart';
import 'package:papets_app/models/user_model.dart';
import 'package:papets_app/services/firestore/firestore_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel user = await FirestoreService().getCurrentUserData();
    _user = user;
    notifyListeners();
  }
}
