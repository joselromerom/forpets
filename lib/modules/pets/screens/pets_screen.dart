import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:papets_app/constants/app_font_family.dart';
import 'package:papets_app/constants/app_theme.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({Key? key}) : super(key: key);

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final List<String> _listItems = [
    'https://source.unsplash.com/random/600×700/?pets',
    'https://source.unsplash.com/random/700×700/?pets',
    'https://source.unsplash.com/random/500×700/?pets',
    'https://source.unsplash.com/random/400×700/?pets',
    'https://source.unsplash.com/random/800×700/?pets',
    'https://source.unsplash.com/random/300×700/?pets',
    'https://source.unsplash.com/random/900×700/?pets',
    'https://source.unsplash.com/random/1000×700/?pets',
    'https://source.unsplash.com/random/1100×700/?pets',
    'https://source.unsplash.com/random/1200×700/?pets',
    'https://source.unsplash.com/random/1300×700/?pets',
    'https://source.unsplash.com/random/1400×700/?pets',
    'https://source.unsplash.com/random/1500×700/?pets',
    'https://source.unsplash.com/random/1150×700/?pets',
    'https://source.unsplash.com/random/1250×700/?pets',
    'https://source.unsplash.com/random/1350×700/?pets',
    'https://source.unsplash.com/random/1310×700/?pets',
    'https://source.unsplash.com/random/1110×700/?pets',
  ];
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => {},
                        child: const Icon(FeatherIcons.search),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      /*   GestureDetector(
                        onTap: () => {},
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(currentUser!.photoUrl),
                        ),
                      ),*/
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Descubre',
                    style: FontFamily().titleFont(),
                  ),
                  Text(
                    'Tips para tu mascota',
                    style: FontFamily().textFont(
                      color: PapetsColors.gray,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: _listItems
                    .map(
                      (item) => Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(item),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ]),
        ),
      );
}
