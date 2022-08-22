import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mt_app/app/sign_in/service/signin_service.dart';
import 'package:mt_app/app/sign_up/model/user_entity.dart';
import 'package:mt_app/shared/util/constants.dart';
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
  bool _obscure = true;

  _signUser() {
    try {
      if (_formKey.currentState.validate()) {
        UserEntity user = UserEntity();
        user.email = _controllerEmail.text;
        user.password = _controllerPassword.text;
        setState(() {
          _loading = true;
        });
        service.signUser(user).then((res) => {
              if (res != null) {_redirectByUserType(res)}
            });
      }
    } catch (error) {
      _errorMessage = error.toString();
    }
  }

  _redirectByUserType(String userId) async {
    UserModel userModel = await service.getUser(userId).then((value) => value);
    setState(() {
      _loading = false;
    });

    switch (userModel.type) {
      case STUDENT_TYPE:
        Navigator.pushReplacementNamed(context, "/student_panel");
        break;
      case PERSONAL_TRAINER_TYPE:
        Navigator.pushReplacementNamed(context, "/personal_trainer_panel");
        break;
    }
  }

  Widget _inputTextForm({
    TextEditingController controller,
    String hintText,
    bool autoFocus,
    bool obscure
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        autofocus: autoFocus,
        controller: controller,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20),
        obscureText: obscure ? _obscure : false,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            hintText: hintText,
            labelText: hintText,
            suffixIcon: obscure ?
            IconButton(
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
                icon: Icon(Icons.remove_red_eye, color: const Color(0xffd50032))) : null,
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Center(
                        child: SvgPicture.asset('lib/shared/assets/logo.svg', color: const Color(0xffd50032))),
                  ),
                  _inputTextForm(
                      controller: _controllerEmail,
                      hintText: 'E-mail',
                      autoFocus: true,
                      obscure: false
                  ),
                  _inputTextForm(
                      controller: _controllerPassword,
                      hintText: 'Senha',
                      autoFocus: true,
                      obscure: true
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          _signUser();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                          child: Text('Entrar', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    ),
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
      ),
    );
  }
}
