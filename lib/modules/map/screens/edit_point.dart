import 'dart:typed_data';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papets_app/constants/app_font_family.dart';
import 'package:papets_app/constants/app_theme.dart';
import 'package:papets_app/models/custom_marker.dart';
import 'package:papets_app/modules/map/screens/map_widgets.dart';
import 'package:papets_app/providers/menu_index_provider.dart';
import 'package:papets_app/providers/theme_provider.dart';
import 'package:papets_app/services/map/aud_map_service.dart';
import 'package:papets_app/services/map/map_service.dart';
import 'package:papets_app/services/storage/storage_service.dart';
import 'package:papets_app/utils/utils.dart';
import 'package:papets_app/utils/widgets/global_widget.dart';
import 'package:papets_app/utils/widgets/input_widgets.dart';
import 'package:provider/provider.dart';

class EditPoint extends StatefulWidget {
  const EditPoint({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditPointState createState() => _EditPointState();
}

class _EditPointState extends State<EditPoint> {
  TextEditingController descripcionControllerE = TextEditingController();
  TextEditingController nombreControllerE = TextEditingController();
  TextEditingController telefonoControllerE = TextEditingController();

  late MenuIndexProvider myproviderCurrentIndex;

  Uint8List? image;
  int indexType = 0;
  Color? color;

  @override
  void initState() {
    descripcionControllerE.text = myCustomMarker.description;
    nombreControllerE.text = myCustomMarker.nombre;
    telefonoControllerE.text = myCustomMarker.telefono;
    typeMarker = myCustomMarker.type;
    defauldType();
    super.initState();
  }

  defauldType() {
    for (var i = 0; i < dropdownItemList.length; i++) {
      if (dropdownItemList[i]["label"] == typeMarker) {
        setState(() {
          indexType = i;
        });
      }
    }
  }

  void selectImage() async {
    try {
      Uint8List img = await pickImage(ImageSource.gallery);
      setState(() {
        image = img;
      });
    } catch (e) {
      showSnackBar('No se selecciono img', context);
    }
  }

  imgWidget() => image != null
      ? ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.memory(
            image!,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
        )
      : ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            myCustomMarker.photoUrl,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
        );

  dropWidget() => InkWell(
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: const Color(0x3A000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(
              FeatherIcons.x,
              color: Colors.red,
              size: 24,
            ),
            onPressed: () async {
              MarkerId markerId = MarkerId(
                  " _${myCustomMarker.nombre}_${myCustomMarker.userId}_${myCustomMarker.photoUrl}");
              MapService().deleteMarker(markerId.toString());
              CustomMarker markerOld = CustomMarker(
                  markerId: MarkerId(
                      " _${myCustomMarker.nombre}_${myCustomMarker.userId}_$myCustomMarker.photoUrl"),
                  nombre: myCustomMarker.nombre,
                  telefono: myCustomMarker.telefono,
                  userId: myCustomMarker.userId,
                  type: myCustomMarker.type,
                  description: myCustomMarker.description,
                  photoUrl: myCustomMarker.photoUrl,
                  latitude: myCustomMarker.latitude,
                  longitude: myCustomMarker.longitude,
                  address: myCustomMarker.address,
                  stars: myCustomMarker.stars);

              AudMapService().addPoint(
                  markerOld, markerOld, "Eliminar", DateTime.now().toString());

              customInfoWindowController.hideInfoWindow!();
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    myproviderCurrentIndex = Provider.of<MenuIndexProvider>(context);
    final theme = Provider.of<ThemeChanger>(context);
    theme.iconsColor == "Amarillo"
        ? color = PapetsColors.amarillo
        : theme.iconsColor == "Morado"
            ? color = PapetsColors.morado
            : color = PapetsColors.azul;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(0, 61, 0, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 44, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              imgWidget(),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 16, 16, 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GlobalWidget().leftWidget(context),
                                        dropWidget(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 10,
                                child: GestureDetector(
                                  onTap: selectImage,
                                  child: Icon(Icons.add_a_photo, color: color),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(30, 20, 16, 15),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  children: [
                    Text(
                      "El punto esta hubicado en ${myCustomMarker.address}",
                      style: FontFamily().textFont(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(22, 10, 20, 12),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Tipo:',
                        style: FontFamily().subtitleFont(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    customDropDown(dropdownItemList[0], context, color!),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Nombre:',
                        style: FontFamily().subtitleFont(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FormWidgets().textField(
                        controller: nombreControllerE,
                        hintText: 'Nombre del punto',
                        maxLines: 1),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Telefono:',
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
                        keyboardType: TextInputType.phone,
                        controller: telefonoControllerE,
                        hintText: 'Telefono',
                        maxLines: 1),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Descripción:',
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
                        controller: descripcionControllerE,
                        hintText: 'Descripción',
                        maxLines: 3),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: button(Colors.red, 'Cancelar', 160)),
                  InkWell(
                      onTap: () async {
                        //Subir foto a firebase
                        String? photoUrl;
                        if (image != null) {
                          photoUrl = await StorageService()
                              .uploadImageToStorage(
                                  childName: nombreControllerE.text,
                                  file: image!);
                        } else if (nombreControllerE.text == "") {
                          showSnackBar(
                              '¡Ups! Tienes que escribir el Nombre".', context);
                        } else if (telefonoControllerE.text == "") {
                          showSnackBar(
                              '¡Ups! Tienes que escribir el Telefono".',
                              context);
                        } else if (descripcionControllerE.text == "") {
                          showSnackBar(
                              '¡Ups! Tienes que escribir una Descripción.',
                              context);
                        } else {
                          photoUrl = myCustomMarker.photoUrl;

                          MarkerId markerId = MarkerId(
                              " _${myCustomMarker.nombre}_${myCustomMarker.userId}_${myCustomMarker.photoUrl}");
                          CustomMarker markerOld = CustomMarker(
                              markerId: MarkerId(
                                  " _${myCustomMarker.nombre}_${myCustomMarker.userId}_$myCustomMarker.photoUrl"),
                              nombre: myCustomMarker.nombre,
                              telefono: myCustomMarker.telefono,
                              userId: myCustomMarker.userId,
                              type: myCustomMarker.type,
                              description: myCustomMarker.description,
                              photoUrl: myCustomMarker.photoUrl,
                              latitude: myCustomMarker.latitude,
                              longitude: myCustomMarker.longitude,
                              address: myCustomMarker.address,
                              stars: myCustomMarker.stars);
                          // ignore: use_build_context_synchronously
                          CustomMarker marker = createMarker(
                              " _${nombreControllerE.text}_${myCustomMarker.userId}_$photoUrl",
                              nombreControllerE.text,
                              telefonoControllerE.text,
                              myCustomMarker.userId,
                              typeMarker,
                              descripcionControllerE.text,
                              photoUrl,
                              myCustomMarker.latitude,
                              myCustomMarker.longitude,
                              myCustomMarker.stars,
                              myCustomMarker.address,
                              context);

                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          customInfoWindowController.hideInfoWindow!();
                          MapService()
                              .modifyMarker(marker, markerId.toString());
                          AudMapService().addPoint(markerOld, marker,
                              "Modificar", DateTime.now().toString());
                        }
                      },
                      child: button(Colors.green, 'Aceptar', 160)),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
