import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getgolo/localization/Localized.dart';
import 'package:getgolo/localization/LocalizedKey.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/src/entity/Place.dart';
import 'package:getgolo/src/entity/PlaceCategory.dart';
import 'package:getgolo/src/views/citydetail/SuggestionView/SuggestionCell.dart';


class BookmarkList extends StatefulWidget {
  final PlaceCategory category;
  final List<Place> places;
  // event
  final void Function(Place) handleOpenPlace; // open place with id
  final void Function(int) handleViewAllCategory;

  BookmarkList({this.category, this.places, this.handleOpenPlace, this.handleViewAllCategory});

  @override
  _Sugestion createState() => _Sugestion();
}

class _Sugestion extends State<BookmarkList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(top: widget.places != null && widget.places.length == 0 ? 0 : 20),
        height: widget.places != null && widget.places.length == 0 ? 0 : 310,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Tittle
            // Container(
            //   padding: EdgeInsets.only(left: 25),
            //   height: 60,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Container(
            //         child: Container(
            //           child: Text(
            //             widget.category.featureTitle != null ? widget.category.featureTitle : '',
            //             style: TextStyle(
            //                 fontFamily: GoloFont,
            //                 fontWeight: FontWeight.w500,
            //                 fontSize: 20,
            //                 color: GoloColors.secondary1),
            //           ),
            //         ),
            //       ),
            //       Container(
            //           child: CupertinoButton(
            //             child: Text(
            //                 Localized.of(context).trans(LocalizedKey.viewAll) +
            //                     " (${widget.places != null ? widget.places.length : 0})",
            //                 style: TextStyle(
            //                     fontFamily: GoloFont,
            //                     fontWeight: FontWeight.w500,
            //                     fontSize: 15,
            //                     color: GoloColors.primary)),
            //             onPressed: () {
            //               widget.handleViewAllCategory(widget.category.id);
            //             },
            //           ))
            //     ],
            //   ),
            // ),
            //List
            Container(height: 250, child: _sugestionTable())
          ],
        ),
      ),
    );
  }

  Widget _sugestionTable() => new ListView.builder(
      itemCount: widget.places != null ? widget.places.length : 0,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all( 10),
      itemBuilder: (BuildContext context, int index) =>
          _buildBookmarkCell(context, index));

  Widget _buildBookmarkCell(BuildContext context, int index) =>
      GestureDetector(
        onTap: () {
          widget.handleOpenPlace(widget.places[index]);
        },
        child: Container(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              width: 180,
              child: SuggestionCell(place: widget.places[index]),
            )),
      );
}
