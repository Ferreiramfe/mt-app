import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mt_app/shared/models/exercise_plans_model.dart';

import '../util/constants.dart';

class ExercisePlansServices {
  ExercisePlansServices();

  CollectionReference studentRef =
      FirebaseFirestore.instance.collection(STUDENTS_COLLECTION);

  Future<void> createExercisePlan(String userId, ExercisePlansModel exercise) async {
    List<ExercisePlansModel> exercisesList = await getExercises(userId);
    int index = exercisesList.indexWhere((element) => element.day == exercise.day);
    if (index != -1) {
      ExercisePlansModel oldEx = exercisesList[index];
      oldEx.status = 'INACTIVE';
      await studentRef
          .doc(userId)
          .collection(EXERCISE_PLANS_COLLECTION)
          .doc(oldEx.id).update(oldEx.toMap());
    }
    exercise.createdAt = Timestamp.now();
    await studentRef
        .doc(userId)
        .collection(EXERCISE_PLANS_COLLECTION)
        .doc().set(exercise.toMap());
  }

  Future<List<ExercisePlansModel>> getExercises(String userId) async {
    var res = await studentRef.doc(userId).collection(EXERCISE_PLANS_COLLECTION).where('status', isEqualTo: 'ACTIVE').get();
    return res.docs.map((doc) => ExercisePlansModel.fromFirestore(doc)).toList();
  }
}
