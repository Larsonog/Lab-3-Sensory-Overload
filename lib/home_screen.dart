import 'package:flutter/material.dart';
import 'package:overexpose_journal/home.dart';
//import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.path, this.home});

  final String? path;
  final Home? home;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
        appBar: AppBar(title: const Text("OverExposed Journal")),
        body: PageView(
          //return PageView(
          /// [PageView.scrollDirection] defaults to [Axis.horizontal].
          /// Use [Axis.vertical] to scroll vertically.
          controller: controller,
          children: const <Widget>[
            Center(
              child: Text('This week'),
            ),
            Center(
              child: Text('Next week'),
            ),
            Center(
              child: Text('Last week'),
            ),
          ],
        ));
  }
}
