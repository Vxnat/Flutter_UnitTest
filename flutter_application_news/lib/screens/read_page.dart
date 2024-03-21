// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ReadPage extends StatefulWidget {
  String? urlToImage;
  String? title;
  String? name;
  String? publishedAt;
  String? content;
  String? timeRead;
  ReadPage({
    Key? key,
    this.urlToImage,
    this.title,
    this.name,
    this.publishedAt,
    this.content,
    this.timeRead,
  }) : super(key: key);

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  String? title;
  String? name;
  String? publishedAt;
  String? urlToImage;
  String? content;
  String? timeRead;
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    urlToImage = widget.urlToImage ?? '';
    title = widget.title ?? '';
    name = widget.name ?? '';
    publishedAt = widget.publishedAt ?? '';
    content = widget.content ?? '';
    timeRead = widget.timeRead ?? '';
    isFavorite =
        context.read<ListProvider>().isListContainItem(title.toString());
  }

  String formatDate(String inputDate) {
    // Phân tích chuỗi ngày thành đối tượng DateTime
    DateTime dateTime = DateTime.parse(inputDate);

    // Lấy ngày, tháng và năm
    int day = dateTime.day;
    int year = dateTime.year;

    // Xác định hậu tố của ngày
    String suffix = '';
    if (day == 1 || day == 21 || day == 31) {
      suffix = 'st';
    } else if (day == 2 || day == 22) {
      suffix = 'nd';
    } else if (day == 3 || day == 23) {
      suffix = 'rd';
    } else {
      suffix = 'th';
    }

    // Chuyển đổi tháng thành định dạng ngắn (ví dụ: "Jan", "Feb", ...)
    String monthAbbreviation = DateFormat('MMM').format(dateTime);

    // Tạo chuỗi định dạng ngày mới
    String formattedDate = '$day$suffix $monthAbbreviation $year';

    return formattedDate;
  }

  void tongleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        context.read<ListProvider>().addFavoriteItem(
            title.toString(),
            name.toString(),
            urlToImage.toString(),
            publishedAt.toString(),
            content.toString(),
            timeRead.toString());
      } else {
        context.read<ListProvider>().removeFavoriteItem(title.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 19,
          ), // Icon mới cho nút back
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 226, 226, 226),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
                onTap: () {
                  tongleFavorite();
                },
                child: !isFavorite
                    ? const Icon(Icons.favorite_border)
                    : const Icon(Icons.favorite)),
          )
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 226, 226, 226),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: urlToImage.toString(),
              placeholder: (context, url) => const CircularProgressIndicator(),
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
                  Text('By ${name.toString()}',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  Text(
                      formatDate(publishedAt
                          .toString()
                          .substring(0, publishedAt.toString().indexOf('T'))),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ],
              ),
            ),
            Flexible(
                child: Text(content.toString(),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 105, 105, 105),
                        fontWeight: FontWeight.bold,
                        fontSize: 14)))
          ],
        ),
      ),
    );
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
}
