import 'package:flutter/material.dart';
import 'package:mt_app/app/modules/cross-profile/exercises/exercises_details_page.dart';
import 'package:mt_app/app/modules/personal_trainer/config/trainer_config_page.dart';
import 'package:mt_app/app/modules/personal_trainer/home/personal_trainer_home_page.dart';
import 'package:mt_app/app/modules/personal_trainer/trainer_details/pages/trainer_details_page.dart';
import 'package:mt_app/app/modules/student/config/student_config_page.dart';
import 'package:mt_app/app/modules/student/details/form/student_exercise_form_page.dart';
import 'package:mt_app/app/modules/student/details/student_details_page.dart';
import 'package:mt_app/app/modules/student/home/student_home_page.dart';
import 'package:mt_app/app/sign_in/pages/sign_in_page.dart';
import 'package:mt_app/app/sign_up/pages/signup_page.dart';

class MTRouter {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => SignInPage());
      case "/signup":
        return MaterialPageRoute(builder: (_) => SignupPage());
      case "/student_panel":
        return MaterialPageRoute(builder: (_) => StudentHome());
      case "/personal_trainer_panel":
        return MaterialPageRoute(builder: (_) => PersonalTrainerHomePage());
      case "/trainer_details":
        return MaterialPageRoute(
            builder: (_) => TrainerDetailsPage(trainer: args));
      case "/student_details":
        return MaterialPageRoute(
            builder: (_) => StudentDetailsPage(student: args));
      case "/student_exercise_form":
        return MaterialPageRoute(
            builder: (_) => StudentExerciseFormPage(student: args));
      case "/exercise_details":
        return MaterialPageRoute(
            builder: (_) => ExercisesDetailsPage(exercises: args));
      case "/student_config":
        return MaterialPageRoute(
            builder: (_) => StudentConfigPage(student: args));
      case "/trainer_config":
        return MaterialPageRoute(
            builder: (_) => TrainerConfigPage(trainer: args));
      default:
        _routeError();
    }
  }

  static Route<dynamic> _routeError() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Tela não encontrada!"),
        ),
        body: Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}
