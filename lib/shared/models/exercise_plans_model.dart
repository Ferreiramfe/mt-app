import 'package:cloud_firestore/cloud_firestore.dart';

class ExercisePlansModel {
  String id;
  String type;
  String name;
  String exerciseRegion;
  String targetMuscle;
  int series;
  int frequency;
  int cadence;
  int restTime;
  String day;
  Timestamp createdAt;
  String status;


  ExercisePlansModel({
    this.id,
    this.type,
    this.name,
    this.exerciseRegion,
    this.targetMuscle,
    this.series,
    this.frequency,
    this.cadence,
    this.restTime,
    this.day,
    this.createdAt,
    this.status
  });

  factory ExercisePlansModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return ExercisePlansModel(
        id: doc.id,
        type: data['type'],
        name: data['name'],
        exerciseRegion: data['exerciseRegion'],
        targetMuscle: data['targetMuscle'],
        series: data['series'],
        frequency: data['frequency'],
        cadence: data['cadence'],
        restTime: data['restTime'],
        day: data['day'],
        createdAt: data['createdAt'],
        status: data['status']
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "type": this.type,
      "name": this.name,
      "exerciseRegion": this.exerciseRegion,
      "targetMuscle": this.targetMuscle,
      "series": this.series,
      "frequency": this.frequency,
      "cadence": this.cadence,
      "restTime": this.restTime,
      "day": this.day,
      "createdAt": this.createdAt,
      "status": this.status,
    };
    return map;
  }
}
