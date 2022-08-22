import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mt_app/shared/models/user_model.dart';

import '../util/constants.dart';

class UserServices {
  UserService() {}

  CollectionReference usersRef =
      FirebaseFirestore.instance.collection(USERS_COLLECTION);

  Future<List<UserModel>> getUsersByType(String type) async {
    var res = await usersRef
        .where('type', isEqualTo: type)
        .get();
    return res.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }
}
