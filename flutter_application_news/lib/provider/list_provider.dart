import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_get_api_news/auth/auth_service.dart';
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
  int count = 0;
  bool isAddNewNameArticle = false;
  bool isDarkMode = false;
  bool isChangeHomeView = false;
  String currentNameSearch = 'All';
  String currentTitleSearch = '';
  List<Comment> listComment = [];
  List<dynamic> listDataApi = [];
  List<dynamic> listDataSlider = [];
  List<dynamic> part1 = [];
  List<dynamic> part2 = [];
  List<dynamic> part3 = [];
  List<dynamic> part4 = [];
  List<dynamic> part5 = [];
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
      item['source']['id'] = ++count;
      listArticle.add(item);
    }
    // Chuyển data sang listDataApi
    listDataApi = listArticle;
    listDataSlider = listDataApi.sublist(0, 3);
    // Data Api rỗng và chưa thêm các tên lựa chọn thì add thêm vào và ngược lại
    listDataApi.isNotEmpty && !isAddNewNameArticle
        ? listNameArticle.insert(0, 'All')
        : null;
    // Nếu chưa thêm name thì thông báo load lại
    !isAddNewNameArticle ? notifyListeners() : null;
    isAddNewNameArticle = true;
    loadDataSetting();
    count = 0;
    return listArticle;
  }

  void splitListDataApi(List<dynamic> listData) {
    int length = listData.length;
    int minPartLength = (length / 5).floor();
    int remainder = length % 5;

    part1 = listData.sublist(0, minPartLength + (remainder >= 1 ? 1 : 0));
    part2 = listData.sublist(
        part1.length, part1.length + minPartLength + (remainder >= 2 ? 1 : 0));
    part3 = listData.sublist(part1.length + part2.length,
        part1.length + part2.length + minPartLength + (remainder >= 3 ? 1 : 0));
    part4 = listData.sublist(
        part1.length + part2.length + part3.length,
        part1.length +
            part2.length +
            part3.length +
            minPartLength +
            (remainder >= 4 ? 1 : 0));
    part5 = listData
        .sublist(part1.length + part2.length + part3.length + part4.length);
  }

  void filterDataWhenSearch(String value, bool isChangeHomeView) {
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
        splitListDataApi(filteredList);
      }
    } else {
      // Nếu thanh tìm kiếm có và phần Name vẫn chọn 1 cái
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
        splitListDataApi(filteredList);
      } else {
        // Nếu thanh tìm kiếm có và phần Name vẫn chọn All
        filteredList = listDataApi
            .where((item) => item['title']
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()))
            .toList();
        splitListDataApi(filteredList);
      }
    }
    notifyListeners();
  }

  void loadDataLocal() async {
    // final localData = await SharedPreferences.getInstance();
    // List<String>? listFavorite = localData.getStringList('listFavoriteLocal');
    // List<String>? listComments = localData.getStringList('listCommentLocal');
    // if (listFavorite != null) {
    //   List<Favorite> newListFavorite = listFavorite
    //       .map((itemString) => Favorite.fromString(itemString))
    //       .toList();
    //   _listFavorite.clear();
    //   _listFavorite.addAll(newListFavorite);
    // }
    // if (listComments != null) {
    //   List<Comment> newListComment = listComments
    //       .map((itemString) => Comment.fromString(itemString))
    //       .toList();
    //   listComment.clear();
    //   listComment.addAll(newListComment);
    // }

    notifyListeners();
  }

  void loadDataSetting() async {
    final localData = await SharedPreferences.getInstance();
    isChangeHomeView = localData.getBool('isChangeHomeViewLocal') ?? false;
    isChangeHomeView ? splitListDataApi(listDataApi) : null;
    isDarkMode = localData.getBool('isDarkModeLocal') ?? false;
  }

  // void saveDataLocal() async {
  //   final localData = await SharedPreferences.getInstance();
  //   List<String> listFavoriteString =
  //       listFavorite.map((item) => item.toString()).toList();
  //   localData.setStringList('listFavoriteLocal', listFavoriteString);
  //   List<String> listCommentString =
  //       listComment.map((item) => item.toString()).toList();
  //   localData.setStringList('listCommentLocal', listCommentString);
  // }

  void saveSettingLocal(bool isChangeHomeView, bool isDarkMode) async {
    final localData = await SharedPreferences.getInstance();
    localData.setBool('isChangeHomeViewLocal', isChangeHomeView);
    localData.setBool('isDarkModeLocal', isDarkMode);
  }

  void addFavoriteItem(
    int id,
    String title,
    String author,
    String name,
    String urlToImage,
    String publishedAt,
    String content,
  ) {
    listFavorite.add(Favorite(
      id: id,
      title: title,
      author: author,
      name: name,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
      content: content,
    ));
    List<Favorite> newList = listFavorite.reversed.toList();
    listFavorite.clear();
    listFavorite.addAll(newList);
    final auth = AuthService();
    User? user = FirebaseAuth.instance.currentUser!;
    String idUser = user.email!.split('@')[0];
    print(idUser);
    auth.addNewFavoriteItem(
        idUser,
        id.toString(),
        title.toString(),
        author.toString(),
        name.toString(),
        urlToImage.toString(),
        publishedAt.toString(),
        content.toString());
    // saveDataLocal();
    notifyListeners();
  }

  void removeFavoriteItem(int id) {
    final auth = AuthService();
    User? user = FirebaseAuth.instance.currentUser!;
    String idUser = user.email!.split('@')[0];
    auth.removeFavoriteItem(id.toString());
    listFavorite.removeWhere((element) => element.id == id);
    // saveDataLocal();
    notifyListeners();
  }

  bool isListContainItem(int id) {
    return listFavorite.any((element) => element.id == id);
  }

  void addCommentItem(
      String title, String content, String time, String avatarUrl) {
    listComment.add(Comment(
        title: title, content: content, time: time, avatarUrl: avatarUrl));
    // saveDataLocal();
    notifyListeners();
  }

  List<Comment> listLegal(String title) {
    List<Comment> newList =
        listComment.where((element) => element.title == title).toList();
    notifyListeners();
    return newList.reversed.toList();
  }

  String getRandomAvatarUrl() {
    Random random = Random();
    int index = random.nextInt(
        listAvatarUrl.length); // Sinh số ngẫu nhiên từ 0 đến chiều dài của list
    return listAvatarUrl[index]; // Trả về giá trị ngẫu nhiên từ list
  }
}
