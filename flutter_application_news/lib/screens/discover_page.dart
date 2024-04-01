import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_get_api_news/auth/auth_service.dart';
import 'package:flutter_application_get_api_news/extensions/extension_date.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:flutter_application_get_api_news/screens/read_page.dart';
import 'package:provider/provider.dart';

// Chuyen giao giua Fav va Home thi data ko load lai
class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;
  bool isSearching = false; // Trạng thái thanh Search
  bool isBusy = false;
  bool isApiCalled = false;
  bool isShowNotFound = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void tongleHomeView() {
    context.read<ListProvider>().isChangeHomeView =
        !context.read<ListProvider>().isChangeHomeView;
    if (context.read<ListProvider>().isChangeHomeView) {
      context
          .read<ListProvider>()
          .splitListDataApi(context.read<ListProvider>().listDataApi);
      context.read<ListProvider>().currentTitleSearch = '';
      context.read<ListProvider>().currentNameSearch = 'All';
      selectedIndex = 0;
    }
    context.read<ListProvider>().saveSettingLocal(
        context.read<ListProvider>().isChangeHomeView,
        context.read<ListProvider>().isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    // print(context.read<ListProvider>().listDataApi.)
    return Scaffold(
      body: Container(
        color: !context.read<ListProvider>().isDarkMode
            ? null
            : const Color.fromARGB(255, 41, 41, 41),
        padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discover',
                  style: TextStyle(
                    color: !context.read<ListProvider>().isDarkMode
                        ? null
                        : Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Text(
              'New from all around the world',
              style: TextStyle(color: Colors.grey),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              height: 40,
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  if (context.read<ListProvider>().listDataApi.isNotEmpty) {
                    if (value.isEmpty) {
                      isSearching = false;
                      context.read<ListProvider>().currentTitleSearch = '';
                      context.read<ListProvider>().filterDataWhenSearch(
                          value,
                          !context.read<ListProvider>().isChangeHomeView
                              ? false
                              : true);
                    } else {
                      isSearching = true;
                      context.read<ListProvider>().currentTitleSearch = value;
                      context.read<ListProvider>().filterDataWhenSearch(
                          value,
                          !context.read<ListProvider>().isChangeHomeView
                              ? false
                              : true);
                    }
                  }
                },
                style: const TextStyle(color: Colors.black),
                cursorColor: const Color.fromARGB(255, 109, 109, 109),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
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
            if (!context.read<ListProvider>().isChangeHomeView)
              Expanded(child: getDataFromAPI([]))
            else if (context.read<ListProvider>().part1.isEmpty)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 300),
                  child: Text(
                    'Not Found!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: !context.read<ListProvider>().isDarkMode
                          ? null
                          : Colors.white,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(5, (index) {
                      late List<dynamic> currentPart;
                      switch (index + 1) {
                        case 1:
                          currentPart = context.read<ListProvider>().part1;
                          break;
                        case 2:
                          currentPart = context.read<ListProvider>().part2;
                          break;
                        case 3:
                          currentPart = context.read<ListProvider>().part3;
                          break;
                        case 4:
                          currentPart = context.read<ListProvider>().part4;
                          break;
                        case 5:
                          currentPart = context.read<ListProvider>().part5;
                          break;
                        default:
                      }
                      return Container(
                        height: 140,
                        margin: const EdgeInsets.only(bottom: 5),
                        child: getDataFromAPI(currentPart),
                      );
                    }),
                  ),
                ),
              ),
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
            hoverColor: Colors.white,
            splashColor: Colors.white,
            onTap: () {
              if (!isBusy) {
                setState(() {
                  selectedIndex = index;
                  // Khi lựa chọn 1 tên khác ALL , có thể thanh Search đang rỗng hoặc ko rỗng
                  if (context.read<ListProvider>().listNameArticle[index] !=
                      'All') {
                    isSearching = true;
                    context.read<ListProvider>().currentNameSearch =
                        context.read<ListProvider>().listNameArticle[index];
                    context.read<ListProvider>().filterDataWhenSearch(
                        context.read<ListProvider>().currentTitleSearch,
                        !context.read<ListProvider>().isChangeHomeView
                            ? false
                            : true);
                    isBusy = true;
                    isShowNotFound = false;
                  } else {
                    // Khi lựa chọn ALL , thanh Search rỗng
                    if (context
                        .read<ListProvider>()
                        .currentTitleSearch
                        .isEmpty) {
                      isSearching = false;
                      isShowNotFound = false;
                      context.read<ListProvider>().splitListDataApi(
                          context.read<ListProvider>().listDataApi);
                    } else {
                      // Khi lựa chọn ALL , thanh Search không rỗng
                      isSearching = true;
                      isShowNotFound = false;
                    }
                    context.read<ListProvider>().currentNameSearch = 'All';
                    context.read<ListProvider>().filterDataWhenSearch(
                        context.read<ListProvider>().currentTitleSearch,
                        !context.read<ListProvider>().isChangeHomeView
                            ? false
                            : true);
                    isBusy = true;
                  }
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                color: isSelected
                    ? Colors.blue
                    : const Color.fromARGB(255, 231, 231, 231),
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

  FutureBuilder<dynamic> getDataFromAPI(List<dynamic> listData) {
    return FutureBuilder(
      future: context.read<ListProvider>().getDataApi(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: CircularProgressIndicator(
                  color: !context.read<ListProvider>().isDarkMode
                      ? Colors.black
                      : Colors.white),
            );
          case ConnectionState.done:
            if (isSearching &&
                context.read<ListProvider>().filteredList.isEmpty) {
              isBusy = false;
              // Khi chế độ mặc định
              return Center(
                child: Text(
                  'Not Found!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: !context.read<ListProvider>().isDarkMode
                        ? null
                        : Colors.white,
                  ),
                ),
              );
            } else if (context.watch<ListProvider>().listDataApi.isEmpty) {
              // Khi API bị lỗi
              return Center(
                child: Text(
                  'Unable to load data.\nPlease try again later!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: !context.read<ListProvider>().isDarkMode
                        ? null
                        : Colors.white,
                  ),
                ),
              );
            } else {
              // Khi mọi thứ bình thường
              isBusy = false; // Chua xu li dc khi chuyen sang che do xem ngang
              isShowNotFound = false;
              return listDataFromApi(listData);
            }
        }
      },
    );
  }

  ListView listDataFromApi(List<dynamic> listData) {
    var watchListProvider = context.watch<ListProvider>();
    return ListView.builder(
      // isSearching : Thanh tìm kiếm đang có kí tự
      // context.read<ListProvider>().currentNameSearch : Phần button list view được chọn ngoài All
      scrollDirection: !context.read<ListProvider>().isChangeHomeView
          ? Axis.vertical
          : Axis.horizontal,
      itemCount: !context.read<ListProvider>().isChangeHomeView
          ? isSearching ||
                  context.read<ListProvider>().currentNameSearch != 'All'
              ? context.read<ListProvider>().filteredList.length
              : watchListProvider.listDataApi.length
          : isSearching ||
                  context.read<ListProvider>().currentNameSearch != 'All'
              ? listData.length
              : listData.length,
      itemBuilder: (context, index) {
        final item = !context.read<ListProvider>().isChangeHomeView
            ? isSearching ||
                    context.read<ListProvider>().currentNameSearch != 'All'
                ? context.read<ListProvider>().filteredList[index]
                : watchListProvider.listDataApi[index]
            : isSearching ||
                    context.read<ListProvider>().currentNameSearch != 'All'
                ? listData[index]
                : listData[index];
        final itemSource = item['source'];
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadPage(
                      id: itemSource['id'],
                      title: item['title'],
                      author: item['author'],
                      name: itemSource['name'],
                      publishedAt: item['publishedAt'],
                      urlToImage: item['urlToImage'],
                      content: item['content']),
                ));
          },
          child: Container(
            width: !context.read<ListProvider>().isChangeHomeView
                ? double.infinity
                : null,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(children: [
              Hero(
                  tag: 'location-img-${item['urlToImage']}',
                  child: imageProvider(item)),
              const SizedBox(
                width: 5,
              ),
              Container(
                width: 260,
                height: 120,
                margin: !context.read<ListProvider>().isChangeHomeView
                    ? null
                    : const EdgeInsets.only(right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${itemSource['name']}',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                    Text(
                      item['title'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: !context.read<ListProvider>().isDarkMode
                              ? null
                              : Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              context.read<ListProvider>().getRandomAvatarUrl(),
                              height: 30,
                              width: 30,
                            ),
                            Text(
                              item['author'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          item['publishedAt'].toString().substring(
                              0, item['publishedAt'].toString().indexOf('T')),
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
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
      placeholder: (context, url) => const CircularProgressIndicator(
        color: Colors.black,
      ),
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
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
        );
      },
    );
  }
}
