import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class GlobalWidget {
  leftWidget(BuildContext context) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: const Color(0x3A000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: const Icon(
            FeatherIcons.arrowLeft,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      );
}
