import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papets_app/constants/app_font_family.dart';
import 'package:papets_app/constants/app_theme.dart';
import 'package:papets_app/utils/utils.dart';
import 'package:papets_app/utils/widgets/input_widgets.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // After login we never use email and password controller
    // Dispose delete the objects from the tree
    super.dispose();
    _emailController.dispose();
  }

  Future sendEmail() async {
    setState(() {
      _isLoading = true;
      try {
        FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text.trim());
        showSnackBar("Se envio un email a tu correo", context);
      } catch (e) {
        showSnackBar("Hubo un error, intentelo mas tarde.", context);
      }
    });

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

  Widget sendButton(text, color, onTap) => InkWell(
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
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
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
                              "assets/logos/new_logo_purple.png",
                              scale: 1.1,
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Recupera tu contraseña',
                          textAlign: TextAlign.left,
                          style: FontFamily().subtitleFont(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Si deseas recuperar tu contraseña ingresa tu correo, se te enviará un mensaje y en el podrás registrar una contraseña nueva.',
                          style: FontFamily().textLight(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Ingresa tu correo',
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
                        height: 25,
                      ),
                      sendButton(
                        'Recuperar Contraseña',
                        Colors.black,
                        sendEmail,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/login'),
                        child: Text(
                          'Iniciar sesión',
                          style: FontFamily().subtitleFont(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
