import 'package:brainace_pro/app_bar.dart';
import 'package:brainace_pro/main.dart';
import 'package:brainace_pro/theme/theme_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomizeTheme extends StatefulWidget {
  const CustomizeTheme({super.key});

  @override
  State<CustomizeTheme> createState() => _CustomizeThemeState();
}

class _CustomizeThemeState extends State<CustomizeTheme> {
  SharedPreferences? prefs;
  Future<void> prefsF = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
  }

  void _showCupertinoColorPicker(String colorKey) {
    Size size = MediaQuery.of(context).size;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Select a color'),
          message: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorPicker(
                  pickerColor: getThemeColor(
                      prefs, Theme.of(context).brightness, colorKey,),
                  onColorChanged: (Color color) {
                    print("Color changed to $color");
                    setThemeColor(
                        prefs, Theme.of(context).brightness, colorKey, color,)
                        .then((obj) {
                      if (context.mounted) {
                        MyApp.of(context).reloadTheme();
                      }
                    });
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: size.width * 0.064,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoActionSheetAction(
              child: Text(
                'Reset',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: size.width * 0.064,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                setThemeColor(
                    prefs, Theme.of(context).brightness, colorKey, null,)
                    .then((obj) {
                  Navigator.of(context).pop();
                  if (context.mounted) {
                    MyApp.of(context).reloadTheme();
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildColorTile({
    required String label,
    required String colorKey,
    Color? textColor,
  }) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 0.11 * size.height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: getThemeColor(prefs, Theme.of(context).brightness, colorKey),
        boxShadow: [
          BoxShadow(
            color: const Color(0x4C4C4C64).withAlpha(137),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _showCupertinoColorPicker(colorKey);
        },
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor ?? Theme.of(context).colorScheme.onPrimary,
              fontSize: size.width * 0.051,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }


  Future<void> resetToDefaultColors() async {
    if (prefs != null) {
      final brightness = Theme.of(context).brightness;
      await setThemeColor(prefs, brightness, "surface", null);
      await setThemeColor(prefs, brightness, "primary", null);
      await setThemeColor(prefs, brightness, "secondary", null);
      await setThemeColor(prefs, brightness, "tertiary", null);
      await setThemeColor(prefs, brightness, "primaryContainer", null);
      if (context.mounted) {
        MyApp.of(context).reloadTheme();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: appBar(context, "Customise Colors"),
      body: Padding(
        padding: EdgeInsets.only(left: size.width / 10, right: size.width / 10, top : size.height / 20),
        child: Column(
          children: [
            _buildColorTile(
              label: 'Background',
              colorKey: "surface",
              textColor: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 30),
            _buildColorTile(
              label: 'Primary',
              colorKey: "primary",
            ),
            const SizedBox(height: 30),
            _buildColorTile(
              label: 'Secondary',
              colorKey: "secondary",
            ),
            const SizedBox(height: 30),
            _buildColorTile(
              label: 'Accent',
              colorKey: "tertiary",
            ),
            const SizedBox(height: 30),
            _buildColorTile(
              label: 'Contrast',
              colorKey: "primaryContainer",
              textColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            // Spacer will push the button to the vertical center of any remaining space.
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: resetToDefaultColors,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  'Reset to Default Colors',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF7D509F),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
