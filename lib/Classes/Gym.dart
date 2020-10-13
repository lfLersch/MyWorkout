import 'package:myworkout/Classes/Training.dart';
import 'User.dart';
class Gym{
  String id;
  String name;
  String login;
  String password;
  List<User> listUser = List();


  Gym(this.id, this.name, this.login, this.password);

  addUser(String key, Map m){
    listUser.add(User.inGym(key,m['name']));
  }

  toJson(){
    return{
      "name": name,
      "login": login,
      "password": password
    };
  }
}