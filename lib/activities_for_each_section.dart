import 'package:brainace_pro/activities/start_activity.dart';
import 'package:brainace_pro/attention/long_term_concentration_video.dart';
import 'package:brainace_pro/builders/idioms_builder.dart';
import 'package:brainace_pro/investing/menu.dart';
import 'package:brainace_pro/linguistic/hangman.dart';
import 'package:brainace_pro/linguistic/listening_comprehension_video.dart';
import 'package:brainace_pro/linguistic/wordly.dart';
import 'package:brainace_pro/memory/faces.dart';
import 'package:brainace_pro/memory/memory_game1.dart';
import 'package:brainace_pro/memory/working_memory.dart';
import 'package:brainace_pro/attention/reading/reading.dart';
import 'package:brainace_pro/linguistic/scrabble.dart';
import 'package:brainace_pro/logical_thinking/sudoku.dart';
import 'package:brainace_pro/logical_thinking/2048/game_2048.dart';
import 'package:brainace_pro/sats/start_sats_math.dart';
import 'package:brainace_pro/sats/start_sats_quiz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:brainace_pro/well_being/meditation/meditation_minutes.dart';
import 'package:brainace_pro/well_being/memes.dart';
import 'package:brainace_pro/well_being/sport.dart';
import 'package:brainace_pro/well_being/yoga.dart';
import 'package:brainace_pro/attention/short_term_concentration.dart';
import 'package:brainace_pro/attention/find_the_number.dart';
import 'package:brainace_pro/linguistic/poems_reading/poems_info.dart';
import 'package:brainace_pro/linguistic/reading_comprehension.dart';
import 'package:brainace_pro/logical_thinking/riddles_info.dart';
import 'package:brainace_pro/memory/learning_words/memory.dart';

import 'builders/grammar_mcq_builder.dart';
import 'builders/correct_a_word_builder.dart';
import 'builders/riddle_of_the_day_builder.dart';
import 'builders/strong_concentration_builder.dart';
import 'builders/vocabulary_builder.dart';

var memoryBaseList = [
  [Memory, "Memory", 10],
  [WorkingMemory, "WorkingMemory", 5],
  [MemoryGame1, "MemoryGame1", 5],
  [Faces, "Faces", 5],
  [LongTermConcentrationVideo, "LongTermConcentrationVideo", 10],
];


var memoryAllList = [
  'Memory',
  'WorkingMemory',
  'MemoryGame1',
  'Faces',
  'LongTermConcentrationVideo',
  'InvestingMenu',
  'Reading',
  'Scrabble',
  'Hangman',
  'SudokuGame',
  'Wordly',
  'Game2048',
  'Meditation',
  'Meme',
  'Sport',
  'Yoga',
  'FindTheNumber',
];

var attentionBaseList = [
  [strongConcentrationBuilder, "StrongConcentrationDesc", 5],
  [ShortTermConcentration, "ShortTermConcentration", 5],
  [LongTermConcentrationVideo, "LongTermConcentrationVideo", 10],
  [Memory, "Memory", 10],
  [MemoryGame1, "MemoryGame1", 5],
  [FindTheNumber, "FindTheNumber", 5],
];

var attentionAllList = [
  'StrongConcentrationDesc',
  'ShortTermConcentration',
  'LongTermConcentrationVideo',
  'Memory',
  'MemoryGame1',
  'FindTheNumber',
  'Reading',
  'Scrabble',
  'Hangman',
  'SudokuGame',
  'Wordly',
  'Game2048',
  'InvestingMenu',
  'Meditation',
  'Meme',
  'Sport',
  'Yoga',
];

var linguisticBaseList = [
  [Memory, "Memory", 10],
  [PoemsInfo, "PoemsInfo", 5],
  [ReadingComprehension, "ReadingComprehension", 10],
  [ListeningComprehensionVideo, "ListeningComprehensionVideo", 10],
  [0, "SpellingMistakes", 5],
  // [const SpellingMistakes(exerciseId: 0), "SpellingMistakes", 5],
  [correctAWordBuilder, "CorrectAWord", 5],
  [grammarMcqBuilder, "Grammar", 5],
  [0, "SpellingMistakes", 5],
  // [const SpellingMistakes(exerciseId: 0), "SpellingMistakes", 5],
  [vocabularyBuilder, "Vocabulary", 5],
  [idiomsBuilder, "Idioms", 5],
  [const Scrabble(iteration: 1, allPoints: 0), "Scrabble", 5],
  [const Hangman(), "Hangman", 5],
  [const Wordly(), "Wordly", 5],
];


