import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myworkout/Classes/Training.dart';
import 'package:myworkout/Classes/User.dart';
import 'package:myworkout/Utility/Loading.dart';
import 'package:myworkout/Pages/WorkoutsPage.dart';
import 'package:myworkout/main.dart';
import './SignPage.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final databaseReference = Firestore.instance;
  User user;
  bool loading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  @override
  void initState() {
    super.initState();
  }

  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            WorkoutsPage(user),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end);
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
  }

  Future<bool> handleSubmit(String login, String password) async {
    bool f;
    User u;
    await databaseReference
        .collection("users")
        .where("password", isEqualTo: password)
        .where("login", isEqualTo: login)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      if (snapshot.documents.length >= 0) {
        u = User(
            snapshot.documents[0].documentID,
            snapshot.documents[0]['name'],
            snapshot.documents[0]['login'],
            snapshot.documents[0]['password']);
        snapshot.documents[0]['workouts'].forEach((k, v) {
          Training t = Training(k, v['name']);
          databaseReference
              .collection("training")
              .document(t.id)
              .get()
              .then((DocumentSnapshot snapshot) {
            snapshot.data['exercises'].forEach((v) => t.addExercise(v));
            u.listTraining.add(t);
          });
        });
        f = true;
      } else {
        f = false;
      }
    }).whenComplete(() {
      setState(() {
        user = u;
        loading = false;
      });

    });

    return f;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
              padding: EdgeInsets.only(
                top: 60,
                left: 40,
                right: 40,
              ),
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    width: 128,
                    height: 128,
                    //child: Image.asset("assets/logo.png")
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: loginController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Login",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        )),
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Senha",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        )),
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 60,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.3, 1],
                        colors: [
                          Colors.deepOrange,
                          Colors.orangeAccent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SizedBox.expand(
                      child: FlatButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              /*Container(
                        child: SizedBox(
                          child: Image.asset("caminho"),
                          height: 20,
                          width: 20,
                        ),
                      )*/
                            ],
                          ),
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            bool login = await handleSubmit(
                                loginController.text, passwordController.text);
                            if (loading == false) {
                              setState(() {

                              });
                              if (login) {
                                print(user.login);
                                print(user.id);
                                print(user.listTraining.length);
                                Navigator.of(context).push(_createRoute());
                              }
                            }
                          }),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Não tem uma conta?",
                            style: TextStyle(color: Colors.lightBlue)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SignPage();
                            }));
                          },
                          child: Text("Cadastre-se",
                              style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold)),
                        )
                      ]),
                ],
              ),
            ),
          );
  }
}
