import 'package:flutter/material.dart';
import 'package:papets_app/modules/authentication/screens/forgotpass_screen.dart';
import 'package:papets_app/modules/authentication/screens/login_screen.dart';
import 'package:papets_app/modules/home/home.dart';
import 'package:papets_app/modules/map/screens/create_point.dart';
import 'package:papets_app/modules/map/screens/edit_point.dart';
import 'package:papets_app/modules/map/screens/map_screen.dart';
import 'package:papets_app/modules/authentication/screens/signup_screen.dart';
import 'package:papets_app/modules/map/screens/view_point.dart';
import 'package:papets_app/root.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Root());
      case '/Root':
        return MaterialPageRoute(builder: (_) => const Root());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case '/map_view':
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case '/create_point':
        return MaterialPageRoute(builder: (_) => const CreatePoint());
      case '/edit_point':
        return MaterialPageRoute(builder: (_) => const EditPoint());
      case '/view_point':
        return MaterialPageRoute(builder: (_) => const ViewPoint());
      case '/home_page':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/forgot_password':
        return MaterialPageRoute(builder: (_) => const ForgotPassScreen());
      default:
        return MaterialPageRoute(builder: (_) => const Root());
    }
  }
}
