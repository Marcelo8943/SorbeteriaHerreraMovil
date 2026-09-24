import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('PADDING: ${MediaQuery.of(context).padding}');
    return const Scaffold(
      body: Center(child: Text('Dashboard — en construcción')),
    );
  }
}
