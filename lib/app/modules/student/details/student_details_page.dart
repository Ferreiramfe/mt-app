import 'package:flutter/material.dart';
import 'package:mt_app/shared/models/exercise_plans_model.dart';
import 'package:mt_app/shared/models/students_model.dart';
import 'package:mt_app/shared/services/exercise_plans_services.dart';
import 'package:intl/intl.dart';

import '../../../../shared/models/exercise_model.dart';

class StudentDetailsPage extends StatefulWidget {
  StudentModel student;
  StudentDetailsPage({Key key, this.student}) : super(key: key);

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  TextEditingController _searchController = TextEditingController();
  ExercisePlansModel _exerciseOfTheDay;
  List<ExercisePlansModel> _exercises;
  var _days = {
    'SUNDAY': 'DOMINGO',
    'MONDAY': 'SEGUNDA',
    'TUESDAY': 'TERÇA',
    'WEDNESDAY': 'QUARTA',
    'THURSDAY': 'QUINTA',
    'FRIDAY': 'SEXTA',
    'SATURDAY': 'SÁBADO',
  };

  Future<List<ExercisePlansModel>> _getExercises() async {
    ExercisePlansServices exerciseServices = ExercisePlansServices();
    List<ExercisePlansModel> result =
        await exerciseServices.getExercises(widget.student.id);
    DateTime date = DateTime.now();
    String currentDay = DateFormat('EEEE').format(date).toUpperCase();

    _exercises = result;
    _exerciseOfTheDay = result.singleWhere(
            (element) => element.day.toUpperCase() == _days[currentDay]);
    if (_exerciseOfTheDay != -1) {
      result.remove(_exerciseOfTheDay);
    }

    return result;
  }

  Widget _exerciseOfTheDayWidget(ExercisePlansModel exercise, bool exerciseOfTheDay) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/exercise_details', arguments: exercise);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              exerciseOfTheDay
                  ? Text('Treino do Dia',
                  style: TextStyle(
                      color: const Color(0xffd50032),
                      fontSize: 20,
                      fontWeight: FontWeight.w800))
                  : Center(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(exercise.day.substring(0, 3),
                        style: TextStyle(
                            color: const Color(0xffd50032),
                            fontSize: 60,
                            fontWeight: FontWeight.w800)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exercise.type,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800)),
                        Text(exercise.exerciseRegion,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Qtd Exercícios: ${exercise.exercises.length.toString()}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _personalTrainerCard(StudentModel student) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: CircleAvatar(
                    maxRadius: 70,
                    backgroundColor: const Color(0xffd50032),
                    child: Text('${student.user.firstName[0]}${student.user.lastName[0]}',
                      style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(student.user.firstName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(student.user.email),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                )],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do aluno'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/student_exercise_form',
              arguments: widget.student);
        },
        backgroundColor:const Color(0xffd50032),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          FutureBuilder<List<ExercisePlansModel>>(
              future: _getExercises(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Column(
                      children: [
                        _personalTrainerCard(widget.student),
                        Text('Usuario nao possui treinos'),
                      ],
                    );
                  case ConnectionState.waiting:
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator()
                        ],
                      ),
                    );
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _personalTrainerCard(widget.student),
                          _exercises != null && _exercises.length > 0
                          ? Expanded(
                            child: Column(
                              children: [
                                _exerciseOfTheDay != null ? _exerciseOfTheDayWidget(_exerciseOfTheDay, true) : Center(),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: _exercises.length,
                                      itemBuilder: (_, index) {
                                        // List<ExercisePlansModel> itens =
                                        //     _exercises;
                                        // ExercisePlansModel exercise =
                                        //     itens[index];
                                        return _exerciseOfTheDayWidget(_exercises[index], false);
                                      }),
                                ),
                              ],
                            ),
                          )
                          : Padding(
                            padding: const EdgeInsets.only(top: 48.0),
                            child: Center(child: Text('Usuário nao possui treinos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
                          ),
                        ],
                      ),
                    );
                    break;
                }
              }),
        ],
      ),
    );
  }
}
