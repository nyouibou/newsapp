// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/controller/homesceencontroller.dart';
import 'package:newsapp/controller/searchscreencontroller.dart';
import 'package:newsapp/view/globalwidget/customnewspage.dart';
import 'package:newsapp/view/searchscreen/search_screen.dart';
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
          .fetchNewsbyCategory();
      await Provider.of<HomeScreenController>(context, listen: false)
          .getTopHeadlines();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerObj = Provider.of<HomeScreenController>(context);
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("News App"),
            centerTitle: true,
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                                  create: (context) => SearchScreenController(),
                                  child: SearchScreen(),
                                )));
                  },
                  icon: Icon(
                    Icons.search_sharp,
                    size: 30,
                    color: Colors.black,
                  ))
            ],
          ),
          body: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 300,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.easeInToLinear,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                ),
                items: List.generate(
                    providerObj.topheadlinesList.length,
                    (index) => Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: providerObj
                                      .topheadlinesList[index].urlToImage ??
                                  "",
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        )),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: List.generate(
                  HomeScreenController.categoryList.length,
                  (index) => InkWell(
                    onTap: () async {
                      await Provider.of<HomeScreenController>(context,
                              listen: false)
                          .fetchNewsbyCategory(
                              index: index,
                              Category:
                                  HomeScreenController.categoryList[index]);
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
                          HomeScreenController.categoryList[index],
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )),
              ),
              Expanded(
                child: providerObj.categoryLoading == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        itemCount: providerObj.articlesByCategory.length,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        itemBuilder: (context, index) => CustomNewsCard(
                            imageUrl:
                                providerObj.articlesByCategory[index].urlToImage ??
                                    "",
                            author: providerObj.articlesByCategory[index].author ??
                                "",
                            category: providerObj
                                    .articlesByCategory[index].source?.name ??
                                "",
                            title: providerObj.articlesByCategory[index].title ??
                                "",
                            dateTime: providerObj.articlesByCategory[index]
                                        .publishedAt !=
                                    null
                                ? DateFormat("dd MMM yyyy ").format(
                                    providerObj.articlesByCategory[index].publishedAt!)
                                : ""),
                        separatorBuilder: (context, index) => Divider(
                          thickness: .5,
                          indent: 30,
                          endIndent: 30,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
