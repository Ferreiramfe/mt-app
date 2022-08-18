import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mt_app/shared/models/students_model.dart';
import 'package:mt_app/shared/models/user_model.dart';

import '../util/constants.dart';

class StudentService {
  StudentService();

  CollectionReference studentsRef = FirebaseFirestore.instance.collection(STUDENTS_COLLECTION);

  Future<void> contractPersnal(StudentModel studentModel) async {
    studentModel.userRef = '$USERS_COLLECTION/${studentModel.id}';
    await studentsRef.add(studentModel.toMap());
  }

  Future<List<StudentModel>> getStudentsFromTrainerId(String trainerId) async {
    var query = await studentsRef
        .where('trainerId', isEqualTo: trainerId)
        .get();
    List<StudentModel> list = [];
    
    for (var doc in query.docs) {
      Map data = doc.data();
      DocumentReference ref = FirebaseFirestore.instance
          .doc(data['userRef']);
      UserModel user = UserModel.fromFirestore(await ref.get());
      StudentModel student = StudentModel.fromFirestore(doc, user);
      list.add(student);
    }
    return list;
  }
}