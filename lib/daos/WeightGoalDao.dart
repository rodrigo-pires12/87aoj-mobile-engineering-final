import 'package:flutter/material.dart';
import 'package:path/path.dart';
import "package:sqflite/sqflite.dart";
import 'package:trabalho_final/models/WeightGoal.dart';

class WeightGoalDao {
  Future<Database> getDatabase() async {
    Database db = await openDatabase(
      join(await getDatabasesPath(), "weight_tracker_database.db"),
    );
    db.execute(
        "CREATE TABLE WeightGoal (id INTEGER PRIMARY KEY, weightGoal text);");

    return db;
  }

  Future<WeightGoal> read() async {
    final db = await getDatabase();
    List<Map<String, dynamic>> maps = await db.query("WeightGoal", limit: 1);
    return WeightGoal(id: maps[0]["id"], weightGoal: maps[0]["weightGoal"]);
  }

  Future<int> insertWeightGoal(WeightGoal weightGoal) async {
    final db = await getDatabase();
    List<Map<String, dynamic>> maps = await db.query("WeightGoal");
    if (maps.isEmpty) {
      return db.insert("WeightGoal", weightGoal.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort);
    } else {
      throw "teste";
    }
  }

  Future<int> updateWeightGoal(String weightGoal) async {
    final db = await getDatabase();
    WeightGoal currWeightGoal = await read();
    WeightGoal newWeightGoal =
        WeightGoal(id: currWeightGoal.id, weightGoal: weightGoal);
    return db.update("WeightGoal", newWeightGoal.toMap(),
        where: " id = ?", whereArgs: [currWeightGoal.id]);
  }

  Future<int> deleteWeightGoal(int id) async {
    final db = await getDatabase();
    return db.delete("WeightGoal", where: " id = ?", whereArgs: [id]);
  }
}
