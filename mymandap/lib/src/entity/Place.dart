
import 'package:getgolo/modules/state/AppState.dart';
import 'package:getgolo/src/entity/City.dart';
import 'package:getgolo/src/entity/Review.dart';
import 'package:getgolo/modules/services/platform/lara/lara.dart';
import 'package:html/parser.dart';

import 'Base.dart';
import 'PlaceCategory.dart';
import 'PlaceType.dart';
class Place extends Base{
  int status;
  bool bookmark=false;

  String type;
  String imgUrl;
  String featuredMediaUrl;
  List<String> gallery;
  int menuOrder;
  int author;
  String commentStatus;
  String pingStatus;
  String template;
  List<int> types; // Place types id
  // categories
  List<String> category;
  List<PlaceCategory> categories = [];
  List<String> amenities;
  int cityId;
  String description;
  String name;
  String excerpt;
  // Location
  double lat;
  double lng;
  String address;
  // Manual get
  String cityName;
  List<Review> _reviews = [];
  int reviewCount;
  // Rate
  String _rate;
  String get rate {
    return hasRate ? _rate : "(No review)";
  }
  bool get hasRate {
    return _rate != null && _rate.isNotEmpty;
  }
  // Price range
  String priceRange;
  // Phone - email - site - facebook - instagram
  String phone;
  String email;
  String facebook;
  String instagram;
  String website;
  // Booking
  String booking;
  String bookingSite;
  int bookingType;
  String bookingBannerId;
  String bookingBannerImageUrl;
  String bookingBannerUrl;
  String bookingForm;
  // Opening time
  Map<String, String> openingTime = {};
  //PLace types
  List<PlaceType> placeTypes;

  //City
  City city;

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['city_id'] = this.cityId;
  //   data['category'] = this.category;
  //   data['name'] = this.name;
  //   data['slug'] = this.slug;
  //   data['description'] = this.description;
  //   if (value == null || value == "none") {
  //     priceRange = "";
  //   }
  //   data['price_range'] = this.priceRange;
  //   data['amenities'] = this.amenities;
  //   data['address'] = this.address;
  //   data['lat'] = this.lat;
  //   data['lng'] = this.lng;
  //   data['email'] = this.email;
  //   data['website'] = this.website;
  //   data['opening_hour'] = this.openingTime.toString();
  //   data['gallery'] = this.gallery;
  //   data['booking_type'] = this.bookingType;
  //   data['status'] = this.status;
  //   data['reviews_count'] = this.reviewCount;
  //   if (this.placeTypes != null) {
  //     data['place_types'] = this.placeTypes.map((v) => v.toJson()).toList();
  //   }
  //   data['email'] = this.email;
  //   data['thumb'] = this.featuredMediaUrl;
  //   data["review_score_avg"]=this._rate;
  //   data['phone_number'] = this.phone;
  //
  //
  //   return data;
  // }
  Place(Map<String, dynamic> json) : super(json) {
    status = json["status"];
    type = json["type"];
    featuredMediaUrl = "${Lara.baseUrlImage}${json["thumb"] ?? ""}";
    gallery = json["gallery"] != null ? json["gallery"].cast<String>() : [];
    menuOrder = json["menu_order"];
    author = json["author"];
    pingStatus = json["ping_status"];
    template = json["template"];
    description = parse(json["description"] ?? "").documentElement.text;
    name = parse(json["name"]).documentElement.text;
    // place type
    types = json["place-type"] != null ? json["place-type"].cast<int>() : [];
    // cateogries
    category = json["category"] != null ? json["category"].cast<String>() : [];
    // amenities
    amenities = json["amenities"] != null ? json["amenities"].cast<String>() : [];
    // cities
    cityId = json["city_id"];
    lat = json["lat"];
    String lng = json["lng"].toString();
    this.lng=double.parse(lng=="null"?"0.0":lng);
    print(this.lng);

    address =  json["address"];
    // Price range
    var value = json["price_range"];
    print(json["price_range"]);
    if (value == null || value == "none") {
      priceRange = "";
    }
    else if (value == "free") {
      priceRange = "free";
    }
    else {
      var count = value;

      // priceRange = List<String>.generate(count, (int i) => r"$").join();
    }
    phone = json["phone_number"];
    email = json["email"];
    facebook = json["golo-place_facebook"];
    instagram = json["golo-place_instagram"];
    website = json["website"];
    // booking
    booking = json["golo-place_booking"];
    bookingSite = json["link_bookingcom"];
    bookingType = json["booking_type"];
    bookingBannerUrl = json["golo-place_booking_banner_url"];
    bookingForm = json["golo-place_booking_form"];



    if (json["opening_hour"] != null && json["opening_hour"].length > 0) {
      for (var json in json["opening_hour"]) {
        openingTime[json["title"]] = json["value"];
      }
    }

    // Review count
    reviewCount = json["reviews_count"];
    // rate
    if (json["review_score_avg"] != null) {
      _rate = json["review_score_avg"].toString();
    }
    else if (json["avg_review"] != null && json["avg_review"].length > 0) {
      for (var j in json["avg_review"]){
        if (j["place_id"] == id) {
          _rate = j["aggregate"].toString();
        }
      }
    }

    // if (json["categories"].length > 0) {
    //   categories = List<PlaceCategory>();
    //   for (var jsonCat in json["categories"]) {
    //     categories.add(PlaceCategory.fromJson(jsonCat));
    //   }
    // }
    //Place types
    if (json["place_types"] != null && json["place_types"].length > 0){
      placeTypes = List<PlaceType>();
      for(var json in json["place_types"]){
        placeTypes.add(PlaceType.fromJson(json));
      }
    }

    if (json["city"] != null) {
      city = City.fromJson(json["city"]);
    }

  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(json);
  }

  List<Review> get comments => _reviews;
  void setComments(List<Review> list) {
    _reviews = list ?? [];
  }

  void setRate(String r) {
    _rate = r;
  }

  void setReviewCount(int count) {
    reviewCount = count;
  }
}


