import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:papets_app/constants/app_font_family.dart';
import 'package:papets_app/constants/app_theme.dart';
import 'package:papets_app/providers/theme_provider.dart';
import 'package:papets_app/services/auth/auth_service.dart';
import 'package:papets_app/utils/globals.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    String dropdownvaluTheme =
        theme.themeData.brightness == Brightness.light ? 'Light' : 'Dark';
    var itemsTheme = [
      'Light',
      'Dark',
    ];
    String dropdownvalueColor = theme.iconsColor;
    var itemsColor = [
      'Amarillo',
      'Morado',
      'Azul',
    ];
    Widget profileWidget() => SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 65,
                backgroundImage: NetworkImage(currentUser!.photoUrl),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                currentUser!.name,
                style: FontFamily().titleFont(
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '@${currentUser!.username}',
                style: FontFamily().textFont(
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (() {
                  debugPrint('Edición del perfil');
                  AuthService().signOut();
                }),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: theme.iconsColor == "Amarillo"
                        ? PapetsColors.amarillo
                        : theme.iconsColor == "Morado"
                            ? PapetsColors.morado
                            : PapetsColors.azul,
                  ),
                  width: 160,
                  height: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Cerrar sesión',
                        style: FontFamily().subtitleFont(
                          fontSize: 16,
                        ),
                      ),
                      const Icon(
                        FeatherIcons.arrowRight,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
    themelight() => ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFFFFFFF),
        textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData.fallback());
    themeDark() => ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF303030),
        textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData.fallback());
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileWidget(),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                  value: dropdownvaluTheme,
                  items: itemsTheme.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: FontFamily().textFont(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvaluTheme = newValue!;
                      if (dropdownvaluTheme == "Light") {
                        theme.setTheme(themelight());
                      }
                      if (dropdownvaluTheme == "Dark") {
                        theme.setTheme(themeDark());
                      }
                    });
                  },
                ),
                const SizedBox(width: 30),
                DropdownButton(
                  value: dropdownvalueColor,
                  items: itemsColor.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: FontFamily().textFont(
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalueColor = newValue!;
                      theme.setColor(newValue);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
