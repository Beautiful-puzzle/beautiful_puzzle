import 'package:flutter/material.dart';

class ColorsResource {
  static Color _dynamicColor({required Color light, required Color dark}) {
    return Color.lerp(light, dark, 1)!;
  }

  static Color get primary => _dynamicColor(light: const Color(0xFF23CE6B), dark: const Color(0xFF23CE6B));
  static Color get secondary => _dynamicColor(light: const Color(0xFFA846A0), dark: const Color(0xFFA846A0));
  static Color get surface => _dynamicColor(light: const Color(0xFFF6F8FF), dark: const Color(0xFFF6F8FF));
  static Color get background => _dynamicColor(light: const Color(0xFF272D2D), dark: const Color(0xFF272D2D));
  static Color get backgroundAccent => _dynamicColor(light: const Color(0xFF50514F), dark: const Color(0xFF50514F));

}