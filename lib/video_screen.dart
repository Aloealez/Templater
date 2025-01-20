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
  double _curtainPosition = 0;

  final _controller = YoutubePlayerController(
    params: const YoutubePlayerParams(
      showControls: true,
      mute: false,
      showFullscreenButton: false,
      loop: false,
      enableKeyboard: false,
    ),
  );

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

    // Update curtain position after a delay
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _curtainPosition = -MediaQuery.of(context).size.width;
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
    double cinemaBarHeight = size.height * 0.08, cinemaBarAlignment = -0.8;

    return Scaffold(
      appBar: appBar(
        context,
        "",
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(
            left: 0,
            right: 0,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment(0, 0),
                child: YoutubePlayer(
                  controller: _controller,
                ),
              ),
              Align(
                alignment: Alignment(0, cinemaBarAlignment),
                child: SizedBox(
                  height: cinemaBarHeight,
                  width: size.width,
                  child: Container(
                    color: Color(0xFF777799),
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
                left: _curtainPosition-size.width/2,
                top: 2*cinemaBarHeight + cinemaBarAlignment, // Start immediately after the "TedEd Cinema" bar
                height: (size.height - cinemaBarHeight)/2, // Remaining screen height
                curve: Curves.ease,
                child: SizedBox(
                  width: size.width, // Half screen width for left curtain
                  child: Image.asset(
                    "assets/video/curtainleftKalina.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 3000),
                right: _curtainPosition-size.width/2,
                top: 2*cinemaBarHeight + cinemaBarAlignment, // Start immediately after the "TedEd Cinema" bar
                height: (size.height - cinemaBarHeight)/2, // Remaining screen height
                curve: Curves.ease,
                child: SizedBox(
                  width: size.width, // Half screen width for right curtain
                  child: Image.asset(
                    "assets/video/curtainrightKalina.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 0.8),
                child: Transform.scale(
                  scale: 2.0, // Double the size of the audience image
                  child: Image.asset(
                    "assets/video/audience.png",
                    fit: BoxFit.contain,
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