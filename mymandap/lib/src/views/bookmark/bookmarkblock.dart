import 'dart:async';
import 'dart:convert';
import 'package:getgolo/modules/setting/setting.dart';
import 'package:getgolo/src/blocs/Bloc.dart';
import 'package:getgolo/src/providers/request_services/PlaceProvider.dart';
import 'package:getgolo/src/providers/request_services/query/PageQuery.dart';
import 'package:getgolo/src/entity/PlaceCategory.dart';

class BookmarkBloc implements Bloc {
  // Data
  var _currentPage = 1;
  var categories = <PlaceCategory>[];

  // Stream
  final _categoryController = StreamController<List<PlaceCategory>>.broadcast();
  Stream<List<PlaceCategory>> get categoriesStream => _categoryController.stream;

  void fetchFeature() async {
    categories=[];
    final response = await PlaceProvider.fetchAllBookmark();
    _currentPage++;
    List<PlaceCategory> tmp;
    print(response);
    var data=jsonDecode(response.json)["data"]["features"];
    if (data != null && data.isNotEmpty) {
      tmp = List<PlaceCategory>.generate(data.length,
          (i) => PlaceCategory.fromJson(data[i]));


      for(int i=0;i<tmp.length;i++ ){
        tmp.elementAt(i).places.elementAt(0).bookmark=true;
      }
      categories.addAll(tmp);

      _categoryController.sink.add(tmp);
      // Request next
      //fetchPlaces(cityId);
    }
  }

  // void _groupCategories(List<Place> all) {
  //   for (var place in all) {
  //     for (var category in place.categories) {
  //       var categoryIds = this.categories.map((category) => category.id).toList();
  //       if (!categoryIds.contains(category.id))
  //         this.categories.add(category);
  //     }
  //   }
  //   this.categories.sort((a,b) => a.id.compareTo(b.id));
  // }
  @override
  void dispose() {
    _categoryController.close();
  }
}
