///
///Author: YoungChan
///Date: 2019-05-28 10:16:22
///LastEditors: YoungChan
///LastEditTime: 2019-12-24 09:54:12
///Description: 搜索bar
///
import 'package:flutter/material.dart';

class NCSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String) onSubmitted;
  final void Function(String) onChanged;
  final FocusNode focusNode;
  final String hint;
  final EdgeInsets contentPadding;
  final Key key;

  /// 扫码解析回调
  final String Function(String) onDecodeCode;

  NCSearchBar(
      {this.key,
      this.controller,
      this.onSubmitted,
      this.onChanged,
      this.focusNode,
      this.hint = '',
      this.contentPadding = const EdgeInsets.fromLTRB(16, 8, 16, 8),
      this.onDecodeCode})
      : super(key: key);

  @override
  _NCSearchBarState createState() => _NCSearchBarState();
}

class _NCSearchBarState extends State<NCSearchBar> {
  bool _isShowClearBtn = false;
  TextEditingController _controller;

  @override
  void initState() {
    if (widget.controller != null) {
      _controller = widget.controller;
    } else {
      _controller = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
        size: Size.fromHeight(50),
        child: Container(
          margin: widget.contentPadding,
          decoration: BoxDecoration(
            color: Color(0xFFEFEFEF),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: widget.focusNode,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 6),
                    hintText: widget.hint,
                    hintStyle:
                        TextStyle(fontSize: 16, color: Color(0xFFCCCCCC)),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.search,
                        color: const Color(0xFFCCCCCC),
                      ),
                    ),
                    suffixIcon: _isShowClearBtn
                        ? IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey,
                              size: 16,
                            ),
                            onPressed: () {
                              _controller.text = '';
                              setState(() {
                                _isShowClearBtn = false;
                              });
                              if (widget.onSubmitted != null) {
                                widget.onSubmitted(null);
                              }
                            },
                          )
                        : SizedBox.fromSize(
                            size: Size.square(0),
                          ),
                    border: InputBorder.none,
                    fillColor: Colors.transparent,
                    filled: true,
                  ),
                  onSubmitted: (s) {
                    if (widget.onSubmitted != null) {
                      widget.onSubmitted(s);
                    }
                  },
                  onChanged: (s) {
                    if (s.isEmpty && _isShowClearBtn) {
                      setState(() {
                        _isShowClearBtn = false;
                      });
                    } else if (s.isNotEmpty && !_isShowClearBtn) {
                      setState(() {
                        _isShowClearBtn = true;
                      });
                    }
                    if (widget.onChanged != null) {
                      widget.onChanged(s);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
