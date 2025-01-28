import 'package:flutter/cupertino.dart';

import '../attention/find_the_number.dart';
import '../attention/long_term_concentration_video.dart';
import '../attention/reading/reading.dart';
import '../attention/short_term_concentration.dart';
import '../builders/correct_a_word_builder.dart';
import '../builders/grammar_mcq_builder.dart';
import '../builders/idioms_builder.dart';
import '../builders/listening_comprehension_builder.dart';
import '../builders/long_term_concentration_builder.dart';
import '../builders/riddle_of_the_day_builder.dart';
import '../builders/spelling_mistakes_builder.dart';
import '../builders/strong_concentration_builder.dart';
import '../builders/vocabulary_builder.dart';
import '../investing/menu.dart';
import '../level_instruction.dart';
import '../linguistic/hangman.dart';
import '../linguistic/poems_reading/main.dart';
import '../linguistic/reading_comprehension.dart';
import '../linguistic/scrabble.dart';
import '../linguistic/wordly.dart';
import '../logical_thinking/2048/game_2048.dart';
import '../logical_thinking/riddles.dart';
import '../logical_thinking/sudoku.dart';
import '../memory/faces.dart';
import '../memory/learning_words/memory_words.dart';
import '../memory/memory_game2.dart';
import '../memory/working_memory.dart';
import 'dart:math' as math;

import '../well_being/meditation/meditation_minutes.dart';
import '../well_being/memes.dart';
import '../well_being/self_reflection.dart';
import '../well_being/sport.dart';
import '../well_being/yoga.dart';

Widget activityMemory(BuildContext context) => LevelInstruction(
      "Learning Words",
      testTime: "7 minutes",
      exercise: "Memory",
      testRouteBuilder: MemoryWords.routeBuilder,
      testActivitiesDescription:
          "In this exercises you will be given 5 minutes to learn as many words as you can.",
      testScoreDescription:
          "You will be tested on both the words and their meaning.",
    );

Widget activityWorkingMemory(BuildContext context) => LevelInstruction(
      "Working Memory",
      testTime: "3 minutes",
      exercise: "WorkingMemory",
      testRouteBuilder: WorkingMemory.routeBuilder,
      testActivitiesDescription:
          "In this activity, we will test your short-term memory.",
      testScoreDescription:
          "You will need a piece of paper and something to write with.",
    );

Widget activityFindTheNumber(BuildContext context) => const FindTheNumber();

Widget activityListeningComprehension(BuildContext context) => LevelInstruction(
      "Listening Comprehension",
      testTime: "6 minute",
      exercise: "ListeningComprehensionVideo",
      nextRouteBuilder: listeningComprehensionBuilder(
          math.Random().nextInt(16), false, false),
      testRouteBuilder: (
        BuildContext context, {
        required bool initialTest,
        required bool endingTest,
      }) {
        return MemoryWords.routeBuilder(context,
            initialTest: initialTest, endingTest: endingTest);
      },
      testActivitiesDescription:
          "In this activity you will watch a 4-5 minutes video, which will be followed by a MCQ quiz.",
      testScoreDescription:
          "You will have no possibility to rewatch the video so we recommend you make notes.",
    );

Widget activityReadingComprehension(BuildContext context) =>
    const ReadingComprehension();

Widget activityPoemsReading(BuildContext context) => LevelInstruction(
      "Poems Reading",
      testTime: "1 minute",
      testRouteBuilder: Poems.routeBuilder,
      testActivitiesDescription:
          "In this activity, you can listen to a poem, read it aloud, and have your pronunciation checked 🙂.",
      testScoreDescription: "There is only one poem per day.",
    );
// const PoemsInfo(),

Widget activitySpellingMistakes(BuildContext context) => LevelInstruction(
      "Spelling Mistakes",
      testTime: "1 minute",
      exercise: "SpellingMistakes",
      nextRouteBuilder: spellingMistakesBuilder(
        context,
        initialTest: false,
        endingTest: false,
      ),
      testRouteBuilder: ShortTermConcentration.routeBuilder,
      testActivitiesDescription:
          "In this activity, we will test your short-term memory.",
      testScoreDescription:
          "You will need a piece of paper and something to write with.",
    );

Widget activityRiddlesTest(BuildContext context) => const RiddlesTest();

Widget activityRiddleOfTheDay(BuildContext context) => LevelInstruction(
      "Riddle Of The Day",
      testTime: "3 minutes",
      exercise: "RiddleOfTheDay",
      nextRouteBuilder:
          riddleOfTheDayBuilder(context, initialTest: false, endingTest: false),
      testRouteBuilder: RiddlesTest.routeBuilder,
      testActivitiesDescription:
          "In this section you will receive one harder riddle.",
      testScoreDescription: "You will have 24 hours to solve it.",
    );
// const RiddlesTest(),

Widget activitySudokuGame(BuildContext context) => const SudokuGame();

Widget activityShortTermConcentration(BuildContext context) => LevelInstruction(
      "Attention",
      testTime: "3 minutes",
      exercise: "ShortTermConcentration",
      testRouteBuilder: ShortTermConcentration.routeBuilder,
      testActivitiesDescription:
          "In this activity, we will test your short-term memory.",
      testScoreDescription:
          "You will need a piece of paper and something to write with.",
    );

