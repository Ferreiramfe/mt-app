import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  String _id;
  String _firstName;
  String _lastName;
  String _email;
  String _password;
  String _type;
  Timestamp _timestamp;

  UserEntity();

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "firstName"        : this.firstName,
      "lastName"        : this.lastName,
      "email"       : this.email,
      "type"        : this.type,
      "timestamp"   : this.timestamp
    };
    return map;

  }
  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  Timestamp get timestamp => _timestamp;

  set timestamp(Timestamp value) {
    _timestamp = value;
  }

  String get lastName => _lastName;

  set lastName(String value) {
    _lastName = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }
}