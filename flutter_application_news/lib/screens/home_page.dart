import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_get_api_news/extensions/extension_date.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:flutter_application_get_api_news/screens/discover_page.dart';
import 'package:flutter_application_get_api_news/screens/read_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  void tongleDarkMode() {
    context.read<ListProvider>().isDarkMode =
        !context.read<ListProvider>().isDarkMode;
    context.read<ListProvider>().saveSettingLocal(
        context.read<ListProvider>().isChangeHomeView,
        context.read<ListProvider>().isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: !context.read<ListProvider>().isDarkMode
            ? null
            : const Color.fromARGB(255, 41, 41, 41),
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Breaking News',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: !context.read<ListProvider>().isDarkMode
                        ? null
                        : const Color.fromARGB(255, 236, 236, 236),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DiscoverPage(),
                        ));
                  },
                  child: const Text(
                    'View all',
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Consumer<ListProvider>(
                builder: (context, listProvider, _) {
                  final listDataSlider = listProvider.listDataSlider;
                  return FutureBuilder(
                    future: listProvider.getDataApi(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return Center(
                            child: CircularProgressIndicator(
                              color: listProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          );
                        case ConnectionState.done:
                          if (listDataSlider.isEmpty) {
                            return Center(
                              child: Text(
                                'Unable to load data.\nPlease try again later!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: listProvider.isDarkMode
                                      ? Colors.white
                                      : null,
                                ),
                              ),
                            );
                          } else {
                            return contentSlider(listDataSlider);
                          }
                      }
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recommendation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: !context.read<ListProvider>().isDarkMode
                          ? null
                          : const Color.fromARGB(255, 236, 236, 236),
                    )),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DiscoverPage(),
                          ));
                    },
                    child: const Text('View all',
                        style: TextStyle(color: Colors.blue)))
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(child: Expanded(child: getDataFromAPI(context)))
          ],
        ),
      ),
    );
  }

  Container contentSlider(List<dynamic> listDataSlider) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 2,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          initialPage: 1,
          autoPlay: true,
        ),
        items: listDataSlider
            .map((item) => Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadPage(
                              id: item['source']['id'],
                              title: item['title'],
                              author: item['author'],
                              name: item['source']['name'],
                              publishedAt: item['publishedAt'],
                              urlToImage: item['urlToImage'],
                              content: item['content'],
                            ),
                          ));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Stack(
                          children: <Widget>[
                            Hero(
                              tag: 'location-img-${item['urlToImage']}',
                              child: Image.network(
                                item['urlToImage'],
                                fit: BoxFit.cover,
                                width: 1000.0,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 15,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(item['source']['name'],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13)),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(200, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0),
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: item['author'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13)),
                                      const TextSpan(
                                          text: '  -  ',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      TextSpan(
                                          text:
                                              ExtensionDate.formatDateReadPage(
                                                  item['publishedAt']
                                                      .toString()
                                                      .substring(
                                                          0,
                                                          item['publishedAt']
                                                              .toString()
                                                              .indexOf('T'))),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13))
                                    ])),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${item['title']}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  FutureBuilder<dynamic> getDataFromAPI(BuildContext context) {
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
            if (context.watch<ListProvider>().listDataApi.isEmpty) {
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
              return listDataFromApi(context);
            }
        }
      },
    );
  }

  ListView listDataFromApi(BuildContext context) {
    var readListProvider = context.read<ListProvider>();

    return ListView.builder(
      itemCount: readListProvider.listDataApi.length,
      itemBuilder: (context, index) {
        final item = readListProvider.listDataApi[index];
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
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(children: [
              Hero(
                  tag: 'location-img-${item['urlToImage']}',
                  child: imageProvider(item)),
              const SizedBox(
                width: 10,
              ),
              Container(
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
                          fontSize: 18,
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

CachedNetworkImage imageProvider(item) {
  return CachedNetworkImage(
    imageUrl: item['urlToImage'],
    placeholder: (context, url) => const CircularProgressIndicator(),
    errorWidget: (context, url, error) => Image.asset(
      'img/error_img.jpg',
      width: 150,
      height: 150,
    ),
    imageBuilder: (context, imageProvider) {
      return Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
      );
    },
  );
}
