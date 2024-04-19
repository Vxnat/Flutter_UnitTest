import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/extensions/extension_date.dart';
import 'package:flutter_application_e_commerce_app/modules/banner_slider.dart';
import 'package:flutter_application_e_commerce_app/modules/cart.dart';
import 'package:flutter_application_e_commerce_app/modules/category.dart';
import 'package:flutter_application_e_commerce_app/modules/coupon.dart';
import 'package:flutter_application_e_commerce_app/modules/order.dart';
import 'package:flutter_application_e_commerce_app/modules/production.dart';

class ProviderFood extends ChangeNotifier {
  List<Product> listProducts = [
    Product(
        id: '1',
        idCategory: 'Burger',
        name: 'Burger Beef',
        nameBrand: 'BurgerKing',
        price: 17.58,
        description:
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
        cookingTime: '30mins',
        imgProduct: 'img/burger.jpg',
        quantitySold: 10),
    Product(
        id: '2',
        idCategory: 'Pizza',
        name: 'Pizza Chicken',
        nameBrand: 'PizzaKing',
        price: 5.52,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/pizza.jpg',
        quantitySold: 10),
    Product(
        id: '3',
        idCategory: 'Hotdog',
        name: 'Hotdog',
        nameBrand: 'PizzaKing',
        price: 7.34,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/hotdog.png',
        quantitySold: 10),
    Product(
        id: '4',
        idCategory: 'Pizza',
        name: 'Pizza Seafood',
        nameBrand: 'PizzaKing',
        price: 8.12,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/pizza_seafood.jpg',
        quantitySold: 10),
    Product(
        id: '5',
        idCategory: 'Pizza',
        name: 'Pizza Hawaii',
        nameBrand: 'Pizza Hut',
        price: 9.32,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/pizza_hawaii.jpg',
        quantitySold: 10),
    Product(
        id: '6',
        idCategory: 'Pizza',
        name: 'Pizza Beef',
        nameBrand: 'PizzaKing',
        price: 14.56,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/pizza_beef.jpg',
        quantitySold: 10),
    Product(
        id: '7',
        idCategory: 'Pizza',
        name: 'Pizza Margherita',
        nameBrand: 'PizzaKing',
        price: 22.33,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/pizza_margherita.jpg',
        quantitySold: 10),
    Product(
        id: '8',
        idCategory: 'Pizza',
        name: 'Pizza Pesto.jpg',
        nameBrand: 'PizzaKing',
        price: 11.22,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/pizza_pesto.jpg',
        quantitySold: 10),
    Product(
        id: '9',
        idCategory: 'Pizza',
        name: 'Pizza Pepperoni.jpg',
        nameBrand: 'PizzaKing',
        price: 41.23,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/pizza_pepperoni.jpg',
        quantitySold: 10),
    Product(
        id: '10',
        idCategory: 'Pizza',
        name: 'Pizza Cheese',
        nameBrand: 'PizzaKing',
        price: 5.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/pizza_cheese.jpg',
        quantitySold: 10),
    Product(
        id: '11',
        idCategory: 'Drink',
        name: 'Coca cola',
        nameBrand: 'CocaCola',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/coca_cola.jpg',
        quantitySold: 10),
    Product(
        id: '12',
        idCategory: 'Drink',
        name: 'Pepsi',
        nameBrand: 'Pepsi',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/pepsi.jpg',
        quantitySold: 10),
    Product(
        id: '13',
        idCategory: 'Drink',
        name: 'Sprite',
        nameBrand: 'Sprite',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/sprite.jpg',
        quantitySold: 10),
    Product(
        id: '14',
        idCategory: 'Drink',
        name: 'Sting blue',
        nameBrand: 'Sting',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/sting_blue.jpg',
        quantitySold: 10),
    Product(
        id: '15',
        idCategory: 'Drink',
        name: '7Up',
        nameBrand: '7Up',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/7up.png',
        quantitySold: 10),
    Product(
        id: '16',
        idCategory: 'Burger',
        name: 'Burger Chicken',
        nameBrand: 'Burger King',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/burger_chicken.jpg',
        quantitySold: 10),
    Product(
        id: '17',
        idCategory: 'Burger',
        name: 'Burger Fish',
        nameBrand: 'Burger King',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/burger_fish.jpg',
        quantitySold: 10),
    Product(
        id: '18',
        idCategory: 'Burger',
        name: 'Burger Sheep',
        nameBrand: 'Burger King',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/burger_sheep.png',
        quantitySold: 10),
    Product(
        id: '19',
        idCategory: 'Sandwich',
        name: 'Sandwich Cheese',
        nameBrand: 'Sandwich King',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/cheese_sandwich.jpg',
        quantitySold: 10),
    Product(
        id: '20',
        idCategory: 'Sandwich',
        name: 'Sandwich Chicken',
        nameBrand: 'Sandwich King',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/chicken_sandwich.jpg',
        quantitySold: 10),
    Product(
        id: '21',
        idCategory: 'Sandwich',
        name: 'Monte Cristo Sandwich',
        nameBrand: 'Sandwich King',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/monte_cristo_sandwich.jpg',
        quantitySold: 10),
    Product(
        id: '22',
        idCategory: 'Sandwich',
        name: 'Tuna Sandwich',
        nameBrand: 'Sandwich King',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/tuna_sandwich.jpg',
        quantitySold: 10),
    Product(
        id: '23',
        idCategory: 'Noodle',
        name: 'Cannelloni Noodle',
        nameBrand: 'Noodle King',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/cannelloni_noodle.jpg',
        quantitySold: 10),
    Product(
        id: '24',
        idCategory: 'Noodle',
        name: 'Linguine Noodle',
        nameBrand: 'Noodle King',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/linguine_noodle.jpg',
        quantitySold: 10),
    Product(
        id: '25',
        idCategory: 'Noodle',
        name: 'Penne Noodle',
        nameBrand: 'Penne Noodle',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/penne_noodle.jpg',
        quantitySold: 10),
    Product(
        id: '26',
        idCategory: 'Noodle',
        name: 'Spaghetti Noodle',
        nameBrand: 'Penne Noodle',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/spaghetti_noodle.jpg',
        quantitySold: 10),
    Product(
        id: '27',
        idCategory: 'Hotdog',
        name: 'Hotdog Chocolate',
        nameBrand: 'Hotdog King',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/hotdog_chocolate.jpg',
        quantitySold: 10),
    Product(
        id: '28',
        idCategory: 'Hotdog',
        name: 'Hotdog Korea',
        nameBrand: 'Hotdog King',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/hotdog_korea.jpg',
        quantitySold: 10),
    Product(
        id: '29',
        idCategory: 'Hotdog',
        name: 'Hotdog Rainbow',
        nameBrand: 'Hotdog King',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/hotdog_rainbow.png',
        quantitySold: 10),
    Product(
        id: '30',
        idCategory: 'Sandwich',
        name: 'Egg Sandwich',
        nameBrand: 'Sandwich King',
        price: 3.76,
        description: 'Good',
        cookingTime: '30mins',
        imgProduct: 'img/egg_sandwich.jpg',
        quantitySold: 10),
  ];
  List<Coupon> listCoupons = [
    Coupon(coupon: 'anhtu', price: 2.00, isUse: false),
    Coupon(coupon: 'tuanhung', price: 10.00, isUse: false)
  ];
  List<Cart> listCarts = [];
  List<Category> listCategories = [
    Category(
      id: 'Pizza',
      name: 'Pizza',
      imgCategory: 'img/pizza_category.png',
      color: const Color.fromARGB(255, 253, 205, 166),
    ),
    Category(
      id: 'Burger',
      name: 'Burger',
      imgCategory: 'img/hamburger_category.png',
      color: const Color.fromARGB(255, 253, 205, 166),
    ),
    Category(
      id: 'Hotdog',
      name: 'Hotdog',
      imgCategory: 'img/hotdog_category.png',
      color: const Color.fromARGB(255, 253, 205, 166),
    ),
    Category(
      id: 'Drink',
      name: 'Drink',
      imgCategory: 'img/drink_category.png',
      color: const Color.fromARGB(255, 253, 205, 166),
    ),
    Category(
      id: 'Noodle',
      name: 'Noodle',
      imgCategory: 'img/noodle_category.png',
      color: const Color.fromARGB(255, 253, 205, 166),
    ),
    Category(
      id: 'Sandwich',
      name: 'Sandwich',
      imgCategory: 'img/sandwich_category.png',
      color: const Color.fromARGB(255, 253, 205, 166),
    ),
  ];
  List<BannerSlider> listBanner = [
    BannerSlider(id: '1', name: 'Pizza', imgBanner: 'img/pizza_banner.jpg'),
    BannerSlider(id: '2', name: 'Burger', imgBanner: 'img/burger_banner.jpg'),
    BannerSlider(
        id: '3', name: 'Fastfood', imgBanner: 'img/fastfood_banner.jpg')
  ];
  List<Product> listFilter = [];
  List<Product> listFavorite = [];
  List<Order> listOders = [];
  double couponPrice = 0;
  String coupon = '';

