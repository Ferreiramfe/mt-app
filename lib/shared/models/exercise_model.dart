import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseModel {
  String name;
  String targetMuscle;
  int series;
  int frequency;
  int cadence;
  int restTime;

  ExerciseModel({
    this.name,
    this.targetMuscle,
    this.series,
    this.frequency,
    this.cadence,
    this.restTime,
  });

  factory ExerciseModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return ExerciseModel(
        name: data['name'],
        targetMuscle: data['targetMuscle'],
        series: data['series'],
        frequency: data['frequency'],
        cadence: data['cadence'],
        restTime: data['restTime'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": this.name,
      "targetMuscle": this.targetMuscle,
      "series": this.series,
      "frequency": this.frequency,
      "cadence": this.cadence,
      "restTime": this.restTime,
    };
    return map;
  }
}
