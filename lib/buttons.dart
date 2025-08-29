import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

void nuthin() {}

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
  final double fontScale;

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
    this.fontScale = 1,
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
    Size size = MediaQuery.of(context).size;
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
                PageTransition(
                  type: PageTransitionType.fade,
                  child: widget.route!,
                  reverseDuration: const Duration(milliseconds: 100),
                  opaque: false,
                ),
                (Route<dynamic> route) => false,
              );
            } else {
              if (widget.popRoute) {
                Navigator.pop(context);
              }
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: widget.route,
                  reverseDuration: const Duration(milliseconds: 100),
                  opaque: true,
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
        padding: EdgeInsets.symmetric(horizontal: size.width / 50),
        decoration: BoxDecoration(
          color: toRed
              ? Theme.of(context).colorScheme.error
              : hovered
                  ? Theme.of(context).colorScheme.tertiaryFixed
                  : widget.color ?? Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
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
                      fontSize: widget.width / 15 * widget.fontScale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            : Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: widget.width / 18 * widget.fontScale,
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

