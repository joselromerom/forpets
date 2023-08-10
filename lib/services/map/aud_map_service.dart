import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:papets_app/models/custom_marker.dart';

class AudMapService {
  Future<void> addPoint(CustomMarker markerOld, CustomMarker markerNew,
      String action, String date) {
    return FirebaseFirestore.instance
        .collection('audMarker')
        .add({
          'markerIdOld': markerOld.markerId.toString(),
          'nombreOld': markerOld.nombre,
          'telefonoOld': markerOld.telefono,
          'typeOld': markerOld.type,
          'descriptionOld': markerOld.description,
          'photoUrlOld': markerOld.photoUrl,
          'latitudeOld': markerOld.latitude,
          'longitudeOld': markerOld.longitude,
          'starsOld': markerOld.stars,
          'addressOld': markerOld.address,
          'action': action,
          'date': date,
          'userId': markerNew.userId,
          'markerIdNew': action == "Agregar" || action == "Eliminar"
              ? "null"
              : markerNew.markerId.toString(),
          'nombreNew': action == "Agregar" || action == "Eliminar"
              ? "null"
              : markerNew.nombre,
          'telefonoNew': action == "Agregar" || action == "Eliminar"
              ? "null"
              : markerNew.telefono,
          'typeNew': action == "Agregar" || action == "Eliminar"
              ? "null"
              : markerNew.type,
          'descriptionNew': action == "Agregar" || action == "Eliminar"
              ? "null"
              : markerNew.description,
          'photoUrlNew': action == "Agregar" || action == "Eliminar"
              ? "null"
              : markerNew.photoUrl,
          'latitudeNew': action == "Agregar" || action == "Eliminar"
              ? "null"
              : markerNew.latitude,
          'longitudeNew': action == "Agregar" || action == "Eliminar"
              ? "null"
              : markerNew.longitude,
          'starsNew': action == "Agregar" || action == "Eliminar"
              ? "null"
              : markerNew.stars,
          'addressNew': action == "Agregar" || action == "Eliminar"
              ? "null"
              : markerNew.address,
        })
        // ignore: avoid_print
        .then((value) => print("Datos agregados en la auditoria"))
        .catchError(
            // ignore: avoid_print
            (error) => print("error al agregar el punto en el mapa: $error"));
  }
}
