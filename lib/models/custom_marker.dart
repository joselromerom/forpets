// ignore_for_file: prefer_const_constructors

import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class CustomMarker extends Marker {
  String nombre;
  String telefono;
  String userId;
  String type;
  String description;
  String photoUrl;
  double latitude;
  double longitude;
  String address;
  int stars;

  CustomMarker(
      {required super.markerId,
      super.icon,
      super.position,
      super.onTap,
      super.infoWindow,
      super.onDragEnd,
      super.draggable,
      required this.nombre,
      required this.telefono,
      required this.userId,
      required this.type,
      required this.description,
      required this.photoUrl,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.stars});
}

// ignore: duplicate_ignore
CustomMarker myCustomMarker = CustomMarker(
    markerId: MarkerId("markerId"),
    position: LatLng(0, 0),
    nombre: "nombre",
    telefono: "telefono",
    userId: "userId",
    type: "type",
    description: "description",
    photoUrl: "photoUrl",
    latitude: 0,
    longitude: 0,
    address: "address",
    stars: 5);
