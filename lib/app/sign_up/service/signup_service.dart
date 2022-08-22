import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mt_app/app/sign_up/model/user_entity.dart';
import 'package:mt_app/shared/util/constants.dart';

class SignUpService {
  SignUpService();

  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference usersRef =
      FirebaseFirestore.instance.collection(USERS_COLLECTION);

  Future<void> signUp(UserEntity user) {
    try {
      auth
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password)
          .then((firebaseUser) {
        usersRef.doc(firebaseUser.user.uid).set(user.toMap());

        CollectionReference ref = FirebaseFirestore.instance.collection(
            user.type == STUDENT_TYPE ? STUDENTS_COLLECTION : PERSONAL_TRAINERS_COLLECTION);
        String id = ref.doc().id;
        ref.doc(id).set({
          'id': id,
          'userRef': '${usersRef.path}/${firebaseUser.user.uid}',
          'status': STATUS_ACTIVE,
          'createdAt': Timestamp.now()
        });
      });
    } catch (error) {
      rethrow;
    }
  }
}
