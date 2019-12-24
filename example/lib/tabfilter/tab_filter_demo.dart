///
///Author: YoungChan
///LastEditors: YoungChan
///Description: TabFilter  Demo
///Date: 2019-03-15 18:03:31
///LastEditTime: 2019-12-24 10:50:03
///
import 'package:flutter/material.dart';
import 'package:nctabfilter/nctabfilter.dart';
import 'tab_filter_custom_more.dart';

class TabFilterDemo extends StatefulWidget {
  @override
  _TabFilterDemoState createState() => _TabFilterDemoState();
}

class _TabFilterDemoState extends State<TabFilterDemo> {
  NCTabFilterController _filterController;
  Map<String, List<String>> _dataSource = {
    'NameA': ['value1', 'mlue2', 'nlue3', 'vaue4'],
    'NameC': ['value1', 'value2', 'value4'],
    'NameB': [
      'value1',
    ]
  };
  Map<String, List<String>> _selectTweenData = {};

  @override
  void initState() {
    _filterController = NCTabFilterController(
      tabTitles: ['单选', '多选', '双栏', '更多'],
    );
    super.initState();
  }

  ///构建筛选Tab filter view
  List<Widget> _buildTabFilterView() => <Widget>[
        NCTabSingleFilter<String>(
          dataSource: [
            '全部',
            '分类1',
            '分类2',
            '分类3',
          ],
          enableSearch: true,
          getTitleLabel: (s) => s,
          controller: _filterController,
          onConfirm: (s, index) {
            print("TabMultiFilter1 onConfirm: $s");
          },
        ),
        NCTabMultiFilter<String>(
          dataSource: ['全部', '清洗', '焊接', '组装', '测试', '测试'],
          getTitleLabel: (s) => s + "2",
          controller: _filterController,
          enableSearch: true,
          onConfirm: (s) {
            print("TabMultiFilter2 onConfirm: $s");
          },
        ),
        NCTabTweenFilter<String, String>(
          dataSource: _dataSource,
          getLeftTitleLabel: (s) => s,
          getRightTitleLabel: (s) => s,
          initialData: _selectTweenData,
          onConfirm: (values) {
            print('Tween filter select => $values');
          },
          controller: _filterController,
          isSingleSelectModel: false,
        ),
        NCTabMoreFilter(
          child: TabFilterCustomMore(),
          controller: _filterController,
          fullScreen: false,
          onConfirm: (values) {
            print('More filter select => $values');
            setState(() {
              _filterController.tabTitles[3] = '超长字符测试还要在增加字符看看';
            });
          },
        )
      ];

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: null,
          automaticallyImplyLeading: false,
          title: Text(
            'TabFilter Demo',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          bottom: NCTabFilterBar(
            controller: _filterController,
          ),
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: Text('Hello Flutter'),
            ),
            NCTabFilterView(
              controller: _filterController,
              children: _buildTabFilterView(),
            )
          ],
        ),
      );
}
