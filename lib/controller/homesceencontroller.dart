import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/model/modelsapi.dart';

class HomeScreenController with ChangeNotifier {
  bool categoryLoading = false;
  bool topHeadlinesLoading = false;

  // result
  List<Article> articlesByCategory = [];
  List<Article> topheadlinesList = [];
  static int selectdCategoryIndex = 0;

  static List<String> categoryList = [
    "business",
    "entertainment",
    "general",
    "health",
    "science",
    "sports",
    "technology"
  ];

  // news fetch

  // fetchNews() async {
  //   isLoading = true;
  //   notifyListeners();
  //   final url = Uri.parse(
  //       "https://newsapi.org/v2/everything?q=All&apiKey=742488509a4f4f23b93e7ac3afc24cad");

  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     final decodedRes = jsonDecode(response.body);
  //     NewsResModel resModel = NewsResModel.fromJson(decodedRes);
  //     articles = resModel.articles ?? [];
  //   }
  //   isLoading = false;
  //   notifyListeners();
  // }

  fetchNewsbyCategory({String Category = "business", int index = 0}) async {
    selectdCategoryIndex = index;
    notifyListeners();
    categoryLoading = true;
    notifyListeners();
    final url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=in&category=$Category&apiKey=a21defb1070a4d7f87cf552f2ebc2069");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedRes = jsonDecode(response.body);
      SampleApiModel resModel = SampleApiModel.fromJson(decodedRes);
      articlesByCategory = resModel.articles ?? [];
    }
    categoryLoading = false;
    notifyListeners();
  }

  getTopHeadlines() async {
    topHeadlinesLoading = true;
    notifyListeners();
    final url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=a21defb1070a4d7f87cf552f2ebc2069");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedRes = jsonDecode(response.body);
      SampleApiModel resModel = SampleApiModel.fromJson(decodedRes);
      topheadlinesList = resModel.articles ?? [];
    }
    topHeadlinesLoading = false;
    notifyListeners();
  }
}
