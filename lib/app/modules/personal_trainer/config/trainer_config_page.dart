import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mt_app/shared/models/exercise_plans_model.dart';
import 'package:mt_app/shared/models/students_model.dart';
import 'package:mt_app/shared/models/trainer_model.dart';
import 'package:mt_app/shared/services/exercise_plans_services.dart';
import 'package:intl/intl.dart';
import 'package:mt_app/shared/services/student_service.dart';

import '../../../../shared/services/trainer_service.dart';

class TrainerConfigPage extends StatefulWidget {
  TrainerModel trainer;
  TrainerConfigPage({Key key, this.trainer}) : super(key: key);

  @override
  State<TrainerConfigPage> createState() => _TrainerConfigPageState();
}

class _TrainerConfigPageState extends State<TrainerConfigPage> {
  TextEditingController _controllerFirstName = TextEditingController();
  TextEditingController _controllerLastName = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  TextEditingController _controllerValue = TextEditingController();

  String _imageRef;
  ExercisePlansModel _exerciseOfTheDay;
  List<ExercisePlansModel> _exercises;
  bool _loadingUser = false;
  File _image;
  User _user;
  String _uid;
  var _days = {
    'SUNDAY': 'DOMINGO',
    'MONDAY': 'SEGUNDA',
    'TUESDAY': 'TERÇA',
    'WEDNESDAY': 'QUARTA',
    'THURSDAY': 'QUINTA',
    'FRIDAY': 'SEXTA',
    'SATURDAY': 'SÁBADO',
  };

  TrainerService trainerService = TrainerService();

  Future _getImage() async {
    try {
      final selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        final tmpImage = File(selectedImage.path);
        _image = tmpImage;
        if( _image != null ){
          _uploadImage();
        }
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível fazer o upload'),
          backgroundColor: Color(0xffd50032),
        ),
      );
    }

  }

  _uploadImage() async {
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference root = storage.ref();
    Reference file = root
        .child("profile-pics")
        .child(widget.trainer.id)
        .child( imageName + ".jpg");

    try {
      await file.putFile(_image);
      String path = await file.getDownloadURL();
      setState(() {
        _imageRef = path;
        widget.trainer.imageRef = _imageRef;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível fazer o upload'),
          backgroundColor: Color(0xffd50032),
        ),
      );
    }
  }

  Widget _inputTextForm(
      {
        TextEditingController controller,
        String hintText,
        bool autoFocus,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        autofocus: autoFocus,
        controller: controller,
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

  Widget _inputNumberForm(
      {
        TextEditingController controller,
        String hintText,
        bool autoFocus,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        autofocus: autoFocus,
        keyboardType: TextInputType.text,
        controller: controller,
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

  Widget _personalTrainerCard(TrainerModel trainer) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                        maxRadius: 70,
                        backgroundColor: const Color(0xffd50032),
                        backgroundImage: widget.trainer.imageRef == null
                            ? null
                            : NetworkImage(widget.trainer.imageRef),
                        child: widget.trainer.imageRef == null ? Text('${trainer.user.firstName[0]}${trainer.user.lastName[0]}',
                            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white))
                            : null
                    ),
                    Positioned(
                        bottom: 0,
                        right: 70,
                        child: RawMaterialButton(
                          onPressed: () {
                            _getImage();
                          },
                          elevation: 2.0,
                          fillColor: Color(0xFFF5F6F9),
                          child: Icon(Icons.camera_alt_outlined, color: Colors.blue,),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        )),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(trainer.user.firstName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(trainer.user.email),
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

  _update() async {
    try {
      TrainerModel trainerModel = widget.trainer;
      if (_controllerFirstName.text.isNotEmpty) {
        trainerModel.user.firstName = _controllerFirstName.text;
      }
      if (_controllerLastName.text.isNotEmpty) {
        trainerModel.user.lastName = _controllerLastName.text;
      }
      if (_controllerDescription.text.isNotEmpty) {
        trainerModel.description = _controllerDescription.text;
      }
      if (_controllerValue.text.isNotEmpty) {
        trainerModel.value = _controllerValue.text;
      }
      await trainerService.updateTrainer(widget.trainer);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário atualizado com sucesso'),
          backgroundColor: Colors.greenAccent,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível fazer o update do usuário'),
          backgroundColor: Color(0xffd50032),
        ),
      );
    }
  }

  getUserData() async {
    setState(() {
      _loadingUser = true;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    _user = await auth.currentUser;
    setState(() {
      _uid = _user.uid;
      _loadingUser = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Personal'),
      ),
      floatingActionButton: _uid != widget.trainer.user.id ? FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/student_exercise_form',
              arguments: widget.trainer);
        },
        backgroundColor:const Color(0xffd50032),
        child: const Icon(Icons.add),
      ) : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _personalTrainerCard(widget.trainer),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _inputTextForm(controller: _controllerFirstName, hintText: 'Primeiro Nome', autoFocus: false),
                  _inputTextForm(controller: _controllerLastName, hintText: 'Último Nome', autoFocus: false),
                  _inputTextForm(controller: _controllerDescription, hintText: 'Descrição', autoFocus: false),
                  _inputTextForm(controller: _controllerValue, hintText: 'Valor da mensalidade', autoFocus: false),
                  Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            _update();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                            child: Text('Salvar', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffd50032)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: const Color(0xffd50032))
                                  )
                              )
                          )
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
