import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mt_app/shared/models/students_model.dart';
import 'package:mt_app/shared/services/student_service.dart';

class PersonalTrainerHomePage extends StatefulWidget {
  const PersonalTrainerHomePage({Key key}) : super(key: key);

  @override
  State<PersonalTrainerHomePage> createState() => _PersonalTrainerHomePageState();
}

class _PersonalTrainerHomePageState extends State<PersonalTrainerHomePage> {
  String _uid;
  StudentService studentService = StudentService();

  Future<List<StudentModel>> _getStudents(String trainerId) async {
    List<StudentModel> result = await studentService.getStudentsFromTrainerId(trainerId);
    return result;
  }

  getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;
    _uid = user.uid;
    _getStudents(_uid);
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Widget _personalTrainerCard({StudentModel student}) {
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
                  children: [Text(student.user.name), Text(student.user.email)],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mensalidade'),
                ElevatedButton(
                    child: Text(
                      "Detalhes",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () {
                      Navigator.pushNamed(
                          context,
                          "/student_details",
                          arguments: student
                      );
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
    return FutureBuilder<List<StudentModel>>(
        future: _getStudents(_uid),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Scaffold(
                appBar: AppBar(title: Text('Alunos')),
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
                  title: Text('Alunos'),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        List<StudentModel> itens = snapshot.data;
                        StudentModel user = itens[index];
                        return _personalTrainerCard(student: user);
                      }),
                ),
              );
              break;
          }
        });
  }
}
