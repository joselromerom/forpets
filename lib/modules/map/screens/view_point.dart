import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:papets_app/constants/app_font_family.dart';
import 'package:papets_app/constants/app_theme.dart';
import 'package:papets_app/main.dart';
import 'package:papets_app/models/comments.dart';
import 'package:papets_app/models/custom_marker.dart';
import 'package:papets_app/modules/map/screens/map_widgets.dart';
import 'package:papets_app/services/auth/auth_service.dart';
import 'package:papets_app/services/map/map_service.dart';
import 'package:papets_app/services/map/point_comments.dart';
import 'package:papets_app/utils/globals.dart';
import 'package:papets_app/utils/utils.dart';
import 'package:papets_app/utils/widgets/global_widget.dart';
import 'package:papets_app/utils/widgets/input_widgets.dart';

class ViewPoint extends StatefulWidget {
  const ViewPoint({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewPointState createState() => _ViewPointState();
}

TextEditingController commentsController = TextEditingController();
TextEditingController editCommentsController = TextEditingController();

// Initial Selected Value
String dropdownvalue = '1';
String dropdownvalueEdit = '1';

// List of items in our dropdown menu
var items = [
  '5',
  '4',
  '3',
  '2',
  '1',
];

class _ViewPointState extends State<ViewPoint> {
  @override
  void initState() {
    setState(() {
      dropdownvalue = '5';
      dropdownvalueEdit = '5';
      commentsController.text = "";
      editCommentsController.text = "";
      comments.clear();
      getComments(
          "MarkerId( _${myCustomMarker.nombre}_${myCustomMarker.userId}_${myCustomMarker.photoUrl})");
    });
    super.initState();
  }

  Future<void> showAlertDialog(context, Comment miCommentOld) async {
    dropdownvalueEdit = "${miCommentOld.stars}";
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Moditicar'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    const Text('Modifica tu comentario'),
                    const SizedBox(height: 5),
                    FormWidgets().textField(
                        controller: editCommentsController,
                        hintText: 'Comentarios',
                        maxLines: 3),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 30),
                        const SizedBox(width: 5),
                        DropdownButton(
                          value: dropdownvalueEdit,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalueEdit = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Publicar'),
              onPressed: () {
                if (editCommentsController.text == "") {
                  showSnackBar(
                      '¡Ups! Tienes que escribir el comentario.', context);
                } else {
                  Comment miComment = Comment(
                    miCommentOld.userId,
                    miCommentOld.name,
                    miCommentOld.photoUrl,
                    miCommentOld.markerId,
                    editCommentsController.text,
                    int.parse(dropdownvalueEdit),
                  );
                  PointComments().updateComment(miCommentOld, miComment);
                  int estrellas =
                      (myCustomMarker.stars + int.parse(dropdownvalueEdit)) ~/
                          2;
                  MapService().modifyMarker(
                      CustomMarker(
                          markerId: myCustomMarker.markerId,
                          nombre: myCustomMarker.nombre,
                          telefono: myCustomMarker.telefono,
                          userId: myCustomMarker.userId,
                          type: myCustomMarker.type,
                          description: myCustomMarker.description,
                          photoUrl: myCustomMarker.photoUrl,
                          latitude: myCustomMarker.latitude,
                          longitude: myCustomMarker.longitude,
                          address: myCustomMarker.address,
                          stars: estrellas),
                      myCustomMarker.markerId.toString());
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getComments(String markerId) async {
    return FirebaseFirestore.instance
        .collection('comments')
        .where('markerId', isEqualTo: markerId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Comment miComment = Comment(
          doc["userId"],
          doc["name"],
          doc["photoUrl"],
          doc["markerId"],
          doc["comment"],
          doc["stars"],
        );
        comments.add(miComment);
      }
      setState(() {
        ok = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ok == true
          ? SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 65, 0, 0),
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      myCustomMarker.photoUrl,
                                      width: double.infinity,
                                      height: 300,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
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
                                            myCustomMarker.userId ==
                                                    AuthService()
                                                        .getCurrentUserId()
                                                ? InkWell(
                                                    onTap: () async {},
                                                    child: Card(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      color: const Color(
                                                          0x3A000000),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: IconButton(
                                                        icon: const Icon(
                                                          FeatherIcons.edit2,
                                                          color: Colors.amber,
                                                          size: 24,
                                                        ),
                                                        onPressed: () async {
                                                          navigatorKey
                                                              .currentState
                                                              ?.pushNamed(
                                                                  '/edit_point');
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                : const Text("")
                                          ],
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
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                30, 20, 10, 8),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                children: [
                                  Text(
                                    myCustomMarker.nombre,
                                    style: FontFamily().titleFont(
                                      fontSize: 28,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(30, 0, 16, 8),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            children: [
                              Text(
                                myCustomMarker.description,
                                style: FontFamily().textFont(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(30, 0, 16, 15),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            children: [
                              Text(
                                "Esta hubicado en ${myCustomMarker.address}",
                                style: FontFamily().textFont(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(30, 0, 16, 15),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            children: [
                              Text(
                                "Contacto: ${myCustomMarker.telefono}",
                                style: FontFamily().textFont(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "Este lugar cuenta con una calificación de ",
                        style: FontFamily().subtitleFont(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      createStars(myCustomMarker.stars, 30),
                      const SizedBox(height: 15),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(30, 0, 16, 10),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Reseñas",
                            style: FontFamily().subtitleFont(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20, 20, 20, 12),
                        child: FormWidgets().textField(
                            controller: commentsController,
                            hintText: 'Comentarios',
                            maxLines: 3),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 30),
                                const SizedBox(width: 5),
                                DropdownButton(
                                  value: dropdownvalue,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                if (commentsController.text == "") {
                                  showSnackBar(
                                      '¡Ups! Tienes que escribir el comentario.',
                                      context);
                                } else {
                                  PointComments().addComment(Comment(
                                      AuthService().getCurrentUserId(),
                                      currentUser!.name,
                                      currentUser!.photoUrl,
                                      "MarkerId( _${myCustomMarker.nombre}_${myCustomMarker.userId}_${myCustomMarker.photoUrl})",
                                      commentsController.text,
                                      int.parse(dropdownvalue)));
                                  int estrellas = (myCustomMarker.stars +
                                          int.parse(dropdownvalue)) ~/
                                      2;
                                  MapService().modifyMarker(
                                      CustomMarker(
                                          markerId: myCustomMarker.markerId,
                                          nombre: myCustomMarker.nombre,
                                          telefono: myCustomMarker.telefono,
                                          userId: myCustomMarker.userId,
                                          type: myCustomMarker.type,
                                          description:
                                              myCustomMarker.description,
                                          photoUrl: myCustomMarker.photoUrl,
                                          latitude: myCustomMarker.latitude,
                                          longitude: myCustomMarker.longitude,
                                          address: myCustomMarker.address,
                                          stars: estrellas),
                                      myCustomMarker.markerId.toString());

                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                width: 65,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  color: PapetsColors.amarillo,
                                ),
                                child: Text(
                                  "Publicar",
                                  style: FontFamily().subtitleFont(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Card(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              30, 0, 16, 15),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  comments[index].name,
                                                  style: FontFamily().titleFont(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(
                                                      comments[index].photoUrl),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              comments[index].comment,
                                              style: FontFamily().textFont(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  createStars(
                                                      comments[index].stars,
                                                      15),
                                                  comments[index].userId ==
                                                          AuthService()
                                                              .getCurrentUserId()
                                                      ? Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Comment
                                                                    miComment =
                                                                    Comment(
                                                                  comments[
                                                                          index]
                                                                      .userId,
                                                                  comments[
                                                                          index]
                                                                      .name,
                                                                  comments[
                                                                          index]
                                                                      .photoUrl,
                                                                  comments[
                                                                          index]
                                                                      .markerId,
                                                                  comments[
                                                                          index]
                                                                      .comment,
                                                                  comments[
                                                                          index]
                                                                      .stars,
                                                                );
                                                                PointComments()
                                                                    .deleteComment(
                                                                        miComment);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Icon(
                                                                FeatherIcons.x,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Comment
                                                                    miComment =
                                                                    Comment(
                                                                  comments[
                                                                          index]
                                                                      .userId,
                                                                  comments[
                                                                          index]
                                                                      .name,
                                                                  comments[
                                                                          index]
                                                                      .photoUrl,
                                                                  comments[
                                                                          index]
                                                                      .markerId,
                                                                  comments[
                                                                          index]
                                                                      .comment,
                                                                  comments[
                                                                          index]
                                                                      .stars,
                                                                );
                                                                editCommentsController
                                                                        .text =
                                                                    comments[
                                                                            index]
                                                                        .comment;

                                                                showAlertDialog(
                                                                    context,
                                                                    miComment);
                                                              },
                                                              child: const Icon(
                                                                FeatherIcons
                                                                    .edit3,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      : const Text(""),
                                                ]),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: PapetsColors.amarillo,
              ),
            ),
    );
  }
}
