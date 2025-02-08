import 'dart:convert';

/// chats : [{"_id":"66a4c5e138fa16a6731dacae","type":"text","message":"Hi","file":null,"sender":{"_id":"66a3ae5321b9cf1691ab31aa","name":"Test User One","email":"user1@email.com"},"receiver":{"_id":"66a3b2e873abd21be8be1e91","name":"Test User Two","email":"user2@email.com"},"createdAt":"2024-07-27T10:03:13.958Z","updatedAt":"2024-07-27T10:03:13.958Z","__v":0},{"_id":"66a4c7a438fa16a6731dacc5","type":"text","message":"Hi","file":null,"sender":{"_id":"66a3b2e873abd21be8be1e91","name":"Test User Two","email":"user2@email.com"},"receiver":{"_id":"66a3ae5321b9cf1691ab31aa","name":"Test User One","email":"user1@email.com"},"createdAt":"2024-07-27T10:10:44.012Z","updatedAt":"2024-07-27T10:10:44.012Z","__v":0},{"_id":"66a4d3d037ad51280fb4907a","type":"text","message":"How are you?","file":"files\\image\\1722078160567-465029864-colored-leaves.jpg","sender":{"_id":"66a3b2e873abd21be8be1e91","name":"Test User Two","email":"user2@email.com"},"receiver":{"_id":"66a3ae5321b9cf1691ab31aa","name":"Test User One","email":"user1@email.com"},"createdAt":"2024-07-27T11:02:40.611Z","updatedAt":"2024-07-27T11:02:40.611Z","__v":0}]

ChatsModel chatsModelFromJson(String str) =>
    ChatsModel.fromJson(json.decode(str));

String chatsModelToJson(ChatsModel data) => json.encode(data.toJson());

class ChatsModel {
  ChatsModel({
    this.chats,
  });

  ChatsModel.fromJson(dynamic json) {
    if (json['chats'] != null) {
      chats = [];
      json['chats'].forEach((v) {
        chats?.add(Chats.fromJson(v));
      });
    }
  }

  List<Chats>? chats;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (chats != null) {
      map['chats'] = chats?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// _id : "66a4c5e138fa16a6731dacae"
/// type : "text"
/// message : "Hi"
/// file : null
/// sender : {"_id":"66a3ae5321b9cf1691ab31aa","name":"Test User One","email":"user1@email.com"}
/// receiver : {"_id":"66a3b2e873abd21be8be1e91","name":"Test User Two","email":"user2@email.com"}
/// createdAt : "2024-07-27T10:03:13.958Z"
/// updatedAt : "2024-07-27T10:03:13.958Z"
/// __v : 0

Chats chatsFromJson(String str) => Chats.fromJson(json.decode(str));

String chatsToJson(Chats data) => json.encode(data.toJson());

class Chats {
  Chats({
    this.id,
    this.type,
    this.message,
    this.file,
    this.sender,
    this.receiver,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Chats.fromJson(dynamic json) {
    id = json['_id'];
    type = json['type'];
    message = json['message'];
    file = json['file'];
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    receiver =
        json['receiver'] != null ? Receiver.fromJson(json['receiver']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  String? id;
  String? type;
  String? message;
  String? file;
  Sender? sender;
  Receiver? receiver;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['type'] = type;
    map['message'] = message;
    map['file'] = file;
    if (sender != null) {
      map['sender'] = sender?.toJson();
    }
    if (receiver != null) {
      map['receiver'] = receiver?.toJson();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}

/// _id : "66a3b2e873abd21be8be1e91"
/// name : "Test User Two"
/// email : "user2@email.com"

Receiver receiverFromJson(String str) => Receiver.fromJson(json.decode(str));

String receiverToJson(Receiver data) => json.encode(data.toJson());

class Receiver {
  Receiver({
    this.id,
    this.name,
    this.email,
  });

  Receiver.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
  }

  String? id;
  String? name;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['email'] = email;
    return map;
  }
}

/// _id : "66a3ae5321b9cf1691ab31aa"
/// name : "Test User One"
/// email : "user1@email.com"

Sender senderFromJson(String str) => Sender.fromJson(json.decode(str));

String senderToJson(Sender data) => json.encode(data.toJson());

class Sender {
  Sender({
    this.id,
    this.name,
    this.email,
  });

  Sender.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
  }

  String? id;
  String? name;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['email'] = email;
    return map;
  }
}
