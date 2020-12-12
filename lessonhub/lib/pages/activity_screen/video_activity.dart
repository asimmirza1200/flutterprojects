import 'package:flutter/material.dart';
import 'package:lesson_flutter/api/index.dart';
import 'package:lesson_flutter/models/MediaGroup.dart';
import 'package:lesson_flutter/models/MediaItems/Video.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/index.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:async/async.dart';

class VideoActivity extends StatelessWidget {
  final List videos;

  VideoActivity({this.videos});
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: this._memoizer.runOnce(() async {
          String category =
              await SharedPrefs.getString("category", "mysql_school");
          var data = await Video.getVideosFromList(this.videos, category);
          return data;
        }),
        // future: Video.getVideosFromList(this.videos),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Loader(),
            );
          }
          if (snapshot.hasError) {
            return SizedBox();
          }
          if (snapshot.hasData) {
            List items = snapshot.data["data"];
            List<Video> videos =
                items.map((item) => Video.fromJson(item)).toList();
            return ListView.builder(
              shrinkWrap: true,
              itemCount: videos.length,
              itemBuilder: (BuildContext context, int index) {
                bool isYoutube = videos[index].url.contains("youtube.com");
                return GestureDetector(
                  onTap: () {
                    AppRoutes.nextScreen(
                      context,
                      isYoutube
                          ? AppRoutes.VIDEO_PAGE
                          : AppRoutes.LOCAL_VIDEO_PAGE,
                      arguments: {
                        "url": videos[index].url,
                        "videos": videos,
                        "index": index
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        18.0,
                      ),
                      color: AppConstants.kBlueColor,
                    ),
                    height: 90.0,
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Container(
                          width: 90.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              18.0,
                            ),
                            color:
                                isYoutube ? Colors.transparent : Colors.white,
                            image: isYoutube
                                ? DecorationImage(
                                    image: NetworkImage(
                                      YoutubePlayer.getThumbnail(
                                        videoId: YoutubePlayer.convertUrlToId(
                                          videos[index].url,
                                        ),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        Expanded(
                          child: Text(
                            unitNameToTitle(videos[index].name)
                                .replaceAll(RegExp("[0-9]+"), ""),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return SizedBox();
        });
  }
}
