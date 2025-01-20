import 'package:brainace_pro/buttons.dart';
import 'package:flutter/material.dart';

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
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 10,
          top: size.height / 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 0.02 * size.height),
              Padding(
                padding: EdgeInsets.only(
                  right: size.width / 10,
                ),
                child: Column(
                  children: [
                    Text(
                      "Choose",
                      style: TextStyle(
                        fontSize: size.width / 13,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Your Program",
                      style: TextStyle(
                        fontSize: size.width / 13,
                        fontWeight: FontWeight.w400,
                        color : Theme.of(context).colorScheme.onSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height / 20),
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
