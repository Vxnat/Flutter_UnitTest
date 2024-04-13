import 'package:flutter/material.dart';
import 'package:flutter_application_get_api_news/extensions/extension_date.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ReadPage extends StatefulWidget {
  String? urlToImage;
  String? title;
  String? author;
  String? name;
  String? publishedAt;
  String? content;
  ReadPage({
    Key? key,
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
  String? title;
  String? author;
  String? name;
  String? publishedAt;
  String? urlToImage;
  String? content;
  String? timeRead;
  bool isFavorite = false;
  TextEditingController commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    title = widget.title ?? '';
    author = widget.author ?? '';
    name = widget.name ?? '';
    publishedAt = widget.publishedAt ?? '';
    urlToImage = widget.urlToImage ?? '';
    content = widget.content ?? '';
    isFavorite =
        context.read<ListProvider>().isListContainItem(title.toString());
  }

  Future<bool> tongleFavorite(bool isLiked) async {
    isFavorite = !isFavorite;
    if (isFavorite) {
      context.read<ListProvider>().addFavoriteItem(
          title.toString(),
          author.toString(),
          name.toString(),
          urlToImage.toString(),
          publishedAt.toString(),
          content.toString());
    } else {
      context.read<ListProvider>().removeFavoriteItem(title.toString());
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
                      icon: Icon(
                        Icons.comment_rounded,
                        color: !context.read<ListProvider>().isDarkMode
                            ? Colors.black
                            : Colors.grey[400],
                      )),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: 1000,
                  height: 300,
                  child: Image.network(
                    urlToImage!,
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
                    padding: const EdgeInsets.all(5),
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
}
