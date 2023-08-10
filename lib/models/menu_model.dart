import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:papets_app/modules/blog/screens/blog_screen.dart';
import 'package:papets_app/modules/chats/screens/chats_screen.dart';
import 'package:papets_app/modules/map/screens/map_screen.dart';
import 'package:papets_app/modules/pets/screens/pets_screen.dart';
import 'package:papets_app/modules/profile/screens/profile_screen.dart';

class MenuModel {
  final int id;
  final Widget svgIcon;
  final Widget selectedSvgIcon;
  final String text;
  Widget screen;

  MenuModel({
    required this.id,
    required this.svgIcon,
    required this.selectedSvgIcon,
    required this.text,
    required this.screen,
  });
}

List<MenuModel> menuAmarillo = [
  MenuModel(
    id: 0,
    svgIcon: SvgPicture.asset(
      'assets/yellow_icons/home.svg',
      height: 30,
    ),
    selectedSvgIcon: SvgPicture.asset(
      'assets/yellow_icons/home_yellow.svg',
      height: 35,
    ),
    text: 'Inicio',
    screen: const PetScreen(),
  ),
  MenuModel(
    id: 1,
    svgIcon: SvgPicture.asset(
      'assets/yellow_icons/book-open.svg',
      height: 30,
    ),
    selectedSvgIcon: SvgPicture.asset(
      'assets/yellow_icons/book-open_yellow.svg',
      height: 35,
    ),
    text: 'Mascotas',
    screen: const BlogScreen(),
  ),
  MenuModel(
    id: 2,
    svgIcon: SvgPicture.asset(
      'assets/yellow_icons/map-pin.svg',
      height: 30,
    ),
    selectedSvgIcon: SvgPicture.asset(
      'assets/yellow_icons/map-pin_yellow.svg',
      height: 35,
    ),
    text: 'Mapa',
    screen: const MapScreen(),
  ),
  MenuModel(
    id: 3,
    svgIcon: SvgPicture.asset(
      'assets/yellow_icons/message-circle.svg',
      height: 30,
    ),
    selectedSvgIcon: SvgPicture.asset(
      'assets/yellow_icons/message-circle_yellow.svg',
      height: 35,
    ),
    text: 'Chats',
    screen: const ChatsScreen(),
  ),
  MenuModel(
    id: 4,
    svgIcon: SvgPicture.asset(
      'assets/yellow_icons/user.svg',
      height: 30,
    ),
    selectedSvgIcon: SvgPicture.asset(
      'assets/yellow_icons/user_yellow.svg',
      height: 35,
    ),
    text: 'Perfil',
    screen: const ProfileScreen(),
  ),
];

List<MenuModel> menuAzul = [
  MenuModel(
    id: 0,
    svgIcon: SvgPicture.asset(
      'assets/yellow_icons/home.svg',
      height: 30,
    ),
    selectedSvgIcon: SvgPicture.asset(
      'assets/blue_icons/home_blue.svg',
      height: 35,
    ),
    text: 'Inicio',
    screen: const PetScreen(),
  ),
  MenuModel(
    id: 1,
    svgIcon: SvgPicture.asset(
      'assets/yellow_icons/book-open.svg',
      height: 30,
    ),
    selectedSvgIcon: SvgPicture.asset(
      'assets/blue_icons/book-open_blue.svg',
      height: 35,
    ),
    text: 'Mascotas',
    screen: const BlogScreen(),
  ),
  MenuModel(
    id: 2,
    svgIcon: SvgPicture.asset(
      'assets/yellow_icons/map-pin.svg',
      height: 30,
    ),
    selectedSvgIcon: SvgPicture.asset(
      'assets/blue_icons/map-pin_blue.svg',
      height: 35,
    ),
    text: 'Mapa',
    screen: const MapScreen(),
  ),
  MenuModel(
    id: 3,
    svgIcon: SvgPicture.asset(
      'assets/yellow_icons/message-circle.svg',
      height: 30,
    ),
    selectedSvgIcon: SvgPicture.asset(
      'assets/blue_icons/message-circle_blue.svg',
      height: 35,
    ),
    text: 'Chats',
    screen: const ChatsScreen(),
  ),
  MenuModel(
    id: 4,
    svgIcon: SvgPicture.asset(
      'assets/yellow_icons/user.svg',
      height: 30,
    ),
    selectedSvgIcon: SvgPicture.asset(
      'assets/blue_icons/user_blue.svg',
      height: 35,
    ),
    text: 'Perfil',
    screen: const ProfileScreen(),
  ),
];

List<MenuModel> menuMorado = [
  MenuModel(
    id: 0,
    svgIcon: SvgPicture.asset(
      'assets/yellow_icons/home.svg',
      height: 30,
    ),
    selectedSvgIcon: SvgPicture.asset(
      'assets/purple_icons/home_purple.svg',
      height: 35,
    ),
    text: 'Inicio',
    screen: const PetScreen(),
  ),
  MenuModel(
    id: 1,
    svgIcon: SvgPicture.asset(
      'assets/yellow_icons/book-open.svg',
      height: 30,
    ),
    selectedSvgIcon: SvgPicture.asset(
      'assets/purple_icons/book-open_purple.svg',
      height: 35,
    ),
    text: 'Mascotas',
    screen: const BlogScreen(),
  ),
  MenuModel(
    id: 2,
    svgIcon: SvgPicture.asset(
      'assets/yellow_icons/map-pin.svg',
      height: 30,
    ),
    selectedSvgIcon: SvgPicture.asset(
      'assets/purple_icons/map-pin_purple.svg',
      height: 35,
    ),
    text: 'Mapa',
    screen: const MapScreen(),
  ),
  MenuModel(
    id: 3,
    svgIcon: SvgPicture.asset(
      'assets/yellow_icons/message-circle.svg',
      height: 30,
    ),
    selectedSvgIcon: SvgPicture.asset(
      'assets/purple_icons/message-circle_purple.svg',
      height: 35,
    ),
    text: 'Chats',
    screen: const ChatsScreen(),
  ),
  MenuModel(
    id: 4,
    svgIcon: SvgPicture.asset(
      'assets/yellow_icons/user.svg',
      height: 30,
    ),
    selectedSvgIcon: SvgPicture.asset(
      'assets/purple_icons/user_purple.svg',
      height: 35,
    ),
    text: 'Perfil',
    screen: const ProfileScreen(),
  ),
];
