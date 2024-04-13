// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_get_api_news/extensions/extension_date.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class SingleNewsItemHeaderDelegate extends SliverPersistentHeaderDelegate {
  final ListProvider listProvider;
  final String title;
  final String author;
  final String name;
  final String urlToImage;
  final String publishedAt;
  final String content;
  bool isFavorite;

  @override
  final double maxExtent;
  @override
  final double minExtent;
  TextEditingController commentController = TextEditingController();

  SingleNewsItemHeaderDelegate({
    required this.listProvider,
    required this.title,
    required this.author,
    required this.name,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.isFavorite,
    required this.maxExtent,
    required this.minExtent,
  });

  bool getFavoriteStatus() {
    return isFavorite;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isFavorite = getFavoriteStatus();
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(tag: 'location-img-$urlToImage', child: showImgNews(urlToImage)),
        Positioned(
          top: 20,
          child: SizedBox(
            width: screenWidth,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Color.fromARGB(255, 139, 139, 139))),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      showComment(context, author);
                    },
                    icon: const Icon(Icons.comment_rounded,
                        color: Color.fromARGB(255, 148, 148, 148))),
                LikeButton(
                  size: 26,
                  isLiked: isFavorite,
                  onTap: (isLiked) {
                    return tongleFavorite(isLiked);
                  },
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xCC000000),
                  Color(0x99000000),
                  Color(0x00000000),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.blue,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  ExtensionDate.formatDateReadPage(publishedAt),
                  style: TextStyle(fontSize: 13, color: Colors.grey[200]),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<bool> tongleFavorite(bool isLiked) async {
    isFavorite = !isFavorite;
    if (isFavorite) {
      listProvider.addFavoriteItem(
          title.toString(),
          author.toString(),
          name.toString(),
          urlToImage.toString(),
          publishedAt.toString(),
          content.toString());
    } else {
      listProvider.removeFavoriteItem(title.toString());
    }
    return !isLiked;
  }

  Future<dynamic> showComment(BuildContext context, String author) {
    return showDialog(
        context: context,
        builder: (context) {
          return Consumer<ListProvider>(
            builder: (context, listProvider, child) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text(
                  'Bài viết của $author',
                  textAlign: TextAlign.center,
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  height: 350,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: listProvider.listComment
                              .where((element) => element.title == title)
                              .toList()
                              .length,
                          itemBuilder: (context, index) {
                            final item = listProvider.listComment.reversed
                                .where((element) => element.title == title)
                                .toList()[index];
                            return ListTile(
                                titleAlignment: ListTileTitleAlignment.top,
                                leading: CircleAvatar(
                                    backgroundColor: const Color.fromARGB(
                                        255, 223, 223, 223),
                                    child: Image.asset(item.avatarUrl)),
                                subtitle: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 219, 219, 219),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'User',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        item.content,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        item.time,
                                        style: const TextStyle(
                                            fontSize: 9,
                                            color: Color.fromARGB(
                                                255, 85, 85, 85)),
                                      )
                                    ],
                                  ),
                                ));
                          },
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Nhập bình luận của bạn...',
                            hintStyle: const TextStyle(fontSize: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 24, 24, 24),
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  context.read<ListProvider>().addCommentItem(
                                      title.toString(),
                                      commentController.text,
                                      ExtensionDate.formatTime(DateTime.now()),
                                      context
                                          .read<ListProvider>()
                                          .getRandomAvatarUrl());
                                  commentController.text = '';
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.blue,
                                ))),
                        maxLines: 1,
                        controller: commentController,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();
  ClipRRect showImgNews(String urlToImage) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        child: Image.network(
          urlToImage,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
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
    );
  }
}
