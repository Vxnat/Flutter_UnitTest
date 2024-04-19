import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/components/side_bar_menu.dart';
import 'package:flutter_application_e_commerce_app/provider/provider_food.dart';
import 'package:flutter_application_e_commerce_app/screens/best_sale_product_screen.dart';
import 'package:flutter_application_e_commerce_app/screens/cart_screen.dart';
import 'package:flutter_application_e_commerce_app/screens/filtered_screen.dart';
import 'package:flutter_application_e_commerce_app/screens/production_details_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController searchController;
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterData(String nameProduct, String idCategory, String kindOfSearch) {
    context
        .read<ProviderFood>()
        .filterData(nameProduct, idCategory, kindOfSearch);
    if (idCategory != '') {
      searchController.text = '';
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FilteredScreen(
        currentTextSearch: searchController.text,
      ),
    ));
  }

  void seeAllBestSaleProduct() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const BestSaleProductScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 6),
          child: Row(
            children: [
              Image.asset(
                'img/santa-cruz-skateboards-logo-svgrepo-com.png',
                width: 60,
                height: 60,
              ),
              RichText(
                  text: const TextSpan(children: [
                TextSpan(
                    text: 'Vxnat',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 102, 0), fontSize: 25)),
                TextSpan(
                    text: 'Food',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 102, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 30))
              ]))
            ],
          ),
        ),
        centerTitle: true,
      ),
      drawer: const SideBarMenu(),
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 247, 247, 247)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 45,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 223, 223, 223),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: searchController,
                      cursorColor: const Color.fromARGB(255, 77, 77, 77),
                      decoration: InputDecoration(
                        prefixIcon: Image.asset(
                          'img/search-svgrepo-com.png',
                          width: 10,
                          height: 10,
                        ),
                        hintText: 'Find your food',
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 82, 82, 82),
                            fontStyle: FontStyle.italic,
                            fontSize: 15),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 30.0),
                      ),
                      maxLines: 1,
                      onSubmitted: (newValue) {
                        filterData(searchController.text, '', 'searchBar');
                      },
                    ),
                  ),
                  Consumer<ProviderFood>(
                    builder: (context, providerFood, child) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CartScreen(),
                          ));
                        },
                        child: Stack(children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Image.asset(
                              'img/shopping-basket-shopper-svgrepo-com.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                          providerFood.listCarts.isNotEmpty
                              ? Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      providerFood.listCarts.length.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : Container()
                        ]),
                      );
                    },
                  )
                ],
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 2,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                initialPage: 1,
                autoPlay: true,
              ),
              items: context
                  .read<ProviderFood>()
                  .listBanner
                  .map((item) => Container(
                        margin: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              width: 1000,
                              child: Image.asset(
                                item.imgBanner,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'img/pizza.jpg',
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              margin: const EdgeInsets.only(left: 13, top: 10),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Categories',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.orange),
              ),
            ),
            Container(
              height: 80,
              color: Colors.white,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: context.read<ProviderFood>().listCategories.length,
                itemBuilder: (context, index) {
                  final item =
                      context.read<ProviderFood>().listCategories[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize
                          .min, // Chiều dọc sẽ co lại tối thiểu để vừa với nội dung
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Căn giữa theo chiều dọc
                      children: [
                        GestureDetector(
                          onTap: () {
                            filterData('', item.id, 'searchCategory');
                          },
                          child: Container(
                            width: 70,
                            height: 60,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 240, 215),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Image.asset(
                                  item.imgCategory,
                                  width: 30,
                                  height: 30,
                                ),
                                Text(
                                  item.name, // Nội dung của dòng chữ
                                  style: const TextStyle(
                                      fontSize: 12.0, // Cỡ chữ
                                      color: Color.fromARGB(255, 53, 53, 53),
                                      fontWeight: FontWeight.bold // Màu chữ
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                            height:
                                8.0), // Khoảng cách giữa biểu tượng và dòng chữ
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Best Sale Product',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: seeAllBestSaleProduct,
                    child: const Text(
                      'See more',
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: const Color.fromARGB(255, 240, 240, 240),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Consumer<ProviderFood>(
                    builder: (context, providerFood, child) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Số lượng cột
                          childAspectRatio:
                              3 / 3, // Tỉ lệ khung hình của mỗi item
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: providerFood.listProducts.length > 10
                            ? 10 // Giới hạn số lượng phần tử hiển thị tối đa là 10
                            : providerFood.listProducts
                                .length, // Số lượng phần tử thực tế trong danh sách
                        itemBuilder: (context, index) {
                          final item = providerFood.listProducts[index];
                          if (item.quantitySold >= 10) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailsScreen(item: item),
                                ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.5), // Màu của boxShadow và độ trong suốt
                                      spreadRadius:
                                          5, // Bán kính mở rộng của boxShadow
                                      blurRadius:
                                          7, // Bán kính mờ của boxShadow
                                      offset: const Offset(0,
                                          3), // Độ dịch chuyển của boxShadow theo trục x và y
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      child: Image.asset(
                                        item.imgProduct,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 130,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Text(
                                        item.nameBrand,
                                        style: const TextStyle(
                                            color: Colors.orange,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 10),
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.cookingTime,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13),
                                          ),
                                          Text('\$${item.price.toString()}',
                                              style: const TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
