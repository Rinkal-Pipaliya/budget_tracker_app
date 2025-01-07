import 'package:flutter/services.dart';

class CategoryModel {
  int id;
  String name;
  Uint8List image;
  int index;
  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.index,
  });

  factory CategoryModel.mapToModel({required Map<String, dynamic> m1}) {
    return CategoryModel(
      id: m1['category_id'],
      name: m1['category_name'],
      image: m1['category_image'],
      index: m1['category_image_index'],
    );
  }
}
