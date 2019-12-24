///
/// @Author: YoungChan
///LastEditors: YoungChan
/// @Description: 180度旋转图标
/// @Date: 2019-03-04 19:11:57
///LastEditTime: 2019-03-21 10:51:54
///
import 'package:flutter/material.dart';

class NCAnimationRoatingIcon extends StatefulWidget {
  final bool isSelected;
  final Widget icon;
  NCAnimationRoatingIcon({this.isSelected = false, @required this.icon});

  @override
  _NCAnimationRoatingIconState createState() => _NCAnimationRoatingIconState();
}

class _NCAnimationRoatingIconState extends State<NCAnimationRoatingIcon>
    with SingleTickerProviderStateMixin {
  Animation arrowAnim;
  AnimationController arrowAnimController;

  @override
  void initState() {
    arrowAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    arrowAnim = Tween(begin: .0, end: .5).animate(arrowAnimController);
    super.initState();
  }

  @override
  void dispose() {
    arrowAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSelected) {
      arrowAnimController.forward();
    } else {
      arrowAnimController.reverse();
    }
    return RotationTransition(
      turns: arrowAnim,
      child: widget.icon,
    );
  }
}
