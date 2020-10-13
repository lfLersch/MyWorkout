import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myworkout/Classes/Gym.dart';
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
  bool loading = false;
  int radioGroupValue = 0;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Route _createRoute(User user) {
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

  Future<bool> gymHandleSubmit(String login, String password) async {
    bool f;
    User u;
    await databaseReference
        .collection("users")
        .where("password", isEqualTo: password)
        .where("login", isEqualTo: login)
        .getDocuments()
        .then((QuerySnapshot snapshot) async{
      if (snapshot.documents.length >= 0) {
        u = User(
            snapshot.documents[0].documentID,
            snapshot.documents[0]['name'],
            snapshot.documents[0]['login'],
            snapshot.documents[0]['password']);
        await snapshot.documents[0]['workouts'].forEach((k, v) async {
          Training t = Training(k, v['name']);
          await databaseReference
              .collection("training")
              .document(t.id)
              .get()
              .then((DocumentSnapshot snapshot) {
            for (final v in snapshot.data['exercises']) {
              t.addExercise(v);
            }
            //snapshot.data['exercises'].forEach((v) => t.addExercise(v));
            u.listTraining.add(t);
          });
        });
        f = true;
      } else {
        f = false;
      }
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });

    return f;
  }


  Future<User> loginSubmit(String login, String password) async {
    User u;
    QuerySnapshot querySnapshot = await databaseReference
        .collection("users")
        .where("password", isEqualTo: password)
        .where("login", isEqualTo: login)
        .getDocuments();
    if(querySnapshot.documents.length == 0){
      return u;
    }else{
      u = User(
          querySnapshot.documents[0].documentID,
          querySnapshot.documents[0]['name'],
          querySnapshot.documents[0]['login'],
          querySnapshot.documents[0]['password']);
      await addWorkouts(querySnapshot.documents[0]['workouts'], u);
    }
    return u;
  }

  Future<void> addWorkouts(document, User u) async{
    await document.forEach((k, v) async{
      Training t = Training(k, v['name']);
      u.listTraining.add(t);
      DocumentSnapshot snapshot = await databaseReference
          .collection("training")
          .document(t.id)
          .get();
      for(final v in snapshot.data['exercises']){
        t.addExercise(v);
      }
    });
  }



  radioGroupValueChanged(int value){
    setState(() {
      radioGroupValue = value;
    });
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
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Radio(
                        value: 0,
                        groupValue: radioGroupValue,
                        onChanged: radioGroupValueChanged(0),
                      ),
                      new Text(
                        'Aluno',
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      new Radio(
                        value: 1,
                        groupValue: radioGroupValue,
                        onChanged: radioGroupValueChanged(0),
                      ),
                      new Text(
                        'Academia',
                        style: new TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
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
                              /*Container(child: SizedBox(child: Image.asset("caminho"),height: 20,width: 20,), )*/
                            ],
                          ),
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            if(radioGroupValue == 0){
                              User user = await loginSubmit(
                                  loginController.text, passwordController.text).whenComplete((){
                              });
                              if (user != null) {
                                Navigator.of(context).push(_createRoute(user));
                              }
                            }else{
                              /*Gym gym = await loginSubmit(
                                  loginController.text, passwordController.text).whenComplete((){
                              });*/
                            }

                            //if (loading == false) {

                            //}
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
