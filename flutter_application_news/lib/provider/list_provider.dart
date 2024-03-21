import 'package:flutter/material.dart';
import 'package:flutter_application_get_api_news/modules/favorite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ListProvider extends ChangeNotifier {
  bool isAddNewNameArticle = false;
  List<dynamic> originalList = [];
  List<dynamic> listHomeScreen = [];
  List<String> listNameArticle = [];
  final List<Favorite> _listFavorite = [];
  List<Favorite> get listFavorite => _listFavorite;

  Future<dynamic> getDataApi() async {
    var url =
        ('https://newsapi.org/v2/everything?q=tesla&from=2024-02-21&sortBy=publishedAt&apiKey=d0257c9dc9b74ecfbd17e535156b9dd8');
    var response = await http.get(Uri.parse(url));

    // convert json String to Map
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> listArticle = [];
    for (final item in body['articles']) {
      if (item['title'] == '[Removed]' || item['urlToImage'] == null) {
        continue;
      }
      if (!listNameArticle.any((element) =>
          element.toLowerCase() ==
          item['source']['name'].toString().toLowerCase())) {
        listNameArticle.add(item['source']['name']);
      }
      listArticle.add(item);
    }
    listHomeScreen = listArticle;
    listHomeScreen.isNotEmpty && !isAddNewNameArticle
        ? listNameArticle.insert(0, 'All')
        : null;
    !isAddNewNameArticle ? notifyListeners() : null;
    isAddNewNameArticle = true;
    return listArticle;
  }

  void loadDataLocal() async {
    final localData = await SharedPreferences.getInstance();
    List<String>? listStrings = localData.getStringList('listFavoriteLocal');
    if (listStrings != null) {
      List<Favorite> newListFavorite = listStrings
          .map((itemString) => Favorite.fromString(itemString))
          .toList();
      _listFavorite.clear();
      _listFavorite.addAll(newListFavorite);
      notifyListeners();
    }
  }

  void saveDataLocal(List<Favorite> listFavorite) async {
    final localData = await SharedPreferences.getInstance();
    List<String> listFavoriteString =
        listFavorite.map((item) => item.toString()).toList();
    localData.setStringList('listFavoriteLocal', listFavoriteString);
  }

  void addFavoriteItem(
    String title,
    String name,
    String urlToImage,
    String publishedAt,
    String content,
    String timeRead,
  ) {
    listFavorite.add(Favorite(
      title: title,
      name: name,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
      content: content,
      timeRead: timeRead,
    ));
    List<Favorite> newList = listFavorite.reversed.toList();
    listFavorite.clear();
    listFavorite.addAll(newList);
    saveDataLocal(listFavorite);
    notifyListeners();
  }

  void removeFavoriteItem(String title) {
    listFavorite.removeWhere((element) => element.title == title);
    saveDataLocal(listFavorite);
    notifyListeners();
  }

  void searchByTitle(String title) {
    originalList.addAll(listHomeScreen);
    List<dynamic> listArticle = listHomeScreen;
    List<dynamic> searchResult = [];

    for (final article in listArticle) {
      if (article['title']
          .toString()
          .toLowerCase()
          .contains(title.toLowerCase())) {
        searchResult.add(article);
      }
    }
    listHomeScreen.clear();
    listHomeScreen.addAll(searchResult);
    notifyListeners();
  }

  void restoreOriginalList() {
    listHomeScreen.clear();
    listHomeScreen.addAll(originalList);
    notifyListeners();
  }

  bool isListContainItem(String title) {
    return listFavorite.any((element) => element.title == title);
  }
}
