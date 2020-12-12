import 'Base.dart';

class PlaceType extends Base{
    int categoryId;
    String description;    
    String name;    
  PlaceType(Map<String, dynamic> json) : super(json) {
    categoryId = json["category_id"];
    description = json["description"];
    name = json["name"];
  }
  factory PlaceType.fromJson(Map<String, dynamic> json) {
    return PlaceType(json);
  }
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['category_id'] = this.categoryId;
      data['name'] = this.name;
      data['description'] = this.description;

      return data;
    }

}