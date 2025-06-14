import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_bta_functions/flutter_bta_functions.dart';

class MemeData {
  static const MEMES_PER_DAY = 3;

  final int id;
  final String ext;
  final String url;
  final String name;

  MemeData({
    required this.id,
    required this.ext,
    required this.url,
    required this.name,
  });

  static MemeData fromJson(Map<String, dynamic> json) {
    return MemeData(
      id: json['id'],
      ext: json['ext'],
      url: json['url'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return   {
      'id': id,
      'ext': ext,
      'url': url,
      'name': name,
    };
  }

  static List<MemeData> fromJsonList(List<dynamic> json) {
    return json.map((meme) => MemeData.fromJson(meme)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<MemeData> memes) {
    return memes.map((meme) => meme.toJson()).toList();
  }

  static List<MemeData> fromResponse(http.Response response) {
    Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;
    return fromJsonList(json['memes'] as List<dynamic>);
  }

  static Future<List<MemeData>> updateTodayMemes(SharedPreferences prefs, memesPerDay, {BuildContext? context}) async {
    List<MemeData> memes = [];
    if (prefs.getString('memes_${DateFormat("YYYY-MM-DD").format(DateTime.now())}') != null) {
      memes = MemeData.fromJsonList(jsonDecode(prefs.getString('memes_${DateFormat("YYYY-MM-DD").format(DateTime.now())}')!) as List<dynamic>);
    } else {
      http.Response resp = await http.get(Uri.parse('https://www.dropbox.com/scl/fi/avdtl5ikd1lk6qoihpl95/memes_list.json?rlkey=tbj0ncxpm3rorn3gmtuno5yv5&st=tl1bdh62&dl=1'));
      List<MemeData> fetchedMemes = MemeData.fromResponse(resp);
      memes = getRandomElements(fetchedMemes, memesPerDay);
      await prefs.setString('memes_${DateFormat("YYYY-MM-DD").format(DateTime.now())}', jsonEncode(MemeData.toJsonList(memes)));
    }
    Future<List<dynamic>> memesCacheF = Future.wait(memes.map((meme) => () async {
      print("precache meme${context == null ? ", no build context specified, memes won't load" : ""}: ${meme.id}");
      if (context != null && context.mounted) {
        await precacheImage(
          NetworkImage(meme.url),
          context,
          onError: (error, stackTrace) {
            print('Meme failed to precache: $error');
          },
        ).then((_) async => print('Precached meme ${meme.id}'));
      }
    } (),
    ),);
    await memesCacheF;
    return memes;
  }
}
