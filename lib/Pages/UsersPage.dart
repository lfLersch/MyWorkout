import 'package:flutter/material.dart';
import 'package:myworkout/Classes/User.dart';
import 'package:myworkout/Classes/Training.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myworkout/Pages/ExercisesPage.dart';
import 'package:myworkout/Pages/ImageBankPage.dart';
import 'package:myworkout/Utility/Drawer.dart';

class WorkoutsPage extends StatefulWidget {
  final User user;
  WorkoutsPage(this.user);
  @override
  WorkoutsState createState() => WorkoutsState();
}

class WorkoutsState extends State<WorkoutsPage> {
  DatabaseReference workoutsRef;
  final databaseReference = Firestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  Widget workoutCard(Training t) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            ListTile(
                title: Text(t.name),
                onTap: () {
                  //getData(t);
                  Navigator.of(context).push( new MaterialPageRoute(builder: (context) => new ExercisesPage(widget.user,t)));
                }
              //onTapLunch(item.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return FutureBuilder<String>(// function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Please wait its loading...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Scaffold(
              drawer: drawer(context),
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
                title: Text("Treinos"),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ],
              ),
              body: ListView(
                children: widget.user.listTraining.map((training) => workoutCard(training))
                    .toList(),
              ),
            ); // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
    );
  }
}

