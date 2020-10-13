import './Exercise.dart';

class Training{
  String id;
  String name;
  List<Exercise> exercises;


  Training(this.id, this.name){
    exercises = new List();
  }

  addExercise(Map m){
    Exercise e;
    switch(m['type']) {
      case "Peso":
        e = WeightExercise(m['name'], "", m['type'], m['muscle_group'],m['repetitions'],m['series'], m['weight']);
        break;
      case "Tempo":
        e = TimeExercise(m['name'], "", m['type'], m['muscle_group'],m['repetitions'],m['series'], m['time']);
        break;
      case "Repetições":
        e = RepetitionsExercise(m['name'], "", m['type'], m['muscle_group'],m['repetitions'],m['series']);
        break;
    }
    exercises.add(e);
  }

  toJson(){
    return{
      "name": name,
    };
  }
}