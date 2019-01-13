import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'package:hybrid_app/data/model/user/User.g.dart';

@JsonSerializable()
class User {
  String id;
  String name;

  User(this.id, this.name);

  User.empty() {
    this.id = "";
    this.name = "";
  }

  User.fromName(String name) {
    this.id = Uuid().v4();
    this.name = name;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
