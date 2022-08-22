import 'package:flutter/material.dart';
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
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerTargetMuscle = TextEditingController();
  final TextEditingController _controllerSeries = TextEditingController();
  final TextEditingController _controllerFrequency = TextEditingController();
  final TextEditingController _controllerCadence = TextEditingController();
  final TextEditingController _controllerRestTime = TextEditingController();

  int _count;

  List<Map<String, dynamic>> _values;

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
        ExercisePlansModel exercise = ExercisePlansModel(
            type: _selectedExerciseType,
            exerciseRegion: _selectedExerciseRegion,
            day: _selectedDayOfWeek,
            name: _controllerName.text,
            targetMuscle: _controllerTargetMuscle.text,
            series: int.parse(_controllerSeries.text),
            frequency: int.parse(_controllerFrequency.text),
            cadence: int.parse(_controllerCadence.text),
            restTime: int.parse(_controllerRestTime.text),
            status: 'ACTIVE'
        );
        exerciseServices.createExercisePlan(widget.student.id, exercise).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SUCCESS')),
          );
          Navigator.pushReplacementNamed(context, '/student_details', arguments: widget.student);
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Processing Data')),
        );
      }
    }
  }

  Widget _inputNumberForm(
      {TextEditingController editingController,
        String hintText,
        bool autoFocus}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: editingController,
        autofocus: autoFocus,
        keyboardType: TextInputType.text,
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
  Widget _formField(int index) {
    return TextFormField();
  }

  Widget _inputTextForm(
      {TextEditingController editingController,
      String hintText,
      bool autoFocus}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: editingController,
        autofocus: autoFocus,
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
    _count = 0;
    _values = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criar Treino')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            _count++;
          });
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.navigation),
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
                  shrinkWrap: true,
                  itemCount: 0,
                  itemBuilder: (context, index) {
                    return _formField(index);
                  },
                ),
              ),
              // _inputTextForm(
              //     editingController: _controllerName,
              //     hintText: 'Nome do Treino',
              //     autoFocus: true),
              // _inputTextForm(
              //     editingController: _controllerTargetMuscle,
              //     hintText: 'Músculo Alvo',
              //     autoFocus: true),
              // _inputNumberForm(
              //     editingController: _controllerSeries,
              //     hintText: 'Séries em segundos',
              //     autoFocus: true),
              // _inputNumberForm(
              //     editingController: _controllerFrequency,
              //     hintText: 'Repetições em segundos',
              //     autoFocus: true),
              // _inputNumberForm(
              //     editingController: _controllerCadence,
              //     hintText: 'Cadência em segundos',
              //     autoFocus: true),
              // _inputNumberForm(
              //     editingController: _controllerRestTime,
              //     hintText: 'Descanso em segundos',
              //     autoFocus: true),
            ],
          ),
        ),
      ),
    );
  }
}
