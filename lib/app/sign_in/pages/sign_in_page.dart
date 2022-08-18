import 'package:flutter/material.dart';
import 'package:mt_app/app/sign_in/service/signin_service.dart';
import 'package:mt_app/app/sign_up/model/user_entity.dart';
import '../../../shared/models/user_model.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with TickerProviderStateMixin {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  String _errorMessage = "";
  bool _loading = false;
  SignInService service = SignInService();

  _validarCampos() {
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    //validar campos
    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty && password.length > 6) {
        UserEntity user = UserEntity();
        user.email = email;
        user.password = password;

        _signUser( user );

      } else {
        setState(() {
          _errorMessage = "Preencha a senha! digite mais de 6 caracteres";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Preencha o E-mail válido";
      });
    }
  }

  _signUser( UserEntity user ){
    try {
      setState(() {
        _loading = true;
      });
      service.signUser(user)
      .then((res) => {
        if (res != null) {
          _redirectByUserType(res)
        }
      });

    } catch (error) {
      _errorMessage = error.toString();
    }
  }

  _redirectByUserType(String userId) async {
    UserModel userModel = await service.getUser(userId).then((value) => value);
    setState(() {
      _loading = false;
    });

    switch(userModel.type){
      case 'STUDENT' :
        Navigator.pushReplacementNamed(context, "/student_panel");
        break;
      case 'PERSONAL_TRAINER' :
        Navigator.pushReplacementNamed(context, "/personal_trainer_panel");
        break;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Center(
                      child: Text(
                    'MT',
                    style: TextStyle(color: Colors.red, fontSize: 40),
                  )),
                ),
                TextField(
                  controller: _controllerEmail,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "e-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
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
                          borderRadius: BorderRadius.circular(6))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: ElevatedButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
                      onPressed: () {
                        _validarCampos();
                      }),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Não tem conta? cadastre-se!",
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                  ),
                ),
                _loading
                    ? Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.white))
                    : Container(),
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
