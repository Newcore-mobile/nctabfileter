///
///Author: YoungChan
///LastEditors: YoungChan
///Description: 自定义更多筛选demo
///Date: 2019-03-15 18:12:52
///LastEditTime: 2019-07-24 20:37:29
///
import 'package:flutter/material.dart';
import 'package:nctabfilter/nctabfilter.dart';

class TabFilterCustomMore extends StatefulWidget implements NCMoreFilterAction {
  static _TabFilterCustomMoreState _state;

  @override
  Map onResult() {
    return _state.getResult();
  }

  @override
  void onClear() {
    _state.clear();
  }

  @override
  _TabFilterCustomMoreState createState() {
    _state = _TabFilterCustomMoreState();
    return _state;
  }
}

class _TabFilterCustomMoreState extends State<TabFilterCustomMore> {
  bool _selectValue = false;

  Map getResult() {
    return {'result': _selectValue};
  }

  void clear() {
    setState(() {
      _selectValue = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size.fromHeight(300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Checkbox(
                  value: _selectValue,
                  onChanged: (value) {
                    setState(() {
                      _selectValue = value;
                    });
                  },
                ),
                Text('Check me!')
              ],
            ),
            TextField(),
          ],
        ),
      ),
    );
  }
}
