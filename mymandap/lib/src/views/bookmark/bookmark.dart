import 'dart:math';

import 'package:den_lineicons/den_lineicons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getgolo/localization/Localized.dart';
import 'package:getgolo/localization/LocalizedKey.dart';
import 'package:getgolo/modules/controls/images/MyImageHelper.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/modules/state/AppState.dart';
import 'package:getgolo/src/blocs/navigation/NavigationBloc.dart';
import 'package:getgolo/src/entity/City.dart';
import 'package:getgolo/src/entity/Place.dart';
import 'package:getgolo/src/entity/PlaceCategory.dart';
import 'package:getgolo/src/providers/BlocProvider.dart';
import 'package:getgolo/src/views/bookmark/BookMarkWidget.dart';
import 'package:getgolo/src/views/bookmark/bookmarkblock.dart';
import 'package:getgolo/src/views/citydetail/SuggestionView/SuggestionGrid.dart';
import 'package:getgolo/src/views/citydetail/map/CityGoogleMapView.dart';
import 'package:getgolo/src/views/place_detail_overview/PlaceDetailOverview.dart';
import 'package:flutter/cupertino.dart';

class Bookmark extends StatefulWidget {
  final City city;

  Bookmark({Key key, this.city}) : super(key: key);

  @override
  _BookmarkState createState() {
    return _BookmarkState();
  }
}

class _BookmarkState extends State<Bookmark> {
  bool isList = false;
  int selectedCategoryId;
  //final List<PlaceCategory> categories = AppState().categories;

  // Scroll header
  ScrollController _scrollController;
  Color _headerBackgroundColor = GoloColors.clear;
  Color _titleColor = GoloColors.clear;

  // Bloc
  final bloc = BookmarkBloc();

  @override
  void initState() {
    super.initState();
    // Scroll listener
    _scrollController = ScrollController()
      ..addListener(() {
        var offset = _scrollController.offset;
        // Header background color
        var alpha = offset > 0 ? min(255, offset.toInt()) : 0;
        _headerBackgroundColor = GoloColors.primary.withAlpha(alpha);
        // Title color
        _titleColor = Colors.white.withAlpha(offset > 255 ? 255 : 0);
        // State
        setState(() {});
      });

    // Get data
    // bloc.fetchFeature();
  }

