import 'package:flutter/material.dart';
import 'package:lesson_flutter/api/index.dart';
import 'package:lesson_flutter/models/MediaItems/Video.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayer extends StatefulWidget {
  final Map arguments;
  LocalVideoPlayer({this.arguments});

  @override
  _LocalVideoPlayerState createState() => _LocalVideoPlayerState();
}

class _LocalVideoPlayerState extends State<LocalVideoPlayer> {
  VideoPlayerController _controller;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int playIndex = 0;
  @override
  void initState() {
    String videoUrl = ApiHandler.getMediaUrl(
        this.widget.arguments["url"], "videos", "kerala_psc");
    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    playIndex = this.widget.arguments["index"];
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.pause();
    _controller.dispose();
    _controller = null;
    super.dispose();
  }

  void listener() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: AppDrawer(),
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "assets/bg-full.png",
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Image.asset(
              "assets/blue-top-pattern.png",
              width: 350.0,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: Image.asset(
              "assets/blue-bottom-pattern.png",
              width: 200.0,
              fit: BoxFit.fitWidth,
            ),
          ),
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: kToolbarHeight - 40.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Spacer(),
                    Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.menu,
                          size: 30.0,
                          color: AppConstants.blackColor,
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState.openEndDrawer();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                // padding: EdgeInsets.symmetric(
                //   horizontal: 25.0,
                //   vertical: 25.0,
                // ),
                child: _controller.value.initialized
                    ? Container(
                        height: 300.0,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        height: 300.0,
                        child: Wrap(
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: this.widget.arguments["videos"].length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    Video _currentVideo =
                        this.widget.arguments["videos"][index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return LocalVideoPlayer(
                            arguments: {
                              "url": _currentVideo.url,
                              "videos": this.widget.arguments["videos"],
                              "index": index
                            },
                          );
                        }));
                      },
                      leading: CircleAvatar(
                        radius: 25.0,
                      ),
                      title: Text(_currentVideo.name),
                      subtitle: Text(
                        _currentVideo.description == ""
                            ? "Description not available"
                            : _currentVideo.description,
                      ),
                      trailing: playIndex != index
                          ? SizedBox()
                          : IconButton(
                              icon: Icon(Icons.play_arrow),
                              onPressed: () {},
                            ),
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
