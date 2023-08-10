import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papets_app/modules/authentication/screens/login_screen.dart';
import 'package:papets_app/modules/home/home.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              // When user is logged in we show home screen
              return const HomePage();
            } else if (snapshot.hasError) {
              // ignore: avoid_print
              print(snapshot.error);
              return const Center(
                child: Text(
                    'Actualmente estamos temiendo algunos inconvenientes, estamos trabajando para arreglarlos lo más pronto posible.'),
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
