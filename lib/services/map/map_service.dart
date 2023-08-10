import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:papets_app/models/custom_marker.dart';

class MapService {
  Future<void> addPoint(CustomMarker marker) {
    return FirebaseFirestore.instance
        .collection('markers')
        .add({
          'markerId': marker.markerId.toString(),
          'nombre': marker.nombre,
          'telefono': marker.telefono,
          'userId': marker.userId,
          'type': marker.type,
          'description': marker.description,
          'photoUrl': marker.photoUrl,
          'latitude': marker.latitude,
          'longitude': marker.longitude,
          'stars': marker.stars,
          'address': marker.address,
        })
        // ignore: avoid_print
        .then((value) => print("punto agregado en el mapa"))
        .catchError(
            // ignore: avoid_print
            (error) => print("error al agregar el punto en el mapa: $error"));
  }

  Future<void> modifyMarker(CustomMarker marker, String oldMarkerId) async {
    return FirebaseFirestore.instance
        .collection('markers')
        .where('markerId', isEqualTo: oldMarkerId)
        .get()
        .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.update({
              'markerId': marker.markerId.toString(),
              'nombre': marker.nombre,
              'telefono': marker.telefono,
              'userId': marker.userId,
              'type': marker.type,
              'description': marker.description,
              'photoUrl': marker.photoUrl,
              'latitude': marker.latitude,
              'longitude': marker.longitude,
              'stars': marker.stars,
              'address': marker.address,
            });
          }
        })
        // ignore: avoid_print
        .then((value) => print("Se agrego el cambio"))
        // ignore: avoid_print
        .catchError((err) => print("Failed to modify marker: $err"));
  }

  Future<void> deleteMarker(String markerId) async {
    return FirebaseFirestore.instance
        .collection('markers')
        .where('markerId', isEqualTo: markerId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
      // ignore: avoid_print, invalid_return_type_for_catch_error
    }).catchError((err) => print("Failed to delete marker: $err"));
  }
}
