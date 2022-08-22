import 'package:flutter/material.dart';
import 'package:mt_app/app/sign_up/enum/user_type_enum.dart';
import 'package:mt_app/app/sign_up/model/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mt_app/app/sign_up/service/signup_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController _controllerName = TextEditingController(text: "Jamilton Damasceno");
  TextEditingController _controllerEmail = TextEditingController(text: "jamilton@gmail.com");
  TextEditingController _controllerPassword = TextEditingController(text: "1234567");
  bool _userTypeFlag = false;
  String _userType = 'STUDENT';
  String _errorMessage = "";

  _validateFields(){

    //Recuperar dados dos campos
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    //validar campos
    if( name.isNotEmpty ){

      if( email.isNotEmpty && email.contains("@") ){

        if( password.isNotEmpty && password.length > 6 ){

          UserEntity user = UserEntity();
          user.name = name;
          user.email = email;
          user.password = password;
          user.type = _userType;

          _signupUser(user);

        }else{
          setState(() {
            _errorMessage = "Preencha a senha! digite mais de 6 caracteres";
          });
        }

      }else{
        setState(() {
          _errorMessage = "Preencha o E-mail válido";
        });
      }

    }else{
      setState(() {
        _errorMessage = "Preencha o Nome";
      });
    }
  }

  _signupUser( UserEntity user ){
    try {
      SignUpService service = SignUpService();
      service.signup(user);

      switch( user.type ){
        case 'PERSONAL_TRAINER':
          Navigator.pushNamedAndRemoveUntil(
              context,
              "/personal_trainer_panel",
                  (_) => false
          );
          break;
        case 'STUDENT' :
          Navigator.pushNamedAndRemoveUntil(
              context,
              "/student_panel",
                  (_) => false
          );
          break;
      }
    } catch(e) {
      _errorMessage = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: _controllerName,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome completo",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)
                      )
                  ),
                ),
                TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "e-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)
                      )
                  ),
                ),
                TextField(
                  controller: _controllerPassword,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Text("Estudante"),
                      Switch(
                          value: _userTypeFlag,
                          onChanged: (bool value){
                            setState(() {
                              _userTypeFlag = value;
                              _userType = !value ? 'STUDENT' : 'PERSONAL_TRAINER';
                            });
                          }
                      ),
                      Text("Personal Trainer"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Color(0xff1ebbd8),
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      onPressed: (){
                        _validateFields();
                      }
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
