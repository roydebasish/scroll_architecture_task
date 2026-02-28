import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_architecture_task/bloc/product/product_event.dart';
import 'package:scroll_architecture_task/bloc/product/product_state.dart';
import '../bloc/product/product_bloc.dart';
import 'widgets/product_card.dart';
import 'widgets/profile_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _pageController;
  late final ScrollController _scrollController;

  final Map<int, double> _tabScrollOffset = {};
  int _currentIndex = 0;

  static const double _headerExpandedHeight = 220;
  static const double _headerCollapsedHeight = kToolbarHeight;

  double get _headerCollapseRange =>
      _headerExpandedHeight - _headerCollapsedHeight;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
    _scrollController = ScrollController();

    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_storeCurrentTabOffset);

    context.read<ProductBloc>().add(LoadProducts());
  }

  void _storeCurrentTabOffset() {
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;

    if (offset <= _headerCollapseRange) {
      _tabScrollOffset[_currentIndex] = 0;
    } else {
      _tabScrollOffset[_currentIndex] =
          offset - _headerCollapseRange;
    }
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    _switchTab(_tabController.index);
  }

  void _onPageChanged(int index) {
    _tabController.animateTo(index);
    _switchTab(index);
  }

  void _switchTab(int index) {
    if (_currentIndex == index) return;

    _currentIndex = index;

    final currentOffset = _scrollController.offset;
    final isHeaderCollapsed = currentOffset >= _headerCollapseRange;

    double targetOffset;

    if (!isHeaderCollapsed) {
      targetOffset = currentOffset;
    } else {
      final savedTabOffset = _tabScrollOffset[_currentIndex] ?? 0;
      targetOffset = _headerCollapseRange + savedTabOffset;
    }

    _scrollController.jumpTo(targetOffset);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<ProductBloc>().add(LoadProducts());
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: _headerExpandedHeight,
                  pinned: true,
                  flexibleSpace: const FlexibleSpaceBar(
                    background: ProfileHeader(),
                  ),
                ),

                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.deepOrange,
                      labelColor: Colors.deepOrange,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(text: 'Electronics'),
                        Tab(text: 'Jewelery'),
                        Tab(text: "Men's Clothing"),
                      ],
                      onTap: (index) {
                        _pageController.jumpToPage(index);
                        _switchTab(index);
                      },
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      children: [
                        _buildGrid(state.electronics),
                        _buildGrid(state.jewelery),
                        _buildGrid(state.mens),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGrid(List products) {
    if (products.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: Text('No products found'),
        ),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}