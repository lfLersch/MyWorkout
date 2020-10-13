import 'package:flutter/material.dart';
import 'package:myworkout/Pages/ImageBankPage.dart';

Drawer drawer(BuildContext context){
  return  Drawer(
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
  );
}