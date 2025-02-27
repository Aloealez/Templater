import 'dart:convert';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> getAssets(String path) async {
  if (!path.endsWith('/'))
    {
      path += '/';
    }
  final AssetManifest assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  List<String> assets = filterAssets(assetManifest.listAssets(), path);
  for (int i = 0; i < assets.length; ++i) {
    assets[i] = assets[i].substring(path.length);
  }
  return assets;
}

List<String> filterAssets(List<String> assets, String path) {
  List<String> filteredAssets = [];
  for (String asset in assets) {
    if (asset.startsWith(path)) {
      filteredAssets.add(asset);
    }
  }
  return filteredAssets;
}

class QuestionBank {
  static const String serverHost = "185.189.136.11";
  static const int serverPort = 11537;
  static const String questionAssetPath = "assets/ques";

  late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<List<String>> assetQuestionList(
      String questionSubcategory,
      ) async {
    List<String> assets = await getAssets('$questionAssetPath/${questionSubcategory}');
    print("Assets: $assets");
    return assets;
  }

  Future<void> loadFromAssets(
      String questionSubcategory, {
        int? limit,
      }) async {
    // try {
      List<String> questionIds = await assetQuestionList(questionSubcategory);
      List<String> savedQuestionIds = getSavedQuestionIds(questionSubcategory);
      print("QuestionIds: $questionIds");
      int updatedCount = 0;
      for (String id in questionIds) {
        if (savedQuestionIds.contains(id)) {
          continue;
        }
        String questionStr = await rootBundle.loadString('$questionAssetPath/${questionSubcategory}/$id', cache: false);
        QuizQuestionData question = QuizQuestionData.fromJsonDifficulty(jsonDecode(questionStr), SatsQuestionDifficulty.difficultyEasy);
        // question.subcategory = questionSubcategory;
        await setSavedQuestion(question, questionSubcategory, id);
        savedQuestionIds.add(id);
        if (limit != null && ++updatedCount >= limit) {
          break;
        }
      }
      await setSavedQuestionIds(questionSubcategory, savedQuestionIds);
    // } catch (error) {
    //   print("loadFromAssets(${questionSubcategory}) error: $error");
    // }
  }

  Future<List<String>?> getQuestionListFromBackend(
      String questionSubcategory,
      ) async {
    try {
      Response response = await get(
        Uri(scheme: 'http', host: serverHost, port: serverPort),
        headers: {
          "brainace": ".pro",
          "data-type": "question-list",
          "subcategory": questionSubcategory,
        },
      ).timeout(Duration(seconds: 5));
      if (response.body == "") {
        return null;
      }
      List<String> questionIds = response.body.split(",,");
      return questionIds.isEmpty ? null : questionIds;
    } catch (error) {
      print("getQuestionListFromBackend(${questionSubcategory}) error: $error");
      return null;
    }
  }

  Future<QuizQuestionData?> getQuestionFromBackend(
      String questionSubcategory,
      String id,
      ) async {
    try {
      Response response = await get(
        Uri(scheme: 'http', host: serverHost, port: serverPort),
        headers: {
          "brainace": ".pro",
          "data-type": "question-get",
          "subcategory": questionSubcategory,
          "question-id": id,
        },
      );
      // print("Question $id: ${response.body}");
      if (response.body == "") {
        return null;
      }
      QuizQuestionData question = QuizQuestionData.fromJsonDifficulty(jsonDecode(response.body), SatsQuestionDifficulty.fromContainingString(id));
      // question.subcategory = questionSubcategory;
      return question;
    } catch (error) {
      print("getQuestionFromBackend(${questionSubcategory}) error: $error");
      return null;
    }
  }

  List<String> getSavedQuestionIds(
      String questionSubcategory,
      ) {
    String questionIds = prefs.getString('questionsnew_${questionSubcategory}_list') ?? "";
    return questionIds == "" ? [] : questionIds.split(",,");
  }

  Future<void> setSavedQuestionIds(String questionSubcategory, List<String> questionIds) async {
    await prefs.setString('questionsnew_${questionSubcategory}_list', questionIds.join(",,"));
  }

