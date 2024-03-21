import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:flutter_application_get_api_news/screens/read_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  String formattedDate = '';
  int selectedIndex = 0;
  List<dynamic> filteredList = [];
  bool isSearching = false;
  String currentNameSearch = 'All';
  String currentTitleSearch = '';
  @override
  void initState() {
    super.initState();
    context.read<ListProvider>().loadDataLocal();
    formattedDate = formatDate(DateTime.now());
  }

  String formatDate(DateTime date) {
    String suffix = '';
    int day = date.day;
    if (day == 1 || day == 21 || day == 31) {
      suffix = 'st';
    } else if (day == 2 || day == 22) {
      suffix = 'nd';
    } else if (day == 3 || day == 23) {
      suffix = 'rd';
    } else {
      suffix = 'th';
    }

    String formattedDay = DateFormat('E').format(date); // Lấy thứ
    return '$formattedDay, ${DateFormat('d\'$suffix\' MMMM yyyy').format(date)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDate,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              'Explore',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              height: 35,
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  if (context.read<ListProvider>().listHomeScreen.isNotEmpty) {
                    if (value.isEmpty) {
                      isSearching = false;
                      currentTitleSearch = '';
                      filterDataWhenSearch(value);
                    } else {
                      isSearching = true;
                      currentTitleSearch = value;
                      filterDataWhenSearch(value);
                    }
                  }
                },
                style: const TextStyle(color: Colors.black),
                cursorColor: const Color.fromARGB(255, 109, 109, 109),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      // Border khi widget được focus
                      borderRadius:
                          BorderRadius.circular(10.0), // Border radius
                      borderSide: BorderSide.none, // Xóa bỏ border
                    ),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: const Color.fromARGB(
                        255, 219, 219, 219), // Màu nền của TextFormField
                    prefixIcon: const Icon(Icons.search_sharp),
                    hintText: 'Search for article',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 121, 121, 121))),
              ),
            ),
            buildHorizontalListView(),
            Expanded(child: getDataFromAPI())
          ],
        ),
      ),
    );
  }

  Widget buildHorizontalListView() {
    return Container(
      height: 34,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: ListView.builder(
        itemCount: context.watch<ListProvider>().listNameArticle.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
                if (context.read<ListProvider>().listNameArticle[index] !=
                    'All') {
                  isSearching = true;
                  currentNameSearch =
                      context.read<ListProvider>().listNameArticle[index];
                  filterDataWhenSearch(currentTitleSearch);
                } else {
                  if (currentTitleSearch.isEmpty) {
                    isSearching = false;
                  } else {
                    isSearching = true;
                  }
                  currentNameSearch = 'All';
                  filterDataWhenSearch(currentTitleSearch);
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: isSelected ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              child: Center(
                  child:
                      Text(context.read<ListProvider>().listNameArticle[index],
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.white : Colors.grey,
                          ))),
            ),
          );
        },
      ),
    );
  }

  FutureBuilder<dynamic> getDataFromAPI() {
    return FutureBuilder(
      future: context.read<ListProvider>().getDataApi(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            if (isSearching && filteredList.isEmpty) {
              return const Center(
                child: Text(
                  'Not Found!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
            } else if (context.watch<ListProvider>().listHomeScreen.isEmpty) {
              return const Center(
                child: Text(
                  'Unable to load data.\nPlease try again later!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return listDataFromApi();
            }
        }
      },
    );
  }

  ListView listDataFromApi() {
    var watchListProvider = context.watch<ListProvider>();
    return ListView.builder(
      // isSearching : Thanh tìm kiếm đang có kí tự
      // currentNameSearch : Phần button list view được chọn ngoài All
      itemCount: isSearching || currentNameSearch != 'All'
          ? filteredList.length
          : watchListProvider.listHomeScreen.length,
      itemBuilder: (context, index) {
        final item = isSearching || currentNameSearch != 'All'
            ? filteredList[index]
            : watchListProvider.listHomeScreen[index];
        final itemSource = item['source'];
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadPage(
                    title: item['title'],
                    name: itemSource['name'],
                    publishedAt: item['publishedAt'],
                    urlToImage: item['urlToImage'],
                    content: item['content'],
                    timeRead: '${randomNumber().toString()}mins',
                  ),
                ));
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(children: [
              Container(child: imageProvider(item)),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 260,
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    Text(
                      'By ${itemSource['name']}',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['publishedAt'].toString().substring(
                              0, item['publishedAt'].toString().indexOf('T')),
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        ),
                        Text(
                          item['source']['name'],
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        ),
                        Text(
                          '${randomNumber().toString()}mins',
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        )
                      ],
                    )
                  ],
                ),
              )
            ]),
          ),
        );
      },
    );
  }

  CachedNetworkImage imageProvider(item) {
    return CachedNetworkImage(
      imageUrl: item['urlToImage'],
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => Image.asset(
        'img/error_img.jpg',
        width: 120,
        height: 120,
      ),
      imageBuilder: (context, imageProvider) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
        );
      },
    );
  }

  void filterDataWhenSearch(String value) {
    setState(() {
      if (value.isEmpty) {
        // Nếu thanh tìm kiếm trống, hiển thị tất cả các mục
        filteredList = [];
        // Nếu thanh tìm kiếm trống nhưng phần Name vẫn chọn 1 cái
        if (currentNameSearch != 'All') {
          filteredList = context
              .read<ListProvider>()
              .listHomeScreen
              .where((item) =>
                  item['source']['name'].toString().toLowerCase() ==
                  currentNameSearch.toLowerCase())
              .toList();
        }
      } else {
        // Nếu thanh tìm kiếm có và phần Name vẫn chọn 1 cái
        if (currentNameSearch != 'All') {
          filteredList = context
              .read<ListProvider>()
              .listHomeScreen
              .where((item) =>
                  item['title']
                      .toString()
                      .toLowerCase()
                      .contains(value.toLowerCase()) &&
                  item['source']['name'].toString().toLowerCase() ==
                      currentNameSearch.toLowerCase())
              .toList();
        } else {
          // Nếu thanh tìm kiếm có và phần Name vẫn chọn All
          filteredList = context
              .read<ListProvider>()
              .listHomeScreen
              .where((item) => item['title']
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()))
              .toList();
        }
      }
    });
  }
}

int randomNumber() {
  // Tạo một số ngẫu nhiên từ 0 đến 8
  Random random = Random();
  int randomNumber = random.nextInt(9);

  // Tăng giá trị số ngẫu nhiên lên 2 để nằm trong phạm vi từ 2 đến 10
  return randomNumber + 2;
}