var linguisticAllList = [
  'Memory',
  'PoemsInfo',
  'ReadingComprehension',
  'ListeningComprehensionVideo',
  'SpellingMistakes',
  'CorrectAWord',
  'Grammar',
  'SpellingMistakes',
  'Vocabulary',
  'Idioms',
  'Scrabble',
  'Hangman',
  'Wordly',
  'Reading',
  'SudokuGame',
  'Game2048',
  'InvestingMenu',
  'Meditation',
  'Meme',
  'Sport',
  'Yoga',
  'InvestingMenu',
  'FindTheNumber',
];

var logicalBaseList = [
  [strongConcentrationBuilder, "StrongConcentrationDesc", 5],
  [const Riddles(), "Riddles", 10],
  [riddleOfTheDayBuilder, "RiddleOfTheDay", 3],
  [const Game2048(), "Game2048", 5],
  [const SudokuGame(), "SudokuGame", 10],
  [const InvestingMenu(), "InvestingMenu", 15],
];

var logicalAllList = [
  'StrongConcentrationDesc',
  'Riddles',
  'RiddleOfTheDay',
  'Game2048',
  'SudokuGame',
  'Scrabble',
  'Hangman',
  'Wordly',
  'MemoryGame1',
  'Reading',
  'Meditation',
  'Meme',
  'Sport',
  'Yoga',
  'InvestingMenu',
  'FindTheNumber',
];

var gamesBaseList = [
  [const Scrabble(iteration: 1, allPoints: 0), "Scrabble", 5],
  [const Hangman(), "Hangman", 5],
  [const Wordly(), "Wordly", 5],
  [const Game2048(), "Game2048", 5],
  [const SudokuGame(), "SudokuGame", 5],
  [const FindTheNumber(), "FindTheNumber", 5],
  [MemoryGame1, "MemoryGame1", 5],
];

var gamesAllList = [
  'Scrabble',
  'Hangman',
  'Wordly',
  'Game2048',
  'SudokuGame',
  'FindTheNumber',
  'MemoryGame1',
  'Reading',
  'PoemsInfo',
  'Meditation',
  'Meme',
  'Sport',
  'Yoga',
];

var satsBaseList = [
  [Memory, "Memory", 10],
  [WorkingMemory, "WorkingMemory", 5],
  [MemoryGame1, "MemoryGame1", 5],
  [Faces, "Faces", 5],
  [LongTermConcentrationVideo, "LongTermConcentrationVideo", 10],
  [strongConcentrationBuilder, "StrongConcentrationDesc", 5],
  [ShortTermConcentration, "ShortTermConcentration", 5],
  [FindTheNumber, "FindTheNumber", 5],
  [PoemsInfo, "PoemsInfo", 5],
  [ReadingComprehension, "ReadingComprehension", 10],
  [ListeningComprehensionVideo, "ListeningComprehensionVideo", 10],
  [0, "SpellingMistakes", 5],
  // [const SpellingMistakes(exerciseId: 0), "SpellingMistakes", 5],
  [correctAWordBuilder, "CorrectAWord", 5],
  [grammarMcqBuilder, "Grammar", 5],
  [0, "SpellingMistakes", 5],
  // [const SpellingMistakes(exerciseId: 0), "SpellingMistakes", 5],
  [vocabularyBuilder, "Vocabulary", 5],
  [idiomsBuilder, "Idioms", 5],
  [const Scrabble(iteration: 1, allPoints: 0), "Scrabble", 5],
  [const Hangman(), "Hangman", 5],
  [const Wordly(), "Wordly", 5],
  [const Riddles(), "Riddles", 10],
  [riddleOfTheDayBuilder, "RiddleOfTheDay", 3],
  [const Game2048(), "Game2048", 5],
  [const SudokuGame(), "SudokuGame", 10],
  [const InvestingMenu(), "InvestingMenu", 15],
  [const FindTheNumber(), "FindTheNumber", 5],
];

var satsAllList = [
  'Memory',
  'WorkingMemory',
  'MemoryGame1',
  'Faces',
  'LongTermConcentrationVideo',
  'StrongConcentrationDesc',
  'ShortTermConcentration',
  'FindTheNumber',
  'PoemsInfo',
  'ReadingComprehension',
  'ListeningComprehensionVideo',
  'SpellingMistakes',
  'CorrectAWord',
  'Grammar',
  'SpellingMistakes',
  'Vocabulary',
  'Idioms',
  'Scrabble',
  'Hangman',
  'Wordly',
  'Riddles',
  'RiddleOfTheDay',
  'Game2048',
  'SudokuGame',
  'InvestingMenu',
  'Reading',
  'Meditation',
  'Meme',
  'Sport',
  'Yoga',
];

var skillBaseLists = {
  'memory': memoryBaseList,
  'attention': attentionBaseList,
  'linguistic': linguisticBaseList,
  'logical': logicalBaseList,
  'games': gamesBaseList,
  // 'sats': SatsQuestionTypesRW.typesList,
  'sats': satsBaseList,
};

