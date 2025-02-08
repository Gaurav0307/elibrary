import 'dart:convert';
/// user_details : {"_id":"66a3b2e873abd21be8be1e91","name":"Test User 2","email":"user2@email.com","imageUrl":"files\\picture\\1722439425857-409660075-abstract-colorful.jpg","chats":[{"_id":"66a4c65238fa16a6731dacb5","name":"Test User 3","email":"user3@email.com","imageUrl":"files\\picture\\1722439425857-409660075-abstract-colorful.jpg"},{"_id":"66a3ae5321b9cf1691ab31aa","name":"Test User 1","email":"user1@email.com","imageUrl":"files\\picture\\1722439425857-409660075-abstract-colorful.jpg"}],"createdAt":"2024-07-26T14:30:00.574Z","updatedAt":"2024-07-31T15:23:45.904Z","__v":15}

UserDetailsModel userDetailsModelFromJson(String str) => UserDetailsModel.fromJson(json.decode(str));
String userDetailsModelToJson(UserDetailsModel data) => json.encode(data.toJson());
class UserDetailsModel {
  UserDetailsModel({
      this.userDetails,});

  UserDetailsModel.fromJson(dynamic json) {
    userDetails = json['user_details'] != null ? UserDetails.fromJson(json['user_details']) : null;
  }
  UserDetails? userDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (userDetails != null) {
      map['user_details'] = userDetails?.toJson();
    }
    return map;
  }

}

/// _id : "66a3b2e873abd21be8be1e91"
/// name : "Test User 2"
/// email : "user2@email.com"
/// imageUrl : "files\\picture\\1722439425857-409660075-abstract-colorful.jpg"
/// chats : [{"_id":"66a4c65238fa16a6731dacb5","name":"Test User 3","email":"user3@email.com","imageUrl":"files\\picture\\1722439425857-409660075-abstract-colorful.jpg"},{"_id":"66a3ae5321b9cf1691ab31aa","name":"Test User 1","email":"user1@email.com","imageUrl":"files\\picture\\1722439425857-409660075-abstract-colorful.jpg"}]
/// createdAt : "2024-07-26T14:30:00.574Z"
/// updatedAt : "2024-07-31T15:23:45.904Z"
/// __v : 15

UserDetails userDetailsFromJson(String str) => UserDetails.fromJson(json.decode(str));
String userDetailsToJson(UserDetails data) => json.encode(data.toJson());
class UserDetails {
  UserDetails({
      this.id, 
      this.name, 
      this.email, 
      this.imageUrl, 
      this.chats, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  UserDetails.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    imageUrl = json['imageUrl'];
    if (json['chats'] != null) {
      chats = [];
      json['chats'].forEach((v) {
        chats?.add(Chats.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  String? name;
  String? email;
  String? imageUrl;
  List<Chats>? chats;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['imageUrl'] = imageUrl;
    if (chats != null) {
      map['chats'] = chats?.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}

/// _id : "66a4c65238fa16a6731dacb5"
/// name : "Test User 3"
/// email : "user3@email.com"
/// imageUrl : "files\\picture\\1722439425857-409660075-abstract-colorful.jpg"

Chats chatsFromJson(String str) => Chats.fromJson(json.decode(str));
String chatsToJson(Chats data) => json.encode(data.toJson());
class Chats {
  Chats({
      this.id, 
      this.name, 
      this.email, 
      this.imageUrl,});

  Chats.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    imageUrl = json['imageUrl'];
  }
  String? id;
  String? name;
  String? email;
  String? imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['imageUrl'] = imageUrl;
    return map;
  }

}