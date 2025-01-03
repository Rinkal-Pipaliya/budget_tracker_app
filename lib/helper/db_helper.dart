import 'package:budget_tracker_app/model/category_model.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  // Private Named Constructor
  DBHelper._();

  // Singleton Object
  static DBHelper helper = DBHelper._();

  static Logger logger = Logger();

  Database? db;

  String categoryTable = "category";
  String categoryName = "category_name";
  String categoryImage = "category_image";

  // TODO: Create a DATABASE
  Future<void> initDB() async {
    String dbPath = await getDatabasesPath();

    String path = "${dbPath}budget.db";

    // TODO: Create a TABLES

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, _) async {
        String query = '''CREATE TABLE $categoryTable(
            category_id INTEGER PRIMARY KEY AUTOINCREMENT,
            $categoryName TEXT NOT NULL,
            $categoryImage BLOB NOT NULL
        )''';

        await db.execute(query).then(
          (value) {
            logger.i("Category Table is created...");
          },
        ).onError(
          (error, _) {
            logger.e("Category Table is not created...", error: error);
          },
        );
      },
    );
  }

  // TODO: INSERT DATA
  Future<int?> insertCategory({
    required String name,
    required Uint8List image,
  }) async {
    await initDB();

    String query =
        "INSERT INTO $categoryTable ($categoryName, $categoryImage) VALUES(?, ?);";

    return await db?.rawInsert(
      query,
      [name, image],
    );
  }

  // TODO: FETCH ALL DATA
  Future<List<CategoryModel>> fetchCategory() async {
    await initDB();

    String query = "SELECT * FROM $categoryTable;";

    List<Map<String, dynamic>> res = await db?.rawQuery(query) ?? [];

    return res
        .map(
          (e) => CategoryModel.mapToModel(m1: e),
        )
        .toList();
  }

  Future<List<CategoryModel>> liveSearchCategory({
    required String search,
  }) async {
    await initDB();

    String query =
        "SELECT * FROM $categoryTable WHERE $categoryName LIKE '%$search%';";

    List<Map<String, dynamic>> res = await db?.rawQuery(query) ?? [];

    return res
        .map(
          (e) => CategoryModel.mapToModel(m1: e),
        )
        .toList();
  }

  // TODO: UPDATE DATA
  Future<void> updateCategory() async {
    await initDB();
  }

  // TODO: DELETE DATA
  Future<void> deleteCategory() async {
    await initDB();
  }
}
