// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_application_e_commerce_app/modules/cart.dart';

class Order {
  String id;
  String date;
  List<Cart> listCarts;
  String totalPrice;
  Order({
    required this.id,
    required this.date,
    required this.listCarts,
    required this.totalPrice,
  });
}
