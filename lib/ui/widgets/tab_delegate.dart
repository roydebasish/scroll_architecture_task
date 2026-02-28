import 'package:flutter/material.dart';

class TabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  TabDelegate(this.tabBar);

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant TabDelegate oldDelegate) => false;
}