import 'package:flutter/material.dart';
import 'package:myworkout/Classes/Exercise.dart';
import 'package:myworkout/Utility/SearchDialog.dart';
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
  List<int> indexList = new List();
  final databaseReference = Firestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
  }

  void longPress() {
    setState(() {
      if (longPressFlag) {
        indexList.clear();
        longPressFlag = false;
      } else {
        longPressFlag = true;
      }
    });
  }

  List<RawExercise> rawExerciseList = new List();

  void removeExercise() async{
    final DocumentReference _postsCollectionReference =
    Firestore.instance.collection('training').document(widget.training.id);
    int index = indexList.removeLast();

    await _postsCollectionReference.updateData({'exercises':FieldValue.arrayRemove([widget.training.exercises.elementAt(index).toJson()])}).then((doc) {
      print("l");

      widget.training.exercises.removeAt(index);
      setState(() {

      });
    }).timeout(Duration(seconds:10)).catchError((error) {
      print("Erro ao adicionar exercício");
      setState(() {

      });
    });
        }

  void onTapExercise() async {
    rawExerciseList = new List();
    await Firestore.instance
        .collection("exercises")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        rawExerciseList.add(new RawExercise(
            element['name'], element['description'], element['type'], element['muscle_group']));
      });
    }).whenComplete(() {
      showDialog(
          context: context,
          builder: (context) {
            return SearchDialog(rawExerciseList: rawExerciseList, t: widget.training);
          });
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
                actions: (indexList.isNotEmpty)
                    ?
                <Widget>[
              Padding(
              padding: EdgeInsets.only(right: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          removeExercise();
                        },
                        child: Icon(
                          Icons.delete,
                          size: 26.0,
                        ),
                  ),
              )
                ]
                    :
                  <Widget>[
                      Padding(
                      padding: EdgeInsets.only(right: 16.0),

                      )
        ]
              ),
              body: ListView(
                children: widget.training.exercises.asMap().entries
                    .map((entry) => ExerciseCard(
                          indexList: indexList,
                          e: entry.value,
                          index: entry.key,
                          longPressEnabled: longPressFlag,
                          tapCallback: () {
                            setState(() {
                              if (indexList.contains(entry.key)) {
                                indexList.remove(entry.key);
                                if (indexList.isEmpty) {
                                  longPressFlag = false;
                                }
                              } else {
                                indexList.add(entry.key);
                              }
                            });
                          },
                          longCallback: () {
                            setState(() {
                              if (indexList.contains(entry.key)) {
                                indexList.remove(entry.key);
                                longPressFlag = false;
                              } else {
                                indexList.add(entry.key);
                                //print(entry.key + longPressFlag.toString());
                                longPressFlag = true;
                              }
                            });
                          },
                        ))
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
                      onTap: onTapExercise),
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
        });
  }
}



// ignore: must_be_immutable
class ExerciseCard extends StatefulWidget {
  bool longPressEnabled;
  Exercise e;
  List<int> indexList;
  int index;
  final VoidCallback tapCallback;
  final VoidCallback longCallback;

  ExerciseCard(
      {this.e,
        this.index,
      this.longPressEnabled,
      this.tapCallback,
      this.longCallback,
      this.indexList});

  createState() => new _ExerciseCard();
}

class _ExerciseCard extends State<ExerciseCard> {
  bool selected = false;
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: (widget.indexList.contains(widget.index))
            ? Colors.blue
            : Colors.white,
        child: new InkWell(
          onLongPress: () {
            setState(() {
              widget.longCallback();
            });
          },
          onTap: () {
            print(widget.indexList[0]);
            if (widget.longPressEnabled) {
              setState(() {
                widget.tapCallback();
              });
            } else {}
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
                      child: Text(widget.e.principalField(),
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
                        widget.e.secondField()
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
