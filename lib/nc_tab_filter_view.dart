///
/// @Author: YoungChan
///LastEditors: YoungChan
/// @Description: TabFilter 筛选View，与 TabFilterBar 相关联，每一个关联TabFilterView child TabFilterBar child
///  要布局在Stack 里，使用参照 example/lib/page/tabfilter/
/// @Date: 2019-03-05 11:04:27
///LastEditTime: 2019-07-25 19:23:25
///
import 'package:flutter/material.dart';
import 'nc_tab_filter_controller.dart';

class NCTabFilterView extends StatefulWidget {
  final List<Widget> children;
  final NCTabFilterController controller;

  NCTabFilterView({Key key, this.controller, this.children})
      : assert(children != null),
        assert(controller != null),
        assert(children.length == controller.tabTitles.length),
        super(key: key);

  @override
  _NCTabFilterViewState createState() => _NCTabFilterViewState();
}

class _NCTabFilterViewState extends State<NCTabFilterView>
    with SingleTickerProviderStateMixin {
  NCTabFilterController _controller;
  Animation _viewAnim;
  AnimationController _viewAnimController;
  int _curIndex = 0;

  @override
  void initState() {
    _viewAnimController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _viewAnim =
        CurvedAnimation(parent: _viewAnimController, curve: Curves.easeIn);

    _controller = widget.controller;

    ///dimiss 建通
    _controller.subscibeOnDismiss(() {
      //关闭键盘
      FocusScope.of(context).requestFocus(FocusNode());
      _viewAnimController.reverse();
    });

    ///Tab点击展开监听
    _controller.onTabExpanded = (int index, bool expanded) {
      if (expanded) {
        _viewAnimController.forward();
      } else {
        _viewAnimController.reverse();
      }
      if (_curIndex != index) {
        setState(() {
          _curIndex = index;
        });
      }
    };
    super.initState();
  }

  @override
  void dispose() {
    _viewAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var list = List<Widget>();
    for (var i = 0; i < widget.children.length; i++) {
      list.add(Offstage(
        offstage: _curIndex != i,
        child: widget.children[i],
      ));
    }
    return FadeTransition(
      opacity: _viewAnim,
      child: ScaleTransition(
        alignment: Alignment.topCenter,
        scale: _viewAnim,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _controller.dismiss();
              },
              child: Container(
                color: Colors.black87.withAlpha(100),
              ),
            ),
            Material(
                color: Colors.white,
                child: Stack(
                  children: list,
                )),
          ],
        ),
      ),
    );
  }
}
