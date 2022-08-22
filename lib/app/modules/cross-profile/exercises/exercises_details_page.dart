import 'package:flutter/material.dart';
import 'package:mt_app/shared/models/exercise_plans_model.dart';

class ExercisesDetailsPage extends StatefulWidget {
  ExercisePlansModel exercises;
  ExercisesDetailsPage({Key key, this.exercises}) : super(key: key);

  @override
  State<ExercisesDetailsPage> createState() => _ExercisesDetailsPageState();
}

class _ExercisesDetailsPageState extends State<ExercisesDetailsPage> {

  Widget _exerciseOfTheDayWidget(ExercisePlansModel exercise, bool exerciseOfTheDay, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                      Text(exercise.exercises[index].targetMuscle,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      Text(exercise.exercises[index].name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Text('Sér/Rep: '),
                            Text(
                                '${exercise.exercises[index].series.toString()}/${exercise.exercises[index].frequency.toString()}'),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text('Cadência: '),
                          Text(exercise.exercises[index].cadence.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Cadência: '),
                          Text(exercise.exercises[index].restTime.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
        title: Text('Detalhes do Treino'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
            child: Text(widget.exercises.day,
                style: TextStyle(
                    color: Color(0xffd50032),
                    fontSize: 40,
                    fontWeight: FontWeight.w800)),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: widget.exercises.exercises.length,
                itemBuilder: (_, index) {
                  // List<ExercisePlansModel> itens =
                  //     _exercises;
                  // ExercisePlansModel exercise =
                  //     itens[index];
                  return _exerciseOfTheDayWidget(widget.exercises, false, index);
                }),
          ),
        ],
      ),
    );
  }
}
