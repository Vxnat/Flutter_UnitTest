// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_application_e_commerce_app/modules/production.dart';

class Cart {
  Product product;
  int quantity;
  Cart({
    required this.product,
    required this.quantity,
  });

  // @override
  // String toString() {
  //   return 'Product: ${product.name}, Quantity: $quantity';
  // }
}
