// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:provider/provider.dart';
import '../components/single_news_item_header_delegate.dart';

// ignore: must_be_immutable
class ReadPageNewVersion extends StatefulWidget {
  String? urlToImage;
  String? title;
  String? author;
  String? name;
  String? publishedAt;
  String? content;
  ReadPageNewVersion({
    Key? key,
    this.title,
    this.author,
    this.name,
    this.publishedAt,
    this.urlToImage,
    this.content,
  }) : super(key: key);

  @override
  State<ReadPageNewVersion> createState() => _ReadPageNewVersionState();
}

class _ReadPageNewVersionState extends State<ReadPageNewVersion>
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

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final maxScreenSizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: !context.read<ListProvider>().isDarkMode
          ? Colors.black
          : Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              delegate: SingleNewsItemHeaderDelegate(
                  listProvider: context.read<ListProvider>(),
                  title: title.toString(),
                  author: author.toString(),
                  name: name.toString(),
                  urlToImage: urlToImage.toString(),
                  publishedAt: publishedAt.toString(),
                  content: content.toString(),
                  isFavorite: isFavorite,
                  minExtent: topPadding + 56,
                  maxExtent: maxScreenSizeHeight / 2)),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: !context.read<ListProvider>().isDarkMode
                      ? Colors.white
                      : const Color.fromARGB(255, 0, 0, 0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        author.toString(),
                        style: TextStyle(
                            fontSize: 25,
                            color: !context.read<ListProvider>().isDarkMode
                                ? Colors.black
                                : Colors.white),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                        size: 25,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    content.toString(),
                    style: TextStyle(
                        color: !context.read<ListProvider>().isDarkMode
                            ? Colors.black
                            : Colors.white),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
