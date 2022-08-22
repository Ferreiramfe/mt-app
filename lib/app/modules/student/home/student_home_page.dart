import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mt_app/shared/models/students_model.dart';
import 'package:mt_app/shared/models/user_model.dart';
import 'package:mt_app/shared/services/student_service.dart';
import 'package:mt_app/shared/services/user_services.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  User _user;
  String _uid;
  bool _loading = false;
  UserServices userServices = UserServices();
  Future<List<UserModel>> _getPersonalTrainers(String type) async {
    List<UserModel> result = await userServices.getUsersByType(type);
    result.removeWhere((user) => user.id == _uid);
    return result;
  }

  getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _user = await auth.currentUser;
    _uid = _user.uid;
  }

  _contractService(UserModel user) async {
    try {
      _loading = true;
      StudentService studentService = StudentService();
      StudentModel studentModel = StudentModel(id: _uid, status: 'ACTIVE', trainerId: user.id, createdAt: Timestamp.now());
      await studentService.contractPersnal(studentModel);
      _loading = false;
    } catch (error) {
      _loading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Widget _personalTrainerCard({UserModel user}) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(top: 8, left: 16.0, right: 16.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        maxRadius: 50,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(user.name), Text(user.email)],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mensalidade'),
                ElevatedButton(
                    child: Text(
                      "Contratar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () {
                      _contractService(user);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
        future: _getPersonalTrainers('PERSONAL_TRAINER'),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Scaffold(
                appBar: AppBar(title: Text('Tela Inicial')),
                body: Center(
                  child: Column(
                    children: <Widget>[
                      Text("Carregando usuários"),
                      CircularProgressIndicator()
                    ],
                  ),
                ),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              return Scaffold(
                appBar: AppBar(
                  title: Text('Tela Inicial'),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        List<UserModel> itens = snapshot.data;
                        UserModel user = itens[index];
                        return _personalTrainerCard(user: user);
                      }),
                ),
              );
              break;
          }
        });
  }
}
