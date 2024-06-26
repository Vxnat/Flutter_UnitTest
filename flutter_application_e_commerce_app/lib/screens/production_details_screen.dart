import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/modules/production.dart';
import 'package:flutter_application_e_commerce_app/provider/provider_food.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product item;
  const ProductDetailsScreen({super.key, required this.item});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final Product item;
  late TextEditingController quantityController;
  late bool isFavorite;
  final snackBar = const SnackBar(
    content: Text('Thêm thành công'),
    duration: Duration(milliseconds: 500),
  );
  @override
  void initState() {
    super.initState();
    item = widget.item;
    quantityController = TextEditingController(text: '1');
    isFavorite = context
        .read<ProviderFood>()
        .listFavorite
        .any((element) => element.id == item.id);
  }

  void addToCart(Product product, int quantity) {
    context.read<ProviderFood>().addToCart(product, quantity);
  }

  void updateFavoriteProduct() {
    isFavorite = !isFavorite;
    context.read<ProviderFood>().updateFavoriteProduct(item);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Stack(children: [
              Image.asset(
                item.imgProduct,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      )),
                ),
              ),
            ]),
            Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: () {
                    updateFavoriteProduct();
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  )),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 15, left: 15, right: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Text(
                        '\$${item.price.toString()}',
                        style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer<ProviderFood>(
                          builder: (context, value, child) {
                            return Text(
                              'Đã bán ${item.quantitySold.toString()}',
                            );
                          },
                        ),
                        Row(
                          children: [
                            Text(item.cookingTime),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Image.asset(
                                'img/fire-svgrepo-com.png',
                                width: 25,
                                height: 25,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      item.description,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Quantity',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      IconButton(
                        onPressed: () {
                          if (int.parse(quantityController.text) != 1) {
                            int newQuantity =
                                int.parse(quantityController.text);
                            newQuantity--;
                            quantityController.text = newQuantity.toString();
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.orange,
                      ),
                      SizedBox(
                        width: 35,
                        height: 20,
                        child: TextField(
                          controller: quantityController,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.orange,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 206, 132))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange)),
                            contentPadding: EdgeInsets.only(bottom: 18),
                          ),
                          onChanged: (value) {
                            if (int.parse(value) <= 0) {
                              int newQuantity = 1;
                              quantityController.text = newQuantity.toString();
                            } else {
                              int newQuantity = int.parse(value);
                              quantityController.text = newQuantity.toString();
                            }
                            setState(() {});
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          int newQuantity = int.parse(quantityController.text);
                          newQuantity++;
                          quantityController.text = newQuantity.toString();
                          setState(() {});
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text('Total Price'),
                            Text(
                              '\$${(item.price * int.parse(quantityController.text)).toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(15),
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              addToCart(
                                  item, int.parse(quantityController.text));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.shopping_cart_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add to cart',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
