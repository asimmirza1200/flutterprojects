/// status : true
/// user : {"id":18,"name":"arsalan","email":"admin@admin.com","email_verified_at":null,"avatar":null,"phone_number":null,"facebook":null,"instagram":null,"is_admin":0,"status":1,"created_at":"2020-12-01 01:22:12","updated_at":"2020-12-01 01:22:12"}

class LoginResponse {
  bool _status;
  User _user;

  bool get status => _status;
  User get user => _user;

  LoginResponse({
      bool status, 
      User user}){
    _status = status;
    _user = user;
}

  LoginResponse.fromJson(dynamic json) {
    _status = json["status"];
    _user = json["user"] != null ? User.fromJson(json["user"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    if (_user != null) {
      map["user"] = _user.toJson();
    }
    return map;
  }

}

/// id : 18
/// name : "arsalan"
/// email : "admin@admin.com"
/// email_verified_at : null
/// avatar : null
/// phone_number : null
/// facebook : null
/// instagram : null
/// is_admin : 0
/// status : 1
/// created_at : "2020-12-01 01:22:12"
/// updated_at : "2020-12-01 01:22:12"

class User {
  int _id;
  String _name;
  String _email;
  dynamic _emailVerifiedAt;
  dynamic _avatar;
  dynamic _phoneNumber;
  dynamic _facebook;
  dynamic _instagram;
  int _isAdmin;
  int _status;
  String _createdAt;
  String _updatedAt;

  int get id => _id;
  String get name => _name;
  String get email => _email;
  dynamic get emailVerifiedAt => _emailVerifiedAt;
  dynamic get avatar => _avatar;
  dynamic get phoneNumber => _phoneNumber;
  dynamic get facebook => _facebook;
  dynamic get instagram => _instagram;
  int get isAdmin => _isAdmin;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  User({
      int id, 
      String name, 
      String email, 
      dynamic emailVerifiedAt, 
      dynamic avatar, 
      dynamic phoneNumber, 
      dynamic facebook, 
      dynamic instagram, 
      int isAdmin, 
      int status, 
      String createdAt, 
      String updatedAt}){
    _id = id;
    _name = name;
    _email = email;
    _emailVerifiedAt = emailVerifiedAt;
    _avatar = avatar;
    _phoneNumber = phoneNumber;
    _facebook = facebook;
    _instagram = instagram;
    _isAdmin = isAdmin;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  User.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _email = json["email"];
    _emailVerifiedAt = json["email_verified_at"];
    _avatar = json["avatar"];
    _phoneNumber = json["phone_number"];
    _facebook = json["facebook"];
    _instagram = json["instagram"];
    _isAdmin = json["is_admin"];
    _status = json["status"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["email"] = _email;
    map["email_verified_at"] = _emailVerifiedAt;
    map["avatar"] = _avatar;
    map["phone_number"] = _phoneNumber;
    map["facebook"] = _facebook;
    map["instagram"] = _instagram;
    map["is_admin"] = _isAdmin;
    map["status"] = _status;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }

}