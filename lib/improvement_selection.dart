import 'package:brainace_pro/buttons.dart';
import 'package:flutter/material.dart';

import 'app_bar.dart';

class ImprovementSelection extends StatefulWidget {
  const ImprovementSelection({super.key});

  @override
  State<ImprovementSelection> createState() => _ImprovementSelectionState();
}

class _ImprovementSelectionState extends State<ImprovementSelection> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 10,
          top: size.height / 69,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  right: size.width / 10,
                ),
                child: Column(
                  children: [
                    Text(
                      "Choose",
                      style: TextStyle(
                        fontSize: size.width / 10,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Your Program",
                      style: TextStyle(
                        fontSize: size.width / 11,
                        fontWeight: FontWeight.w500,
                        color : Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.06),
              ImprovementButton(
                text: "SATs Prep",
                width: size.width,
                color: Theme.of(context).colorScheme.tertiary,
                img: (Theme.of(context).brightness == Brightness.light)
                    ? "sats_light.png"
                    : "sats_dark.png",
                name: "sats",
              ),
              SizedBox(height: size.height / 40),
              ImprovementButton(
                text: "Memory",
                width: size.width,
                color: Theme.of(context).colorScheme.secondary,
                img: (Theme.of(context).brightness == Brightness.light)
                    ? "memory_light.png"
                    : "memory_dark.png",
                name: "memory",
              ),
              SizedBox(height: size.height / 40),
              ImprovementButton(
                text: "Attention",
                width: size.width,
                color: Theme.of(context).colorScheme.secondary,
                img: (Theme.of(context).brightness == Brightness.light)
                    ? "attention_light.png"
                    : "attention_dark.png",
                name: "attention",
              ),
              SizedBox(height: size.height / 40),
              ImprovementButton(
                text: "Linguistic",
                width: size.width,
                color: Theme.of(context).colorScheme.secondary,
                img: (Theme.of(context).brightness == Brightness.light)
                    ? "linguistic_light.png"
                    : "linguistic_dark.png",
                name: "linguistic",
              ),
              SizedBox(height: size.height / 40),
              ImprovementButton(
                text: "Logical Thinking",
                width: size.width,
                color: Theme.of(context).colorScheme.secondary,
                img: (Theme.of(context).brightness == Brightness.light)
                    ? "logical_light.png"
                    : "logical_dark.png",
                name: "logical",
              ),
              SizedBox(height: size.height / 40),
              ImprovementButton(
                text: "Just fun",
                width: size.width,
                color: Theme.of(context).colorScheme.secondary,
                img: (Theme.of(context).brightness == Brightness.light)
                    ? "fun_light.png"
                    : "fun_dark.png",
                name: "games",
              ),
              SizedBox(height: size.height / 40),
            ],
          ),
        ),
      ),
    );
  }
}
