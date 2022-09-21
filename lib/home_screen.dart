import 'package:flutter/material.dart';
import 'package:overexpose_journal/home.dart';
//import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.path});

  final String? path;
  //final Home? home;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'OverExpose Journal',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SizedBox(
        child: PageView(
          controller: controller,
          children: <Widget>[
            ListView(shrinkWrap: true, children: const <Widget>[
              ListTile(title: Text("Sunday")),
              ListTile(title: Text("Monday")),
              ListTile(title: Text("Tuesday")),
              ListTile(title: Text("Wednesday")),
              ListTile(title: Text("Thursday")),
              ListTile(title: Text("Friday")),
              ListTile(title: Text("Saturday")),
            ]),
            ListView(shrinkWrap: true, children: const <Widget>[
              ListTile(title: Text("Sunday")),
              ListTile(title: Text("Monday")),
              ListTile(title: Text("Tuesday")),
              ListTile(title: Text("Wednesday")),
              ListTile(title: Text("Thursday")),
              ListTile(title: Text("Friday")),
              ListTile(title: Text("Saturday")),
            ]),
            ListView(shrinkWrap: true, children: const <Widget>[
              ListTile(title: Text("Sunday")),
              ListTile(title: Text("Monday")),
              ListTile(title: Text("Tuesday")),
              ListTile(title: Text("Wednesday")),
              ListTile(title: Text("Thursday")),
              ListTile(title: Text("Friday")),
              ListTile(title: Text("Saturday")),
            ]),
          ],
        ),
      ),
    );
  }
}
