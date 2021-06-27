import 'package:e_ration/MODELS/product_model.dart';

class CartModel {
  ProductModel product;
  int qty;
  bool added;
  DateTime? date;
  String time;

  CartModel({
    required this.product,
    required this.qty,
    this.added = false,
    this.date,
    this.time = '',
  });
}
