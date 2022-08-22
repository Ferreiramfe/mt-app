import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mt_app/shared/models/students_model.dart';
import 'package:mt_app/shared/models/user_model.dart';

import '../util/constants.dart';

class StudentService {
  StudentService();

  CollectionReference studentsRef =
      FirebaseFirestore.instance.collection(STUDENTS_COLLECTION);

  Future<void> contractPersnal(StudentModel studentModel) async {
    await studentsRef
        .doc(studentModel.id)
        .update({'trainerId': studentModel.trainerId});
  }

  Future<List<StudentModel>> getStudentsFromTrainerId(String trainerId) async {
    var query =
        await studentsRef.where('trainerId', isEqualTo: trainerId).get();
    List<StudentModel> list = [];

    for (var doc in query.docs) {
      Map data = doc.data();
      DocumentReference ref = FirebaseFirestore.instance.doc(data['userRef']);
      UserModel user = UserModel.fromFirestore(await ref.get());
      StudentModel student = StudentModel.fromFirestore(doc, user);
      list.add(student);
    }
    return list;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamStudents(String trainerId) {
    return studentsRef
        .where('status', isEqualTo: STATUS_ACTIVE)
        .where('trainerId', isEqualTo: trainerId)
        .snapshots();
  }

  Future<StudentModel> getStudentById(String userId) async {
    var query = await studentsRef
        .where('userRef', isEqualTo: 'users/$userId')
        .limit(1)
        .get();
    StudentModel student;

    for (var doc in query.docs) {
      Map data = doc.data();
      DocumentReference ref = await FirebaseFirestore.instance
          .doc(data['userRef']);
      UserModel user = UserModel.fromFirestore(await ref.get());
      student = StudentModel.fromFirestore(doc, user);
    }
    return student;
  }

  Future<void> updateStudent(StudentModel student) async {
    await studentsRef.doc(student.id).set(student.toMap());
    DocumentReference userRef =
      FirebaseFirestore.instance.doc(student.userRef);
    await userRef.update({
      'firstName': student.user.firstName,
      'lastName': student.user.lastName
    });
  }

  Future<List<StudentModel>> studentModels(var docs) async {
    List<StudentModel> list = [];
    for (var doc in docs) {
      Map data = doc.data();
      DocumentReference ref = await FirebaseFirestore.instance
          .doc(data['userRef']);
      UserModel user = UserModel.fromFirestore(await ref.get());
      StudentModel studentModel = StudentModel.fromFirestore(doc, user);
      list.add(studentModel);
    }
    return list;
  }
}
