// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_get_api_news/auth/auth_service.dart';
import 'package:flutter_application_get_api_news/extensions/extension_date.dart';
import 'package:flutter_application_get_api_news/modules/comment.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ReadPage extends StatefulWidget {
  int? id;
  String? urlToImage;
  String? title;
  String? author;
  String? name;
  String? publishedAt;
  String? content;
  ReadPage({
    Key? key,
    this.id,
    this.title,
    this.author,
    this.name,
    this.publishedAt,
    this.urlToImage,
    this.content,
  }) : super(key: key);

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage>
    with SingleTickerProviderStateMixin {
  int? id;
  String? title;
  String? author;
  String? name;
  String? publishedAt;
  String? urlToImage;
  String? content;
  String? timeRead;
  bool isFavorite = false;
  TextEditingController commentController = TextEditingController();
  ListProvider bloc = ListProvider();
  @override
  void initState() {
    super.initState();
    id = widget.id ?? 0;
    title = widget.title ?? '';
    author = widget.author ?? '';
    name = widget.name ?? '';
    publishedAt = widget.publishedAt ?? '';
    urlToImage = widget.urlToImage ?? '';
    content = widget.content ?? '';
    isFavorite = context.read<ListProvider>().isListContainItem(id!);
  }

  Future<bool> tongleFavorite(bool isLiked) async {
    isFavorite = !isFavorite;
    if (isFavorite) {
      context.read<ListProvider>().addFavoriteItem(
          id!,
          title.toString(),
          author.toString(),
          name.toString(),
          urlToImage.toString(),
          publishedAt.toString(),
          content.toString());
    } else {
      context.read<ListProvider>().removeFavoriteItem(id!);
    }
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: !context.read<ListProvider>().isDarkMode
                ? const Color.fromARGB(255, 41, 41, 41)
                : Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              size: 19,
              color: !context.read<ListProvider>().isDarkMode
                  ? Colors.black
                  : Colors.white), // Icon mới cho nút back
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: !context.read<ListProvider>().isDarkMode
            ? Colors.white
            : const Color.fromARGB(255, 41, 41, 41),
        centerTitle: true,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        showComment(context);
                      },
                      icon: const Icon(Icons.comment_rounded)),
                  const SizedBox(
                    width: 10,
                  ),
                  LikeButton(
                    size: 25,
                    isLiked: isFavorite,
                    onTap: (isLiked) {
                      return tongleFavorite(isLiked);
                    },
                  )
                ],
              ))
        ],
      ),
      body: Container(
        color: !context.read<ListProvider>().isDarkMode
            ? Colors.white
            : const Color.fromARGB(255, 41, 41, 41),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'location-img-$urlToImage',
              child: CachedNetworkImage(
                imageUrl: urlToImage.toString(),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => Image.asset(
                  'img/error_img.jpg',
                  width: double.infinity,
                  height: 200,
                ),
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover)),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('#ThayChuyenDepTrai',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(name.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ),
                  Text(
                      ExtensionDate.formatDateReadPage(publishedAt
                          .toString()
                          .substring(0, publishedAt.toString().indexOf('T'))),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Text(content.toString(),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 105, 105, 105),
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            )),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showComment(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Consumer<ListProvider>(
          builder: (context, listProvider, child) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                'Bình luận',
                textAlign: TextAlign.center,
              ),
              content: Container(
                width: double.maxFinite,
                height: 350,
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      child: ListView.builder(
                        itemCount: listProvider.listComment
                            .where(
                                (element) => element.title == title.toString())
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          Comment commentItem =
                              listProvider.listLegal(title.toString())[index];
                          return ListTile(
                              leading: CircleAvatar(
                                  backgroundColor:
                                      const Color.fromARGB(255, 223, 223, 223),
                                  child: Image.asset(commentItem.avatarUrl)),
                              subtitle: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 194, 194, 194),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      commentItem.content,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      commentItem.time,
                                      style: const TextStyle(
                                          fontSize: 9,
                                          color:
                                              Color.fromARGB(255, 85, 85, 85)),
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
                                    ExtensionDate.formatDateHomePage(
                                        DateTime.now()),
                                    context
                                        .read<ListProvider>()
                                        .getRandomAvatarUrl());
                                commentController.text = '';
                              },
                              icon: const Icon(Icons.send))),
                      maxLines: null,
                      controller: commentController,
                    ),
                  ],
                ),
              ),
            );
          },
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
      width: 100,
      height: 100,
    ),
    imageBuilder: (context, imageProvider) {
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
      );
    },
  );
}
