import 'dart:ffi';

class WeightGoal {
  int? id;
  final String weightGoal;

  WeightGoal({this.id, required this.weightGoal});

  Map<String, dynamic> toMap() {
    return {"id": id, "weightGoal": weightGoal};
  }
}
