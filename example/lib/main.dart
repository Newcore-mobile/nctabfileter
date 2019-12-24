///
///Author: YoungChan
///Date: 2019-12-23 10:25:30
///LastEditors: YoungChan
///LastEditTime: 2019-12-24 10:10:41
///Description: file content
///
import 'package:flutter/material.dart';
import 'tabfilter/tab_filter_demo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
      ),
      home: TabFilterDemo(),
    );
  }
}
