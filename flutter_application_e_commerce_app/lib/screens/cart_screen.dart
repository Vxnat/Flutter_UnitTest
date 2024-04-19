// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_e_commerce_app/modules/production.dart';
import 'package:flutter_application_e_commerce_app/provider/provider_food.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late TextEditingController couponController;
  final successNoti = const SnackBar(
    content: Text('Success Checkout'),
    duration: Duration(milliseconds: 800),
  );
  final correctCoupon = const SnackBar(
    content: Text('Success Apply Coupon'),
    duration: Duration(milliseconds: 800),
  );
  final incorrectCoupon = const SnackBar(
    content: Text('Sorry ! A Coupon Is Incorrect Or Expire'),
    duration: Duration(milliseconds: 800),
  );
  @override
  void initState() {
    super.initState();
    couponController = TextEditingController();
  }

  void updateQuantity(Product product, bool isIncrease) {
    context.read<ProviderFood>().updateQuantity(product, isIncrease);
  }

  String itemTotal() {
    double totalPrice = 0;
    for (var cart in context.read<ProviderFood>().listCarts) {
      totalPrice += (cart.product.price * cart.quantity);
    }
    return totalPrice.toStringAsFixed(2);
  }

  void applyCoupon(String coupon) {
    // Kiem tra ton tai ma giam gia
    bool isContain = context
        .read<ProviderFood>()
        .listCoupons
        .any((element) => element.coupon == coupon);
    // Neu ton tai ma giam gia thi lam rong Coupon , neu khong thi thong bao Ko ton tai
    isContain
        ? couponController.text = ''
        : ScaffoldMessenger.of(context).showSnackBar(incorrectCoupon);
    // Neu gio hang ko rong
    if (context.read<ProviderFood>().listCarts.isNotEmpty) {
      final item = context
          .read<ProviderFood>()
          .listCoupons
          .firstWhere((element) => element.coupon == coupon);
      if (!item.isUse) {
        context.read<ProviderFood>().applyCoupon(coupon);
        ScaffoldMessenger.of(context).showSnackBar(correctCoupon);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(incorrectCoupon);
      }
    } else {
      // Neu gio hang rong
      int lengthListCarts = context.read<ProviderFood>().listCarts.length;
      showAlertMessage(lengthListCarts);
    }
  }

  void checkout() {
    int lengthListCarts = context.read<ProviderFood>().listCarts.length;
    showAlertMessage(lengthListCarts);
  }

  void addToOrder() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(successNoti);
    // Them vao danh sach Order : Kiem tra khi ap dung phieu giam gia , neu ap dung ma tien < 0 thi cho 0dong va nguoc lai
    context.read<ProviderFood>().addToOrder((double.parse(itemTotal()) -
                context.read<ProviderFood>().couponPrice) <
            0
        ? 0.toStringAsFixed(2)
        : (double.parse(itemTotal()) - context.read<ProviderFood>().couponPrice)
            .toStringAsFixed(2));
  }

  Future<dynamic> showAlertMessage(int lengthListCarts) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            !(lengthListCarts == 0) ? 'Confirm Checkout' : 'Your cart is empty',
            style: const TextStyle(color: Color.fromARGB(255, 255, 94, 0)),
          ),
          content: Text(!(lengthListCarts == 0)
              ? 'Are you sure you want to checkout?'
              : 'Please add your food !'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            !(lengthListCarts == 0)
                ? TextButton(
                    onPressed: () {
                      addToOrder();
                    },
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                  )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
        leading: IconButton(
            hoverColor: Colors.white,
            highlightColor: const Color.fromARGB(255, 255, 208, 137),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.orange,
            )),
        title: const Text(
          'My Cart',
          style: TextStyle(
              color: Color.fromARGB(255, 235, 141, 0),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        color: const Color.fromARGB(255, 235, 235, 235),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Container(
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 197, 197, 197)
                          .withOpacity(
                              0.5), // Màu của boxShadow và độ trong suốt
                      spreadRadius: 5, // Bán kính mở rộng của boxShadow
                      blurRadius: 7, // Bán kính mờ của boxShadow
                      offset: const Offset(0,
                          3), // Độ dịch chuyển của boxShadow theo trục x và y
                    ),
                  ],
                ),
                child: Consumer<ProviderFood>(
                  builder: (context, providerFood, child) {
                    if (providerFood.listCarts.isEmpty) {
                      return const Center(
                        child: Text(
                          'Your cart is empty',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: providerFood.listCarts.length,
                      itemBuilder: (context, index) {
                        final item = providerFood.listCarts[index];
                        return Container(
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 5, left: 10, right: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 197, 197, 197)
                                    .withOpacity(
                                        0.5), // Màu của boxShadow và độ trong suốt
                                spreadRadius:
                                    5, // Bán kính mở rộng của boxShadow
                                blurRadius: 7, // Bán kính mờ của boxShadow
                                offset: const Offset(0,
                                    3), // Độ dịch chuyển của boxShadow theo trục x và y
                              ),
                            ],
                          ),
                          height: 120,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      item.product.imgProduct,
                                      fit: BoxFit.fill,
                                      width: 150,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 200,
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            item.product.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              updateQuantity(
                                                  item.product, false);
                                            },
                                            icon:
                                                const Icon(Icons.remove_circle),
                                            color: const Color.fromARGB(
                                                255, 255, 115, 0),
                                          ),
                                          Text(item.quantity.toString()),
                                          IconButton(
                                            onPressed: () {
                                              updateQuantity(
                                                  item.product, true);
                                            },
                                            icon: const Icon(Icons.add_circle),
                                            color: const Color.fromARGB(
                                                255, 255, 115, 0),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 0),
                                      child: SizedBox(
                                        width: 60,
                                        child: RichText(
                                            text: TextSpan(children: [
                                          const TextSpan(
                                              text: '\$ ',
                                              style: TextStyle(
                                                  color: Colors.orange)),
                                          TextSpan(
                                              text:
                                                  item.product.price.toString())
                                        ])),
                                      )),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    width: 60,
                                    child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        text: TextSpan(children: [
                                          const TextSpan(
                                              text: '\$ ',
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: (item.product.price *
                                                      item.quantity)
                                                  .toStringAsFixed(2),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17))
                                        ])),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 197, 197, 197)
                        .withOpacity(0.5), // Màu của boxShadow và độ trong suốt
                    spreadRadius: 5, // Bán kính mở rộng của boxShadow
                    blurRadius: 7, // Bán kính mờ của boxShadow
                    offset: const Offset(
                        0, 3), // Độ dịch chuyển của boxShadow theo trục x và y
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: couponController,
                            decoration: InputDecoration(
                              hintText: 'Enter your discount code',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.orange, width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                    color: Colors.orange, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                    color: Colors.orange, width: 1.0),
                              ),
                            ),
                            cursorColor: Colors.orange,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(60, 55),
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              applyCoupon(couponController.text);
                            },
                            child: const Text(
                              'Apply',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  ),
                  Consumer<ProviderFood>(
                    builder: (context, providerFood, child) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Item Total:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                '\$ ${itemTotal()}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Tax:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '\$ ${providerFood.couponPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Divider(
                              color: Color.fromRGBO(0, 0, 0, 0.094),
                              height: 1,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              Text(
                                '\$ ${(double.parse(itemTotal()) - providerFood.couponPrice) < 0 ? 0.toStringAsFixed(2) : (double.parse(itemTotal()) - providerFood.couponPrice).toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width, 50),
                                    padding: const EdgeInsets.all(5),
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: checkout,
                                child: const Text(
                                  'Checkout',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )),
                          )
                        ],
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