  @override
  Widget build(BuildContext context) {
    bloc.fetchFeature();

    return BlocProvider<BookmarkBloc>(
        bloc: bloc,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder(
            stream: bloc.categoriesStream,
            builder: (context, snapshot) {
              print("===============> received stream event");
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.all(0),
                            scrollDirection: Axis.vertical,
                            controller: _scrollController,
                            children: <Widget>[
                              //1. Header
                              // Container(
                              //   height: 300,
                              //   child: Stack(
                              //     children: <Widget>[
                              //       MyImage.from(widget.city.featuredImage),
                              //       Container(
                              //         decoration: BoxDecoration(
                              //             color: Colors.white,
                              //             gradient: LinearGradient(
                              //                 begin: FractionalOffset.topCenter,
                              //                 end: FractionalOffset.bottomCenter,
                              //                 colors: [
                              //                   Colors.transparent,
                              //                   Colors.black.withAlpha(200)
                              //                 ],
                              //                 stops: [
                              //                   0.4,
                              //                   1.0
                              //                 ])),
                              //       ),
                              //       Container(
                              //         alignment: Alignment.topCenter,
                              //         margin: EdgeInsets.only(top: 80),
                              //         child: Column(
                              //           children: <Widget>[
                              //             Container(
                              //               margin: EdgeInsets.only(top: 12),
                              //               child: Text(
                              //                 widget.city.country ?? "",
                              //                 style: TextStyle(
                              //                     color: Colors.white,
                              //                     fontFamily: GoloFont,
                              //                     fontWeight: FontWeight.w500,
                              //                     fontSize: 16),
                              //               ),
                              //             ),
                              //             Container(
                              //               child: Text(
                              //                 widget.city.name ?? "",
                              //                 style: TextStyle(
                              //                     color: Colors.white,
                              //                     fontFamily: GoloFont,
                              //                     fontWeight: FontWeight.w500,
                              //                     fontSize: 50),
                              //               ),
                              //             ),
                              //             Container(
                              //               child: Text(
                              //                 widget.city.intro ?? "",
                              //                 style: TextStyle(
                              //                     color: Colors.white,
                              //                     fontFamily: GoloFont,
                              //                     fontStyle: FontStyle.italic,
                              //                     fontSize: 18),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              //2. Category
                              // Container(height: 60, child: _tableCategories(bloc)),
                              //3. Map
                              // Container(
                              //   height: 150,
                              //   child: Stack(
                              //     children: <Widget>[
                              //       Container(
                              //           child: _buildMap(bloc, false)
                              //       ),
                              //       Container(
                              //           child: SizedBox.expand(
                              //               child: FlatButton(
                              //                 color: Colors.transparent,
                              //                 splashColor: Colors.transparent,
                              //                 highlightColor: Colors.transparent,
                              //                 onPressed: (){
                              //                   _openMap(bloc);
                              //                 },
                              //               )
                              //           )
                              //       )
                              //     ],
                              //   ),
                              // ),

                              //4. Suggestion List || Suggestion Grid
                              Container(
                                margin: EdgeInsets.all(0),
                                padding: EdgeInsets.all(0),
                                child: _buildListSuggestion(bloc)
                                    // : _buildGridSuggestion(bloc),
                              ),
                              //5. Information
                              // Visibility(
                              //   visible: isList,
                              //   child: Container(
                              //     margin: EdgeInsets.only(top: 25, bottom: 30),
                              //     decoration: BoxDecoration(
                              //         color: Color.fromRGBO(249, 249, 249, 1)),
                              //     child: Container(
                              //         margin: EdgeInsets.only(
                              //             left: 25, top: 20, bottom: 5),
                              //         child: Column(
                              //           crossAxisAlignment:
                              //           CrossAxisAlignment.stretch,
                              //           mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //           children: <Widget>[
                              //             Container(
                              //               alignment: Alignment.centerLeft,
                              //               child: Text(
                              //                   Localized.of(context).trans(
                              //                       LocalizedKey
                              //                           .cityInfomation) ??
                              //                       "",
                              //                   style: TextStyle(
                              //                     fontFamily: GoloFont,
                              //                     fontSize: 20,
                              //                     fontWeight: FontWeight.w500,
                              //                     color: GoloColors.secondary1,
                              //                   )),
                              //             ),
                              //             Container(
                              //               alignment: Alignment.centerLeft,
                              //               margin: EdgeInsets.only(top: 10),
                              //               child: Text(
                              //                 widget.city.description ?? "",
                              //                 style: TextStyle(
                              //                   fontFamily: GoloFont,
                              //                   fontSize: 16,
                              //                   color: GoloColors.secondary2,
                              //                 ),
                              //                 maxLines: 3,
                              //                 overflow: TextOverflow.ellipsis,
                              //               ),
                              //             ),
                              //             Container(
                              //               alignment: Alignment.centerLeft,
                              //               child: CupertinoButton(
                              //                 onPressed: () {
                              //                   openFullCityDescription(context);
                              //                 },
                              //                 padding: EdgeInsets.all(0),
                              //                 child: Text(
                              //                     Localized.of(context).trans(
                              //                         LocalizedKey.readMore) ??
                              //                         "",
                              //                     style: TextStyle(
                              //                       fontFamily: GoloFont,
                              //                       fontSize: 15,
                              //                       fontWeight: FontWeight.w500,
                              //                       color: GoloColors.primary,
                              //                     )),
                              //               ),
                              //             )
                              //           ],
                              //         )),
                              //   ),
                              // )
                            ],
                          ),
                        )
                      ],
                    ),
                   _buildHeader()
                  ],
                ),
              );
            },
          ),
        ));
  }

  // ### HEADER
  Widget _buildHeader() {
    return     Container(
      margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
        child: Text("Bookmarks",style: TextStyle(fontSize: 20),),);
  }

  Widget _tableCategories(BookmarkBloc bloc) {
    //var listCat = categories.where((cat) => bloc.groupedPlaces.containsKey(cat.id)).toList();
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: bloc.categories.length + 1,
      itemBuilder: (BuildContext context, int index) =>
          _buildCategoriesCell(context, index == 0 ? null : bloc.categories[index - 1]),
    );
  }

  Widget _buildCategoriesCell(BuildContext context, PlaceCategory cat) {
    String title;
    title = cat == null
        ? Localized.of(context).trans(LocalizedKey.home).toUpperCase()
        : cat.name.toUpperCase();
    return Container(
        child: FlatButton(
            onPressed: () {
              setState(() {
                this.isList = cat == null;
                this.selectedCategoryId = cat != null ? cat.id : null;
              });
            },
            child: Text(title ?? "",
                style: TextStyle(
                    fontFamily: GoloFont,
                    color: (cat != null ? cat.id == selectedCategoryId : (selectedCategoryId == null))
                        ? GoloColors.primary
                        : GoloColors.secondary1,
                    fontSize: 15,
                    fontWeight: FontWeight.w500))));
  }

  Widget _buildListSuggestion(BookmarkBloc bloc) {
    if (bloc.categories == null || bloc.categories.length == 0) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      height: MediaQuery.of(context).size.height-50,
        child: GridView.count(
          childAspectRatio: 0.7,
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate 100 widgets that display their index in the List.
        children: bloc.categories.map((cat) => BookmarkList(
              category: cat,
              places: cat.places,
              handleOpenPlace: (place) {
                _openPlace(place);
              },
              handleViewAllCategory: (id) {
                setState(() {
                  if (id != null) {
                    this.isList = false;
                    this.selectedCategoryId = id;
                  }
                });
              },
            ))
                .toList()));
  }

  Widget _buildGridSuggestion(BookmarkBloc bloc) {
    var cat = bloc.categories.where((cat) => cat.id == selectedCategoryId).first;
    if (selectedCategoryId == null || cat == null) {
      return Container();
    }
    return Container(
        margin: EdgeInsets.only(bottom: 35, left: 0, right: 0),
        child: SuggestionGrid(
          category: cat,
          places: cat.places ?? [],
          handleOpenPlace: (place) {
            _openPlace(place);
          },
        ));
  }

  Widget _buildMap(BookmarkBloc bloc, bool isFullScreen) {
    return new GoogleMapViewCity(
      categories: selectedCategoryId == null ? bloc.categories : bloc.categories.where((cat) => cat.id == selectedCategoryId).toList(),
      city: widget.city,
      isFullScreen: isFullScreen,
      zoom: 12,
    );
  }

  // ### ACTIONS
  void _openPlace(Place place) {
    if (place != null) {
      HomeNav(context).openPlace(place);
    }
  }

  void _openMap(BookmarkBloc bloc) {
    Navigator.of(context, rootNavigator: true).push(PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 222),
        pageBuilder: (BuildContext context, _, __) {
          return Container(
              child: _buildMap(bloc, true)
          );
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return SlideTransition(
            child: child,
            position:
            animation.drive(Tween(begin: Offset(0.5, 0), end: Offset.zero)),
          );
        },
        fullscreenDialog: true));
  }

  void openFullCityDescription(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 222),
        pageBuilder: (BuildContext context, _, __) {
          return PlaceDetailOverview(city: widget.city);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return SlideTransition(
            child: child,
            position:
            animation.drive(Tween(begin: Offset(0.5, 0), end: Offset.zero)),
          );
        },
        fullscreenDialog: true
    )
    );
  }
}
