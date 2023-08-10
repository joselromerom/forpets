import 'package:custom_info_window/custom_info_window.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:papets_app/constants/app_theme.dart';
import 'package:papets_app/main.dart';
import 'package:papets_app/models/custom_marker.dart';
import 'package:papets_app/models/map_style.dart';
import 'dart:async';
import 'package:papets_app/modules/map/request_permission/request_permission_controller.dart';
import 'package:papets_app/modules/map/screens/map_widgets.dart';
import 'package:papets_app/providers/menu_index_provider.dart';
import 'package:papets_app/providers/theme_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _controller = RequestPermissionController(Permission.locationWhenInUse);

  late StreamSubscription _subscription;

  late MenuIndexProvider myproviderCurrentIndex;
  initializePreferences() async {
    final SharedPreferences prefs = await preferencias;
    mapStyle = prefs.getString('MapStyle');
  }

  @override
  void initState() {
    _controller.request();
    _subscription = _controller.onStatusChanged.listen((status) {
      switch (status) {
        case PermissionStatus.granted:
          setState(() {
            getPosition();
          });
          break;
        case PermissionStatus.denied:
          myproviderCurrentIndex.set(0);
          break;
        case PermissionStatus.permanentlyDenied:
          showAlertDialog(context);
          break;
        case PermissionStatus.restricted:
          break;
        case PermissionStatus.limited:
          break;
        case PermissionStatus.provisional:
          break;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    myproviderCurrentIndex = Provider.of<MenuIndexProvider>(context);
    assing(context);
    initializePreferences();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 61, 0, 0),
      child: permissionGps == true
          ? Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition: position,
                  markers: markers.values.toSet(),
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  onTap: (position) {
                    customInfoWindowController.hideInfoWindow!();
                  },
                  onLongPress: (position) {
                    positionC = position;
                    navigatorKey.currentState?.pushNamed('/create_point');
                  },
                  onMapCreated: onMapCreated,
                  onCameraMove: (position) {
                    customInfoWindowController.onCameraMove!();
                  },
                ),
                CustomInfoWindow(
                  controller: customInfoWindowController,
                  height: 300,
                  width: 300,
                  offset: 35,
                ),
                Align(
                  alignment: const AlignmentDirectional(0.65, -0.96),
                  child: settings(context),
                ),
                Align(
                    alignment: const AlignmentDirectional(0.35, -0.76),
                    child: carru(context))
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                color: ThemeChanger().iconsColor == "Amarillo"
                    ? PapetsColors.amarillo
                    : ThemeChanger().iconsColor == "Morado"
                        ? PapetsColors.morado
                        : ThemeChanger().iconsColor == "Azul"
                            ? PapetsColors.azul
                            : null,
              ),
            ),
    );
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final status = await _controller.check();
      if (status == PermissionStatus.granted) {
        setState(() {
          getPosition();
          myproviderCurrentIndex.set(0);
          myproviderCurrentIndex.set(2);
        });
      } else {}
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    customInfoWindowController.dispose();
    super.dispose();
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    customInfoWindowController.googleMapController ??= controller;
    if (mapStyle == "aubergine") {
      customInfoWindowController.googleMapController
          ?.setMapStyle(MapStyle().aubergine);
    }
    if (mapStyle == "dark") {
      customInfoWindowController.googleMapController
          ?.setMapStyle(MapStyle().dark);
    }
    if (mapStyle == "defaultt") {
      customInfoWindowController.googleMapController
          ?.setMapStyle(MapStyle().defaultt);
    }
    if (mapStyle == "night") {
      customInfoWindowController.googleMapController
          ?.setMapStyle(MapStyle().night);
    }
    if (mapStyle == "retro") {
      customInfoWindowController.googleMapController
          ?.setMapStyle(MapStyle().retro);
    }
    if (mapStyle == "uber") {
      customInfoWindowController.googleMapController
          ?.setMapStyle(MapStyle().uber);
    }
  }

  Future<void> showAlertDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Necesitas activar manualmente el gps'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ir a configuracion'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
                myproviderCurrentIndex.set(0);
                Navigator.popAndPushNamed(context, "/home_page");
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
                myproviderCurrentIndex.set(0);
              },
            ),
          ],
        );
      },
    );
  }

  assing(BuildContext context) async {
    all = await MarkerIcon.svgAsset(
        assetName: 'assets/markers/All.svg', context: context, size: 50);
    // ignore: use_build_context_synchronously
    caminatas = await MarkerIcon.svgAsset(
        assetName: 'assets/markers/Caminatas.svg', context: context, size: 50);
    // ignore: use_build_context_synchronously
    guarderias = await MarkerIcon.svgAsset(
        assetName: 'assets/markers/Guarderias.svg', context: context, size: 50);
    // ignore: use_build_context_synchronously
    mascotas = await MarkerIcon.svgAsset(
        assetName: 'assets/markers/Mascotas perdidas.svg',
        context: context,
        size: 50);
    // ignore: use_build_context_synchronously
    pet = await MarkerIcon.svgAsset(
        assetName: 'assets/markers/pet friendly.svg',
        context: context,
        size: 50);
    // ignore: use_build_context_synchronously
    tiendas = await MarkerIcon.svgAsset(
        assetName: 'assets/markers/Tiendas.svg', context: context, size: 50);
    // ignore: use_build_context_synchronously
    vacunacion = await MarkerIcon.svgAsset(
        assetName: 'assets/markers/Vacunacion.svg', context: context, size: 50);
    // ignore: use_build_context_synchronously
    veterinarias = await MarkerIcon.svgAsset(
        assetName: 'assets/markers/Veterinarias.svg',
        context: context,
        size: 50);

//agregar markers desde firebase cuando recarga la imagen
    markers.clear();
    if (settingsLabel == "Todos") {
      markers.clear();
      FirebaseFirestore.instance
          .collection('markers')
          .get()
          .then((QuerySnapshot querySnapshot) {
        // ignore: avoid_function_literals_in_foreach_calls
        querySnapshot.docs.forEach((doc) {
          if (querySnapshot.docs.isEmpty) {
            setState(() {
              settingsLabel = "No Data";
            });
          } else {
            CustomMarker marker = createMarker(
                doc["markerId"],
                doc["nombre"],
                doc["telefono"],
                doc["userId"],
                doc["type"],
                doc["description"],
                doc["photoUrl"],
                doc["latitude"],
                doc["longitude"],
                doc["stars"],
                doc["address"],
                context);
            setState(() {
              markers[marker.markerId.toString()] = marker;
            });
          }
        });
      });
    } else {
      markers.clear();
      FirebaseFirestore.instance
          .collection('markers')
          .where('type', isEqualTo: settingsLabel)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          setState(() {
            settingsLabel = "No Data";
          });
        } else {
          for (var doc in querySnapshot.docs) {
            CustomMarker marker = createMarker(
                doc["markerId"],
                doc["nombre"],
                doc["telefono"],
                doc["userId"],
                doc["type"],
                doc["description"],
                doc["photoUrl"],
                doc["latitude"],
                doc["longitude"],
                doc["stars"],
                doc["address"],
                context);
            setState(() {
              markers[marker.markerId.toString()] = marker;
            });
          }
        }
      });
    }
  }
}
