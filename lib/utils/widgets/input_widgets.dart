import 'package:flutter/material.dart';
import 'package:papets_app/constants/app_font_family.dart';

class FormWidgets {
  TextField textField({
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.done,
    bool autocorrect = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextAlign textAlign = TextAlign.left,
    int maxLength = 128,
    bool obscured = false,
    String hintText = "",
    required int maxLines,
    required TextEditingController controller,
  }) =>
      TextField(
        maxLines: maxLines,
        controller: controller,
        style: FontFamily().textFont(),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        autocorrect: autocorrect,
        textCapitalization: textCapitalization,
        textAlign: textAlign,
        maxLength: maxLength,
        obscureText: obscured,
        decoration: InputDecoration(
          labelStyle: FontFamily().textFont(
            color: Colors.grey,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          labelText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              1,
            ),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          counterText: "",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              1,
            ),
            borderSide: const BorderSide(
              width: 1,
            ),
          ),
        ),
      );
}
