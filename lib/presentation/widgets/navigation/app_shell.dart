import 'package:flutter/material.dart';

import 'app_tabbar.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.tabScreens,
    required this.tabItems,
    required this.drawerBuilder,
  }) : assert(tabScreens.length == tabItems.length);

  final List<Widget> tabScreens;
  final List<AppTabBarItem> tabItems;
  final Widget Function(BuildContext context) drawerBuilder;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Builder(builder: widget.drawerBuilder),
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _currentIndex, children: widget.tabScreens),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: EdgeInsets.only(
          bottom: MediaQuery.of(context).systemGestureInsets.bottom,
        ),
        child: AppTabBar(
          items: widget.tabItems,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          onMorePressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
    );
  }
}
