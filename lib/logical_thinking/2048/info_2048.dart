import 'package:flutter/material.dart';
import '../../app_bar.dart';

class Info2048 extends StatefulWidget {
  const Info2048({super.key});
  @override
  State<Info2048> createState() => _Info2048();
}

class _Info2048 extends State<Info2048> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 15,
          right: size.width / 15,
          bottom: size.height / 10,
          top: size.height / 20,
        ),
        child: Text(
          "Swipe your finger to move the tiles on the board. When two tiles with the same number touch, they merge into one, doubling their value. Keep merging tiles to reach the 2048 tile. The game ends when no more moves are possible.",
          style: TextStyle(
            fontSize: 0.02 * size.height,
          ),
        ),
      ),
    );
  }
}