  List<String> getUsedQuestionsIds(String questionSubcategory) {
    if (prefs.getString('questionsnew_${questionSubcategory}_used') == null) {
      return [];
    }
    return prefs.getString('questionsnew_${questionSubcategory}_used')!.split(",,");
  }

  Future<void> setUsedQuestionsIds(String questionSubcategory, List<String> usedQuestionIds) async {
    await prefs.setString('questionsnew_${questionSubcategory}_used', usedQuestionIds.join(",,"));
  }

  Future<void> setSavedQuestion(
      QuizQuestionData question,
      String questionSubcategory,
      String questionID,
      ) async {
    await prefs.setString('questionsnew_${questionSubcategory}_$questionID', question.toJson());
  }

  QuizQuestionData? getSavedQuestion(
      String questionSubcategory,
      String questionID,
      ) {
    String? savedQuestion = prefs.getString('questionsnew_${questionSubcategory}_$questionID');
    if (savedQuestion == null) {
      return null;
    }
    return QuizQuestionData.fromJson(jsonDecode(savedQuestion));
  }

  Future<bool> updateQuestionsFromBackend(
      String questionSubcategory, {
        int? limit,
      }) async {
    List<String>? fetchedQuestionIdList = await getQuestionListFromBackend(questionSubcategory);
    if (fetchedQuestionIdList == null) {
      return false;
    }
    List<String> savedQuestionIds = getSavedQuestionIds(questionSubcategory);

    int updatedCount = 0;
    for (String id in fetchedQuestionIdList) {
      if (savedQuestionIds.contains(id)) {
        continue;
      }
      QuizQuestionData? question = await getQuestionFromBackend(questionSubcategory, id);
      if (question == null) {
        continue;
      }
      await setSavedQuestion(question, questionSubcategory, id);
      savedQuestionIds.add(id);
      if (limit != null && ++updatedCount >= limit) {
        break;
      }
    }
    await setSavedQuestionIds(questionSubcategory, savedQuestionIds);
    // } catch (e) {
    //   print("Failed to update questions: $e");
    // }
    return true;
  }

  Future<bool> updateQuestions(
      String questionSubcategory, {
        int? limit,
      }) async {
    print("Updating questions for ${questionSubcategory}.");
    await loadFromAssets(questionSubcategory, limit: limit);
    return await updateQuestionsFromBackend(questionSubcategory, limit: limit);
  }

  Future<Map<String, QuizQuestionData>> getQuestions(
      String questionSubcategory,
      int limit,
      bool markAsUsed,
      bool avoidUsed, {
        SatsQuestionDifficulty? difficulty,
      }) async {
    List<String> questionIds = getSavedQuestionIds(questionSubcategory);
    if (questionIds.isEmpty) {
      return {};
    }
    List<String> usedQuestionIds = getUsedQuestionsIds(questionSubcategory);
    // print("QuestionIds: $questionIds");
    // print("UsedQuestionIds: $usedQuestionIds");

    Map<String, QuizQuestionData> questions = {};
    for (var id in questionIds) {
      if (questions.length >= limit) {
        break;
      }
      if (usedQuestionIds.length >= questionIds.length) {
        usedQuestionIds = [];
      }
      if (avoidUsed && usedQuestionIds.contains(id)) {
        continue;
      }
      QuizQuestionData? question = getSavedQuestion(questionSubcategory, id);
      if (question == null) {
        continue;
      }
      if (difficulty != null && question.difficulty != difficulty) {
        continue;
      }
      questions[id] = question;
      if (markAsUsed) {
        usedQuestionIds.add(id);
      }
    }
    if (markAsUsed) {
      await setUsedQuestionsIds(questionSubcategory, usedQuestionIds);
    }
    if (questions.length < limit) {
      print("Using questions from other difficulty levels. ${questionSubcategory}");
      questions.addAll(await getQuestions(questionSubcategory, limit - questions.length, markAsUsed, avoidUsed));
    }
    return questions;
  }

  Future<void> reportQuestion(
      String questionSubcategory,
      String questionID,
      ) async {
    await post(Uri(scheme: 'http', host: serverHost, port: serverPort),
      headers: {
        "brainace": ".pro",
        "data-type": "question-report",
        "subcategory": questionSubcategory,
        "question-id": questionID,
      },
    );
  }
}
