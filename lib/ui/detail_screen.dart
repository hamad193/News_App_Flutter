import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/widgets/error_widget.dart';

class DetailScreen extends StatefulWidget {
  final title;
  final imageUrl;
  final description;
  final date;
  final sourceName;

  const DetailScreen({
    Key? key,
    this.title,
    this.imageUrl,
    this.description,
    this.date,
    this.sourceName,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Stack(
        children: [
          Container(),
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            child: SizedBox(
              height: height * 0.5,
              width: width,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error){
                  return ErrorImageWidget(error);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0.01,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Container(
                height: height * 0.45,
                width: width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView(
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.poppins(
                            fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.sourceName,
                            style: GoogleFonts.poppins(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            widget.date,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.description,
                        style: GoogleFonts.poppins(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
