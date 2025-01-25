import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


ColorScheme defaultLightColors = const ColorScheme.light(
  primary: Color(0xFF8D97FC),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF858AE3),
  onSecondary: Color(0xFFFFFFFF),
  tertiary: Color(0xFF1B9AAA),
  onTertiary: Color(0xFF000000),
  primaryContainer: Color(0xFF12263A),
  onPrimaryContainer: Color(0xFFFFFFFF),
  surface: Color(0xFFFCFEFF),
  onSurface: Color(0xFF000000),
  error: Color.fromARGB(255, 238, 51, 38),
  shadow: Color.fromARGB(100, 76, 76, 76),

  primaryFixed: Color(0xFF5E17EB),
  primaryFixedDim: Color(0xFF0E148D),
);


ColorScheme defaultDarkColors = const ColorScheme.dark(
  primary: Color(0xFF6b418d),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF7D509D),
  onSecondary: Color(0xFFFFFFFF),
  tertiary: Color(0xFFB83197),
  onTertiary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFE7D1FF),
  onPrimaryContainer: Color(0xFF000000),
  surface: Color(0xFF131313),
  onSurface: Color(0xFFFFFFFF),
  error: Color.fromARGB(255, 234, 31, 17),
  shadow: Color.fromARGB(0, 0, 0, 0),

  primaryFixedDim: Color(0xFFECA0FF),
  secondaryContainer: Color(0xff652f8f),
  tertiaryFixed: Color.fromARGB(255, 102, 148, 190),
  onTertiaryFixed: Colors.white,
);


Future<void> setThemeColor(SharedPreferences? prefs, Brightness brightness, String colorKey, Color? color) async {
  if (prefs != null) {
    print("Setting color $colorKey to $color");
    if (color == null) {
      await prefs.remove("theme_colorScheme_${brightness == Brightness.dark ? "dark" : "light"}_$colorKey");
    } else {
      await prefs.setInt("theme_colorScheme_${brightness == Brightness.dark ? "dark" : "light"}_$colorKey", color.value);
    }
  } else {
    print("setThemeColor() Prefs is null");
  }
}


Color getThemeColor(SharedPreferences? prefs, Brightness brightness, String colorKey,) {
  int? colorNum;
  if (prefs == null) {
    colorNum = null;
  } else {
    colorNum = prefs.getInt("theme_colorScheme_${brightness == Brightness.dark ? "dark" : "light"}_$colorKey");
  }

  Color color = Color(0xFF000000);
  if (colorNum == null) {
    switch (colorKey) {
      case "primary":
        color = brightness == Brightness.dark ? defaultDarkColors.primary : defaultLightColors.primary;
        break;
      case "onPrimary":
        color = brightness == Brightness.dark ? defaultDarkColors.onPrimary : defaultLightColors.onPrimary;
        break;
      case "secondary":
        color = brightness == Brightness.dark ? defaultDarkColors.secondary : defaultLightColors.secondary;
        break;
      case "onSecondary":
        color = brightness == Brightness.dark ? defaultDarkColors.onSecondary : defaultLightColors.onSecondary;
        break;
      case "tertiary":
        color = brightness == Brightness.dark ? defaultDarkColors.tertiary : defaultLightColors.tertiary;
        break;
      case "onTertiary":
        color = brightness == Brightness.dark ? defaultDarkColors.onTertiary : defaultLightColors.onTertiary;
        break;
      case "primaryContainer":
        color = brightness == Brightness.dark ? defaultDarkColors.primaryContainer : defaultLightColors.primaryContainer;
        break;
      case "onPrimaryContainer":
        color = brightness == Brightness.dark ? defaultDarkColors.onPrimaryContainer : defaultLightColors.onPrimaryContainer;
        break;
      case "surface":
        color = brightness == Brightness.dark ? defaultDarkColors.surface : defaultLightColors.surface;
        break;
      case "onSurface":
        color = brightness == Brightness.dark ? defaultDarkColors.onSurface : defaultLightColors.onSurface;
        break;
      case "error":
        color = brightness == Brightness.dark ? defaultDarkColors.error : defaultLightColors.error;
        break;
      case "shadow":
        color = brightness == Brightness.dark ? defaultDarkColors.shadow : defaultLightColors.shadow;
        break;
      case "primaryFixed":
        color = brightness == Brightness.dark ? defaultDarkColors.primaryFixed : defaultLightColors.primaryFixed;
        break;
      case "primaryFixedDim":
        color = brightness == Brightness.dark ? defaultDarkColors.primaryFixedDim : defaultLightColors.primaryFixedDim;
        break;
    }
  } else {
    color = Color(colorNum);
  }

  return color;
}


ColorScheme createDarkColorScheme(SharedPreferences? prefs) {
  Brightness brightness = Brightness.dark;
  return ColorScheme.dark(
    primary: getThemeColor(prefs, brightness, "primary"),
    onPrimary: getThemeColor(prefs, brightness, "onPrimary"),
    secondary: getThemeColor(prefs, brightness, "secondary"),
    onSecondary: getThemeColor(prefs, brightness, "onSecondary"),
    tertiary: getThemeColor(prefs, brightness, "tertiary"),
    onTertiary: getThemeColor(prefs, brightness, "onTertiary"),
    primaryContainer: getThemeColor(prefs, brightness, "primaryContainer"),
    onPrimaryContainer: getThemeColor(prefs, brightness, "onPrimaryContainer"),
    primaryFixed: getThemeColor(prefs, brightness, "primaryFixed"),
    primaryFixedDim: getThemeColor(prefs, brightness, "primaryFixedDim"),
    surface: getThemeColor(prefs, brightness, "surface"),
    onSurface: getThemeColor(prefs, brightness, "onSurface"),
    error: getThemeColor(prefs, brightness, "error"),
    shadow: getThemeColor(prefs, brightness, "shadow"),
  );
}


ColorScheme createLightColorScheme(SharedPreferences? prefs) {
  Brightness brightness = Brightness.light;
  return ColorScheme.light(
    primary: getThemeColor(prefs, brightness, "primary"),
    onPrimary: getThemeColor(prefs, brightness, "onPrimary"),
    secondary: getThemeColor(prefs, brightness, "secondary"),
    onSecondary: getThemeColor(prefs, brightness, "onSecondary"),
    tertiary: getThemeColor(prefs, brightness, "tertiary"),
    onTertiary: getThemeColor(prefs, brightness, "onTertiary"),
    primaryContainer: getThemeColor(prefs, brightness, "primaryContainer"),
    onPrimaryContainer: getThemeColor(prefs, brightness, "onPrimaryContainer"),
    primaryFixed: getThemeColor(prefs, brightness, "primaryFixed"),
    primaryFixedDim: getThemeColor(prefs, brightness, "primaryFixedDim"),
    surface: getThemeColor(prefs, brightness, "surface"),
    onSurface: getThemeColor(prefs, brightness, "onSurface"),
    error: getThemeColor(prefs, brightness, "error"),
    shadow: getThemeColor(prefs, brightness, "shadow"),
  );
}
