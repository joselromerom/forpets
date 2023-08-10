import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papets_app/constants/app_font_family.dart';
import 'package:papets_app/constants/app_theme.dart';
import 'package:papets_app/providers/menu_index_provider.dart';
import 'package:papets_app/services/auth/auth_service.dart';
import 'package:papets_app/utils/utils.dart';
import 'package:papets_app/utils/widgets/input_widgets.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Uint8List? _image;
  late String response;
  late MenuIndexProvider myproviderCurrentIndex;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _nameController.dispose();
  }

  void selectImage() async {
    try {
      Uint8List img = await pickImage(ImageSource.gallery);
      setState(() {
        _image = img;
      });
    } catch (e) {
      final ByteData imageData = await NetworkAssetBundle(Uri.parse(
              "https://cdn.dribbble.com/users/916023/screenshots/17296764/media/e9df28e434c0c5f379d784e0e15014b1.png"))
          .load("");
      setState(() {
        _image = imageData.buffer.asUint8List();
      });
      debugPrint(_image.toString());
      // ignore: use_build_context_synchronously
      showSnackBar('No se selecciono img', context);
    }
  }

  void signupUser() async {
    if (_image == null) {
      showSnackBar(
          '¡Ups! Ha ocurrido un error con la imagen del perfil, por favor inténtalo de nuevo.',
          context);
    }

    if (_emailController.text.isEmpty) {
      showSnackBar(
          "¡Ups! Ha ocurrido un error con el correo, por favor intentalo de nuevo.",
          context);
    }
    if (_passwordController.text.isEmpty ||
        _passwordController.text.length < 7) {
      showSnackBar(
          "¡Ups! Ha ocurrido un error con la contraseña, por favor intentalo de nuevo.",
          context);
    }
    if (_usernameController.text.isEmpty) {
      showSnackBar(
          "¡Ups! Ha ocurrido un error con el usuario, por favor intentalo de nuevo.",
          context);
    }
    if (_nameController.text.isEmpty) {
      showSnackBar(
          "¡Ups! Ha ocurrido un error con el nombre, por favor intentalo de nuevo.",
          context);
    } else {
      response = await AuthService().signUpWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        name: _nameController.text,
        file: _image!,
      );

      if (response != 'success') {
        // ignore: use_build_context_synchronously
        showSnackBar(response, context);
      } else {
        myproviderCurrentIndex.set(0);
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/');
      }
    }
  }

  Widget signupButton() => InkWell(
        onTap: signupUser,
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
            color: Colors.black,
          ),
          child: Text(
            'Registrarse',
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
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Bienvenid@",
                              style: FontFamily().titleFont(
                                fontSize: 52,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            flex: 1,
                            child: Image.asset(
                              "assets/logos/new_logo_blue.png",
                              scale: 1.1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: selectImage,
                            child: _image != null
                                ? CircleAvatar(
                                    radius: 65,
                                    backgroundImage: MemoryImage(_image!),
                                  )
                                : const CircleAvatar(
                                    radius: 65,
                                    backgroundImage: NetworkImage(
                                        'https://images.unsplash.com/photo-1592479950461-2c8ef29f2a14?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1335&q=80'),
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Nombre:',
                          textAlign: TextAlign.left,
                          style: FontFamily().subtitleFont(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FormWidgets().textField(
                          controller: _nameController,
                          hintText: 'Juliana Arias',
                          maxLines: 1),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Nombre de usuario:',
                          textAlign: TextAlign.left,
                          style: FontFamily().subtitleFont(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FormWidgets().textField(
                          controller: _usernameController,
                          hintText: 'juliariias',
                          maxLines: 1),
                      const SizedBox(
                        height: 10,
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
                        height: 5,
                      ),
                      FormWidgets().textField(
                          controller: _emailController,
                          hintText: 'correo@gmail.com',
                          maxLines: 1),
                      const SizedBox(
                        height: 10,
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
                        height: 5,
                      ),
                      FormWidgets().textField(
                          controller: _passwordController,
                          hintText: '**********',
                          obscured: true,
                          maxLines: 1),
                      const SizedBox(
                        height: 25,
                      ),
                      signupButton(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: Text(
                              '¿Ya tienes una cuenta?',
                              style: FontFamily().textFont(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/login'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: Text(
                                'Iniciar sesión',
                                style: FontFamily().subtitleFont(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
