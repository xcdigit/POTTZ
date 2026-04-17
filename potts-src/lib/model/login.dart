import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class Login {
  Login(
    this.login,
    this.id,
    this.name,
    this.company,
  );

  String? login;
  String? id;
  String? name;
  String? company;

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  Map<String, dynamic> toJson() => _$LoginToJson(this);

  // 命名构造函数
  Login.empty();
}
