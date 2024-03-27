// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
          .fetchNewsCategory();
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
          : Column(
              children: [
                Text(
                  "Top News",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                CarouselSlider(
                    options: CarouselOptions(height: 400.0),
                    items: List.generate(
                        providerObj.topheadlines.length,
                        (index) => Container(
                              height: 200,
                              width: 400,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: providerObj
                                              .topheadlines[index].urlToImage ??
                                          ""),
                                  borderRadius: BorderRadius.circular(10)),
                            ))),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      providerObj.CategoryList.length,
                      (index) => InkWell(
                        onTap: () async {
                          await Provider.of<HomeScreenController>(context,
                                  listen: false)
                              .fetchNewsCategory(
                                  index: index,
                                  Category: providerObj.CategoryList[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.red.withOpacity(.2),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            child: Text(
                              providerObj.CategoryList[index],
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
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
                ),
              ],
            ),
    );
  }
}
