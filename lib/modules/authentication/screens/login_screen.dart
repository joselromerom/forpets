import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:papets_app/constants/app_font_family.dart';
import 'package:papets_app/constants/app_theme.dart';
import 'package:papets_app/providers/menu_index_provider.dart';
import 'package:papets_app/services/auth/auth_service.dart';
import 'package:papets_app/utils/utils.dart';
import 'package:papets_app/utils/widgets/input_widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  late MenuIndexProvider myproviderCurrentIndex;

  @override
  void dispose() {
    // After login we never use email and password controller
    // Dispose delete the objects from the tree
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    if (kDebugMode) {
      print("Email: ${_emailController.text}");
      print("Password: ${_passwordController.text}");
    }
    String response = await AuthService().signInWithEmail(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (response != 'success') {
      // ignore: use_build_context_synchronously
      showSnackBar(response, context);
    } else {
      if (kDebugMode) {
        print('Acabas de iniciar sesión');
      }
      myproviderCurrentIndex.set(0);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget customImage({required String src}) => Image.network(
        src,
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        color: PapetsColors.darkBlue.withOpacity(0.3),
        colorBlendMode: BlendMode.darken,
      );

  Widget loginButton(text, color, onTap) => InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: color,
          ),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: color,
                  ),
                )
              : Text(
                  text,
                  style: FontFamily().titleFont(
                    fontSize: 18,
                    color: PapetsColors.white,
                  ),
                ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    myproviderCurrentIndex = Provider.of<MenuIndexProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  constraints: const BoxConstraints(
                    minWidth: 100,
                    maxWidth: 500,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 100),
                              child: Text(
                                "Bienvenid@",
                                style: FontFamily().titleFont(
                                  fontSize: 52,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Image.asset(
                              "assets/logos/new_logo.png",
                              scale: 1.1,
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Ingresa tu correo y contraseña',
                          textAlign: TextAlign.left,
                          style: FontFamily().textLight(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Correo:',
                          textAlign: TextAlign.left,
                          style: FontFamily().subtitleFont(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FormWidgets().textField(
                          controller: _emailController,
                          hintText: 'correo@gmail.com',
                          maxLines: 1),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Contraseña:',
                          textAlign: TextAlign.left,
                          style: FontFamily().subtitleFont(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FormWidgets().textField(
                          controller: _passwordController,
                          hintText: '**********',
                          obscured: true,
                          maxLines: 1),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: Text(
                              '¿No tienes una cuenta?',
                              style: FontFamily().textFont(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/signup'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: Text(
                                'Registrarse',
                                style: FontFamily().subtitleFont(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      loginButton('Iniciar sesión', Colors.black, loginUser),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/forgot_password'),
                        child: Text(
                          '¿Olvidaste tu contraseña?',
                          style: FontFamily().subtitleFont(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'O',
                        style: FontFamily().subtitleFont(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Inicia Sesión con',
                        style: FontFamily().subtitleFont(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      loginButton(
                          'Google',
                          const Color.fromRGBO(219, 68, 55, 1),
                          () => {
                                showSnackBar(
                                    'Google no se encuentra disponible',
                                    context),
                              }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
