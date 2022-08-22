import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mt_app/app/modules/personal_trainer/home/personal_trainer_home_page.dart';
import 'package:mt_app/app/modules/student/home/student_home_page.dart';
import 'package:mt_app/app/mt_router.dart';
import 'package:mt_app/shared/models/user_model.dart';
import 'package:mt_app/shared/services/user_services.dart';
import 'package:mt_app/shared/util/constants.dart';

import 'app/sign_in/pages/sign_in_page.dart';

final ThemeData temaPadrao =
    ThemeData(
        primaryColor: Color(0xff37474f), accentColor: Color(0xff546e7a),
    );

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instance;
  UserServices userServices = UserServices();
  Widget initial = SignInPage();
  String initialRoute = '/';
  if (await auth.currentUser != null) {
    UserModel user;
    await userServices.getUser(auth.currentUser.uid)
      .then((value) {
        user = value;
    });
    initial = user.type == STUDENT_TYPE ? StudentHome() : PersonalTrainerHomePage();
    initialRoute = user.type == STUDENT_TYPE ? '/student_panel' : '/personal_trainer_panel';
  }
  runApp(MaterialApp(
    title: "MT",
    home: initial,
    theme: temaPadrao,
    initialRoute: initialRoute,
    onGenerateRoute: MTRouter.generateRoutes,
    debugShowCheckedModeBanner: false,
  ));
}
