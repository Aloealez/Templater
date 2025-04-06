import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_bar.dart';

class ReadingStreak extends StatefulWidget {
  const ReadingStreak({super.key});
  @override
  State<ReadingStreak> createState() => _ReadingStreak();
}

class _ReadingStreak extends State<ReadingStreak> {
  bool ticked = false;
  late SharedPreferences prefs;
  List<int?> streak = List<int?>.filled(31, null);
  int day = 0;
  int missed = 0, done = 0, future = 0;

  Future<void> calcDay() async {
    DateTime firstDay = DateTime.now();
    DateTime today = DateTime.now();
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('beginning_date') != null) {
      firstDay = DateTime.parse(prefs.getString('beginning_date')!);
    }

    setState(() {
      day = today.difference(firstDay).inDays + 1;
    });
  }

  Widget createDay(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: (streak[index] == 1)
            ? (Theme.of(context).brightness == Brightness.light)
                ? const Color.fromARGB(255, 94, 219, 98)
                : const Color.fromARGB(255, 3, 102, 0)
            : (index < day)
                ? (Theme.of(context).brightness == Brightness.light)
                    ? const Color.fromARGB(255, 253, 116, 106)
                    : const Color.fromARGB(255, 102, 0, 0)
                : Theme.of(context).colorScheme.primary.withOpacity(0.2),
      ),
      width: size.width / 8,
      height: size.width / 8,
      //color: Colors.grey[200],
      child: Center(
        child: Text(
          index.toString(),
          style: TextStyle(
            fontSize: size.width / 25,
            color: (Theme.of(context).brightness == Brightness.dark ||
                    index < day ||
                    (index == day && streak[index] == 1))
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }

  Future<void> readMemory() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 1; i <= 30; i++) {
        streak[i] = prefs.getInt('readingDay$i')?.toInt();
        if (streak[i] == 1) {
          done++;
        } else if (i < day) {
          missed++;
        } else {
          future++;
        }
      }
    });
  }

  Future<void> initMemory() async {
    await calcDay();
    await readMemory();
  }

  @override
  void initState() {
    super.initState();
    initMemory();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 10,
          right: size.width / 10,
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                "Your Reading Streak",
                style: TextStyle(
                  fontSize: size.width / 12,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: size.width / 10,
            ),
            Column(
              children: [
                for (int i = 0; i < 6; i++)
                  Row(
                    children: [
                      for (int j = 0; j < 5; j++)
                        Expanded(
                          child: Column(
                            children: [
                              createDay(context, 5 * i + j + 1),
                              SizedBox(
                                height: size.width / 30,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                SizedBox(
                  width: size.width / 30,
                ),
              ],
            ),
            SizedBox(
              height: size.width / 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (Theme.of(context).brightness == Brightness.light)
                        ? const Color.fromARGB(255, 94, 219, 98)
                        : const Color.fromARGB(255, 3, 102, 0),
                  ),
                  width: size.width / 8,
                  height: size.width / 8,
                  //color: Colors.grey[200],
                  child: Center(
                    child: Text(
                      done.toString(),
                      style: TextStyle(
                        fontSize: size.width / 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width / 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (Theme.of(context).brightness == Brightness.light)
                        ? const Color.fromARGB(255, 253, 116, 106)
                        : const Color.fromARGB(255, 102, 0, 0),
                  ),
                  width: size.width / 8,
                  height: size.width / 8,
                  //color: Colors.grey[200],
                  child: Center(
                    child: Text(
                      missed.toString(),
                      style: TextStyle(
                        fontSize: size.width / 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width / 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),
                  width: size.width / 8,
                  height: size.width / 8,
                  //color: Colors.grey[200],
                  child: Center(
                    child: Text(
                      future.toString(),
                      style: TextStyle(
                        fontSize: size.width / 25,
                        color: (Theme.of(context).brightness == Brightness.dark)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
