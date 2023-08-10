import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papets_app/constants/app_font_family.dart';
import 'package:papets_app/constants/app_theme.dart';
import 'package:papets_app/models/custom_marker.dart';
import 'package:papets_app/modules/map/screens/map_widgets.dart';
import 'package:papets_app/providers/menu_index_provider.dart';
import 'package:papets_app/providers/theme_provider.dart';
import 'package:papets_app/services/auth/auth_service.dart';
import 'package:papets_app/services/map/aud_map_service.dart';
import 'package:papets_app/services/map/map_service.dart';
import 'package:papets_app/services/storage/storage_service.dart';
import 'package:papets_app/utils/utils.dart';
import 'package:papets_app/utils/widgets/global_widget.dart';
import 'package:papets_app/utils/widgets/input_widgets.dart';
import 'package:provider/provider.dart';

class CreatePoint extends StatefulWidget {
  const CreatePoint({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreatePointState createState() => _CreatePointState();
}

class _CreatePointState extends State<CreatePoint> {
  TextEditingController descripcionController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();

  Uint8List? image;

  late MenuIndexProvider myproviderCurrentIndex;
  Color? color;
  @override
  void initState() {
    typeMarker = dropdownItemList[0]["label"];
    super.initState();
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

  imgWidget() => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(22, 10, 20, 12),
        child: Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: image != null
                  ? InkWell(
                      onTap: () => selectImage(),
                      child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: MemoryImage(
                                    image!), // <--- .image added here
                              ))),
                    )
                  : InkWell(
                      onTap: () => selectImage(),
                      child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: const DecorationImage(
                                image: NetworkImage(
                                    'https://cdn-icons-png.flaticon.com/512/5982/5982349.png'), // <--- .image added here
                              ))),
                    )),
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
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlobalWidget().leftWidget(context),
                ],
              ),
              const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                  child: Text(
                    'Agregar un punto',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  )),
              imgWidget(),
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
                          controller: nombreController,
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
                          controller: telefonoController,
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
                          controller: descripcionController,
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
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        child: button(Colors.red, 'Cancelar', 160)),
                    InkWell(
                      onTap: () async {
                        String? photoUrl;
                        if (image == null) {
                          showSnackBar(
                              '¡Ups! Tienes elegir una imagen.', context);
                        } else if (nombreController.text == "") {
                          showSnackBar(
                              '¡Ups! Tienes que escribir el Nombre".', context);
                        } else if (telefonoController.text == "") {
                          showSnackBar(
                              '¡Ups! Tienes que escribir el Telefono".',
                              context);
                        } else if (descripcionController.text == "") {
                          showSnackBar(
                              '¡Ups! Tienes que escribir una Descripción.',
                              context);
                        } else {
                          //Subir foto a firebase
                          photoUrl = await StorageService()
                              .uploadImageToStorage(
                                  childName: nombreController.text,
                                  file: image!);
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                  positionC!.latitude, positionC!.longitude);

                          Placemark placeMark = placemarks[0];
                          String address =
                              "${placeMark.street} ${placeMark.subLocality}, ${placeMark.locality},${placeMark.country}";

                          // ignore: use_build_context_synchronously
                          CustomMarker marker = createMarker(
                              " _${nombreController.text}_${AuthService().getCurrentUserId()}_$photoUrl",
                              nombreController.text,
                              telefonoController.text,
                              AuthService().getCurrentUserId(),
                              typeMarker,
                              descripcionController.text,
                              photoUrl,
                              positionC!.latitude,
                              positionC!.longitude,
                              5,
                              address,
                              context);
                          //subiendo el marker a firebase
                          MapService().addPoint(marker);

                          AudMapService().addPoint(marker, marker, "Agregar",
                              DateTime.now().toString());
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          customInfoWindowController.hideInfoWindow!();
                          // Navigator.pushNamed(context, '/');
                        }
                      },
                      child: button(Colors.green, 'Registrar', 160),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