  void addToCart(Product product, int quantity) {
    bool isContain =
        listCarts.any((element) => element.product.id == product.id);
    if (isContain) {
      final Cart item =
          listCarts.firstWhere((element) => element.product.id == product.id);
      item.quantity += quantity;
    } else {
      listCarts.insert(0, Cart(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(Product product, bool isIncrease) {
    bool isContain =
        listCarts.any((element) => element.product.id == product.id);
    if (isContain) {
      if (isIncrease) {
        final Cart item =
            listCarts.firstWhere((element) => element.product.id == product.id);
        item.quantity++;
      } else {
        final Cart item =
            listCarts.firstWhere((element) => element.product.id == product.id);
        if (item.quantity > 1) {
          item.quantity--;
        } else {
          listCarts.remove(item);
          listCarts.isEmpty ? couponPrice = 0 : null;
        }
      }
    }
    notifyListeners();
  }

  void applyCoupon(String coupon) {
    bool isContain = listCoupons.any((element) => element.coupon == coupon);
    if (isContain) {
      final Coupon item =
          listCoupons.firstWhere((element) => element.coupon == coupon);
      couponPrice = item.price;
      this.coupon = item.coupon;
      notifyListeners();
    }
  }

  void filterData(String nameProduct, String idCategory, String kindOfSearch) {
    if (kindOfSearch == 'searchBar') {
      listFilter = listProducts
          .where((element) =>
              element.name.toLowerCase().contains(nameProduct.toLowerCase()))
          .toList();
    } else if (kindOfSearch == 'searchCategory') {
      listFilter = listProducts
          .where((element) => element.idCategory == idCategory)
          .toList();
    }
    notifyListeners();
  }

  void updateFavoriteProduct(Product product) {
    bool isContain = listFavorite.any((element) => element.id == product.id);
    if (!isContain) {
      listFavorite.insert(0, product);
    } else {
      final item =
          listFavorite.firstWhere((element) => element.id == product.id);
      listFavorite.remove(item);
    }
    notifyListeners();
  }

  void addToOrder(String totalPrice) {
    final List<Cart> clonedListCarts =
        List.from(listCarts); // Tạo một bản sao của listCarts
    listOders.insert(
        0,
        Order(
            id: generateRandomOrderID(),
            date: ExtensionDate.formatDateHomePage(DateTime.now()),
            listCarts: clonedListCarts,
            totalPrice: totalPrice));
    if (coupon != '') {
      final item =
          listCoupons.firstWhere((element) => element.coupon == coupon);
      item.isUse = true;
    }
    coupon = '';
    couponPrice = 0;
    updateQuantitySold();
    listCarts.clear();
    notifyListeners();
  }

  void updateQuantitySold() {
    for (Cart item in listCarts) {
      bool isContain =
          listProducts.any((element) => element.id == item.product.id);
      if (isContain) {
        final Product product =
            listProducts.firstWhere((element) => element.id == item.product.id);
        product.quantitySold += item.quantity;
      }
    }
    notifyListeners();
  }

  String generateRandomOrderID() {
    final random = Random();
    String result = '#';
    for (int i = 0; i < 5; i++) {
      result += random.nextInt(10).toString();
    }
    result += '-';
    for (int i = 0; i < 9; i++) {
      result += random.nextInt(10).toString();
    }
    return result;
  }
}
