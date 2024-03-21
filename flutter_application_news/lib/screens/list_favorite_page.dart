import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_get_api_news/modules/favorite.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:flutter_application_get_api_news/screens/read_page.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    var watchListFavorite = context.watch<ListProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Favorite',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: context.watch<ListProvider>().listFavorite.isEmpty
            ? const Center(
                child: Text(
                  'Your Favorite is empty!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: watchListFavorite.listFavorite.length,
                itemBuilder: (context, index) {
                  final item = watchListFavorite.listFavorite[index];
                  return Flexible(child: listFavorite(context, item));
                },
              ),
      ),
    );
  }

  InkWell listFavorite(BuildContext context, Favorite item) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReadPage(
                title: item.title,
                name: item.name,
                publishedAt: item.publishedAt,
                urlToImage: item.urlToImage,
                content: item.content,
                timeRead: item.timeRead,
              ),
            ));
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Container(child: imageNetwork(item)),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            width: 260,
            height: 125,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'By ${item.name.toString()}',
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.publishedAt.toString().substring(
                          0, item.publishedAt.toString().indexOf('T')),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                    Text(
                      item.name.toString(),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                    Text(
                      item.timeRead.toString(),
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
  }

  CachedNetworkImage imageNetwork(Favorite item) {
    return CachedNetworkImage(
      imageUrl: item.urlToImage.toString(),
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
}
