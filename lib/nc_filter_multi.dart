///
/// @Author: YoungChan
///LastEditors: YoungChan
/// @Description: 多项选择列表筛选
/// @Date: 2019-03-05 18:00:45
///LastEditTime: 2019-12-24 11:08:29
///
import 'package:flutter/material.dart';
import 'nc_tab_filter_controller.dart';
import 'nc_search_bar.dart';

class NCTabMultiFilter<T> extends StatefulWidget {
  ///数据源
  final List<T> dataSource;

  ///获取数据源中的标题文本
  final String Function(T) getTitleLabel;

  ///初始值， 有个条件，必须是dataSource中的数据，否则不起作用，因为要和dataSource中其他数据进行比较
  final List<T> initialData;

  ///是否开启搜索
  final bool enableSearch;

  ///确认回调
  final void Function(List<T>) onConfirm;
  final NCTabFilterController controller;

  NCTabMultiFilter(
      {@required this.dataSource,
      @required this.getTitleLabel,
      this.initialData,
      this.enableSearch = false,
      @required this.controller,
      this.onConfirm})
      : assert(dataSource != null),
        assert(getTitleLabel != null),
        assert(controller != null);

  @override
  _NCTabMultiFilterState createState() => _NCTabMultiFilterState<T>(
      dataSource: dataSource,
      getTitleLabel: getTitleLabel,
      onConfirm: onConfirm);
}

class _NCTabMultiFilterState<T> extends State<NCTabMultiFilter> {
  static const maxLength = 8;

  ///数据源
  List<CheckableWrap<T>> _dataSource;
  List<CheckableWrap<T>> _showDataSource;

  ///获取数据源中的标题文本
  final String Function(T) getTitleLabel;

  ///确认回调
  final void Function(List<T>) onConfirm;
  final TextEditingController _searchEditController = TextEditingController();
  GlobalKey _searchKey = GlobalKey();

  _NCTabMultiFilterState(
      {List<T> dataSource, this.getTitleLabel, this.onConfirm}) {
    _dataSource = dataSource.map((t) {
      return CheckableWrap(data: t);
    }).toList();
  }

  void _search(String key) {
    setState(() {
      if (key?.isNotEmpty == true) {
        _showDataSource = _dataSource
            ?.where((d) => getTitleLabel(d.data).contains(key))
            ?.toList();
      } else {
        _showDataSource = _dataSource;
      }
    });
  }

  @override
  void initState() {
    _dataSource.forEach((d) {
      if (widget.initialData?.contains(d.data) == true) {
        d.isChecked = true;
      }
    });
    _showDataSource = _dataSource;
    super.initState();
  }

  @override
  void didUpdateWidget(NCTabMultiFilter oldWidget) {
    _dataSource = widget.dataSource.map<CheckableWrap<T>>((t) {
      return CheckableWrap(data: t);
    }).toList();
    _dataSource.forEach((d) {
      if (widget.initialData?.contains(d.data) == true) {
        d.isChecked = true;
      }
    });
    _search(_searchEditController.text);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var maxHeight = maxLength * 44 + maxLength;
    if (_showDataSource != null && _showDataSource.length < maxLength) {
      maxHeight = _showDataSource.length * 44 + _showDataSource.length;
    }
    maxHeight += 52;
    if (widget.enableSearch) {
      maxHeight += 50;
    }
    return SizedBox.fromSize(
      size: Size.fromHeight(maxHeight.toDouble()),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Offstage(
            offstage: !widget.enableSearch,
            child: NCSearchBar(
              controller: _searchEditController,
              key: _searchKey,
              onChanged: (s) {
                _search(s);
              },
              onSubmitted: (s) {
                _search(s);
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => Divider(
                color: const Color(0xFFEEEEEE),
                height: 1,
              ),
              itemCount: _showDataSource?.length ?? 0,
              itemBuilder: (context, index) {
                var item = _showDataSource[index];
                return _CheckedListCell(
                  initialValue: item.isChecked,
                  onCheckChanged: (checked) {
                    item.isChecked = checked;
                  },
                  title: getTitleLabel(item.data),
                );
              },
            ),
          ),
          SizedBox.fromSize(
            size: const Size.fromHeight(52),
            child: Row(
              children: <Widget>[
                SizedBox.fromSize(
                  size: const Size(16, 16),
                ),
                Expanded(
                  child: FlatButton(
                    child: Text(
                      '清空',
                      style: TextStyle(
                          fontSize: 14, color: const Color(0xFF999999)),
                    ),
                    color: const Color(0xFFF5F5F5),
                    onPressed: () {
                      setState(() {
                        for (var d in _dataSource) {
                          d.isChecked = false;
                        }
                      });
                    },
                  ),
                  flex: 1,
                ),
                SizedBox.fromSize(
                  size: const Size(16, 16),
                ),
                Expanded(
                  child: FlatButton(
                    child: Text(
                      '确定',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (onConfirm != null) {
                        var list = _dataSource
                            .where((t) => t.isChecked)
                            .map((t) => t.data)
                            .toList();
                        onConfirm(list);
                      }
                      widget.controller.dismiss();
                    },
                  ),
                  flex: 1,
                ),
                SizedBox.fromSize(
                  size: const Size(16, 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CheckedListCell extends StatefulWidget {
  final String title;
  final ValueChanged<bool> onCheckChanged;
  final bool initialValue;
  _CheckedListCell(
      {this.title, this.onCheckChanged, this.initialValue = false});

  @override
  __CheckedListCellState createState() => __CheckedListCellState();
}

class __CheckedListCellState extends State<_CheckedListCell> {
  bool _checked = false;

  @override
  void initState() {
    _checked = widget.initialValue;
    super.initState();
  }

  @override
  void didUpdateWidget(_CheckedListCell oldWidget) {
    _checked = widget.initialValue;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _checked = !_checked;
        });
        if (widget.onCheckChanged != null) {
          widget.onCheckChanged(_checked);
        }
      },
      child: Container(
        height: 44,
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                widget.title ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            Checkbox(
              value: _checked,
              onChanged: (check) {
                setState(() {
                  _checked = check;
                });
                if (widget.onCheckChanged != null) {
                  widget.onCheckChanged(check);
                }
              },
              activeColor: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}

class CheckableWrap<T> {
  bool isChecked = false;
  T data;

  CheckableWrap({this.isChecked = false, this.data});
}
