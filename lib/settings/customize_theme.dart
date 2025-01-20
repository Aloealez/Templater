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
                BlockPicker(
                  pickerColor: getThemeColor(prefs, Theme.of(context).brightness, colorKey),
                  onColorChanged: (Color color) {
                    print("Color changed to $color");
                    setThemeColor(prefs, Theme.of(context).brightness, colorKey, color).then((obj) {
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
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoActionSheetAction(
              child: const Text('Reset'),
              onPressed: () {
                setThemeColor(prefs, Theme.of(context).brightness, colorKey, null).then((obj) {
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
            color: Color(0x4C4C4C64).withAlpha(137),
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
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: appBar(
        context,
        "Customise Colors",
      ),
      body: Center(
        child: FutureBuilder(
          future: prefsF,
          builder: (context, snapshot) {
            prefs = snapshot.data as SharedPreferences?;
            return Container(
              margin: EdgeInsets.only(
                left: size.width / 8,
                right: size.width / 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 30,
                children: [
                  _buildColorTile(
                    label: 'Background',
                    colorKey: "surface",
                  ),

                  _buildColorTile(
                    label: 'Primary',
                    colorKey: "primary",
                  ),

                  _buildColorTile(
                    label: 'Secondary',
                    colorKey: "secondary",
                  ),

                  _buildColorTile(
                    label: 'Accent',
                    colorKey: "tertiary",
                  ),

                  _buildColorTile(
                    label: 'Contrast',
                    colorKey: "primaryContainer",
                    textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
