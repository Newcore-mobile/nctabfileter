///
///Author: YoungChan
///LastEditors: YoungChan
///Description: 更多筛选容器，内部筛选View自定义实现
///Date: 2019-03-15 17:42:15
///LastEditTime: 2019-12-23 10:57:31
///
import 'package:flutter/material.dart';
import 'nc_tab_filter_controller.dart';
import 'nc_more_filter_action.dart';

class NCTabMoreFilter extends StatefulWidget {
  final Widget child;
  final NCTabFilterController controller;

  ///是否全屏
  final bool fullScreen;
  final void Function(Map) onConfirm;

  NCTabMoreFilter(
      {@required this.child,
      @required this.controller,
      this.onConfirm,
      this.fullScreen = true})
      : assert(child is NCMoreFilterAction);

  @override
  _NCTabMoreFilterState createState() => _NCTabMoreFilterState();
}

class _NCTabMoreFilterState extends State<NCTabMoreFilter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: widget.fullScreen ? MainAxisSize.max : MainAxisSize.min,
      children: <Widget>[
        widget.fullScreen
            ? Expanded(
                child: widget.child,
              )
            : widget.child,
        SizedBox.fromSize(
          size: const Size.fromHeight(52),
          child: Row(
            children: <Widget>[
              SizedBox.fromSize(
                size: Size(16, 16),
              ),
              Expanded(
                child: FlatButton(
                  child: Text(
                    '清空',
                    style:
                        TextStyle(fontSize: 14, color: const Color(0xFF999999)),
                  ),
                  color: const Color(0xFFF5F5F5),
                  onPressed: () {
                    (widget.child as NCMoreFilterAction).onClear();
                  },
                ),
                flex: 1,
              ),
              SizedBox.fromSize(
                size: Size(16, 16),
              ),
              Expanded(
                child: FlatButton(
                  child: Text(
                    '确定',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (widget.onConfirm != null) {
                      widget.onConfirm(
                          (widget.child as NCMoreFilterAction).onResult());
                    }
                    widget.controller.dismiss();
                  },
                ),
                flex: 1,
              ),
              SizedBox.fromSize(
                size: Size(16, 16),
              ),
            ],
          ),
        )
      ],
    );
  }
}
