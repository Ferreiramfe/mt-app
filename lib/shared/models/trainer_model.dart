import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mt_app/shared/models/user_model.dart';

class TrainerModel {
  String id;
  String userRef;
  Timestamp createdAt;
  String status;
  UserModel user;
  String description;
  String imageRef;
  String value;

  TrainerModel(
      {this.id,
      this.userRef,
      this.createdAt,
      this.status,
      this.user,
      this.description,
      this.imageRef,
      this.value});

  factory TrainerModel.fromFirestore(DocumentSnapshot doc, UserModel user) {
    Map data = doc.data();
    return TrainerModel(
      id: doc.id,
      userRef: data['userRef'],
      createdAt: data['createdAt'],
      status: data['status'],
      user: user,
      description: data['description'],
      imageRef: data['imageRef'],
      value: data['value'],
    );
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "userRef": this.userRef,
      "createdAt": this.createdAt,
      "status": this.status,
      "description": this.description,
      "imageRef": this.imageRef,
      "value": this.value,
    };
    return map;
  }
}
