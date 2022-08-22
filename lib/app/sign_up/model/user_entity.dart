import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mt_app/app/sign_up/enum/user_type_enum.dart';

class UserEntity {
  String _id;
  String _name;
  String _email;
  String _password;
  String _type;
  Timestamp _timestamp;

  UserEntity();

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "name"        : this.name,
      "email"       : this.email,
      "type"        : this.type,
      "timestamp"   : this._timestamp
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

  Timestamp get timestamp => _timestamp;

  set timestamp(Timestamp value) {
    _timestamp = value;
  }
}