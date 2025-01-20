import 'dart:math' as math;

import 'package:brainace_pro/well_being/meme_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brainace_pro/app_bar.dart';


class Meme extends StatefulWidget {
  const Meme({super.key});

  @override
  _MemeState createState() => _MemeState();
}

class _MemeState extends State<Meme> with WidgetsBindingObserver {
  SharedPreferences? prefs;

  int currentMeme = 0;
  Set<String> seenMemes = {};
  List<MemeData> memes = [];
  Future<void>? memesF;

  Future<void> updateMemesList() async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) {
      memes = await MemeData.updateTodayMemes(prefs!, MemeData.MEMES_PER_DAY, context: context);
    }
    print("Memes: ${memes.map((e) => e.id)}");
  }

  @override
  void initState() {
    memesF = updateMemesList();
    super.initState();
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
    print("State: $state");
    if (state == AppLifecycleState.resumed) {
      memesF = updateMemesList();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding memes...");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: FutureBuilder(
        future: memesF,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || memesF == null || memes.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!seenMemes.contains(currentMeme.toString())) {
            seenMemes.add(currentMeme.toString());
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Warning",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryFixedDim,
                      fontSize: size.width / 15,
                    ),),
                SizedBox(height: size.height * 0.010),
                Text(
                  "${MemeData.MEMES_PER_DAY - seenMemes.length} ${MemeData.MEMES_PER_DAY - seenMemes.length == 1 ? "meme" : "memes"} left for today",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: size.width / 25,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                SizedBox(
                  width: size.width,
                  height: size.height * 0.003,
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryFixedDim,
                  ),
                ),
                // Image.asset("assets/memes/$currentMeme.png"),
                Image.network(memes[currentMeme].url),
                SizedBox(
                  width: size.width,
                  height: size.height * 0.003,
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryFixedDim,
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentMeme = math.max(0, currentMeme - 1);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryFixedDim.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.all(12),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: size.width * 0.06),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentMeme = math.min(MemeData.MEMES_PER_DAY - 1, currentMeme + 1);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryFixedDim.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.all(12),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
