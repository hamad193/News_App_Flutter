import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channels_headlines_model.dart';
import 'package:news_app/ui/categories_screen.dart';
import 'package:news_app/ui/detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:news_app/widgets/error_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum NewsFilterList {
  bbcNews,
  aryNews,
  alJazeera,
  cbsNews,
  cnnNews,
  nationalGeographic,
  timesOfIndia
}



class _HomeScreenState extends State<HomeScreen> {




  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');

  NewsFilterList? selectedMenu;

  String name = 'bbc-news';

  NewsChannelsHeadlinesModel? newsChannelsHeadlines;
  CategoriesNewsModel? categoriesNews;


  Future<void> _refresh() async {
    try {
      // Call your NewsViewModel methods to fetch updated data
      final updatedNewsChannelsHeadlines = await newsViewModel.fetchNewsChannelsHeadlinesApi(name);
      final updatedCategoriesNews = await newsViewModel.fetchCategoriesNewsApi('General');

      // Update your state variables with the fetched data
      setState(() {
        newsChannelsHeadlines = updatedNewsChannelsHeadlines;
        categoriesNews = updatedCategoriesNews;
      });
    } catch (error) {
      // Handle errors as needed
      print('Error refreshing data: $error');
    }
  }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
        // backgroundColor: Colors.green,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CategoriesScreen()));
            },
            icon: SizedBox(
                height: 25,
                width: 25,
                child: Image.asset('images/category_icon.png')),
          ),
          title: Text(
            'News',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton<NewsFilterList>(
              initialValue: selectedMenu,
              onSelected: (NewsFilterList item) {
                if (NewsFilterList.bbcNews.name == item.name) {
                  name = 'bbc-news';
                }
                if (NewsFilterList.aryNews.name == item.name) {
                  name = 'ary-news';
                }
                if (NewsFilterList.alJazeera.name == item.name) {
                  name = 'al-jazeera-english';
                }
                if (NewsFilterList.cbsNews.name == item.name) {
                  name = 'cbs-news';
                }
                if (NewsFilterList.cnnNews.name == item.name) {
                  name = 'cnn';
                }
                if (NewsFilterList.nationalGeographic.name == item.name) {
                  name = 'national-geographic';
                }
                if (NewsFilterList.timesOfIndia.name == item.name) {
                  name = 'the-times-of-india';
                }
                setState(() {});
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<NewsFilterList>>[
                const PopupMenuItem(
                  value: NewsFilterList.bbcNews,
                  child: Text('BBC News'),
                ),
                const PopupMenuItem(
                  value: NewsFilterList.aryNews,
                  child: Text('ARY News'),
                ),
                const PopupMenuItem(
                  value: NewsFilterList.alJazeera,
                  child: Text('Al-Jazeera'),
                ),
                const PopupMenuItem(
                  value: NewsFilterList.cnnNews,
                  child: Text('CNN'),
                ),
                const PopupMenuItem(
                  value: NewsFilterList.cbsNews,
                  child: Text('CBS News'),
                ),
                const PopupMenuItem(
                  value: NewsFilterList.nationalGeographic,
                  child: Text('National Geographic'),
                ),
                const PopupMenuItem(
                  value: NewsFilterList.timesOfIndia,
                  child: Text('Times of India'),
                ),
              ],
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            children: [
              SizedBox(
                height: height * 0.5,
                width: width,
                child: FutureBuilder<NewsChannelsHeadlinesModel>(
                    future: newsViewModel.fetchNewsChannelsHeadlinesApi(name),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitCircle(size: 50, color: Colors.blue),
                        );
                      } else {
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.articles!.length,
                            itemBuilder: (context, index) {
                              DateTime dateTime = DateTime.parse(snapshot
                                  .data!.articles![index].publishedAt
                                  .toString());

                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                        title: snapshot.data!.articles![index].title.toString(),
                                        imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                        description: snapshot.data!.articles![index].description.toString(),
                                        sourceName: snapshot.data!.articles![index].source!.name.toString(),
                                        date:  format.format(dateTime),
                                      )));
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: height * 0.6,
                                      width: width * 0.9,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: height * 0.02),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot
                                              .data!.articles![index].urlToImage
                                              .toString(),
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) {
                                            return const SpinKitFadingCircle(
                                                color: Colors.amber, size: 50);
                                          },
                                          errorWidget: (context, url, error){
                                           return ErrorImageWidget(error);
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      child: Card(
                                        elevation: 5,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: SizedBox(
                                          height: height * 0.22,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  width: width * 0.725,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        snapshot
                                                            .data!
                                                            .articles![index]
                                                            .title
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        maxLines: 3,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            snapshot
                                                                .data!
                                                                .articles![index]
                                                                .source!
                                                                .name
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .blue, fontSize: 12),
                                                          ),
                                                          Text(
                                                            format
                                                                .format(dateTime),
                                                            style: GoogleFonts
                                                                .poppins(fontSize: 12),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }
                    }),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: height * 0.7,
                child: FutureBuilder<CategoriesNewsModel>(
                    future: newsViewModel.fetchCategoriesNewsApi('General'),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitCircle(size: 50, color: Colors.blue),
                        );
                      } else {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.articles!.length,
                            // shrinkWrap: true,
                            itemBuilder: (context, index) {
                              DateTime dateTime = DateTime.parse(snapshot
                                  .data!.articles![index].publishedAt
                                  .toString());

                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                        title: snapshot.data!.articles![index].title.toString(),
                                        imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                        description: snapshot.data!.articles![index].description.toString(),
                                        sourceName: snapshot.data!.articles![index].source!.name.toString(),
                                        date:  format.format(dateTime),
                                      )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: width * 0.35,
                                          width: width * 0.3,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot
                                                  .data!.articles![index].urlToImage
                                                  .toString(),
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) {
                                                return const SpinKitFadingCircle(
                                                    color: Colors.amber, size: 50);
                                              },
                                              errorWidget: (context, url, error){
                                                return ErrorImageWidget(error);
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: SizedBox(
                                            height: width * 0.33,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data!.articles![index].title
                                                      .toString(),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        snapshot
                                                            .data!
                                                            .articles![index]
                                                            .source!
                                                            .name
                                                            .toString(),
                                                        style: GoogleFonts.poppins(fontSize: 12,
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          format.format(dateTime),
                                                          style: GoogleFonts
                                                              .poppins(fontSize: 12)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}
