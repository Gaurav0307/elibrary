import 'dart:convert';
/// users : [{"_id":"66a3b2e873abd21be8be1e91","name":"Test User 2","email":"user2@email.com","imageUrl":"files\\picture\\1722439425857-409660075-abstract-colorful.jpg","createdAt":"2024-07-26T14:30:00.574Z","updatedAt":"2024-07-31T15:23:45.904Z","__v":15}]

UsersModel usersModelFromJson(String str) => UsersModel.fromJson(json.decode(str));
String usersModelToJson(UsersModel data) => json.encode(data.toJson());
class UsersModel {
  UsersModel({
      this.users,});

  UsersModel.fromJson(dynamic json) {
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users?.add(Users.fromJson(v));
      });
    }
  }
  List<Users>? users;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (users != null) {
      map['users'] = users?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// _id : "66a3b2e873abd21be8be1e91"
/// name : "Test User 2"
/// email : "user2@email.com"
/// imageUrl : "files\\picture\\1722439425857-409660075-abstract-colorful.jpg"
/// createdAt : "2024-07-26T14:30:00.574Z"
/// updatedAt : "2024-07-31T15:23:45.904Z"
/// __v : 15

Users usersFromJson(String str) => Users.fromJson(json.decode(str));
String usersToJson(Users data) => json.encode(data.toJson());
class Users {
  Users({
      this.id, 
      this.name, 
      this.email, 
      this.imageUrl, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  Users.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    imageUrl = json['imageUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  String? name;
  String? email;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['imageUrl'] = imageUrl;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}