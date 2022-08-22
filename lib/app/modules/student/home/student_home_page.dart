import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mt_app/shared/models/students_model.dart';
import 'package:mt_app/shared/models/trainer_model.dart';
import 'package:mt_app/shared/services/student_service.dart';
import 'package:mt_app/shared/services/trainer_service.dart';
import 'package:mt_app/shared/services/user_services.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final TextEditingController _searchController = TextEditingController();
  List<TrainerModel> _trainers;
  List<TrainerModel> _filteredTrainers;
  StudentModel _student;
  User _user;
  String _uid;
  bool _loading = false;
  bool _loadingMyTrainer = false;
  UserServices userServices = UserServices();
  TrainerService trainerService = TrainerService();
  StudentService studentService = StudentService();

  getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _user = await auth.currentUser;
    _uid = _user.uid;
    await studentService.getStudentById(_uid).then((value) {
      setState(() {
        _student = value;
      });
    });
  }

  getPersonalTrainers() async {
    _trainers = await trainerService.getAllTrainers();
  }

  _contractService(String trainerId) async {
    try {
      setState(() {
        _student.trainerId = trainerId;
      });

      await studentService.contractPersnal(_student);
      setState(() {
        _loading = false;
        _loadingMyTrainer = false;
      });
    } catch (error) {
      setState(() {
        _loading = false;
        _loadingMyTrainer = false;
      });
    }
  }

  TrainerModel _findMyPersoanlTrainer() {
    try {
      return _trainers.singleWhere((element) => element.id == _student.trainerId);
    } catch (e) {
      return null;
    }
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
        onChanged: (val) {},
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {
                  List<TrainerModel> list = [];
                  for (TrainerModel trainer in _trainers) {
                    if (trainer.user.firstName
                        .contains(_searchController.text) ||
                        trainer.user.lastName
                            .contains(_searchController.text) ||
                        trainer.user.email.contains(_searchController.text)) {
                      list.add(trainer);
                    }
                  }
                  _filteredTrainers = list;
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

  Widget _personalTrainerCard({TrainerModel trainer}) {
    return
      trainer.id == _student.trainerId
      ? Center() :
      Card(
      child: Padding(
        padding:
            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    maxRadius: 50,
                    backgroundColor: Colors.deepOrangeAccent,
                    child: Text(
                      '${trainer.user.firstName[0]}${trainer.user.lastName[0]}',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${trainer.user.firstName} ${trainer.user.lastName}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(trainer.user.email),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('PERSONAL TRAINER'),
                    )
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Card(
                    color: Colors.white60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('R\$ 31212',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: 20)),
                          Center(child: Text('por mês'))
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                          onPressed: () {},
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, bottom: 16.0),
                            child: Text('Detalhes',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 16)),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.deepOrange.withAlpha(0)),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.deepOrange.withAlpha(0)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: const Color(0xffd50032)))))),
                    ),
                    _loading == false
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _loading = true;
                          });
                          _contractService(trainer.id);
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 16.0),
                          child: Text('Cadastrar',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white)),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffd50032)),
                            shadowColor: MaterialStateProperty.all<Color>(
                                const Color(0xffd50032)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: const Color(0xffd50032))))))
                    : const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _myPersonalTrainerCard({TrainerModel trainer}) {
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
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    maxRadius: 50,
                    backgroundColor: Colors.deepOrangeAccent,
                    child: Text(
                      '${trainer.user.firstName[0]}${trainer.user.lastName[0]}',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${trainer.user.firstName} ${trainer.user.lastName}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(trainer.user.email),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('PERSONAL TRAINER'),
                    )
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Card(
                    color: Colors.white60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('R\$ 31212',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: 20)),
                          Center(child: Text('por mês'))
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                          onPressed: () {},
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, bottom: 16.0),
                            child: Text('Detalhes',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 16)),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.deepOrange.withAlpha(0)),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.deepOrange.withAlpha(0)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Colors.deepOrange))))),
                    ),
                    _loadingMyTrainer == false
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _loadingMyTrainer = true;
                          });
                          _contractService(null);
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 16.0),
                          child: Text(
                              'Cancelar',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87)),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange.withAlpha(0)),
                            shadowColor: MaterialStateProperty.all<Color>(
                                Colors.deepOrange.withAlpha(0)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)))))
                    : const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _streamTrainers() {
    return trainerService.streamTrainers();
  }

  _buildTrainerModel(var data) {
    trainerService.trainerModels(data).then((value) {
      setState(() {
        _trainers = value;
        _filteredTrainers = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instrutores'),
      ),
      drawer: Drawer(),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _streamTrainers(),
              builder: (builder, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_searchController.text.length == 0) {
                  _buildTrainerModel(snapshot.data.docs);
                }
                return _filteredTrainers != null && _filteredTrainers.length > 0
                    ? Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Meu Personal Trainer', style:
                                    TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    )),
                                  _findMyPersoanlTrainer() != null
                                      ? _myPersonalTrainerCard(trainer: _findMyPersoanlTrainer())
                                      : Padding(
                                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
                                    child: Center(child: Text('Você não possui personal trainers')),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: ListView.builder(
                                itemCount: _filteredTrainers.length,
                                itemBuilder: (context, index) {
                                  return _personalTrainerCard(
                                      trainer: _filteredTrainers[index]);
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
                            child: CircularProgressIndicator(),
                          )
                        ],
                      );
              })
        ],
      ),
    );
  }
}
