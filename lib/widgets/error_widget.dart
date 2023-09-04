import 'package:flutter/material.dart';
import 'dart:io';

class ErrorImageWidget extends StatelessWidget {
  final error;

  const ErrorImageWidget(this.error, {super.key});

  @override
  Widget build(BuildContext context) {
    if (error is HttpException) {
      return Image.asset('images/error_image.png', fit: BoxFit.cover);
    } else {
      return Image.asset('images/error_image.png', fit: BoxFit.cover);
    }
  }
}
