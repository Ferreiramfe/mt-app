import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mt_app/app/sign_up/model/user_entity.dart';
import 'package:mt_app/app/sign_up/service/signup_service.dart';
import 'package:mt_app/shared/util/constants.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _controllerFirstName = TextEditingController();
  TextEditingController _controllerLastName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  String _selectedUserType;

  _signupUser() {
    try {
      if (_formKey.currentState.validate() && _controllerPassword.text.length > 6 && _selectedUserType != null) {
        UserEntity user = UserEntity();
        user.firstName = _controllerFirstName.text;
        user.lastName = _controllerLastName.text;
        user.email = _controllerEmail.text;
        user.password = _controllerPassword.text;
        user.type = _selectedUserType == 'ESTUDANTE' ? STUDENT_TYPE : PERSONAL_TRAINER_TYPE;
        user.timestamp = Timestamp.now();
        SignUpService service = SignUpService();
        service.signUp(user);

        switch (user.type) {
          case PERSONAL_TRAINER_TYPE:
            Navigator.pushNamedAndRemoveUntil(
                context, "/personal_trainer_panel", (_) => false);
            break;
          case STUDENT_TYPE:
            Navigator.pushNamedAndRemoveUntil(
                context, "/student_panel", (_) => false);
            break;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Não foi possível cadastrar o usuário'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget _inputTextForm({
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
            hintStyle: TextStyle(
                color: Colors.black
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),)),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        },
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 32.0, right: 32.0),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _inputTextForm(
                      controller: _controllerFirstName,
                      hintText: 'Primeiro Nome',
                      autoFocus: true),
                  _inputTextForm(
                      controller: _controllerLastName,
                      hintText: 'Último Nome',
                      autoFocus: true),
                  _inputTextForm(
                      controller: _controllerEmail,
                      hintText: 'E-Mail',
                      autoFocus: true),
                  _inputTextForm(
                      controller: _controllerPassword,
                      hintText: 'Senha',
                      autoFocus: true),
                  Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: DropdownButtonFormField(
                        hint: Text('Usuário'),
                        value: _selectedUserType,
                        icon: const Icon(Icons.arrow_downward),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedUserType = newValue;
                          });
                        },
                        items: ['PERSONAL TRAINER', 'ESTUDANTE'].map((location) {
                          return DropdownMenuItem(
                            child: new Text(location),
                            value: location,
                          );
                        }).toList(),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            _signupUser();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                            child: Text('Cadastrar', style: TextStyle(fontWeight: FontWeight.bold)),
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
              )),
        ),
      ),
    );
  }
}
