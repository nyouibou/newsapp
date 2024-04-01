import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/model/modelsapi.dart';

class SearchScreenController with ChangeNotifier {
  bool isLoading = false;
  // bool categoryLoading = false;
  // bool topHeadlinesLoading = false;
  List<Article> searchedArticles = [];

  searchNews({required String query}) async {
    isLoading = true;
    notifyListeners();
    final url = Uri.parse(
        "https://newsapi.org/v2/everything?q=$query&sortBy=popularity&apiKey=a21defb1070a4d7f87cf552f2ebc2069");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      SampleApiModel resmodel = SampleApiModel.fromJson(decodedData);
      searchedArticles = resmodel.articles ?? [];
    }
    isLoading = false;
    notifyListeners();
  }
}
