import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mt_app/shared/models/trainer_model.dart';

import '../models/user_model.dart';
import '../util/constants.dart';

class TrainerService {
  TrainerService();

  CollectionReference trainersRef = FirebaseFirestore.instance.collection(PERSONAL_TRAINERS_COLLECTION);


  Future<List<TrainerModel>> getAllTrainers() async {
    try {
      var query = await trainersRef.where('status', isEqualTo: STATUS_ACTIVE).get();
      List<TrainerModel> list = [];

      for (var doc in query.docs) {
        Map data = doc.data();
        DocumentReference ref = FirebaseFirestore.instance
            .doc(data['userRef']);
        UserModel user = UserModel.fromFirestore(await ref.get());
        TrainerModel trainerModel = TrainerModel.fromFirestore(doc, user);
        list.add(trainerModel);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamTrainers() {
    return trainersRef
        .where('status', isEqualTo: STATUS_ACTIVE).snapshots();
  }

  Future<List<TrainerModel>> trainerModels(var docs) async {
    List<TrainerModel> list = [];
    for (var doc in docs) {
      Map data = doc.data();
      DocumentReference ref = await FirebaseFirestore.instance
          .doc(data['userRef']);
      UserModel user = UserModel.fromFirestore(await ref.get());
      TrainerModel trainerModel = TrainerModel.fromFirestore(doc, user);
      list.add(trainerModel);
    }
    return list;
  }

  Future<TrainerModel> getTrainerById(String userId) async {
    var query = await trainersRef
        .where('userRef', isEqualTo: 'users/$userId')
        .limit(1)
        .get();
    TrainerModel trainerModel;
    for (var doc in query.docs) {
      Map data = doc.data();
      DocumentReference ref = await FirebaseFirestore.instance
          .doc(data['userRef']);
      UserModel user = UserModel.fromFirestore(await ref.get());
      trainerModel = TrainerModel.fromFirestore(doc, user);
    }
    return trainerModel;
  }

  Future<void> updateTrainer(TrainerModel trainer) async {
    await trainersRef.doc(trainer.id).set(trainer.toMap());
    DocumentReference userRef =
    FirebaseFirestore.instance.doc(trainer.userRef);
    await userRef.update({
      'firstName': trainer.user.firstName,
      'lastName': trainer.user.lastName
    });
  }

}