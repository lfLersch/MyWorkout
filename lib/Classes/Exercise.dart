class Exercise{
  String id;
  String name;
  String muscleGroup;
  String obs;
  String description;
  String type;


  Exercise(this.name, this.description, this.type, this.muscleGroup);

  String principalField(){
    return ("a");
  }

  String secondField(){
    return ("a");
  }

  toJson(){
    return{
      "name": name,
      "description": description,
      "type": type,
      "muscleGroup": muscleGroup
    };
  }
}

class TimeExercise extends Exercise{
  int repetitions;
  int series;
  int time;

  TimeExercise(String name, String description, String type, String muscleGroup, this.repetitions, this.series, this.time) : super(name, description, type, muscleGroup);

  String principalField(){
    return (time.toString() + "s");
  }

  String secondField(){
    return (series.toString() + "x" + repetitions.toString());
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'repetitions': repetitions,
        'series': series,
        'muscle_group': muscleGroup,
        'type': type,
        'time' : time
      };

}

class WeightExercise extends Exercise{
  int repetitions;
  int series;
  int weight;

  WeightExercise(String name, String description, String type, String muscleGroup, this.repetitions, this.series, this.weight) : super(name, description, type, muscleGroup);

  String principalField(){
    return (weight.toString() + "kg");
  }

  String secondField(){
    return (series.toString() + "x" + repetitions.toString());
  }
  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'repetitions': repetitions,
        'series': series,
        'muscle_group': muscleGroup,
        'type': type,
        'weight' : weight
      };
}

class RepetitionsExercise extends Exercise{
  int repetitions;
  int series;

  RepetitionsExercise(String name, String description, String type, String muscleGroup, this.repetitions, this.series) : super(name, description, type, muscleGroup);

  String principalField(){
    return (repetitions.toString());
  }

  String secondField(){
    return ("series: " + series.toString());
  }
  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'repetitions': repetitions,
        'series': series,
        'muscle_group': muscleGroup,
        'type': type,
      };
}


class RawExercise{
  String name;
  String description;
  String type;
  String muscle_group;
  RawExercise(this.name, this.description, this.type, this.muscle_group);

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'repetitions': 15,
        'series': 3,
        'muscle_group': muscle_group,
        'type': type,
        'weight' : 15
      };
}
