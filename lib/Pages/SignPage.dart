import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myworkout/Classes/User.dart';
import './LoginPage.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class SignPage extends StatefulWidget {
  @override
  SignState createState() => SignState();
}

class SignState extends State<SignPage> {
  DatabaseReference UserRef;
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase.instance;
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    UserRef = database.reference().child('users');
    //UserRef.onChildAdded.listen(_onEntryAdded);
    //UserRef.onChildChanged.listen(_onEntryChanged);
  }

  /*_onEntryAdded(Event event) {
    setState(() {
      items.add(Item.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = Item.fromSnapshot(event.snapshot);
    });
  }*/


  void handleSubmit(User user) {
    final FormState form = formKey.currentState;

      UserRef.push().set(user.toJson());
      Navigator.of(context).push( new MaterialPageRoute(builder: (context) => new LoginPage()));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.text,
              obscureText: true,
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
              height: 20,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                gradient:  LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3,1],
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,),
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

                  onPressed: () {
                    //handleSubmit(User(nameController.text, loginController.text, passwordController.text));


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


