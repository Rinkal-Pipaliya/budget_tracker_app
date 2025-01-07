class SpendingModel {
  int id;
  String desc;
  num amount;
  String mode;
  String date;
  int categoryId;

  SpendingModel({
    required this.id,
    required this.desc,
    required this.amount,
    required this.mode,
    required this.date,
    required this.categoryId,
  });

  factory SpendingModel.mapToModel({required Map<String, dynamic> m1}) {
    return SpendingModel(
      id: m1['spending_id'],
      desc: m1['spending_desc'],
      amount: m1['spending_amount'],
      mode: m1['spending_mode'],
      date: m1['spending_date'],
      categoryId: m1['spending_category_id'],
    );
  }
}
