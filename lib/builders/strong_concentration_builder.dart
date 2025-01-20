

import 'package:flutter/material.dart';

import '../attention/strong_concentration.dart';

FutureBuilder strongConcentrationBuilder({required bool initialTest, required bool endingTest}) {
  return FutureBuilder (future: () async {}(), builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    return StrongConcentration(initialTest: initialTest, endingTest: endingTest,);
  },);
}