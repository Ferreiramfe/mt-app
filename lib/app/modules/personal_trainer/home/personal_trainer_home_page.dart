import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mt_app/shared/models/students_model.dart';
import 'package:mt_app/shared/services/student_service.dart';
import 'package:mt_app/shared/services/trainer_service.dart';

import '../../../../shared/models/trainer_model.dart';

class PersonalTrainerHomePage extends StatefulWidget {
  const PersonalTrainerHomePage({Key key}) : super(key: key);

  @override
  State<PersonalTrainerHomePage> createState() =>
      _PersonalTrainerHomePageState();
}

class _PersonalTrainerHomePageState extends State<PersonalTrainerHomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _uid;
  StudentService studentService = StudentService();
  TrainerService trainerService = TrainerService();
  TrainerModel _trainer;
  List<StudentModel> _students;
  List<StudentModel> _filteredStudents;
  bool _loadingUser = true;

  getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;
    if (user != null) {
      _uid = user.uid;
      await trainerService.getTrainerById(_uid).then((value) {
        setState(() {
          _trainer = value;
          _loadingUser = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _uid;
    _students;
    _filteredStudents;
    _trainer;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Widget _personalStudentCard({StudentModel student}) {
    return Card(
      child: Padding(
        padding:
            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        maxRadius: 50,
                        backgroundColor: const Color(0xffd50032),
                        backgroundImage: student.imageRef != null
                            ? NetworkImage(student.imageRef)
                            : null,
                        child: student.imageRef == null
                            ? Text(
                                '${student.user.firstName[0]}${student.user.lastName[0]}',
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.user.firstName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(student.user.email),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('ALUNO'),
                    )
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/student_details",
                          arguments: student);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Text('Detalhes',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white)),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffd50032)),
                        shadowColor: MaterialStateProperty.all<Color>(
                            Colors.deepOrange.withAlpha(0)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: const Color(0xffd50032)))))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputTextForm({
    TextEditingController controller,
    String hintText,
    bool autoFocus,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        autofocus: autoFocus,
        controller: controller,
        onFieldSubmitted: (val) {
          List<StudentModel> list = [];
          for (StudentModel student in _students) {
            if (student.user.firstName.contains(val) ||
                student.user.lastName.contains(val) ||
                student.user.email.split('@')[0].contains(val)) {
              list.add(student);
            }
          }
          setState(() {
            _filteredStudents = list;
          });
        },
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {
                  List<StudentModel> list = [];
                  for (StudentModel student in _students) {
                    if (student.user.firstName
                            .contains(_searchController.text) ||
                        student.user.lastName
                            .contains(_searchController.text) ||
                        student.user.email
                            .split('@')[0]
                            .contains(_searchController.text)) {
                      list.add(student);
                    }
                  }
                  setState(() {
                    _filteredStudents = list;
                  });
                },
                icon: Icon(Icons.search, color: const Color(0xffd50032))),
            contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            hintText: hintText,
            labelText: hintText,
            filled: true,
            fillColor: Colors.white,
            hintStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            )),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        },
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _streamStudents() {
    if (_trainer != null) {
      return studentService.streamStudents(_trainer.id);
    }
  }

  _buildStudentModel(var data) {
    studentService.studentModels(data).then((value) {
      setState(() {
        _students = value;
        _filteredStudents = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alunos'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffd50032),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _loadingUser != true
                      ? Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              backgroundImage: _trainer.imageRef != null
                                  ? NetworkImage(_trainer.imageRef)
                                  : null,
                              child: _trainer.imageRef == null
                                  ? Text(
                                      '${_trainer.user.firstName[0]}${_trainer.user.lastName[0]}',
                                      style: TextStyle(
                                          color: Color(0xffd50032),
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold))
                                  : null,
                            ),
                            Text(
                                '${_trainer.user.firstName} ${_trainer.user.lastName[0]}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white))
                          ],
                        )
                      : CircularProgressIndicator(),
                ],
              ),
            ),
            Column(
              children: [
                Column(
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Icon(Icons.home_filled), Text('Inicio')],
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, '/personal_trainer_panel');
                      },
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Icon(Icons.settings), Text('Configurações')],
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/trainer_config',
                            arguments: _trainer);
                      },
                    ),
                  ],
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Icon(Icons.logout), Text('Sair')],
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/', (Route<dynamic> route) => false);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _inputTextForm(
              controller: _searchController,
              hintText: 'Pesquisar',
              autoFocus: false),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _streamStudents(),
              builder: (builder, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (!snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(child: CircularProgressIndicator()),
                    ],
                  );
                }
                if (_searchController.text.length == 0) {
                  _buildStudentModel(snapshot.data.docs);
                }
                return _filteredStudents != null && _filteredStudents.length > 0
                    ? Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: _filteredStudents.length,
                                itemBuilder: (context, index) {
                                  return _personalStudentCard(
                                      student: _filteredStudents[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Center(
                            child: Text('Não há alunos',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                          )
                        ],
                      );
              })
        ],
      ),
    );
  }
}
