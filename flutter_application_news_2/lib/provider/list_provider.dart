import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_get_api_news/modules/comment.dart';
import 'package:flutter_application_get_api_news/modules/favorite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ListProvider extends ChangeNotifier {
  List<String> listAvatarUrl = [
    'img/bear-svgrepo-com.png',
    'img/crab-svgrepo-com.png',
    'img/crocodile-svgrepo-com.png',
    'img/cute-animals-svgrepo-com.png',
    'img/dinosaur-svgrepo-com.png',
    'img/elk-svgrepo-com.png',
    'img/fox-svgrepo-com.png',
    'img/hedgehog-svgrepo-com.png',
    'img/jellyfish-svgrepo-com.png',
    'img/lion-svgrepo-com.png',
    'img/penguin-svgrepo-com.png',
    'img/polar-bear-svgrepo-com.png',
    'img/rabbit-svgrepo-com.png',
    'img/raccoon-svgrepo-com.png',
    'img/shrimp-svgrepo-com.png',
    'img/squirrel-svgrepo-com.png',
    'img/the-cow-svgrepo-com.png',
    'img/turtle-svgrepo-com.png',
    'img/whale-svgrepo-com.png',
    'img/wild-boar-svgrepo-com.png',
  ];
  bool isAddNewNameArticle = false;
  bool isDarkMode = false;
  String currentNameSearch = 'All';
  String currentTitleSearch = '';
  List<Comment> listComment = [];
  List<dynamic> listDataApi = [];
  List<dynamic> listDataSlider = [];
  List<String> listNameArticle = [];
  List<dynamic> filteredList = [];
  final List<Favorite> _listFavorite = [];
  List<Favorite> get listFavorite => _listFavorite;

  Future<dynamic> getDataApi() async {
    var url =
        ('https://newsapi.org/v2/everything?q=tesla&from=2024-02-31&sortBy=publishedAt&apiKey=d0257c9dc9b74ecfbd17e535156b9dd8');
    var response = await http.get(Uri.parse(url));

    // convert json String to Map
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> listArticle = [];
    for (final item in body['articles']) {
      if (item['title'] == null ||
          item['urlToImage'] == null ||
          item['author'] == null ||
          item['author'].toString().length >= 20) {
        continue;
      }
      if (!listNameArticle.any((element) =>
          element.toLowerCase() ==
          item['source']['name'].toString().toLowerCase())) {
        listNameArticle.add(item['source']['name']);
      }
      listArticle.add(item);
    }
    // Chuyển data sang listDataApi
    listDataApi = listArticle;
    listDataSlider = listDataApi.sublist(0, 10);
    // Data Api rỗng và chưa thêm các tên lựa chọn thì add thêm vào và ngược lại
    listDataApi.isNotEmpty && !isAddNewNameArticle
        ? listNameArticle.insert(0, 'All')
        : null;
    // Nếu chưa thêm name thì thông báo load lại
    !isAddNewNameArticle ? notifyListeners() : null;
    isAddNewNameArticle = true;
    loadDataSetting();
    return listArticle;
  }

  void filterDataWhenSearch(String value) {
    if (value.isEmpty) {
      // Nếu thanh tìm kiếm trống, hiển thị tất cả các mục
      filteredList = [];
      // Nếu thanh tìm kiếm trống nhưng phần Name vẫn chọn 1 cái
      if (currentNameSearch != 'All') {
        filteredList = listDataApi
            .where((item) =>
                item['source']['name'].toString().toLowerCase() ==
                currentNameSearch.toLowerCase())
            .toList();
      }
    } else {
      // Nếu thanh tìm kiếm không rỗng và phần Name vẫn chọn 1 cái
      if (currentNameSearch != 'All') {
        filteredList = listDataApi
            .where((item) =>
                item['title']
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase()) &&
                item['source']['name'].toString().toLowerCase() ==
                    currentNameSearch.toLowerCase())
            .toList();
      } else {
        // Nếu thanh tìm kiếm khôbg rỗng và phần Name vẫn chọn All
        filteredList = listDataApi
            .where((item) => item['title']
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()))
            .toList();
      }
    }
    notifyListeners();
  }

  void loadDataLocal() async {
    final localData = await SharedPreferences.getInstance();
    List<String>? listFavorite = localData.getStringList('listFavoriteLocal');
    List<String>? listComments = localData.getStringList('listCommentLocal');
    if (listFavorite != null) {
      List<Favorite> newListFavorite = listFavorite
          .map((itemString) => Favorite.fromString(itemString))
          .toList();
      _listFavorite.clear();
      _listFavorite.addAll(newListFavorite);
    }
    if (listComments != null) {
      List<Comment> newListComment = listComments
          .map((itemString) => Comment.fromString(itemString))
          .toList();
      listComment.clear();
      listComment.addAll(newListComment);
    }

    notifyListeners();
  }

  void loadDataSetting() async {
    final localData = await SharedPreferences.getInstance();
    isDarkMode = localData.getBool('isDarkModeLocal') ?? false;
  }

  void saveDataLocal() async {
    final localData = await SharedPreferences.getInstance();
    List<String> listFavoriteString =
        listFavorite.map((item) => item.toString()).toList();
    localData.setStringList('listFavoriteLocal', listFavoriteString);
    List<String> listCommentString =
        listComment.map((item) => item.toString()).toList();
    localData.setStringList('listCommentLocal', listCommentString);
  }

  void saveSettingLocal() async {
    final localData = await SharedPreferences.getInstance();
    localData.setBool('isDarkModeLocal', isDarkMode);
  }

  void addFavoriteItem(
    String title,
    String author,
    String name,
    String urlToImage,
    String publishedAt,
    String content,
  ) {
    listFavorite.insert(
        0,
        Favorite(
          title: title,
          author: author,
          name: name,
          urlToImage: urlToImage,
          publishedAt: publishedAt,
          content: content,
        ));
    saveDataLocal();
    notifyListeners();
  }

  void removeFavoriteItem(String title) {
    listFavorite.removeWhere((element) => element.title == title);
    saveDataLocal();
    notifyListeners();
  }

  bool isListContainItem(String title) {
    return listFavorite.any((element) => element.title == title);
  }

  void addCommentItem(
      String title, String content, String time, String avatarUrl) {
    listComment.add(Comment(
      title: title,
      content: content,
      time: time,
      avatarUrl: avatarUrl,
    ));
    saveDataLocal();
    notifyListeners();
  }

  // List<Comment> listLegal(String id) {
  //   List<Comment> newList =
  //       listComment.where((element) => element.id == id).toList();
  //   notifyListeners();
  //   return newList.reversed.toList();
  // }

  String getRandomAvatarUrl() {
    Random random = Random();
    int index = random.nextInt(listAvatarUrl.length);
    return listAvatarUrl[index];
  }
}
