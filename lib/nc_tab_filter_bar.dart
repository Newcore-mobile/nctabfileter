///
/// @Author: YoungChan
///LastEditors: YoungChan
/// @Description: 标题底部Tab筛选控件, 要布局在AppBar 的bottom 里
/// @Date: 2019-03-04 17:38:26
///LastEditTime: 2019-12-24 09:56:04
///
import 'package:flutter/material.dart';
import 'nc_animation_roating_icon.dart';
import 'nc_tab_filter_controller.dart';

class NCTabFilterBar extends StatefulWidget implements PreferredSizeWidget {
  final NCTabFilterController controller;

  ///监听tabbar 的打开和关闭
  final void Function(int, bool) onTabFilterExpanded;
  NCTabFilterBar({Key key, @required this.controller, this.onTabFilterExpanded})
      : preferredSize = Size.fromHeight(44),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _NCTabFilterBarState createState() => _NCTabFilterBarState();
}

class _NCTabFilterBarState extends State<NCTabFilterBar> {
  NCTabFilterController _controller;

  ///当前展开的Tab index
  int _expandedTabIndex = -1;

  @override
  void initState() {
    if (_controller != widget.controller) {
      _controller = widget.controller;

      ///监听FilterView dismiss 通知
      _controller.subscibeOnDismiss(() {
        setState(() {
          if (widget.onTabFilterExpanded != null) {
            //Tab filter 展开通知
            widget.onTabFilterExpanded(_expandedTabIndex, false);
          }
          _expandedTabIndex = -1;
        });
      });

      _controller.onUpdateTabBar = () {
        setState(() {});
      };
    }
    super.initState();
  }

  List<Widget> _buildChildren() {
    var list = List<Widget>();
    for (var i = 0; i < _controller.tabTitles.length; i++) {
      var title = _controller.tabTitles[i];

      list.add(Expanded(
        child: _HeaderTab(
          name: title,
          selected: _controller.isTabSelect(i),
          expanded: _expandedTabIndex == i,
          onExpandedChanged: (expanded) {
            if (expanded) {
              if (_expandedTabIndex != i) {
                if (_expandedTabIndex >= 0) {
                  _controller.onTabExpanded(_expandedTabIndex, false);
                }
                setState(() {
                  _expandedTabIndex = i;
                });
              }
            } else {
              _expandedTabIndex = -1;
            }
            _controller.onTabExpanded(i, expanded);
            if (widget.onTabFilterExpanded != null) {
              //Tab filter 展开通知
              widget.onTabFilterExpanded(i, expanded);
            }
          },
        ),
        flex: 1,
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
      size: Size.fromHeight(44),
      child: Row(
        children: _buildChildren(),
      ));
}

///Tab项
///@param selected 是否选中状态
///@param expanded 是否点击展开状态
class _HeaderTab extends StatefulWidget {
  final String name;
  final bool selected;
  final bool expanded;
  final Function(bool expanded) onExpandedChanged;
  _HeaderTab(
      {Key key,
      this.name,
      this.selected = false,
      this.expanded = false,
      this.onExpandedChanged})
      : super(key: key);

  @override
  _HeaderTabState createState() => _HeaderTabState();
}

class _HeaderTabState extends State<_HeaderTab>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  void didUpdateWidget(_HeaderTab oldWidget) {
    _isExpanded = widget.expanded;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
            if (widget.onExpandedChanged != null) {
              widget.onExpandedChanged(_isExpanded);
            }
          });
        },
        child: Center(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 70),
              child: Text(widget.name,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.selected || _isExpanded
                        ? Theme.of(context).primaryColor
                        : const Color(0xFF333333),
                  )),
            ),
            SizedBox.fromSize(
              size: const Size(4.0, 4.0),
            ),
            NCAnimationRoatingIcon(
              isSelected: _isExpanded,
              icon: Icon(
                Icons.arrow_drop_down,
                color: widget.selected || _isExpanded
                    ? Theme.of(context).primaryColor
                    : const Color(0xFF333333),
              ),
            ),
          ],
        )),
      );
}
