import 'package:appunti_web_frontend/note.dart' show ProvidedArg;
import 'package:flutter/material.dart';

import 'utils.dart';
import 'platform.dart';
import 'io.dart';
import 'home.dart';
import 'login.dart';
import 'subjects.dart';
import 'edit.dart';
import 'profile.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appunti Web',
      locale: Locale('it', 'IT'),
      theme: ThemeData(
        primaryColor: Color(0xff6246ea),
        textTheme: TextTheme(
          bodyText2: TextStyle(
             letterSpacing: 0,
            wordSpacing: -1,
            height: 1.3,
            fontSize: 17.0
          ),
          headline4: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.black
          ),
          headline3: TextStyle(
            height: 1.4,
            fontWeight: FontWeight.w900,
            color: Colors.black
          ),
          button: TextStyle(
            color: Colors.white
          )
        )
      ),
      routes: {
        "/edit": (context) {
          String token;
          try {
            token = getToken(tokenStorage);
            if(!refreshTokenStillValid(tokenStorage)) goToRouteAsap(context, '/login');
            else {
              try {
                bool mod = isMod(token);
                return EditPage(mod, token);
              }
              catch(e) {
                showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text("$e")
                  )
                );
                goToRouteAsap(context, '/login');
              }
            }
          }
          catch(e) {
            goToRouteAsap(context, '/login');
          } 
          return CircularProgressIndicator();
          
        }, 
        "/login": (context) => LoginPage(),
        "/signup": (context) => SignupPage(),
        "/": (context) => HomePage(),
        "/subjects": (context) => SubjectsPage(),
        "/profile": (context)  {
          List args = ModalRoute.of(context).settings.arguments;
          if(args[0] == ProvidedArg.id) {
            String uid = args[1];
            return ProfilePage(uid);
          } else return ProfilePage(args[1]["id"], userData: args[1]);
        },
        "/editProfile": (context) {
          Map args = ModalRoute.of(context).settings.arguments;
          return EditProfile(args);
        }
      },
      initialRoute: '/',
    );
  }
}