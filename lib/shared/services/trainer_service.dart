import 'package:cloud_firestore/cloud_firestore.dart';

import '../util/constants.dart';

class TrainerService {
  TrainerService();

  CollectionReference trainerRef = FirebaseFirestore.instance.collection(STUDENTS_COLLECTION);

}