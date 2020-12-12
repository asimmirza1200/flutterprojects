import 'dart:convert';

import 'package:den_lineicons/den_lineicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getgolo/modules/controls/images/MyImageHelper.dart';
import 'package:getgolo/modules/services/http/Api.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/modules/state/AppState.dart';
import 'package:getgolo/src/entity/Place.dart';
import 'package:getgolo/src/providers/request_services/Api+city.dart';
import 'package:getgolo/src/providers/request_services/PlaceProvider.dart';

class SuggestionCell extends StatefulWidget {
  final Place place;

  SuggestionCell({Key key, this.place}) : super(key: key);
  @override
  _SuggestionCell createState() {
    return _SuggestionCell();
  }
}

class _SuggestionCell extends State<SuggestionCell> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
             //1. Image
            MyImage.from(widget.place.featuredMediaUrl,
                borderRadius: new BorderRadius.all(Radius.circular(15)),
                color: GoloColors.secondary3),
            Container(
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.all(Radius.circular(15)),
                  color: Colors.white,
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withAlpha(200)],
                      stops: [0.4, 1.0])),
            ),
            //3. Lable, title
            Container(
                child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              getPlaceTypes(widget.place) ?? "",
                              style: TextStyle(
                                  fontFamily: GoloFont,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.place.name ?? "",
                                style: TextStyle(
                                    fontFamily: GoloFont,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                                maxLines: 2,
                              )),
                        ],
                      ),
                      Container(
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.place.rate ?? "",
                                      style: TextStyle(
                                        fontFamily: GoloFont,
                                        color: GoloColors.primary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.place.hasRate,
                                    child: Icon(DenLineIcons.star,
                                        color: GoloColors.primary, size: 11)
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                        (widget.place.reviewCount ?? 0) <= 0 ? "" : "(${widget.place.reviewCount})", // review count
                                        style: TextStyle(
                                          fontFamily: GoloFont,
                                          color: GoloColors.primary,
                                          fontSize: 15,
                                        )),
                                  ),
                                ],
                              ),
                              // Container(
                              //   padding: EdgeInsets.only(right: 10),
                              //   child: Text(widget.place.priceRange ?? r"$",
                              //       style: TextStyle(
                              //         fontFamily: GoloFont,
                              //         color: Colors.white,
                              //         fontSize: 15,
                              //       )),
                              // ),
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            )),
            //2. Button
            Align(
              alignment: Alignment.topRight,
              child: widget.place.bookmark?Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 20, right: 20),
                decoration:
                BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                height: 32,
                width: 32,
                child: CupertinoButton(
                  padding:
                  EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 6),
                  onPressed: () async {
                    var response;

                    if(widget.place.bookmark){
                      response=await PlaceProvider.removeBookmark(widget.place.id.toString(), widget.place.category.first);
                      setState(() {
                        widget.place.bookmark=false;
                      });
                    }else{
                      response=await PlaceProvider.addBookmark(widget.place.id.toString(), widget.place.category.first);
                      setState(() {
                        widget.place.bookmark=true;
                      });
                    }
                    var data=jsonDecode(response.json);
                    if(!data["status"]){
                      Fluttertoast.showToast(
                          msg: data["message"],
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }else{
                      Fluttertoast.showToast(
                          msg: data["message"],
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }


                  },
                  child: Icon(DenLineIcons.bookmark,
                      size: 20, color: GoloColors.primary),
                ),
              ):Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 20, right: 20),
                decoration:
                BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                height: 32,
                width: 32,
                child: CupertinoButton(
                  padding:
                  EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 6),
                  onPressed: () async {
                    var response;

                    if(widget.place.bookmark){
                       response=await PlaceProvider.removeBookmark(widget.place.id.toString(), widget.place.category.first);
                       setState(() {
                         widget.place.bookmark=false;
                       });
                    }else{
                       response=await PlaceProvider.addBookmark(widget.place.id.toString(), widget.place.category.first);
                       setState(() {
                         widget.place.bookmark=true;
                       });
                    }
                    var data=jsonDecode(response.json);
                    if(!data["status"]){
                      Fluttertoast.showToast(
                          msg: data["message"],
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }else{
                      Fluttertoast.showToast(
                          msg: data["message"],
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }


                  },
                  child: Icon(DenLineIcons.bookmark,
                      size: 20, color: GoloColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getPlaceTypes(Place place) {
    var string = "";
    if(place.placeTypes != null) {
      string = place.placeTypes.map((placeType) => placeType.name).toList().join("\n");
    }
    return string;
  }
}
