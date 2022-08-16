import 'package:flutter/material.dart';
import 'package:mt_app/app/modules/student/home/student_home_page.dart';
import 'package:mt_app/app/sign_in/pages/sign_in_page.dart';
import 'package:mt_app/app/sign_up/pages/signup_page.dart';

class MTRouter {
  static Route<dynamic> generateRoutes(RouteSettings settings){

    final args = settings.arguments;
    switch( settings.name ){
      case "/" :
        return MaterialPageRoute(
            builder: (_) => SignInPage()
        );
      case "/signup" :
        return MaterialPageRoute(
            builder: (_) => SignupPage()
        );
      case "/student_panel" :
        return MaterialPageRoute(
            builder: (_) => StudentHome()
        );
      default:
        _routeError();
    }
  }

  static Route<dynamic> _routeError(){
    return MaterialPageRoute(
        builder: (_){
          return Scaffold(
            appBar: AppBar(title: Text("Tela não encontrada!"),),
            body: Center(
              child: Text("Tela não encontrada!"),
            ),
          );
        }
    );

  }
  
}