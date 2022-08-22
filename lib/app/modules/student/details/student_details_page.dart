import 'package:flutter/material.dart';
import 'package:mt_app/shared/models/exercise_plans_model.dart';
import 'package:mt_app/shared/models/students_model.dart';
import 'package:mt_app/shared/services/exercise_plans_services.dart';
import 'package:intl/intl.dart';

class StudentDetailsPage extends StatefulWidget {
  StudentModel student;
  StudentDetailsPage({Key key, this.student}) : super(key: key);

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  var _days = {
    'SUNDAY': 'DOMINGO',
    'MONDAY': 'SEGUNDA',
    'TUESDAY': 'TERÇA',
    'WEDNESDAY': 'QUARTA',
    'THURSDAY': 'QUINTA',
    'FRIDAY': 'SEXTA',
    'SATURDAY': 'SÁBADO',
  };

  var _exerciseOfTheDay;

  Future<List<ExercisePlansModel>> _getExercises() async {
    ExercisePlansServices exerciseServices = ExercisePlansServices();
    List<ExercisePlansModel> result =
        await exerciseServices.getExercises(widget.student.id);
    DateTime date = DateTime.now();
    String currentDay = DateFormat('EEEE').format(date).toUpperCase();
    _exerciseOfTheDay = result.singleWhere(
        (element) => element.day.toUpperCase() == _days[currentDay]);
    if (_exerciseOfTheDay != -1) {
      result.remove(_exerciseOfTheDay);
    }
    return result;
  }

  Widget _exerciseOfTheDayWidget(ExercisePlansModel exercise, bool exerciseOfTheDay) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            exerciseOfTheDay
                ? Text('Treino do Dia',
                style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 30,
                    fontWeight: FontWeight.w800))
                : Center(),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(exercise.day.substring(0, 3),
                      style: TextStyle(
                          color: Colors.deepOrange,
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
                      Text(exercise.targetMuscle,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      Text(exercise.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Text('Sér/Rep: '),
                            Text(
                                '${exercise.series.toString()}/${exercise.frequency.toString()}'),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text('Cadência: '),
                          Text(exercise.cadence.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Cadência: '),
                          Text(exercise.restTime.toString()),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _exerciseCard({ExercisePlansModel exercise}) {
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
                  children: [Text(exercise.name), Text(exercise.type)],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    child: Text(
                      "Detalhes",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExercisePlansModel>>(
        future: _getExercises(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Scaffold(
                appBar: AppBar(title: Text('Tela Inicial')),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/student_exercise_form',
                        arguments: widget.student);
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.navigation),
                ),
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
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/student_exercise_form',
                        arguments: widget.student);
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.navigation),
                ),
                body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: snapshot.data != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _exerciseOfTheDayWidget(_exerciseOfTheDay, true),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (_, index) {
                                      List<ExercisePlansModel> itens =
                                          snapshot.data;
                                      ExercisePlansModel exercise =
                                          itens[index];
                                      return _exerciseOfTheDayWidget(exercise, false);
                                    }),
                              ),
                            ],
                          )
                        : Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Não foi possível encontrar o dado',
                                  style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800)),
                            ],
                          ))),
              );
              break;
          }
        });
  }
}
