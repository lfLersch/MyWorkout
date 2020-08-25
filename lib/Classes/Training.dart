import './Exercise.dart';

class Training{
  String id;
  String name;
  List<Exercise> exercises;


  Training(this.id, this.name){
    exercises = new List();
  }

  addExercise(Map m){
    exercises.add(Exercise(m['name'],m['weight'].toString(),m['repetitions'].toString(),m['series'].toString()));
  }

  toJson(){
    return{
      "name": name,
    };
  }
}