var skillAllLists = {
  'memory': memoryAllList,
  'attention': attentionAllList,
  'linguistic': linguisticAllList,
  'logical': logicalAllList,
  'games': gamesAllList,
  // 'sats': SatsQuestionTypesRW.typesList,
  'sats': satsAllList,
};

var sectionTimes = {
  'Memory': 10,
  'WorkingMemory': 5,
  'MemoryGame1': 5,
  'Faces': 5,
  'LongTermConcentrationVideo': 10,
  'StrongConcentrationDesc': 5,
  'ShortTermConcentration': 5,
  'FindTheNumber': 5,
  'PoemsInfo': 5,
  'ReadingComprehension': 10,
  'ListeningComprehensionVideo': 10,
  'SpellingMistakes': 5,
  'CorrectAWord': 5,
  'Grammar': 5,
  'Vocabulary': 5,
  'Idioms': 5,
  'Scrabble': 5,
  'Hangman': 5,
  'Wordly': 5,
  'Riddles': 10,
  'RiddleOfTheDay': 3,
  'Game2048': 5,
  'SudokuGame': 10,
  'InvestingMenu': 15,
  for (var type in SatsQuestionSubcategories.typesList) type: 5, // we give 1 minute for each SATs question (on average)
};

var sectionNames = {
  'Memory': 'Learning words',
  'Faces': 'Faces Memory',
  'LongTermConcentrationVideo': 'Long Term Concentration',
  'StrongConcentrationDesc': 'Strong Concentration',
  'ShortTermConcentration': 'Short Term Concentration',
  'FindTheNumber': 'Find The Number',
  'PoemsInfo': 'Poem reading',
  'ReadingComprehension': 'Reading Comprehension',
  'ListeningComprehensionVideo': 'Listening Comprehension',
  'SpellingMistakes': 'Spelling Mistakes',
  'CorrectAWord': 'Correct a Word',
  'Grammar': 'Grammar',
  'Vocabulary': 'Choose Best Word',
  'Idioms': 'Idioms, expressions and phrasal verbs',
  'Scrabble': 'Like Scrabble',
  'Hangman': 'Hangman',
  'Wordly': 'Wordly',
  'Riddles': 'Riddles',
  'RiddleOfTheDay': 'Riddle Of The Day',
  'Game2048': '2048',
  'SudokuGame': 'Sudoku',
  'WorkingMemory': 'Working memory',
  'MemoryGame1': 'Memory Game',
  'InvestingMenu': 'Short Learning Course',
  for (var type in SatsQuestionSubcategories.typesList) type: SatsQuestionSubcategories.fromString(type).getName(),
};

Map<String, Widget Function(BuildContext)> sectionActivities = {
  'Memory': activityMemory,
  'Faces': activityFaces,
  'LongTermConcentrationVideo': activityLongTermConcentrationVideo,
  'StrongConcentrationDesc': activirtStrongConcentration,
  'ShortTermConcentration': activityShortTermConcentration,
  'FindTheNumber': activityFindTheNumber,
  'PoemsInfo': activityPoemsReading,
  'ReadingComprehension': activityReadingComprehension,
  'Reading': activityReading,
  'ListeningComprehensionVideo': activityListeningComprehension,
  'SpellingMistakes': activitySpellingMistakes,
  'CorrectAWord': activityCorrectAWord,
  'Grammar': activityGrammar,
  'Vocabulary': activityVocabulary,
  'Idioms': activityIdioms,
  'Scrabble': activityScrabble,
  'Hangman': activityHangman,
  'Wordly': activityWordly,
  'Riddles': activityRiddlesTest,
  'RiddleOfTheDay': activityRiddleOfTheDay,
  'Game2048': activityGame2048,
  'SudokuGame': activitySudokuGame,
  'WorkingMemory': activityWorkingMemory,
  'MemoryGame1': activityMemoryGame,
  'InvestingMenu': activityInvestingMenu,

  // for (var type in SatsQuestionSubcategories.typesList) type: SatsQuestionSubcategories.fromString(type).getName(),
  for (var type in SatsQuestionSubcategories.typesList.sublist(0, 10)) type: (context) => StartSatsQuiz(subcategory: SatsQuestionSubcategories.fromString(type)),
  for (var type in SatsQuestionSubcategories.typesList.sublist(10)) type: (context) => StartSatsMath(subcategory: SatsQuestionSubcategories.fromString(type)),

  'Sport' : activitySport,
  'Yoga' : activityYoga,
  'SelfReflection' : activitySelfReflection,
  'Outdoor time' : activityMeme,
  'Meditation' : activityMeditation,
  'Meme' : activityMeme,
} ;

var wellbeing = [
  'Sport / Yoga',
  'Self reflection',
  'Outdoor time',
  'Meditation',
];

var wellbeingTimes = {
  'Sport / Yoga': 4,
  'Self reflection': 2,
  'Outdoor time': 2,
  'Meditation': 2,
};
