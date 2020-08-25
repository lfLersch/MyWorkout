import 'package:myworkout/Classes/Training.dart';
class User{
  String id;
  String name;
  String login;
  String password;
  List<Training> listTraining = List();


  User(this.id, this.name, this.login, this.password);

  addTraining(String key, Map m){
    listTraining.add(Training(key,m['name']));

  }

  toJson(){
    return{
      "name": name,
      "login": login,
      "password": password
    };
  }
}