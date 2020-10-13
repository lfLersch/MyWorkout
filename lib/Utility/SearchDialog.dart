
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myworkout/Classes/Exercise.dart';
import 'package:myworkout/Classes/Training.dart';

class SearchDialog extends StatefulWidget {
  SearchDialog({this.rawExerciseList, this.t});
  Training t;
  List<RawExercise> rawExerciseList;
  @override
  SearchDialogState createState() => SearchDialogState();
}

class SearchDialogState extends State<SearchDialog> {
  TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "Search query";
  List<RawExercise> showList;
  RawExercise exerciseSelected;



  @override
  void initState() {
    super.initState();
    showList = widget.rawExerciseList;
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      showList = widget.rawExerciseList
          .where((e) => e.name.toLowerCase().contains(newQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: double.maxFinite,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Expanded(
              child: new Container(
                //color: Colors.blue,
                  height: 10.0,
                  width: 200.0,
                  child: TextField(
                    controller: _searchQueryController,
                    autofocus: true,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue,
                      hintText: "Search Data...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white30),
                    ),
                    style: TextStyle(
                        color: Colors.white, fontSize: 16.0),
                    onChanged: (query) => updateSearchQuery(query),
                  ))),
          Expanded(
              flex: 6,
              child: ListView.builder(
                  itemCount: showList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          exerciseSelected = showList[index];
                        });
                      },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: (showList[index] == exerciseSelected) ? Colors.blue : Colors.white,
                          ),

                          height: 50,
                          child: Center(
                              child: Text(showList[index].name)),
                        ),
                    );
                  })),
          Expanded(
            child: Row(children: <Widget>[
              Expanded(
                flex: 5,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.red,
                    textColor: Colors.white,
                  child: Text(
                    'Cancelar'
                  )
                ),
              ),
              Expanded(
                child: SizedBox(

                )
              ),
              Expanded(
                flex: 5,
                child: FlatButton(
                    onPressed: () {
                      addExercise();

                      setState(() {

                        widget.t.exercises.add(Exercise(exerciseSelected.name,'10','15','3'));
                      });
                      Navigator.pop(context);
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text(
                        'Confirmar'
                    )
                ),
              )
              ]

            ),
          )
        ]),
      ),
    );
  }

  Future<void> addExercise() async{
    final DocumentReference _postsCollectionReference =
    Firestore.instance.collection('training').document(widget.t.id);

    await _postsCollectionReference.updateData({'exercises':FieldValue.arrayUnion([exerciseSelected.toJson()])}).then((doc) {
      print("Exercício adicionado");
    }).timeout(Duration(seconds:10)).catchError((error) {
      print("Erro ao adicionar exercício");
    });
  }
}