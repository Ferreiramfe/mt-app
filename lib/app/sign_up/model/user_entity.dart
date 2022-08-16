import 'package:mt_app/app/sign_up/enum/user_type_enum.dart';

class UserEntity {
  String _id;
  String _name;
  String _email;
  String _password;
  String _type;

  UserEntity();

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "name"        : this.name,
      "email"       : this.email,
      "type"        : this.type,
    };
    return map;

  }
  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }
}