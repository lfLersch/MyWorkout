import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myworkout/Classes/Exercise.dart';
import 'dart:convert';
import 'package:myworkout/Classes/User.dart';
import 'package:myworkout/Classes/Training.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myworkout/Pages/ExercisesPage.dart';
import 'package:myworkout/Pages/ImageBankPage.dart';

class NewExercisePage extends StatefulWidget {
  final User user;
  final Training training;
  NewExercisePage(this.user,this.training);

  @override
  NewExerciseState createState() => NewExerciseState();
}

class NewExerciseState extends State<NewExercisePage> {
  DatabaseReference workoutsRef;
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  final databaseReference = Firestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }


  @override
  Widget requestTemplate(Training t) {
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
                      title: Text("Novo Exercício"),
                      trailing: Icon(Icons.add),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ImageBankPage()));
                      },
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
                leading: _isSearching ? const BackButton() : Container(),
                title: _isSearching ? _buildSearchField() : Container(),
                actions: _buildActions(),
              ),
              /*appBar: AppBar(
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
              ),*/
              body: ListView(
                children: widget.user.listTraining.map((training) => requestTemplate(training))
                    .toList(),
              ),
            ); // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
    );
  }
}