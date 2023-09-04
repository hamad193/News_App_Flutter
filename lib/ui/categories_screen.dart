import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/ui/detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:news_app/widgets/error_widget.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  String categoryName = 'General';

  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
  ];

  CategoriesNewsModel? categoriesNews;


  Future<void> _refresh() async {
    try {
      // Call your NewsViewModel methods to fetch updated data
      final updatedCategoriesNews = await newsViewModel.fetchCategoriesNewsApi('General');

      // Update your state variables with the fetched data
      setState(() {
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
      appBar: AppBar(elevation: 0),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 30,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: categoriesList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          categoryName = categoriesList[index];
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: categoryName == categoriesList[index]
                                  ? Colors.blue
                                  : Colors.grey.shade300),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Center(
                              child: Text(
                                categoriesList[index].toString(),
                                style: GoogleFonts.poppins(
                                    color: categoryName == categoriesList[index]
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(categoryName),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(size: 50, color: Colors.blue),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
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
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      snapshot.data!.articles![index]
                                                          .source!.name
                                                          .toString(),
                                                      style: GoogleFonts.poppins(
                                                          color: Colors.blue, fontSize: 12),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(format.format(dateTime),
                                                        style: GoogleFonts.poppins(fontSize: 12)),
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
                          }),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
