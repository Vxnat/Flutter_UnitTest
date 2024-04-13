import 'package:flutter/material.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:flutter_application_get_api_news/screens/read_page.dart';
import 'package:flutter_application_get_api_news/screens/read_page_new_version.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Favorite',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: !context.read<ListProvider>().isDarkMode
                    ? Colors.white
                    : Colors.white),
          ),
          backgroundColor: !context.read<ListProvider>().isDarkMode
              ? Colors.grey[900]
              : const Color.fromARGB(255, 41, 41, 41),
          centerTitle: true,
        ),
        body: Container(
            color: !context.read<ListProvider>().isDarkMode
                ? Colors.white
                : Colors.grey[800],
            padding: const EdgeInsets.all(15),
            child: Expanded(child: Consumer<ListProvider>(
              builder: (context, listProvider, child) {
                if (listProvider.listFavorite.isEmpty) {
                  return Center(
                      child: Text(
                    'Your favorite is empty',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: !context.read<ListProvider>().isDarkMode
                            ? Colors.black
                            : Colors.grey[200]),
                  ));
                }
                return ListView.builder(
                  itemCount: listProvider.listFavorite.length,
                  itemBuilder: (context, index) {
                    final item = listProvider.listFavorite[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReadPageNewVersion(
                                title: item.title,
                                name: item.name,
                                publishedAt: item.publishedAt,
                                urlToImage: item.urlToImage,
                                content: item.content,
                              ),
                            ));
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Image.network(
                                item.urlToImage.toString(),
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return const CircularProgressIndicator(
                                      color: Colors.black,
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'img/error_img.jpg',
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
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
                                  item.name.toString(),
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    item.title.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: !context
                                                .read<ListProvider>()
                                                .isDarkMode
                                            ? null
                                            : Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.author.toString(),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    Text(
                                      item.publishedAt
                                          .toString()
                                          .toString()
                                          .substring(
                                              0,
                                              item.publishedAt
                                                  .toString()
                                                  .toString()
                                                  .indexOf('T')),
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
              },
            ))));
  }
}
