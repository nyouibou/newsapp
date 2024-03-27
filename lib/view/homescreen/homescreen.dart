// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/controller/homesceencontroller.dart';
import 'package:newsapp/view/homescreen/widgets/customnewspage.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<HomeScreenController>(context, listen: false)
          .fetchNews();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerObj = Provider.of<HomeScreenController>(context);
    return Scaffold(
      body: providerObj.isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              itemCount: providerObj.articles.length,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemBuilder: (context, index) => CustomNewsCard(
                imageUrl: providerObj.articles[index].urlToImage ?? "",
                author: providerObj.articles[index].author ?? "",
                category: providerObj.articles[index].source?.name ?? "",
                title: providerObj.articles[index].title ?? "",
                dateTime: DateFormat("dd MMM yyyy ")
                    .format(providerObj.articles[index].publishedAt!),
              ),
              separatorBuilder: (context, index) => Divider(
                thickness: .5,
                indent: 30,
                endIndent: 30,
              ),
            ),
    );
  }
}
