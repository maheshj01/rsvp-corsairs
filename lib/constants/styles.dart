import 'package:flutter/material.dart';
import 'package:rsvp/themes/theme.dart';

/// mention style constants to be used across different pages in you app here
/// e.g borderRadius,textstyle,gradients etc
///
const OutlineInputBorder inputborder =
    OutlineInputBorder(borderSide: BorderSide(color: Colors.white));
const OutlineInputBorder focusedInputborder = OutlineInputBorder(
    borderSide: BorderSide(color: CorsairsTheme.primaryYellow, width: 2));
OutlineInputBorder errorInputborder =
    OutlineInputBorder(borderSide: BorderSide(color: CorsairsTheme.primaryRed));

const TextStyle inputHintStyle = TextStyle(color: Colors.white54);
