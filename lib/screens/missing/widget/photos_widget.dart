import 'package:flutter/material.dart';

class PhotosWidget extends StatefulWidget {
  const PhotosWidget({super.key});

  @override
  State<PhotosWidget> createState() => _PhotosWidgetState();
}

class _PhotosWidgetState extends State<PhotosWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Image.asset('assets/images/1.jpg'),
    );
  }
}
