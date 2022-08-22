import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'exercise_model.dart';

class ExercisePlansModel {
  String id;
  String type;
  String exerciseRegion;
  String day;
  Timestamp createdAt;
  String status;
  List<ExerciseModel> exercises;

  ExercisePlansModel({
    this.id,
    this.type,
    this.exerciseRegion,
    this.day,
    this.createdAt,
    this.status,
    this.exercises
  });

  factory ExercisePlansModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    List<ExerciseModel> list = [];
    List exercises = data['exercises'];
    for (dynamic element in exercises) {
      ExerciseModel exerciseModel = ExerciseModel(
          name: element['name'],
          targetMuscle: element['targetMuscle'],
          series: element['series'],
          frequency: element['frequency'],
          cadence: element['cadence'],
          restTime: element['restTime']
      );
      list.add(exerciseModel);
    }
    return ExercisePlansModel(
        id: doc.id,
        type: data['type'],
        exerciseRegion: data['exerciseRegion'],
        day: data['day'],
        exercises: list,
        createdAt: data['createdAt'],
        status: data['status']
    );
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> exercisesMap = [];
    for (ExerciseModel exercise in this.exercises) {
      exercisesMap.add({
        "name": exercise.name,
        "targetMuscle": exercise.targetMuscle,
        "series": exercise.series,
        "frequency": exercise.frequency,
        "cadence": exercise.cadence,
        "restTime": exercise.restTime,
      });
    }
    Map<String, dynamic> map = {
      "id": this.id,
      "type": this.type,
      "exerciseRegion": this.exerciseRegion,
      "day": this.day,
      "exercises": exercisesMap,
      "createdAt": this.createdAt,
      "status": this.status,
    };
    return map;
  }
}
