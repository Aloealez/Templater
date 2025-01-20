import 'package:flutter/material.dart';

Widget createDot(
  BuildContext context,
  int usersAnswer,
  Object correct,
  int val,
) {
  Size size = MediaQuery.of(context).size;
  return usersAnswer == val || correct == val
      ? Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width / 30,
          ),
          child: Icon(
            correct == val ? Icons.check_circle : Icons.cancel,
            color: correct == val ? Colors.green : Colors.red,
          ),
        )
      : Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width / 30,
          ),
          child: Icon(Icons.circle_outlined,
              color: Theme.of(context).colorScheme.primary,),
        );
}
