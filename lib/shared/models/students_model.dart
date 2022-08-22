import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mt_app/shared/models/user_model.dart';


class StudentModel {
  String id;
  String userRef;
  String trainerId;
  Timestamp createdAt;
  String status;
  UserModel user;
  String imageRef;

  StudentModel({this.id, this.userRef, this.trainerId, this.createdAt, this.status, this.user, this.imageRef});

  factory StudentModel.fromFirestore(DocumentSnapshot doc, UserModel user) {
    Map data = doc.data();
    return StudentModel(
        id: doc.id,
        userRef: data['userRef'],
        trainerId: data['trainerId'],
        createdAt: data['createdAt'],
        status: data['status'],
        user: user,
        imageRef: data['imageRef']
    );
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "userRef": this.userRef,
      "trainerId": this.trainerId,
      "createdAt": this.createdAt,
      "status": this.status,
      "imageRef": this.imageRef
    };
    return map;
  }
}
