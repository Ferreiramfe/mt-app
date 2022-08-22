import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerModel {
  String id;
  DocumentReference userRef;
  DocumentReference studentRef;
  Timestamp createdAt;
  String status;

  TrainerModel({this.id, this.userRef, this.studentRef, this.createdAt, this.status});

  factory TrainerModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return TrainerModel(
        id: doc.id,
        userRef: data['userRef'],
        studentRef: data['trainerRef'],
        createdAt: data['createdAt'],
        status: data['status']
    );
  }
}