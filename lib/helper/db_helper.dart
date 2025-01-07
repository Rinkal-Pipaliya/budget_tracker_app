import 'package:budget_tracker_app/model/category_model.dart';
import 'package:budget_tracker_app/model/spending_model.dart';
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
  // Category Table
  String categoryTable = "category";
  String categoryName = "category_name";
  String categoryImage = "category_image";
  String categoryImageIndex = " category_image_index";

  // Spending table
  String spendingTable = "spending";
  String spendingId = "spending_id";
  String spendingDesc = "spending_desc";
  String spendingAmount = "spending_amount";
  String spendingMode = "spending_mode";
  String spendingDate = "spending_date";
  String spendingCategoryId = "spending_category_id";

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
            $categoryImage BLOB NOT NULL,
            $categoryImageIndex INTEGER NOT NULL
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

        String sq = '''CREATE TABLE $spendingTable(
          $spendingId INTEGER PRIMARY KEY AUTOINCREMENT,
          $spendingDesc TEXT NOT NULL,
          $spendingAmount NUMERIC NOT NULL,
          $spendingMode TEXT NOT NULL,
          $spendingDate TEXT NOT NULL,
          $spendingCategoryId INTEGER NOT NULL
        );''';

        await db.execute(sq);
      },
    );
  }

  // TODO: INSERT DATA
  Future<int?> insertCategory({
    required String name,
    required Uint8List image,
    required int index,
  }) async {
    await initDB();

    String query =
        "INSERT INTO $categoryTable ($categoryName, $categoryImage, $categoryImageIndex) VALUES(?, ?, ?);";

    return await db?.rawInsert(
      query,
      [name, image, index],
    );
  }

  Future<int?> insertSpending({required SpendingModel spending}) async {
    await initDB();

    String sq =
        "INSERT INTO ($spendingDesc,$spendingAmount,$spendingMode,$spendingDate,$spendingCategoryId) VALUES(?,?,?,?,?);";

    List args = [
      spending.desc,
      spending.amount,
      spending.mode,
      spending.date,
      spending.categoryId,
    ];
    return await db?.rawInsert(sq, args);
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
  Future<int?> updateCategory({required CategoryModel category}) async {
    await initDB();

    String query =
        "UPDATE $categoryTable SET $categoryName = ?, $categoryImage = ?, $categoryImageIndex = ?  WHERE category_id = $category";

    return await db?.rawUpdate(
      query,
      [
        category.name,
        category.index,
        category.image,
      ],
    );
  }

  // TODO: DELETE DATA
  Future<int?> deleteCategory({required int id}) async {
    await initDB();

    String query = "DELETE FROM $categoryTable WHERE category_id = $id";

    return await db?.rawDelete(query);
  }
}