Widget activityLongTermConcentrationVideo(BuildContext context) =>
    LevelInstruction(
      "Attention",
      testTime: "5 minutes",
      exercise: "LongTermConcentrationVideo",
      nextRouteBuilder:
          longTermConcentrationBuilder(math.Random().nextInt(13), false, false),
      testRouteBuilder: LongTermConcentrationVideo.routeBuilder,
      testActivitiesDescription:
          "In this activity you will watch a 4-5 minutes video, which will be followed by a MCQ quiz.",
      testScoreDescription:
          "You will have no possibility to rewatch the video so we recommend you make notes.",
    );

Widget activirtStrongConcentration(BuildContext context) => LevelInstruction(
      "Strong Concentration",
      testTime: "2 minutes",
      exercise: "StrongConcentrationDesc",
      nextRouteBuilder:
          strongConcentrationBuilder(initialTest: false, endingTest: false),
      testRouteBuilder: LongTermConcentrationVideo.routeBuilder,
      testActivitiesDescription:
          "In this exercise, you will have 2 minutes to solve as many math equations as possible while listening to music.",
      testScoreDescription: "You cannot use the calculator.",
    );

Widget activityReading(BuildContext context) => const Reading();

Widget activityHangman(BuildContext context) => const Hangman();

Widget activityWordly(BuildContext context) => const Wordly();

Widget activityGame2048(BuildContext context) => const Game2048();

Widget activityScrabble(BuildContext context) => const Scrabble(
      iteration: 1,
      allPoints: 0,
    );

Widget activityFaces(BuildContext context) => const Faces();

Widget activityCorrectAWord(BuildContext context) => LevelInstruction(
      "Correct A Word",
      testTime: "2 minutes",
      exercise: "SpellingMistakes",
      nextRouteBuilder: correctAWordBuilder(
        context,
        initialTest: false,
        endingTest: false,
      ),
      testRouteBuilder: MemoryGame2.routeBuilder,
      testActivitiesDescription:
          "In this activity you will be presented with different texts and your task will be to find one word which is misspelled and correct it.",
      testScoreDescription:
          "If you believe all the words are correct, leave the field empty.",
    );

Widget activityInvestingMenu(BuildContext context) => const InvestingMenu();

Widget activityGrammar(BuildContext context) => LevelInstruction(
      "Grammar",
      testTime: "1 minute",
      exercise: "Grammar",
      nextRouteBuilder: grammarMcqBuilder(
        context,
        initialTest: false,
        endingTest: false,
        exerciseId: 0,
      ),
      testRouteBuilder: MemoryGame2.routeBuilder,
      testActivitiesDescription:
          "In this activity, you should select the correct grammatical option to complete fill-in-the-blank sentences.",
      testScoreDescription:
          "The questions will match the level you picked at the beginning.",
    );

Widget activityVocabulary(BuildContext context) => LevelInstruction(
      "Vocabulary",
      testTime: "1 minute",
      exercise: "Vocabulary",
      nextRouteBuilder:
          vocabularyBuilder(context, initialTest: false, endingTest: false),
      testRouteBuilder: MemoryGame2.routeBuilder,
      testActivitiesDescription:
          "In this activity, you should select the best word to complete fill-in-the-blank sentences.",
      testScoreDescription:
          "The questions will match the level you picked at the beginning.",
    );

Widget activityIdioms(BuildContext context) => LevelInstruction(
      "Idioms",
      testTime: "1 minute",
      exercise: "Idioms",
      nextRouteBuilder:
          idiomsBuilder(context, initialTest: false, endingTest: false),
      testRouteBuilder: MemoryGame2.routeBuilder,
      testActivitiesDescription:
          "In this activity, you should select the best phrase to complete fill-in-the-blank sentences.",
      testScoreDescription:
          "The questions will match the level you picked at the beginning.",
    );

Widget activityMemoryGame(BuildContext context) => LevelInstruction(
      "Memory Game",
      testTime: "1 minute",
      testRouteBuilder: MemoryGame2.routeBuilder,
      testActivitiesDescription:
          "Match all pairs of cards by remembering their positions. Click to reveal a card, and try to find its match.",
      testScoreDescription: "Click “Start” when ready 🙂",
    );

Widget activitySport(BuildContext context) => Sport();
// LevelInstruction(
//   "Sport",
//   nextRouteBuilder: FutureBuilder(future: () async {} (),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return const Sport();
//       },),
//   testRouteBuilder: MemoryGame2.routeBuilder,
//   testActivitiesDescription: "Here is an example plan we created for you 🙂",
//   testScoreDescription: "Next update will introduce different plan choices.",
// ),

Widget activityYoga(BuildContext context) => const Yoga();

Widget activitySelfReflection(BuildContext context) => const SelfReflection();

Widget activityMeditation(BuildContext context) => LevelInstruction(
      "Meditation",
      testTime: "1-5 minutes",
      testRouteBuilder: MeditationMinutes.routeBuilder,
      testActivitiesDescription:
          "Let’s go 🥳\nBefore you begin, find a quiet place and get comfortable.",
      testScoreDescription:
          "You can sit on a cushion or chair, or even lie down if that's more comfortable for you.",
    );

Widget activityMeme(BuildContext context) => const Meme();
