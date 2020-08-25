import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myworkout/Classes/Exercise.dart';
import 'dart:convert';
import 'package:myworkout/Classes/User.dart';
import 'package:myworkout/Classes/Training.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ExercisesPage extends StatefulWidget {
  final User user;
  final Training training;

  ExercisesPage(this.user, this.training);

  @override
  ExercisesState createState() => ExercisesState();
}

class ExercisesState extends State<ExercisesPage> {
  DatabaseReference workoutsRef;
  bool longPressFlag = false;
  List<String> indexList = new List();
  final databaseReference = Firestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }
  void longPress() {
    setState(() {
      if (indexList.isEmpty) {
        longPressFlag = false;
      } else {
        longPressFlag = true;
      }
    });
  }

  Future<String> getData() async {
    /*var doc = databaseReference
        .collection("training")
        .document(chosenTraining.id)
        .get()
        .then((DocumentSnapshot snapshot) {
          snapshot['exercises'].forEach((k,v) => chosenTraining.addExercise(v));
    });*/

    return Future.value("Data download successfully");
  }

  @override
  Widget requestTemplate(Exercise e) {
    return Card(
      child: new InkWell(
        onLongPress: (){
          print(longPressFlag);
        },
        onTap: (){
        },
      //margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              Expanded(
                child: new Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(e.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      )),
                ),
              ),
              Expanded(
                child: new Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Text(e.weight + " kg",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      )),
                ),
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              Expanded(
                child: new Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  child: Text(
                    "obs",
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: new Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    "series: " + e.series + "   repetitions: " + e.repetitions,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }

  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getData(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // AsyncSnapshot<Your object type>
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Scaffold(
              key: _scaffoldKey,
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text("Luiz Lersch"),
                      accountEmail: Text("luiz@mail.com"),
                      /* currentAccountPicture: new GestureDetector(
                child: new CircleAvatar(
                  backgroundImage: AssetImage("lalala"),
                ),

              ),*/
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage("assets/hamburguerBackground.jpg"),
                            fit: BoxFit.fill),
                      ),
                    ),
                    ListTile(
                        title: Text("Novo Pedido"),
                        trailing: Icon(Icons.add),
                        onTap:
                            () {} /*Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => newRequest(appInfo))),*/
                        ),
                    ListTile(
                      title: Text("Pedidos"),
                      trailing: Icon(Icons.list),
                    ),
                    ListTile(
                      title: Text("Close"),
                      trailing: Icon(Icons.exit_to_app),
                      onTap: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
              ),
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                ),
                title: Text(widget.training.name),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ],
              ),
              body: ListView(
                children: widget.training.exercises
                    .map((exercise) => CustomWidget(
                    e: exercise,
                  longPressEnabled: longPressFlag,
                  callback: () {
                    if (indexList.contains(exercise.id)) {
                      indexList.remove(exercise.id);
                    } else {
                      indexList.add(exercise.id);
                    }

                    longPress();
                  },))
                    .toList(),
              ),
              floatingActionButton: SpeedDial(
                // both default to 16
                marginRight: 15,
                marginBottom: 15,
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                closeManually: false,
                curve: Curves.bounceIn,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                onOpen: () => print('OPENING DIAL'),
                onClose: () => print('DIAL CLOSED'),
                tooltip: 'Speed Dial',
                heroTag: 'speed-dial-hero-tag',
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 8.0,

                shape: CircleBorder(),
                children: [
                  SpeedDialChild(
                      child: Icon(Icons.add),
                      backgroundColor: Colors.green,
                      label: 'Novo Exercício',
                      labelStyle: TextStyle(fontSize: 13.0),
                      onTap: () => print('FIRST CHILD')),
                  SpeedDialChild(
                    child: Icon(Icons.edit),
                    backgroundColor: Colors.blue,
                    label: 'Editar Nome',
                    labelStyle: TextStyle(fontSize: 13.0),
                    onTap: () => print('SECOND CHILD'),
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.delete),
                    backgroundColor: Colors.red,
                    label: 'Excluir Treino',
                    labelStyle: TextStyle(fontSize: 13.0),
                    onTap: () => print('THIRD CHILD'),
                  ),
                ],
              ),
            ); // snapshot.data  :- get your object which is pass from your downloadData() function
        }
    );
  }
}

class CustomWidget extends StatefulWidget {
  bool longPressEnabled;
  Exercise e;
  final VoidCallback callback;
  CustomWidget({this.e, this.longPressEnabled, this.callback});


createState() => new _CustomWidgetState();
}
class _CustomWidgetState extends State<CustomWidget> {
  bool selected = false;
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: color,
        child: new InkWell(
          onLongPress: (){
            setState(() {
              selected = !selected;
            });
            color = Colors.blue;
            widget.callback();

          },
          onTap: (){
            if(widget.longPressEnabled){
              selected = !selected;
              if(selected) {
                color = Colors.blue;
              }else {
                color = Colors.white;
              }
              widget.callback();
            }
          },
          //margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(widget.e.name,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          )),
                    ),
                  ),
                  Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Text(widget.e.weight + " kg",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          )),
                    ),
                  ),
                ],
              ),
              new Row(
                children: <Widget>[
                  Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: Text(
                        "obs",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "series: " + widget.e.series + "   repetitions: " + widget.e.repetitions,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
