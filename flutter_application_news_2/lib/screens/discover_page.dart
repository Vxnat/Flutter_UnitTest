import 'package:flutter/material.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:flutter_application_get_api_news/screens/home_page.dart';
import 'package:flutter_application_get_api_news/screens/read_page_new_version.dart';
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
    context.read<ListProvider>().loadDataSetting();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          );
                    } else {
                      isSearching = true;
                      context.read<ListProvider>().currentTitleSearch = value;
                      context.read<ListProvider>().filterDataWhenSearch(
                            value,
                          );
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
                        );
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
                    } else {
                      // Khi lựa chọn ALL , thanh Search không rỗng
                      isSearching = true;
                      isShowNotFound = false;
                    }
                    context.read<ListProvider>().currentNameSearch = 'All';
                    context.read<ListProvider>().filterDataWhenSearch(
                          context.read<ListProvider>().currentTitleSearch,
                        );
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

  FutureBuilder<dynamic> getDataFromAPI() {
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
      // context.read<ListProvider>().currentNameSearch : Phần button list view được chọn ngoài All
      itemCount:
          isSearching || context.read<ListProvider>().currentNameSearch != 'All'
              ? context.read<ListProvider>().filteredList.length
              : watchListProvider.listDataApi.length,
      itemBuilder: (context, index) {
        final item = isSearching ||
                context.read<ListProvider>().currentNameSearch != 'All'
            ? context.read<ListProvider>().filteredList[index]
            : watchListProvider.listDataApi[index];
        final itemSource = item['source'];
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadPageNewVersion(
                    title: item['title'],
                    author: item['author'],
                    name: itemSource['name'],
                    publishedAt: item['publishedAt'],
                    urlToImage: item['urlToImage'],
                    content: item['content'] +
                        'On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains. On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains. On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains. On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains.',
                  ),
                ));
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(children: [
              Hero(
                  tag: 'location-img-${item['urlToImage']}',
                  child: showImgNews(item, 150, null)),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 260,
                height: 150,
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
}
