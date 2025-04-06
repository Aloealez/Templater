import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:brainace_pro/theme/theme_colors.dart';
import 'package:brainace_pro/well_being/meme_data.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'title_page.dart';
import 'package:flutter/services.dart';
import 'package:brainace_pro/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz/question_bank.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  // extend maximum size of cached images (WARNING - can take a looot of memory)
  PaintingBinding.instance.imageCache.maximumSize = 5000;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1000 * 1024 * 1024;

  final prefs = await SharedPreferences.getInstance();
  final int themeMode = prefs.getInt('themeMode') ?? 0;

  SatsQuestionBank satsQuestionBank = SatsQuestionBank();
  await satsQuestionBank.init();
  for (var subcategory in SatsQuestionSubcategories.typesList.sublist(0, 10)) {
    // questionBank.loadFromAssets(SatsQuestionSubcategories.fromString(subcategory), limit: 5);
    // questionBank.updateQuestionsFromBackend(SatsQuestionSubcategories.fromString(subcategory), limit: 5);
    satsQuestionBank.updateQuestions(SatsQuestionSubcategories.fromString(subcategory), limit: 2);
  }

  QuestionBank questionBank = QuestionBank();
  await questionBank.init();
  for (var subcategory in SatsQuestionSubcategories.typesList.sublist(10)) {
    questionBank.updateQuestions(subcategory, limit: 4);
  }

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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  List<ThemeMode> themes = [ThemeMode.dark, ThemeMode.light];
  int actTheme = 0;
  ThemeMode themeMode = ThemeMode.dark;
  SharedPreferences? prefs;
  Future<void>? precacheAllF;

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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      precacheAllF = precacheAll();
    }
  }

  Future<void> myAppPrecacheImage(String assetName) async {
    await precacheImage(
      AssetImage(assetName),
      context,
      onError: (error, stackTrace) {
        print('Image failed to load: $error');
      },
    ).then((_) async => print("Precached image $assetName"));
  }

  Future<void> precacheAll() async {
    for (String answer in ["A", "B", "C", "D"]) {
      myAppPrecacheImage("assets/icons/${answer.toLowerCase()}_filled.png");
    }
    for (String answer in ["A", "B", "C", "D"]) {
      myAppPrecacheImage("assets/icons/${answer.toLowerCase()}_outlined.png");
    }

    myAppPrecacheImage("assets/brain.png");
    myAppPrecacheImage("assets/help_icon_dark.png");
    myAppPrecacheImage("assets/help_icon_light.png");

    // precache setting images
    for (String settings in ["terms_of_use", "contact_us", "reset_the_app", "end_the_program", "our_website", "switch_theme", "customize_colors"]) {
      myAppPrecacheImage("assets/settings/$settings.png");
    }

    // navbar icons
    for (String navbar in ["activities", "analysis", "home", "progress", "settings"]) {
      myAppPrecacheImage("assets/navbar_icons/$navbar.png");
    }

    for (String improvementSelection in ["fun", "attention", "linguistic", "logical", "memory", "sats"]) {
      myAppPrecacheImage("assets/improvement_selection/${improvementSelection}_dark.png");
      myAppPrecacheImage("assets/improvement_selection/${improvementSelection}_light.png");
    }

    for (String satsSubcategory in SatsQuestionSubcategories.typesList) {
      myAppPrecacheImage("assets/sats/start_images/$satsSubcategory.png");
    }

    List<String> activitiesImages = [
      "2048.png",
      "Boundaries.png",
      "brain_train_section.png",
      "Central-Ideas-and-Details.png",
      "vocabulary.png",
      "Command-of-Evidence.png",
      "correct_a_word.png",
      "Cross-Text-Connections.png",
      "data_analysis.png",
      "faces_memory.png",
      "find_the_image.png",
      "find_the_number.png",
      "find_the_word.png",
      "Form-Structure-and-Sense.png",
      "good_deed.png",
      "grammar.png",
      "hangman.png",
      "idioms.png",
      "Inferences.png",
      "investing.png",
      "learning_course.png",
      "learning_words.png",
      "listening.png",
      "long_term_concentration.png",
      "math.png",
      "maths_section.png",
      "meditation.png",
      "memes.png",
      "memory_game.png",
      "poems.png",
      "reading.png",
      "reading_comprehension.png",
      "reading_out_loud.png",
      "reading_writing_section.png",
      "Rhetorical-Synthesis.png",
      "riddles.png",
      "riddle_of_the_day.png",
      "scrabble.png",
      "seaquance_backwards.png",
      "self_reflection.png",
      "short_term_concentration.png",
      "spelling.png",
      "sport.png",
      "strong_concentration.png",
      "sudoku.png",
      "Text-Structure-and-Purpose.png",
      "Transitions.png",
      "wordly.png",
      "Words-in-Context.png",
      "working_memory.png",
      "yoga.png",
    ];
    for (String activity in activitiesImages) {
      myAppPrecacheImage("assets/activities/$activity");
    }

    if (prefs != null) {
      MemeData.updateTodayMemes(prefs!, MemeData.MEMES_PER_DAY, context: context);
    }
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

    precacheAllF = precacheAll();

    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'BrainAce.pro',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: createLightColorScheme(prefs),
        useMaterial3: true,
        fontFamily: 'OpenSauceOne',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: createDarkColorScheme(prefs),
        useMaterial3: true,
        fontFamily: 'OpenSauceOne',
      ),
      themeMode: themeMode,
      home: const TitlePage(title: 'BrainAce.pro'),
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