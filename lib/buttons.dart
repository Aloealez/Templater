import 'package:brainace_pro/improvement_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'language_level_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

void nuthin() {}

class StartButton extends StatefulWidget {
  final String text;
  final String tooltip;
  final double width;

  const StartButton({
    super.key,
    required this.text,
    required this.width,
    required this.tooltip,
  });

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  bool hovered = false;
  late SharedPreferences prefs;
  DateTime now = DateTime.now();
  Future<void> initMemory() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.remove('plan');
    prefs.setString('beginning_date', DateTime(now.year, now.month, now.day).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        initMemory();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImprovementSelection(
              // widget.text,
            ),
          ),
        );
      },
      onHover: (value) {
        setState(() {
          hovered = value;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: hovered
              ? Theme.of(context).colorScheme.tertiaryFixed
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(45),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Tooltip(
          message: widget.tooltip,
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.width / 18,
                color: const Color.fromARGB(255, 224, 246, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ).animate(target: hovered ? 1 : 0).scaleXY(end: 1.1),
    );
  }
}

class InstructionsButton extends StatefulWidget {
  final Widget functionToRun;

  const InstructionsButton(
    this.functionToRun, {
    super.key,
  });

  @override
  State<InstructionsButton> createState() => _InstructionsButtonState();
}

class _InstructionsButtonState extends State<InstructionsButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget.functionToRun,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Text(
        '? Instructions ?',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class RedirectButton extends StatefulWidget {
  final String text;
  final String? tooltip;
  final double width;
  final Widget? route;
  final bool popRoute;
  final bool requirement;
  final void Function() onClick;
  final bool clearAllWindows;
  final Color? color;

  const RedirectButton({
    super.key,
    required this.text,
    required this.width,
    this.tooltip,
    this.route,
    this.popRoute = true,
    this.requirement = true,
    this.onClick = nuthin,
    this.clearAllWindows = false,
    this.color,
  });

  @override
  State<RedirectButton> createState() => _RedirectButtonState();
}

class _RedirectButtonState extends State<RedirectButton> {
  bool hovered = false;
  bool accesible = true;
  bool toRed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (value) {
        if (widget.requirement) {
          setState(() {
            hovered = value;
          });
        }
      },
      onTap: () {
        if (widget.requirement) {
          //
          widget.onClick();
          //
          if (widget.route != null) {
            if (widget.clearAllWindows) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => widget.route!),
                (Route<dynamic> route) => false,
              );
            } else {
              if (widget.popRoute) {
                Navigator.pop(context);
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => widget.route!,
                ),
              );
            }
          }
        } else if (!toRed) {
          setState(() {
            accesible = false;
            toRed = true;
          });
          Future.delayed(const Duration(milliseconds: 250), () {
            setState(() {
              accesible = true;
            });
          });

          Future.delayed(const Duration(milliseconds: 650), () {
            setState(() {
              toRed = false;
            });
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: toRed
              ? Theme.of(context).colorScheme.error
              : hovered
                  ? Theme.of(context).colorScheme.tertiaryFixed
                  : widget.color ?? Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(69),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: widget.tooltip != null
            ? Tooltip(
                message: widget.tooltip!,
                child: Center(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                        fontSize: widget.width / 15,
                        fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            : Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: widget.width / 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      )
          .animate(target: hovered ? 1 : 0)
          .scaleXY(end: 1.05)
          .animate(target: accesible ? 0 : 1)
          .shake(
            hz: 4,
            rotation: 0.15,
            duration: const Duration(milliseconds: 250),
          )
          .scaleXY(end: 1.2),
    );
  }
}

class ImprovementButton extends StatefulWidget {
  final String text;
  final double width;
  final Color color;
  final String img;
  final String name;

  const ImprovementButton({
    super.key,
    required this.text,
    required this.width,
    required this.img,
    required this.name,
    required this.color,
  });

  @override
  State<ImprovementButton> createState() => _ImprovementButtonState();
}

class _ImprovementButtonState extends State<ImprovementButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    late SharedPreferences prefs;
    //initMemory();
    return SizedBox(
      //flex: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.width / 6,
            width: size.width / 6,
            child: Image.asset(
              "assets/improvement_selection/${widget.img}",
              height: size.width / 6,
            ),
          ),
          SizedBox(
            width: size.width / 40,
          ),
          SizedBox(
            height: size.height / 15,
            width: size.width * 0.6,
            child: InkWell(
              onHover: (value) {
                setState(() {
                  hovered = value;
                });
              },
              onTap: () {
                Future<void> initMemory() async {
                  prefs = await SharedPreferences.getInstance();
                  prefs.setString(
                    'skill',
                    widget.name,
                  );
                }

                initMemory();

                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: LanguageLevelSelection(),
                    reverseDuration: const Duration(milliseconds: 100),
                    opaque: true,
                  ),
                );
              },
              child: Container(
                width: widget.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  // gradient: LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   colors: <Color>[
                  //     Theme.of(context).colorScheme.primary,
                  //     Theme.of(context).colorScheme.secondary,
                  //   ],
                  //   tileMode: TileMode.decal,
                  // ),
                  color: widget.color,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: widget.width / 16,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: const Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Theme.of(context).colorScheme.shadow.withAlpha(169),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
