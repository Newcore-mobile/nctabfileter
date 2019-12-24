///
/// @Author: YoungChan
///LastEditors: YoungChan
/// @Description: TabFilter Controller, 连接控制TabFilter 和 FilterView
/// @Date: 2019-03-05 09:59:49
///LastEditTime: 2019-05-08 18:39:19
///
import 'package:flutter/material.dart';

class NCTabFilterController extends ChangeNotifier {
  final List<String> tabTitles;
  Map<int, bool> tabSelectIndex = {};

  NCTabFilterController({@required this.tabTitles});

  ///Tab点击展开通知， TabFilterBar 调用，TabFilterView 监听
  Function(int, bool) onTabExpanded;

  VoidCallback onUpdateTabBar;

  ///标识tab 是否选中状态
  bool isTabSelect(int index) =>
      tabSelectIndex[index] == null ? false : tabSelectIndex[index];

  void dismiss() {
    notifyListeners();
  }

  void subscibeOnDismiss(VoidCallback cb) {
    addListener(cb);
  }
}
