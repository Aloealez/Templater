import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

AppBar appBar(
  BuildContext context,
  String title, {
  bool canReturn = true,
  meditation = false,
  Widget? route,
  Widget? screen,
}) {
  Size size = MediaQuery.of(context).size;
  return AppBar(
    surfaceTintColor: Theme.of(context).colorScheme.surface,
    backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0),
    leading: canReturn
        ? IconButton(
            color: (!meditation)
                ? Theme.of(context).colorScheme.onSurface
                : Colors.white,
            icon: const Icon(Icons.close),
            onPressed: () {
              // if (route == null) {
              //   Navigator.of(context).pushAndRemoveUntil(
              //     PageTransition(
              //       type: PageTransitionType.fade,
              //       child: Home(),
              //     ),
              //         (Route<dynamic> route) => false,
              //   );
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
              // }
              if (screen != null) {
                Navigator.of(context).pushAndRemoveUntil(
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: screen,
                    reverseDuration: const Duration(milliseconds: 100),
                    opaque: false,
                  ),
                  (Route<dynamic> route) => false,
                );
                return;
              }
              Navigator.pop(context);
              if (route != null) {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: route,
                    reverseDuration: const Duration(milliseconds: 100),
                    opaque: false,
                  ),
                );
              }
            },
            splashRadius: 1,
            highlightColor: Colors.white.withOpacity(0.1),
          )
        : null,
  );
}
