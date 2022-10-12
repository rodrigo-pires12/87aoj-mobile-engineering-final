import 'package:path/path.dart';
import "package:sqflite/sqflite.dart";
import 'package:trabalho_final/models/Weight.dart';

class WeightDao {
  Future<Database> getDatabase() async {
    // databaseFactory.deleteDatabase(
    //     join(await getDatabasesPath(), "weight_tracker_database.db"));
    Database db = await openDatabase(
        join(await getDatabasesPath(), "weight_tracker_database.db"),
        onCreate: ((db, version) {
      return db.execute(
          "CREATE TABLE Weight (id INTEGER PRIMARY KEY, date text, weight text);");
    }), version: 1);
    return db;
  }

  Future<List<Weight>> readAll() async {
    final db = await getDatabase();
    List<Map<String, dynamic>> maps = await db.query("Weight", orderBy: "date");

    final result = List.generate(maps.length, (index) {
      return Weight(
          id: maps[index]["id"],
          date: maps[index]["date"],
          weight: maps[index]["weight"]);
    });

    return result;
  }

  Future<int> insertWeight(Weight weight) async {
    final db = await getDatabase();
    return db.insert("Weight", weight.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<int> deleteWeight(int id) async {
    final db = await getDatabase();
    return db.delete("Weight", where: " id = ?", whereArgs: [id]);
  }
}
