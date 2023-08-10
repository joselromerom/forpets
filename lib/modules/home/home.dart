import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papets_app/constants/app_font_family.dart';
import 'package:papets_app/constants/app_theme.dart';
import 'package:papets_app/models/menu_model.dart';
import 'package:papets_app/providers/menu_index_provider.dart';
import 'package:papets_app/providers/theme_provider.dart';
import 'package:papets_app/providers/user_provider.dart';
import 'package:papets_app/responsive/responsive_layout.dart';
import 'package:papets_app/utils/globals.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    userData();
  }

  userData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
    currentUser = userProvider.getUser;
    isLogedIn = true;
  }

  late List<MenuModel> menu;
  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuIndexProvider>(context);
    final theme = Provider.of<ThemeChanger>(context);
    //Saber que poner en el widget dependiendo la arquitectura

    theme.iconsColor == "Amarillo"
        ? menu = menuAmarillo
        : theme.iconsColor == "Morado"
            ? menu = menuMorado
            : menu = menuAzul;

    (kIsWeb)
        ? menu[2].screen = const Center(
            child: Text("No implementado en web"),
          )
        : Platform.isAndroid
            ? menu[2].screen = menu[2].screen
            : Platform.isIOS
                ? menu[2].screen = const Center(
                    child: Text("No implementado en iOS"),
                  )
                : menu[2].screen = const Center(
                    child: Text("No implementado en otras plataformas"),
                  );

    return Scaffold(
      body: ResponsiveLayout(
        phone: menu[menuProvider.currentIndex].screen,
        tablet: desktopTabletLayout(menuProvider),
        desktop: desktopTabletLayout(menuProvider),
      ),
      bottomNavigationBar:
          (ResponsiveLayout.isPhone(context)) ? papetsMenu(menuProvider) : null,
    );
  }

  // --- BottomNavigationBar Container
  Widget papetsMenu(menuProvider) => Container(
        // margin: const EdgeInsets.all(15),
        width: double.infinity,
        height: (kIsWeb)
            ? 70
            : (Platform.isAndroid)
                ? 50
                : 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
          // borderRadius: BorderRadius.circular(50),
        ),
        child: mobileMenu(menuProvider),
      );

  // --- Mobile Menu
  Widget mobileMenu(menuProvider) => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFFFFEFE)
                : const Color(0xFF303030)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int index = 0; index < menu.length; index++)
              InkWell(
                onTap: () => setState(() {
                  menuProvider.currentIndex = index;
                  HapticFeedback.lightImpact();
                }),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (index == menuProvider.currentIndex)
                        ? menu[index].selectedSvgIcon
                        : menu[index].svgIcon,
                    SizedBox(
                      height: (kIsWeb)
                          ? 0
                          : (Platform.isIOS)
                              ? 15
                              : 0,
                    ),
                  ],
                ),
              )
          ],
        ),
      );

  // --- Desktop and Tablet Widget Menu
  Widget desktopTabletLayout(menuProvider) => Row(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            padding: const EdgeInsets.all(30),
            color: PapetsColors.white,
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                (ResponsiveLayout.isTablet(context))
                    ? Image.asset(
                        'assets/logos/logo_ipad.png',
                        scale: 8,
                      )
                    : Image.asset(
                        'assets/logos/logo_desktop_light.png',
                      ),
                const SizedBox(
                  height: 50,
                ),
                for (int index = 0; index < menu.length; index++)
                  InkWell(
                    onTap: () => setState(() {
                      menuProvider.currentIndex = index;
                      HapticFeedback.lightImpact();
                    }),
                    child: (ResponsiveLayout.isTablet(context))
                        ? Container(
                            margin: const EdgeInsets.only(bottom: 40),
                            child: (index == menuProvider.currentIndex)
                                ? menu[index].selectedSvgIcon
                                : menu[index].svgIcon,
                          )
                        : Container(
                            margin: const EdgeInsets.only(bottom: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                (index == menuProvider.currentIndex)
                                    ? menu[index].selectedSvgIcon
                                    : menu[index].svgIcon,
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  menu[index].text,
                                  style: FontFamily().textFont(
                                    color: PapetsColors.darkBlue,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: menu[menuProvider.currentIndex].screen,
          ),
        ],
      );
}
