import 'package:flutter/material.dart';
import 'package:mt_app/shared/models/exercise_model.dart';
import 'package:mt_app/shared/models/exercise_plans_model.dart';
import 'package:mt_app/shared/models/students_model.dart';
import 'package:flutter/services.dart';
import 'package:mt_app/shared/services/exercise_plans_services.dart';

class StudentExerciseFormPage extends StatefulWidget {
  StudentModel student;
  StudentExerciseFormPage({Key key, this.student}) : super(key: key);

  @override
  State<StudentExerciseFormPage> createState() =>
      _StudentExerciseFormPageState();
}

class _StudentExerciseFormPageState extends State<StudentExerciseFormPage> {
  int _count;
  bool enable = true;
  List<Map<String, dynamic>> _values;
  bool _enableFloatingActionBtn = false;
  final List _exercisesTypes = [
    'Hipertrofia muscular',
    'Potência muscular',
    'Resistência muscular',
    'Força muscular',
    'Aeróbico'
  ];

  final List _exerciseRegion = ['Superior', 'Inferior', 'Superior/Inferior'];

  final List _dayOfWeek = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo'
  ];

  final Map<String, dynamic> _keys = {
      "name": '',
      "targetMuscle": '',
      "series": '',
      "frequency": '',
      "cadence": '',
      "restTime": '',
  };

  String _selectedExerciseType;
  String _selectedExerciseRegion;
  String _selectedDayOfWeek;

  final _formKey = GlobalKey<FormState>();

  _submit() {
    if (_formKey.currentState.validate()) {
      try {
        ExercisePlansServices exerciseServices = ExercisePlansServices();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Processing Data')),
        );
        List<ExerciseModel> list = [];
        for (var value in _values) {
          ExerciseModel exercise = ExerciseModel(
            name: value['name'],
            targetMuscle: value['targetMuscle'],
            series: int.parse(value['series']),
            frequency: int.parse(value['frequency']),
            cadence: int.parse(value['cadence']),
            restTime: int.parse(value['restTime'])
          );
          list.add(exercise);
        }
        ExercisePlansModel exercisePlansModel = ExercisePlansModel(
            type: _selectedExerciseType,
            exerciseRegion: _selectedExerciseRegion,
            day: _selectedDayOfWeek,
            exercises: list,
            status: 'ACTIVE'
        );
        exerciseServices.createExercisePlan(widget.student.id, exercisePlansModel).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SUCCESS')),
          );
          Navigator.pushReplacementNamed(context, '/student_details', arguments: widget.student);
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ocorreu um Erro')),
        );
      }
    }
  }

  _validateForm() {
    var data = _values[_count-1];
    if (data['name'] != '' && data['targetMuscle'] != ''
        && data['series'] != '' && data['frequency'] != ''
        && data['cadence'] != '' && data['restTime'] != '') {
      setState(() {
        _enableFloatingActionBtn = true;
      });
    }
  }

  Widget _dynamicForm({
    int index
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
        _count == index + 1
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Exercício ${index + 1}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    )),
                Row(
                  children: [
                    IconButton(onPressed: () {
                      setState(() {
                        enable = !enable;
                      });
                    }, icon: Icon(enable == false ? Icons.arrow_downward : Icons.close), color: const Color(0xffd50032)),
                    IconButton(onPressed: () {
                      setState(() {
                        if (_count > 1) {
                          _values.removeAt(index);
                          _count--;
                        }
                      });
                    }, icon: Icon(Icons.delete_forever), color: const Color(0xffd50032)),
                  ],
                )
              ],
            ),
            enable == true
            ? Column(
              children: [
                _inputTextForm(
                    hintText: 'Exercício',
                    autoFocus: false,
                    index: index,
                    key: 'name'
                ),
              _inputTextForm(
                  hintText: 'Músculo Alvo',
                  autoFocus: false,
                  index: index,
                  key: 'targetMuscle' ),
              _inputNumberForm(
                  hintText: 'Séries',
                  autoFocus: false,
                  index: index,
                  key: 'series' ),
              _inputNumberForm(
                  hintText: 'Repetições ',
                  autoFocus: false,
                  index: index,
                  key: 'frequency' ),
              _inputNumberForm(
                  hintText: 'Cadência em segundos',
                  autoFocus: false,
                  index: index,
                  key: 'cadence'),
              _inputNumberForm(
                  hintText: 'Descanso em segundos',
                  autoFocus: false,
                  index: index,
                  key: 'restTime'
              )
              ],
            ) : Center(),
          ],
        )
        : Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nome do Treino: ${_values[index]['name']}',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w800)),
                              Text('Músculo alvo: ${_values[index]['targetMuscle']}',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w800)),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Text('Sér/Rep: '),
                                    Text(
                                        '${_values[index]['series']}/${_values[index]['frequency']}'),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text('Cadência: '),
                                  Text(_values[index]['cadence']),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Cadência: '),
                                  Text(_values[index]['restTime']),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            IconButton(onPressed: () {
              setState(() {
                if (_count > 1) {
                  _values.removeAt(index);
                  _count--;
                }
              });
            }, icon: Icon(Icons.delete_forever), color: const Color(0xffd50032), iconSize: 46)
          ],
        ),
      ),
    );
  }

  _onUpdate(int index, String val, String key) {
    var value = _values[index];
    value[key] = val;
    _validateForm();
  }

  Widget _inputNumberForm(
      {String hintText,
        bool autoFocus,
        int index,
        String key
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        autofocus: autoFocus,
        keyboardType: TextInputType.text,
        onChanged: (val) {
          _onUpdate(index, val, key);
        },
        style: TextStyle(fontSize: 20),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            hintText: hintText,
            labelText: hintText,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        },
      ),
    );
  }

  Widget _inputTextForm(
      { String hintText,
        bool autoFocus,
        int index,
        String key
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        autofocus: autoFocus,
        onChanged: (val) {
          _onUpdate(index, val, key);
        },
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            hintText: hintText,
            labelText: hintText,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _count = 1;
    _values = [_keys];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Treino'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () {
              _submit();
            },
            child: const Text('Salvar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_enableFloatingActionBtn) {
            setState(() {
              _enableFloatingActionBtn = false;
              _count++;
              _values = [..._values, {
                "name": '',
                "targetMuscle": '',
                "series": '',
                "frequency": '',
                "cadence": '',
                "restTime": '',
              }];
            });
          }
        },
        backgroundColor: _enableFloatingActionBtn ? const Color(0xffd50032) : Colors.black26,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: DropdownButtonFormField(
                  hint: Text('Tipos de Treino'),
                  value: _selectedExerciseType,
                  icon: const Icon(Icons.arrow_downward),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedExerciseType = newValue;
                    });
                  },
                  items: _exercisesTypes.map((location) {
                    return DropdownMenuItem(
                      child: new Text(location),
                      value: location,
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: DropdownButtonFormField(
                  hint:
                      Text('Região do Treino'),
                  value: _selectedExerciseRegion,
                  icon: const Icon(Icons.arrow_downward),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedExerciseRegion = newValue;
                    });
                  },
                  items: _exerciseRegion.map((location) {
                    return DropdownMenuItem(
                      child: new Text(location),
                      value: location,
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: DropdownButtonFormField(
                  hint: Text('Dia da Semana'),
                  icon: const Icon(Icons.arrow_downward),
                  value: _selectedDayOfWeek,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedDayOfWeek = newValue;
                    });
                  },
                  items: _dayOfWeek.map((location) {
                    return DropdownMenuItem(
                      child: new Text(location),
                      value: location,
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _count,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _dynamicForm(index: index),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
