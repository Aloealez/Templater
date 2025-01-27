import 'package:flutter/material.dart';
import '../score_n_progress/progress_screen.dart';
import '../../app_bar.dart';

class Faces extends StatefulWidget {
  const Faces({super.key});

  @override
  State<Faces> createState() => _Faces();
}

class _Faces extends State<Faces> {
  List<int> picked = [];
  double score = 0;
  List<int> seenPhotos = [];
  int currentPhoto = 0;
  double points = 0;

  @override
  void initState() {
    super.initState();

    List<int> allPhotos = List.generate(100, (index) => index);
    allPhotos.shuffle();
    for (int i = 0; i < 10; i++) {
      picked.add(allPhotos[i]);
      picked.add(allPhotos[i]);
    }
    picked.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: SingleChildScrollView(
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.9,
          margin: EdgeInsets.only(
            left: size.width / 10,
            right: size.width / 10,
          ),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Memory",
                      style: TextStyle(
                        fontSize: size.width / 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Center(
                    child: Text(
                      "Exercise 1 - Faces memory ",
                      style: TextStyle(fontSize: size.width / 20),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height / 15,
              ),
              Center(
                child: Text(
                  "Have you seen this face before?",
                  style: TextStyle(
                    fontSize: size.width / 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: size.height / 30,
              ),
              Container(
                width: 0.7 * size.width,
                height: 0.7 * size.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 15.0,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox.fromSize(
                    child: Image.asset(
                      'assets/memory/faces/${picked[currentPhoto]}.png',
                      fit: BoxFit.cover,
                      width: size.width * 0.75,
                      height: size.height * 0.5,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: size.width / 4,
                    height: size.height / 15,
                    child: FloatingActionButton(
                      backgroundColor: Theme.of(context).colorScheme.primaryFixedDim.withOpacity(0.3),
                      onPressed: () {
                        setState(() {
                          if (seenPhotos.contains(picked[currentPhoto])) {
                            points += 1;
                          } else {
                            points -= 0.5;
                          }
                          seenPhotos.add(picked[currentPhoto]);
                          if (seenPhotos.length == 20) {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProgressScreen(
                                  userScore: points,
                                  maxScore: 10,
                                  exercise: 'Faces',
                                ),
                              ),
                            );
                          } else {
                            ++currentPhoto;
                          }
                        });
                      },
                      heroTag: "yesButton", // Assign a unique tag
                      child: const Text(
                        "Yes",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width / 4,
                    height: size.height / 15,
                    child: FloatingActionButton(
                      backgroundColor: Theme.of(context).colorScheme.primaryFixedDim.withOpacity(0.3),
                      onPressed: () {
                        setState(() {
                          if (seenPhotos.contains(picked[currentPhoto])) {
                            points -= 0.5;
                          } else {
                            points += 1;
                          }
                          seenPhotos.add(picked[currentPhoto]);
                          if (seenPhotos.length == 20) {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProgressScreen(
                                  userScore: points,
                                  maxScore: 10,
                                  exercise: 'Faces',
                                ),
                              ),
                            );
                          } else {
                            ++currentPhoto;
                          }
                        });
                      },
                      heroTag: "noButton", // Assign a unique tag
                      child: const Text(
                        "No",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //Text(picked[currentPhoto].toString()),
              //Text(points.toString()),
              //Text(seenPhotos.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
