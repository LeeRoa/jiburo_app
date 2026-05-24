import 'package:flutter/material.dart';
import 'package:jiburo_app/screens/missing/widget/complete_cover.dart';
import 'package:jiburo_app/screens/missing/widget/count_label.dart';

class PhotosWidget extends StatefulWidget {
  final bool isComplete;
  final List<String> imgs;
  const PhotosWidget({super.key, required this.imgs, this.isComplete = false});

  @override
  State<PhotosWidget> createState() => _PhotosWidgetState();
}

class _PhotosWidgetState extends State<PhotosWidget> {
  final PageController _controller = PageController();
  int _currPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final page = _controller.page?.round() ?? 0;

      if (page != _currPage) {
        setState(() {
          _currPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.imgs.length,
            itemBuilder: (context, index) {
              return Image.asset(
                widget.imgs[index],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
        ),

        if (widget.isComplete) CompleteCover(),
        Positioned(
          bottom: 12,
          right: 12,
          child: CountLabel(count: _currPage + 1, total: widget.imgs.length),
        ),
      ],
    );
  }
}
