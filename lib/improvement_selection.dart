import 'package:brainace_pro/buttons.dart';
import 'package:brainace_pro/margins.dart';
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
      appBar: appBar(context, ''),
      body: SingleChildScrollView(
        child: Container(
          margin: activitiesMargins(size),
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  Text(
                    'Choose',
                    style: TextStyle(
                      fontSize: size.width / 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Your Program',
                    style: TextStyle(
                      fontSize: size.width / 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 0.7,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.0792),
              ImprovementButton(
                text: '📚 SATs Prep',
                width: size.width,
                color: Theme.of(context).colorScheme.tertiary,
                name: 'sats',
              ),
              SizedBox(height: size.height / 30),
              ImprovementButton(
                text: '🧠 Memory',
                width: size.width,
                color: Theme.of(context).colorScheme.secondary,
                name: 'memory',
              ),
              SizedBox(height: size.height / 30),
              ImprovementButton(
                text: '💡 Attention',
                width: size.width,
                color: Theme.of(context).colorScheme.secondary,
                name: 'attention',
              ),
              SizedBox(height: size.height / 30),
              ImprovementButton(
                text: '💬 Linguistic',
                width: size.width,
                color: Theme.of(context).colorScheme.secondary,
                name: 'linguistic',
              ),
              SizedBox(height: size.height / 30),
              ImprovementButton(
                text: '🧩 Logical Thinking',
                width: size.width,
                color: Theme.of(context).colorScheme.secondary,
                name: 'logical',
              ),
              SizedBox(height: size.height / 30),
              ImprovementButton(
                text: '🦄 Just fun',
                width: size.width,
                color: Theme.of(context).colorScheme.secondary,
                name: 'games',
              ),
              SizedBox(height: size.height / 30),
            ],
          ),
        ),
      ),
    );
  }
}
