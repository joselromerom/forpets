import 'package:card_swiper/card_swiper.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:papets_app/constants/app_font_family.dart';
import 'package:papets_app/constants/app_theme.dart';
import 'package:papets_app/main.dart';
import 'package:papets_app/models/comments.dart';
import 'package:papets_app/models/custom_marker.dart';
import 'package:papets_app/models/map_style.dart';
import 'package:papets_app/providers/theme_provider.dart';
import 'package:papets_app/services/auth/auth_service.dart';
import 'package:papets_app/services/map/aud_map_service.dart';
import 'package:papets_app/services/map/map_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

BitmapDescriptor? caminatas,
    guarderias,
    mascotas,
    pet,
    tiendas,
    vacunacion,
    all,
    veterinarias = BitmapDescriptor.defaultMarker;

String typeMarker = "";

CustomInfoWindowController customInfoWindowController =
    CustomInfoWindowController();

LatLng? positionC;

String? settingsLabel = "All";

// ignore: prefer_const_constructors
CameraPosition position = CameraPosition(
  // ignore: prefer_const_constructors
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);
bool ok = false;

Position? newPosition;

bool permissionGps = false;

Map<String, CustomMarker> markers = {};

String? mapStyle = "";

Future<SharedPreferences> preferencias = SharedPreferences.getInstance();

List<Comment> comments = [];

button(Color? color, String text, double width) => Container(
      width: width,
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
      child: Text(
        text,
        style: FontFamily().titleFont(
          fontSize: 18,
        ),
      ),
    );
Future getPosition() async {
  newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  position = CameraPosition(
    target: LatLng(newPosition!.latitude, newPosition!.longitude),
    zoom: 14.4746,
  );
  permissionGps = true;
}

customDropDown(dynamic defaultValue, context, Color color) => CoolDropdown(
    dropdownList: dropdownItemList,
    resultWidth: 400,
    resultHeight: 55,
    dropdownWidth: 300,
    defaultValue: defaultValue,
    resultTS: FontFamily().textFont(),
    unselectedItemTS: FontFamily().textFont(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFFEFE)
          : const Color(0xFF000000),
    ),
    selectedItemTS: FontFamily().textFont(),
    selectedItemBD: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    ),
    resultBD: BoxDecoration(
      color: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF0F0F0)
          : const Color(0xFF454545),
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: Colors.grey,
        width: 1,
      ),
    ),
    dropdownBD: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: Colors.grey,
        width: 1,
      ),
      color: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFFFFEFE)
          : const Color(0xFF303030),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 15,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    onChange: (selectedItem) {
      typeMarker = "";
      typeMarker = selectedItem["label"];
    },
    resultIcon: SizedBox(
      width: 10,
      height: 10,
      child: SvgPicture.asset(
        'assets/images/dropdown-arrow.svg',
        semanticsLabel: 'Acme Logo',
        color: Colors.grey.withOpacity(0.7),
      ),
    ));
