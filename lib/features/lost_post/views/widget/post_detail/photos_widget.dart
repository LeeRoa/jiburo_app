import 'package:flutter/material.dart';

import 'complete_cover.dart';
import 'count_label.dart';

class PhotosWidget extends StatefulWidget {
  final bool isComplete;

  /// 서버 이미지 주소 목록 (비어 있으면 기본 이미지 1장)
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
            itemCount: widget.imgs.isEmpty ? 1 : widget.imgs.length,
            itemBuilder: (context, index) {
              const empty = 'assets/images/empty-img.png';
              if (widget.imgs.isEmpty) {
                return Image.asset(
                  empty,
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              }
              return Image.network(
                widget.imgs[index],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, _, _) => Image.asset(
                  empty,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
          ),
        ),

        if (widget.isComplete) CompleteCover(),
        if (widget.imgs.isNotEmpty)
          Positioned(
            bottom: 12,
            right: 12,
            child: CountLabel(count: _currPage + 1, total: widget.imgs.length),
          ),
      ],
    );
  }
}
