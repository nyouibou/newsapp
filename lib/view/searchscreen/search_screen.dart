// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/controller/searchscreencontroller.dart';
import 'package:newsapp/view/globalwidget/customnewspage.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchcontroller = TextEditingController();
  @override
  void initState() {
    // Provider.of<SearchScreenController>(context, listen: false).clearData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provObject = Provider.of<SearchScreenController>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  suffixIcon: InkWell(
                      onTap: () {
                        if (searchcontroller.text.isNotEmpty) {
                          Provider.of<SearchScreenController>(context,
                                  listen: false)
                              .searchNews(query: searchcontroller.text);
                        }
                      },
                      child: Icon(Icons.search))),
              controller: searchcontroller,
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: provObject.searchedArticles.length,
              itemBuilder: (context, index) => CustomNewsCard(
                  imageUrl: provObject.searchedArticles[index].urlToImage ?? "",
                  category:
                      provObject.searchedArticles[index].source?.name ?? "",
                  title: provObject.searchedArticles[index].title ?? "",
                  author: provObject.searchedArticles[index].author ?? "",
                  dateTime:
                      provObject.searchedArticles[index].publishedAt != null
                          ? DateFormat("dd MMM yyyy").format(
                              provObject.searchedArticles[index].publishedAt!)
                          : ""),
              separatorBuilder: (context, index) => Divider(
                thickness: .5,
                indent: 30,
                endIndent: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}
