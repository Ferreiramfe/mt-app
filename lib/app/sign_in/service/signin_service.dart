import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mt_app/app/sign_up/model/user_entity.dart';
import 'package:mt_app/shared/models/user_model.dart';

import '../../../shared/util/constants.dart';

class SignInService {
  SignInService();
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference usersRef =
      FirebaseFirestore.instance.collection(USERS_COLLECTION);

  Future<String> signUser(UserEntity user) {
    return auth
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .then((firebaseUser) => firebaseUser.user.uid)
        .catchError((error) =>
            "Erro ao autenticar usuário, verifique e-mail e senha e tente novamente!");
  }

  Future<UserModel> getUser(String userId) async {
    final user = await usersRef.doc(userId).get();
    if (user.exists) {
      final Map data = user.data();
      return UserModel(data);
    }
  }
}