CustomMarker createMarker(
    String markerId,
    String nombre,
    String telefono,
    String userId,
    String type,
    String description,
    String photoUrl,
    double latitude,
    double longitude,
    int stars,
    String address,
    BuildContext context) {
  final marker = CustomMarker(
    markerId: MarkerId(markerId),
    icon: asingIconMarker(type),
    position: LatLng(latitude, longitude),
    stars: stars,
    telefono: telefono,
    type: type,
    userId: userId,
    nombre: nombre,
    photoUrl: photoUrl,
    address: address,
    description: description,
    longitude: longitude,
    latitude: latitude,
    draggable: userId == AuthService().getCurrentUserId() ? true : false,
    onDragEnd: (newPosition) async {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          newPosition.latitude, newPosition.longitude);

      Placemark placeMark = placemarks[0];
      String newAddress =
          "${placeMark.street} ${placeMark.subLocality}, ${placeMark.locality},${placeMark.country}";

      // ignore: use_build_context_synchronously
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Modificar Posición'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text('Deseas modificar la posición de este marcador?'),
                  Text('Quedaria en: $newAddress'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Si'),
                onPressed: () {
                  CustomMarker markerNew = CustomMarker(
                      markerId: MarkerId(
                        " _${nombre}_${userId}_$photoUrl",
                      ),
                      nombre: nombre,
                      telefono: telefono,
                      userId: userId,
                      type: type,
                      description: description,
                      photoUrl: photoUrl,
                      latitude: newPosition.latitude,
                      longitude: newPosition.longitude,
                      address: newAddress,
                      stars: stars);
                  MapService().modifyMarker(markerNew, markerId.toString());

                  CustomMarker markerOld = CustomMarker(
                      markerId: MarkerId(" _${nombre}_${userId}_$photoUrl"),
                      nombre: nombre,
                      telefono: telefono,
                      userId: userId,
                      type: type,
                      description: description,
                      photoUrl: photoUrl,
                      latitude: latitude,
                      longitude: longitude,
                      address: address,
                      stars: stars);

                  AudMapService().addPoint(markerOld, markerNew, "Modificar",
                      DateTime.now().toString());
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    },
    onTap: () {
      customInfoWindowController.addInfoWindow!(
        InkWell(
          onTap: () {
            myCustomMarker.longitude = longitude;
            myCustomMarker.stars = stars;
            myCustomMarker.telefono = telefono;
            myCustomMarker.type = type;
            myCustomMarker.userId = userId;
            myCustomMarker.nombre = nombre;
            myCustomMarker.photoUrl = photoUrl;
            myCustomMarker.address = address;
            myCustomMarker.description = description;
            myCustomMarker.longitude = longitude;
            myCustomMarker.latitude = latitude;
            navigatorKey.currentState?.pushNamed('/view_point');
          },
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFFFFEFE)
                : const Color(0xFF303030),
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  photoUrl,
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text(
                  nombre,
                  style: FontFamily().titleFont(
                    fontSize: 20,
                  ),
                ),
                createStars(stars, 25),
                const SizedBox(height: 5),
                Flexible(
                  flex: 1 /*or any integer value above 0 (optional)*/,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1 /*or any integer value above 0 (optional)*/,
                          child: Text(
                            description,
                            style: FontFamily().textFont(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1 /*or any integer value above 0 (optional)*/,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1 /*or any integer value above 0 (optional)*/,
                          child: Text(
                            address,
                            style: FontFamily().textFont(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        LatLng(latitude, longitude),
      );
    },
  );

  return marker;
}

BitmapDescriptor asingIconMarker(String tipo) {
  BitmapDescriptor iconn = BitmapDescriptor.defaultMarker;
  if (tipo == "Veterinarias") {
    iconn = veterinarias!;
  }
  if (tipo == "Vacunacion") {
    iconn = vacunacion!;
  }
  if (tipo == "Tiendas") {
    iconn = tiendas!;
  }
  if (tipo == "Pet friendly") {
    iconn = pet!;
  }
  if (tipo == "Mascotas perdidas") {
    iconn = mascotas!;
  }
  if (tipo == "Guarderias") {
    iconn = guarderias!;
  }
  if (tipo == "Caminatas") {
    iconn = caminatas!;
  }
  if (tipo == "All") {
    iconn = all!;
  }
  return iconn;
}

List dropdownItemList = [
  {
    'label': 'Caminatas',
    'icon': SizedBox(
      key: UniqueKey(),
      height: 25,
      width: 25,
      child: SvgPicture.asset(
        'assets/markers/Caminatas.svg',
      ),
    ),
  },
  {
    'label': 'Guarderias',
    'icon': SizedBox(
      key: UniqueKey(),
      height: 25,
      width: 25,
      child: SvgPicture.asset(
        'assets/markers/Guarderias.svg',
      ),
    ),
  },
  {
    'label': 'Mascotas perdidas',
    'icon': SizedBox(
      key: UniqueKey(),
      height: 25,
      width: 25,
      child: SvgPicture.asset(
        'assets/markers/Mascotas perdidas.svg',
      ),
    ),
  },
  {
    'label': 'Pet friendly',
    'icon': SizedBox(
      key: UniqueKey(),
      height: 25,
      width: 25,
      child: SvgPicture.asset(
        'assets/markers/Pet friendly.svg',
      ),
    ),
  },
  {
    'label': 'Tiendas',
    'icon': SizedBox(
      key: UniqueKey(),
      height: 25,
      width: 25,
      child: SvgPicture.asset(
        'assets/markers/Tiendas.svg',
      ),
    ),
  },
  {
    'label': 'Vacunacion',
    'icon': SizedBox(
      key: UniqueKey(),
      height: 25,
      width: 25,
      child: SvgPicture.asset(
        'assets/markers/Vacunacion.svg',
      ),
    ),
  },
  {
    'label': 'Veterinarias',
    'icon': SizedBox(
      key: UniqueKey(),
      height: 25,
      width: 25,
      child: SvgPicture.asset(
        'assets/markers/Veterinarias.svg',
      ),
    ),
  },
];
Widget myStyle(BuildContext context) => Column(
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
          child: Text(
            'Estilos de Mapas',
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child: Text(
                    'Aubergine',
                  ),
                ),
                SizedBox(
                  child: InkWell(
                      onTap: () async {
                        final SharedPreferences prefs = await preferencias;
                        await prefs.setString('MapStyle', 'aubergine');

                        customInfoWindowController.googleMapController
                            ?.setMapStyle(MapStyle().aubergine);

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      child: Image.asset('assets/mapStyles/aubergine.png',
                          width: 100, height: 100)),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child: Text(
                    'Dark',
                  ),
                ),
                SizedBox(
                  child: InkWell(
                      onTap: () async {
                        final SharedPreferences prefs = await preferencias;
                        await prefs.setString('MapStyle', 'dark');
                        customInfoWindowController.googleMapController
                            ?.setMapStyle(MapStyle().dark);

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      child: Image.asset('assets/mapStyles/dark.png',
                          width: 100, height: 100)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child: Text(
                    'Default',
                  ),
                ),
                SizedBox(
                  child: InkWell(
                      onTap: () async {
                        final SharedPreferences prefs = await preferencias;
                        await prefs.setString('MapStyle', 'defaultt');

                        customInfoWindowController.googleMapController
                            ?.setMapStyle(MapStyle().defaultt);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      child: Image.asset('assets/mapStyles/default.png',
                          width: 100, height: 100)),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child: Text(
                    'Nigth',
                  ),
                ),
                SizedBox(
                  child: InkWell(
                      onTap: () async {
                        final SharedPreferences prefs = await preferencias;
                        await prefs.setString('MapStyle', 'night');

                        customInfoWindowController.googleMapController
                            ?.setMapStyle(MapStyle().night);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      child: Image.asset('assets/mapStyles/nigth.png',
                          width: 100, height: 100)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child: Text(
                    'Retro',
                  ),
                ),
                SizedBox(
                  child: InkWell(
                      onTap: () async {
                        final SharedPreferences prefs = await preferencias;
                        await prefs.setString('MapStyle', 'retro');

                        customInfoWindowController.googleMapController
                            ?.setMapStyle(MapStyle().retro);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      child: Image.asset('assets/mapStyles/retro.png',
                          width: 100, height: 100)),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child: Text(
                    'Uber',
                  ),
                ),
                SizedBox(
                  child: InkWell(
                      onTap: () async {
                        final SharedPreferences prefs = await preferencias;
                        await prefs.setString('MapStyle', 'uber');

                        customInfoWindowController.googleMapController
                            ?.setMapStyle(MapStyle().uber);

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      child: Image.asset('assets/mapStyles/uber.png',
                          width: 100, height: 100)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
List iconsCarru = [
  {
    'label': 'All',
    'image': SvgPicture.asset(
      'assets/markersCarrousel/All.svg',
    ),
  },
  {
    'label': 'Caminatas',
    'image': SvgPicture.asset(
      'assets/markersCarrousel/Caminatas.svg',
    ),
  },
  {
    'label': 'Guarderias',
    'image': SvgPicture.asset(
      'assets/markersCarrousel/Guarderias.svg',
    ),
  },
  {
    'label': 'Mascotas perdidas',
    'image': SvgPicture.asset(
      'assets/markersCarrousel/Mascotas perdidas.svg',
    ),
  },
  {
    'label': 'Personas',
    'image': SvgPicture.asset(
      'assets/markersCarrousel/Personas.svg',
    ),
  },
  {
    'label': 'Pet friendly',
    'image': SvgPicture.asset(
      'assets/markersCarrousel/Pet friendly.svg',
    ),
  },
  {
    'label': 'Tiendas',
    'image': SvgPicture.asset(
      'assets/markersCarrousel/Tiendas.svg',
    ),
  },
  {
    'label': 'Vacunacion',
    'image': SvgPicture.asset(
      'assets/markersCarrousel/Vacunacion.svg',
    ),
  },
  {
    'label': 'Veterinarias',
    'image': SvgPicture.asset(
      'assets/markersCarrousel/Veterinarias.svg',
    ),
  },
];
Widget carru(context) {
  final theme = Provider.of<ThemeChanger>(context);
  return SizedBox(
    height: 35,
    child: Swiper(
      itemBuilder: (BuildContext context, int index) {
        int num = index - 1;
        num == -1 ? num = 8 : num = num;
        //   print(iconsCarru[num]["label"]);
        if (iconsCarru[num]["label"] == "All") {
          settingsLabel = "Todos";
        } else {
          settingsLabel = iconsCarru[num]["label"];
        }
        return Container(
          decoration: BoxDecoration(
            color: theme.iconsColor == "Amarillo"
                ? PapetsColors.amarillo
                : theme.iconsColor == "Morado"
                    ? PapetsColors.morado
                    : theme.iconsColor == "Azul"
                        ? PapetsColors.azul
                        : null,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          child: iconsCarru[index]["image"],
        );
      },
      itemCount: iconsCarru.length,
      viewportFraction: 0.4,
      fade: 0.2,
      scale: 0.5,
    ),
  );
}

Widget settings(context) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      width: 38,
      height: 38,
      child: InkWell(
        onTap: () async {
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) => SingleChildScrollView(
                controller: ModalScrollController.of(context),
                child: myStyle(context)),
          );
        },
        child: const Icon(FeatherIcons.eye, color: Color(0xFF666666)),
      ),
    );

Widget createStars(int stars, double width) {
  if (stars == 1) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.amber, size: width),
        Icon(Icons.star, color: Colors.black, size: width),
        Icon(Icons.star, color: Colors.black, size: width),
        Icon(Icons.star, color: Colors.black, size: width),
        Icon(Icons.star, color: Colors.black, size: width),
      ],
    );
  }
  if (stars == 2) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.amber, size: width),
        Icon(Icons.star, color: Colors.amber, size: width),
        Icon(Icons.star, color: Colors.black, size: width),
        Icon(Icons.star, color: Colors.black, size: width),
        Icon(Icons.star, color: Colors.black, size: width),
      ],
    );
  }
  if (stars == 3) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.amber, size: width),
        Icon(Icons.star, color: Colors.amber, size: width),
        Icon(Icons.star, color: Colors.amber, size: width),
        Icon(Icons.star, color: Colors.black, size: width),
        Icon(Icons.star, color: Colors.black, size: width),
      ],
    );
  }
  if (stars == 4) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.amber, size: width),
        Icon(Icons.star, color: Colors.amber, size: width),
        Icon(Icons.star, color: Colors.amber, size: width),
        Icon(Icons.star, color: Colors.amber, size: width),
        Icon(Icons.star, color: Colors.black, size: width),
      ],
    );
  }
  if (stars == 5) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.amber, size: width),
        Icon(Icons.star, color: Colors.amber, size: width),
        Icon(Icons.star, color: Colors.amber, size: width),
        Icon(Icons.star, color: Colors.amber, size: width),
        Icon(Icons.star, color: Colors.amber, size: width),
      ],
    );
  }
  return const Text("No data");
}
