import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Exercise{
  String id;
  String name;
  String weight;
  String repetitions;
  String series;
  String obs;


  Exercise(this.name, this.weight, this.repetitions,this.series);

  toJsonTypeWeight(){
    return{
      "name": name,
      "weight": weight,
      "repetitions": repetitions,
      "series": series
    };
  }
}