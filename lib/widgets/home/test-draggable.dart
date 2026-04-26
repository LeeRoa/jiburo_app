import 'package:flutter/material.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';

class TestDraggable extends StatefulWidget {
  const TestDraggable({super.key});

  @override
  State<TestDraggable> createState() => _TestDraggableState();
}

class _TestDraggableState extends State<TestDraggable> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  bool isFullScroll = false;
  double initSize = 0.4;
  double minSize = 0.1;
  double maxSize = 0.8;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        final double currSize = notification.extent; // 현재 size

        print(currSize == maxSize);

        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: initSize, // 초기 높이
        minChildSize: minSize, // 최소 높이
        maxChildSize: maxSize, // 최대 높이
        snap: true,
        snapSizes: [0.4],
        snapAnimationDuration: const Duration(milliseconds: 200),
        builder: (context, scrollController) {
          return Container(
            color: Colors.blue[100],
            child: RawScrollbar(
              controller: scrollController,
              thumbVisibility: true,
              thickness: 3,
              radius: const Radius.circular(8),
              padding: EdgeInsets.only(top: 218, bottom: 20, right: 4),
              child: CustomScrollView(
                controller: scrollController,
                physics: isFullScroll
                    ? const NeverScrollableScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _HeaderDelegate(
                      child: Container(
                        height: 100,
                        padding: EdgeInsets.all(20),
                        color: Colors.blue[100],
                        child: Text('ggg'),
                      ),
                    ),
                  ),
                  SliverList.builder(
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      return ListTile(title: Text("Item $index"));
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _HeaderDelegate({required this.child});

  @override
  Widget build(context, shrinkOffset, overlapsContent) => child;

  @override
  double get maxExtent => 100.0;
  @override
  double get minExtent => 100.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
