import 'dart:async';

import 'package:flutter/material.dart';
import '../navbar.dart';

class MathComingSoon extends StatefulWidget {

  const MathComingSoon({
    super.key,
  });

  @override
  State<MathComingSoon> createState() => _MathComingSoon();
}

class _MathComingSoon extends State<MathComingSoon> {
  String fullText =
      '3.14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038196442881097566593344612847564823378678316527120190914564856692346034861045432664821339360726024914127372458700660631558817488152092096282925409171536436789259036001133053054882046652138414695194151160943305727036575959195309218611738193261179310511854807446237996274956735188575272489122793818301194912983367336244065664308602139494639522473719070217986094370277053921717629317675238467481846766940513200056812714526356082778577134275778960917363717872146844090122495343014654958537105079227968925892354201995611212902196086403441815981362977477130996051870721134999999837297804995105973173281609631859502445945534690830264252230825334468503526193118817101000313783875288658753320838142061717766914730359825349042875546873115956286388235378759375195778185778053217122680661300192787661119590921642019893809525720106548586327886593615338182796823030195203530185296899577362259941389124972177528347913151557485724245415069595082953311686172785588907509838175463746493931925506040092770167113900984882401285836160356370766010471018194';
  String visibleText = '';
  String fadingText = '';
  String lastText = '';
  int currentIndex = 0;
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        if (currentIndex < fullText.length) {
          visibleText += fullText[currentIndex];
          currentIndex++;
          if (visibleText.length > 5) {
            lastText += visibleText[0];
            visibleText = visibleText.substring(1);
          }
          opacity = 1.0;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 0.1 * size.height),
                Text(
                  "Coming Soon...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width / 15,
                    color: Colors.white,

                  ),
                ),
                SizedBox(height: 0.04 * size.height),
                SizedBox(height: 0.003 * size.height, width: size.width, child: Container(color: Theme.of(context).colorScheme.primary,)),
                SizedBox(height: 0.04 * size.height),
                Container(
                  margin: EdgeInsets.only(
                    left: size.width / 10,
                    right: size.width / 10,
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: AnimatedOpacity(
                          opacity: opacity,
                          duration: Duration(milliseconds: 500),
                          child: RichText(
                            text: TextSpan(
                              text: lastText,
                              style: TextStyle(
                                fontSize: size.height * 0.02,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                    text: visibleText,
                                    style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      color: Colors.white,
                                    ),
                                ),
                              ],
                              // textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const MyBottomNavigationBar(),
      );
    }
}
