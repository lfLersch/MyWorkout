import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myworkout/Classes/User.dart';
import './LoginPage.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageBankPage extends StatefulWidget {
  @override
  ImageBankState createState() => ImageBankState();
}

class ImageBankState extends State<ImageBankPage> {
  final databaseReference = Firestore.instance;
  String dropdownType;
  String dropdownMuscle;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dropdownType = 'Peso';
    dropdownMuscle = 'Peitoral';
  }

  void handleSubmit(String type, String muscle, String name, String description) {
    databaseReference.collection("exercises").add({
      "name": name,
      "muscle_group": muscle,
      "type": type,
      "description": description,
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          left: 40,
          right: 40,
        ),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 128,
              height: 50,
              //child: Image.asset("assets/logo.png")
            ),
            DropdownButton<String>(
              value: dropdownType,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownType = newValue;
                });
              },
              items: <String>['Peso', 'Tempo', 'Repetições']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButton<String>(
              value: dropdownMuscle,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownMuscle = newValue;
                });
              },
              items: <String>['Abdômen Reto', 'Abdômen Oblíquo','Bíceps', 'Deltóide (Ombro)', 'Dorsal (Costas)', 'Gêmeo (Panturrilha)', 'Glúteo', 'isquiotibiais (Posterior)','Quadríceps (Anterior)','Peitoral','Trapézio', 'Tríceps',]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "Nome",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  )),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: descriptionController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Descrição",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  )),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
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
                        "Cadastrar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    handleSubmit(
                      dropdownType,
                      dropdownMuscle,
                      nameController.text,
                     descriptionController.text,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
