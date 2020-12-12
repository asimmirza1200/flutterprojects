import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lesson_flutter/api/index.dart';
import 'package:lesson_flutter/models/MediaGroup.dart';
import 'package:lesson_flutter/models/MediaItems/Quiz.dart';
import 'package:lesson_flutter/models/MediaItems/Slide.dart';
import 'package:lesson_flutter/models/MediaItems/UnitTest.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/index.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class KeralaSlidePage extends StatefulWidget {
  final Map arguments;

  KeralaSlidePage({this.arguments});

  @override
  _KeralaSlidePageState createState() => _KeralaSlidePageState();
}

class _KeralaSlidePageState extends State<KeralaSlidePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String _currentAlias = "";
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    _currentAlias = this.widget.arguments["slides"][0].alias;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: AppDrawer(),
      body: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                String imageUrl = ApiHandler.getMediaUrl(
                  Slide.getImageUrl(
                      this.widget.arguments["slides"][index].alias),
                  "images",
                  "kerala_psc",
                );
                return PhotoViewGalleryPageOptions(
                  maxScale: 1.0,
                  imageProvider: NetworkImage(imageUrl),
                  initialScale: PhotoViewComputedScale.contained,
                  // heroAttributes: HeroAttributes(tag: galleryItems[index].id),
                );
              },
              itemCount: this.widget.arguments["slides"].length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  color: Colors.transparent,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes,
                  ),
                ),
              ),
              // backgroundDecoration: widget.backgroundDecoration,
              // pageController: widget.pageController,
              // onPageChanged: onPageChanged,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 5.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Wrap(
                  children: [
                    Text((currentIndex + 1).toString()),
                    Text(" / "),
                    Text(
                      this.widget.arguments["slides"].length.toString(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      // body: Stack(
      //   children: [
      //     Positioned(
      //       top: 0.0,
      //       child: Container(
      //         height: MediaQuery.of(context).size.height,
      //         width: MediaQuery.of(context).size.width,
      //         decoration: BoxDecoration(
      //           image: DecorationImage(
      //             fit: BoxFit.cover,
      //             image: AssetImage(
      //               "assets/bg-full.png",
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //     Positioned(
      //       top: 0.0,
      //       left: 0.0,
      //       child: Image.asset(
      //         "assets/blue-top-pattern.png",
      //         width: 350.0,
      //         fit: BoxFit.fitWidth,
      //       ),
      //     ),
      //     Positioned(
      //       bottom: 0.0,
      //       right: 0.0,
      //       child: Image.asset(
      //         "assets/blue-bottom-pattern.png",
      //         width: 200.0,
      //         fit: BoxFit.fitWidth,
      //       ),
      //     ),
      //     Column(
      //       children: [
      //         Container(
      //           width: MediaQuery.of(context).size.width,
      //           margin: EdgeInsets.only(top: kToolbarHeight - 40.0),
      //           child: Row(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               IconButton(
      //                 icon: Icon(Icons.arrow_back),
      //                 onPressed: () {
      //                   Navigator.of(context).pop();
      //                 },
      //               ),
      //               Spacer(),
      //               Container(
      //                 child: IconButton(
      //                   icon: Icon(
      //                     Icons.menu,
      //                     size: 30.0,
      //                     color: AppConstants.blackColor,
      //                   ),
      //                   onPressed: () {
      //                     _scaffoldKey.currentState.openEndDrawer();
      //                   },
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         Expanded(
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Container(
      //                 alignment: Alignment.center,
      //                 child: CarouselSlider(
      //                   options: CarouselOptions(
      //                       height: height * 0.6,
      //                       disableCenter: true,
      //                       viewportFraction: 1.0,
      //                       onPageChanged: (index, reason) {
      //                         setState(() {
      //                           _currentAlias = this
      //                               .widget
      //                               .arguments["slides"][index]
      //                               .alias;
      //                         });
      //                       }),
      //                   items: this
      //                       .widget
      //                       .arguments["slides"]
      //                       .map<Widget>((Unit item) {
      //                     String imageUrl = ApiHandler.getMediaUrl(
      //                       Slide.getImageUrl(item.alias),
      //                       "images",
      //                       "kerala_psc",
      //                     );
      //                     return Image.network(
      //                       imageUrl,
      //                       loadingBuilder: (BuildContext context, Widget child,
      //                           ImageChunkEvent event) {
      //                         if (event != null) {
      //                           return Center(
      //                             child: CircularProgressIndicator(
      //                               value: event == null
      //                                   ? null
      //                                   : event.expectedTotalBytes != null
      //                                       ? event.cumulativeBytesLoaded /
      //                                           event.expectedTotalBytes
      //                                       : null,
      //                             ),
      //                           );
      //                         }
      //                         return child;
      //                       },
      //                     );
      //                   }).toList(),
      //                 ),
      //               ),
      //               Container(
      //                 padding: EdgeInsets.symmetric(
      //                   horizontal: 15.0,
      //                   vertical: 5.0,
      //                 ),
      //                 decoration: BoxDecoration(
      //                   color: Colors.grey[400],
      //                   borderRadius: BorderRadius.circular(20.0),
      //                 ),
      //                 child: Wrap(
      //                   children: [
      //                     Text(
      //                       (this.widget.arguments["slides"].indexWhere(
      //                                   (item) => item.alias == _currentAlias) +
      //                               1)
      //                           .toString(),
      //                     ),
      //                     Text(" / "),
      //                     Text(
      //                       this.widget.arguments["slides"].length.toString(),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         )
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
