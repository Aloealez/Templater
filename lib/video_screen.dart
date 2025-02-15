import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'app_bar.dart';

class VideoScreen extends StatefulWidget {
  final String videoId;
  final Widget route;

  const VideoScreen({
    super.key,
    required this.videoId,
    required this.route,
  });

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  double _curtainOffset = 0;
  bool _curtainsInitialized = false;
  double _screenWidth = 0;
  bool _showSkipButton = false;

  final _controller = YoutubePlayerController(
    params: const YoutubePlayerParams(
      showControls: true,
      mute: false,
      showFullscreenButton: true,
      loop: false,
      enableKeyboard: false,
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_curtainsInitialized) {
      _screenWidth = MediaQuery.of(context).size.width;
      _curtainOffset = 0;
      _curtainsInitialized = true;
    }
  }


  @override
  void initState() {
    super.initState();
    _controller.loadVideo('https://www.youtube.com/watch?v=${widget.videoId}');
    _controller.listen((event) {
      if (event.playerState == PlayerState.ended) {
        Navigator.pop(context);
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: widget.route,
          ),
        );
      }
    });

    Future.delayed(Duration(milliseconds: 4000), () {
      setState(() {
        _curtainOffset = -_screenWidth / 1.9;
      });
    });

    Future.delayed(Duration(seconds: 6), () {
      setState(() {
        _showSkipButton = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double cinemaBarHeight = size.height * 0.08;
    double cinemaBarOffset = 0.0;

    return Scaffold(
      appBar: appBar(context, ""),
      body: Center(
        child: Container(
          margin: EdgeInsets.zero,
          child: Stack(
            children: [
              Align(
                alignment: Alignment(0, -0.2),
                child: YoutubePlayer(
                  controller: _controller,
                ),
              ),
              Align(
                alignment: Alignment(0, -0.8),
                child: SizedBox(
                  height: cinemaBarHeight,
                  width: size.width,
                  child: Container(
                    color: const Color(0xFF777799),
                    child: Center(
                      child: Text(
                        "TedEd Cinema",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width / 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 3000),
                left: _curtainOffset,
                top: 2 * cinemaBarHeight + cinemaBarOffset,
                width: size.width / 1.95,
                height: (size.height - cinemaBarHeight) / 2,
                curve: Curves.ease,
                child: Image.asset(
                  "assets/video/curtainleftKalina.png",
                  fit: BoxFit.contain,
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 3000),
                right: _curtainOffset,
                top: 2 * cinemaBarHeight + cinemaBarOffset,
                width: size.width / 1.95,
                height: (size.height - cinemaBarHeight) / 2,
                curve: Curves.ease,
                child: Image.asset(
                  "assets/video/curtainrightKalina.png",
                  fit: BoxFit.contain,
                ),
              ),
              Align(
                alignment: Alignment(0, 0.8),
                child: Transform.scale(
                  scale: 2.0,
                  child: Image.asset(
                    "assets/video/audience.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 0.4),
                child: AnimatedOpacity(
                  opacity: _showSkipButton ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  child: SizedBox(
                    height: size.height * 0.05,
                    width: size.width * 0.75,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.onSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: widget.route,
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.skip_next,
                        size: 30,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      label: Text(


                        "Skip",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
