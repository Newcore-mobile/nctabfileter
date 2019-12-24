///
/// @Author: YoungChan
///LastEditors: YoungChan
/// @Description: 单项选择列表筛选
/// @Date: 2019-03-04 19:03:27
///LastEditTime: 2019-12-23 10:56:47
///
import 'package:flutter/material.dart';
import 'nc_tab_filter_controller.dart';
import 'nc_search_bar.dart';

class NCTabSingleFilter<T> extends StatefulWidget {
  ///数据源
  final List<T> dataSource;

  ///获取数据源中的标题文本
  final String Function(T) getTitleLabel;

  ///初始值， 有个条件，必须是dataSource中的数据，否则不起作用，因为要和dataSource中其他数据进行比较
  final T initialData;

  ///选中回调
  final void Function(T, int) onConfirm;

  final NCTabFilterController controller;

  /// 是否开启搜索
  final bool enableSearch;
  NCTabSingleFilter(
      {Key key,
      @required this.dataSource,
      @required this.getTitleLabel,
      @required this.controller,
      this.enableSearch = false,
      this.initialData,
      this.onConfirm})
      : assert(dataSource != null),
        assert(getTitleLabel != null),
        assert(controller != null);

  @override
  _NCTabSingleFilterState createState() => _NCTabSingleFilterState<T>(
      dataSource: dataSource,
      getTitleLabel: getTitleLabel,
      onConfirm: onConfirm);
}

class _NCTabSingleFilterState<T> extends State<NCTabSingleFilter> {
  static const maxLength = 10;
  final String Function(T) getTitleLabel;
  List<T> dataSource;
  List<T> _showDataSource;
  final void Function(T, int) onConfirm;
  T _selectItem;
  final TextEditingController _searchEditController = TextEditingController();
  final GlobalKey _searchKey = GlobalKey();

  _NCTabSingleFilterState(
      {this.dataSource, this.getTitleLabel, this.onConfirm}) {
    _showDataSource = dataSource;
  }

  void _search(String key) {
    setState(() {
      if (key?.isNotEmpty == true) {
        _showDataSource =
            dataSource?.where((d) => getTitleLabel(d).contains(key))?.toList();
      } else {
        _showDataSource = dataSource;
      }
    });
  }

  @override
  void initState() {
    _selectItem = widget.initialData;
    super.initState();
  }

  @override
  void didUpdateWidget(NCTabSingleFilter oldWidget) {
    dataSource = widget.dataSource;
    _selectItem = widget.initialData;
    _search(_searchEditController.text);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var maxHeight = maxLength * 44 + maxLength;
    if (_showDataSource != null && _showDataSource.length < maxLength) {
      maxHeight = _showDataSource.length * 44 + _showDataSource.length;
    }
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
              separatorBuilder: (context, index) => Divider(
                color: const Color(0xFFEEEEEE),
                height: 1,
              ),
              shrinkWrap: true,
              itemCount: _showDataSource?.length ?? 0,
              itemBuilder: (context, index) {
                var item = _showDataSource[index];

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectItem = item;
                    });
                    widget.controller.dismiss();
                    if (onConfirm != null) {
                      onConfirm(item, index);
                    }
                  },
                  child: Container(
                    height: 44,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            getTitleLabel(item),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                          ),
                        ),
                        Offstage(
                          offstage: _selectItem != item,
                          child: Icon(
                            Icons.done,
                            color: Theme.of(context).primaryColor,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
