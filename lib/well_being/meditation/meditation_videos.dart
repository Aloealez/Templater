import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/app_bar.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoListItem extends StatefulWidget {
  final String videoAsset;
  const VideoListItem({super.key, required this.videoAsset});

  @override
  _VideoListItemState createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
  }

  Future<void> launchURL(String url) async {
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final youtubeUrl =
            'https://www.youtube.com/watch?v=${widget.videoAsset.substring(widget.videoAsset.length - 11)}';
        launchURL(youtubeUrl);
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.surface,
              //color: Colors.black.withOpacity(0.35),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              'https://img.youtube.com/vi/${widget.videoAsset.substring(widget.videoAsset.length - 11)}/0.jpg',
              filterQuality: FilterQuality.high,
              fit: BoxFit.none,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(child: CircularProgressIndicator()),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Check internet connection',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    _controller.close();
    super.dispose();
  }
}

class MeditationVideos extends StatefulWidget {
  final int videoTimeIndex;
  const MeditationVideos({super.key, required this.videoTimeIndex});

  @override
  State<MeditationVideos> createState() => _MeditationVideos();
}

class _MeditationVideos extends State<MeditationVideos> {
  List<List<String>> videoAssets = [
    [
      "https://www.youtube.com/watch?v=jMPO6-Sxtuw",
      "https://www.youtube.com/watch?v=AnOuNPoEwOk",
      "https://www.youtube.com/watch?v=IQeV5bdXqgU",
      "https://www.youtube.com/watch?v=n3Y95_w9qvA",
    ],
    [
      "https://www.youtube.com/watch?v=1iIuE4QCIC0",
      "https://www.youtube.com/watch?v=W-KltSK4MQE",
      "https://www.youtube.com/watch?v=qpRDLXn8ZEI",
      "https://www.youtube.com/watch?v=5gCy3b3swT4",
    ],
    [
      "https://www.youtube.com/watch?v=AtFx_qEkqV4",
      "https://www.youtube.com/watch?v=BDXL5usQlvw",
      "https://www.youtube.com/watch?v=GBT0Te_78CU",
      "https://www.youtube.com/watch?v=PRRi2vAxUQA",
    ],
    [
      "https://www.youtube.com/watch?v=Gsepsq5FWfE",
      "https://www.youtube.com/watch?v=lkl2QH196vs",
      "https://www.youtube.com/watch?v=h1wvvFvL9oM",
      "https://www.youtube.com/watch?v=a3gmfSGNSB8",
    ],
    [
      "https://www.youtube.com/watch?v=vcagtZoDcmk",
      "https://www.youtube.com/watch?v=WHhccZZlc74",
      "https://www.youtube.com/watch?v=MhjhkmhFs4o",
      "https://www.youtube.com/watch?v=31RXIywS5-w",
    ],
    [
      "https://www.youtube.com/watch?v=1Ctj3kubpNw",
      "https://www.youtube.com/watch?v=fe-VZd1sFTU",
      "https://www.youtube.com/watch?v=fe-VZd1sFTU",
      "https://www.youtube.com/watch?v=Yi6oaWtKzBk",
    ]
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBar(context, ""),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            left: size.width / 10,
            right: size.width / 10,
            top: size.height / 50,
            bottom: size.height / 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Meditation",
                      style: TextStyle(
                        fontSize: size.width / 8,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'STEP BY STEP',
                      style: TextStyle(fontSize: size.width / 22),
                    ),
                  ),
                  SizedBox(height: 0.04 * size.height),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: size.width / 18,
                          height: 1.2,
                        ),
                        children: const [
                          TextSpan(
                            text: 'To which ',
                          ),
                          TextSpan(
                            text: 'rain animation',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextSpan(text: ' would you like to meditate?'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height / 30),
                  SizedBox(
                    height: size.height,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            children:
                                List.generate(videoAssets.length, (index) {
                              return VideoListItem(
                                videoAsset: videoAssets[index]
                                    [widget.videoTimeIndex],
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: size.height / 20),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
