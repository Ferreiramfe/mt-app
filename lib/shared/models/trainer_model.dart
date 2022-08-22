import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mt_app/shared/models/user_model.dart';

class TrainerModel {
  String id;
  String userRef;
  Timestamp createdAt;
  String status;
  UserModel user;

  TrainerModel({this.id, this.userRef, this.createdAt, this.status, this.user});

  factory TrainerModel.fromFirestore(DocumentSnapshot doc, UserModel user) {
    Map data = doc.data();
    return TrainerModel(
        id: doc.id,
        userRef: data['userRef'],
        createdAt: data['createdAt'],
        status: data['status'],
        user: user
    );
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "userRef": this.userRef,
      "createdAt": this.createdAt,
      "status": this.status,
    };
    return map;
  }
}
