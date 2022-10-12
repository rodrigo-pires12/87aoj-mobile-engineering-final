import 'dart:ffi';

class Weight {
  int? id;
  final String date;
  final String weight;

  Weight({this.id, required this.date, required this.weight});

  Map<String, dynamic> toMap() {
    return {"id": id, "date": date, "weight": weight};
  }
}
