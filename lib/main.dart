import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mt_app/app/mt_router.dart';

import 'app/sign_in/pages/sign_in_page.dart';

final ThemeData temaPadrao =
    ThemeData(primaryColor: Color(0xff37474f), accentColor: Color(0xff546e7a));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: "MT",
    home: SignInPage(),
    theme: temaPadrao,
    initialRoute: "/",
    onGenerateRoute: MTRouter.generateRoutes,
    debugShowCheckedModeBanner: false,
  ));
}
