import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    String idUser = currentUser.email!.split('@')[0];
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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Favorites')
              .where('idUser', isEqualTo: idUser)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Colors.black,
              );
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'Your favorite is empty',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: !context.read<ListProvider>().isDarkMode
                        ? null
                        : Colors.white,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot document = snapshot.data!.docs[index];
                return Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadPage(
                            id: int.parse(document['idNews']),
                            title: document['title'],
                            name: document['name'],
                            publishedAt: document['publishedAt'],
                            urlToImage: document['urlToImage'],
                            content: document['content'],
                          ),
                        ));
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(children: [
                      Container(
                          child: CachedNetworkImage(
                        imageUrl: document['urlToImage'],
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
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
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover)),
                          );
                        },
                      )),
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
                              document['name'],
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                document['title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color:
                                        !context.read<ListProvider>().isDarkMode
                                            ? null
                                            : Colors.white),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  document['author'],
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                                Text(
                                  document['publishedAt'].toString().substring(
                                      0,
                                      document['publishedAt']
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
                ));
              },
            );
          },
        ));
  }

  // InkWell listFavorite(BuildContext context, Favorite item) {
  //   return
  // }

  // CachedNetworkImage imageNetwork(Favorite item) {
  //   return
  // }
}
