import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String email;
  String firstName;
  String lastName;
  String type;
  Timestamp createdAt;
  String status;

  UserModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.type,
    this.createdAt,
    this.status
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return UserModel(
        id: doc.id,
        email: data['email'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        type: data['type'],
        createdAt: data['createdAt'],
        status: data['status']);
  }
}
