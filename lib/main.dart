import 'package:brainace_pro/sats/start_sats_math.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:brainace_pro/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  final prefs = await SharedPreferences.getInstance();
  final int themeMode = prefs.getInt('themeMode') ?? 0;

  runApp(
    MyApp(themeMode: themeMode),
  );
}

class MyApp extends StatefulWidget{
  final int themeMode;

  const MyApp({super.key, required this.themeMode});

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  List<ThemeMode> themes = [ThemeMode.dark, ThemeMode.light];
  int actTheme = 0;
  ThemeMode themeMode = ThemeMode.dark;
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    actTheme = widget.themeMode;
    themeMode = themes[actTheme];
    SharedPreferences.getInstance().then((value) {
      setState(() {
        prefs = value;
      });
    });
  }

  Future<void> myAppPrecacheImage(String assetName) async {
    await precacheImage(
      AssetImage(assetName),
      context,
      onError: (error, stackTrace) {
        print('Image failed to load: $error');
      },
    ).then((_) async => print('Precached image $assetName'));
  }

  @override
  Widget build(BuildContext context) {
    if (prefs == null) {
      SharedPreferences.getInstance().then((value) {
        setState(() {
          prefs = value;
        });
      });
    }

    return MaterialApp(
      title: 'BrainAce.pro',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: createLightColorScheme(prefs),
        useMaterial3: true,
        fontFamily: 'SFPro',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: createDarkColorScheme(prefs),
        useMaterial3: true,
        fontFamily: 'SFPro',
        textTheme: TextTheme(
          bodySmall: TextStyle(fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      themeMode: themeMode,
      home: StartSatsMath(),
    );
  }

  void switchTheme() {
    setState(
          () {
        actTheme = (actTheme + 1) % themes.length;
        themeMode = themes[actTheme];
        saveTheme(actTheme);
      },
    );
  }

  void reloadTheme() {
    setState(() {
      themeMode = themes[actTheme];
    });
  }

  Future<void> saveTheme(themeMode) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs!.setInt('themeMode', themeMode);
  }
}