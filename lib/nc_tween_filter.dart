///
///Author: YoungChan
///LastEditors: YoungChan
///Description: 双栏筛选基类
///Date: 2019-03-15 10:15:08
///LastEditTime: 2019-12-24 10:01:54
///
import 'package:flutter/material.dart';
import 'nc_tab_filter_controller.dart';
import 'package:rxdart/rxdart.dart';

class NCTabTweenFilter<L, R> extends StatefulWidget {
  ///数据源
  final Map<L, List<R>> dataSource;

  ///获取左列表的标题文本
  final String Function(L) getLeftTitleLabel;

  ///获取右列表的标题文本
  final String Function(R) getRightTitleLabel;

  ///初始值， 有个条件，必须是dataSource中的数据，否则不起作用，因为要和dataSource中其他数据进行比较
  final Map<L, List<R>> initialData;

  ///确认回调
  final void Function(Map<L, List<R>>) onConfirm;

  ///是否单选模式
  final bool isSingleSelectModel;

  final NCTabFilterController controller;

  NCTabTweenFilter({
    @required this.dataSource,
    @required this.getLeftTitleLabel,
    @required this.getRightTitleLabel,
    this.initialData,
    @required this.controller,
    this.onConfirm,
    this.isSingleSelectModel = false,
  })  : assert(dataSource != null),
        assert(getLeftTitleLabel != null),
        assert(getRightTitleLabel != null),
        assert(controller != null);

  @override
  _NCTabTweenFilterState createState() => _NCTabTweenFilterState<L, R>(
        dataSource: dataSource,
        getLeftTitleLabel: getLeftTitleLabel,
        getRightTitleLabel: getRightTitleLabel,
        onConfirm: onConfirm,
      );
}

class _NCTabTweenFilterState<L, R> extends State<NCTabTweenFilter> {
  final GlobalKey _rightListKey = GlobalKey();

  ///数据源
  Map<L, List<R>> dataSource;

  ///获取左列表的标题文本
  final String Function(L) getLeftTitleLabel;

  ///获取右列表的标题文本
  final String Function(R) getRightTitleLabel;

  ///确认回调
  final void Function(Map<L, List<R>>) onConfirm;

  _TweenController<L, R> _tweenController;

  L _defaultSelectLeft;

  _NCTabTweenFilterState(
      {this.dataSource,
      this.getLeftTitleLabel,
      this.getRightTitleLabel,
      this.onConfirm});

  @override
  void initState() {
    _tweenController =
        _TweenController<L, R>(isSingleSelectMode: widget.isSingleSelectModel);
    if (widget.initialData?.isNotEmpty == true) {
      _defaultSelectLeft = widget.initialData.keys.toList()[0];
    } else if (dataSource.isNotEmpty) {
      _defaultSelectLeft = dataSource.keys.toList()[0];
    }
    _tweenController.selectItems =
        widget.initialData == null ? {} : widget.initialData;
    super.initState();
  }

  @override
  void dispose() {
    _tweenController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(NCTabTweenFilter oldWidget) {
    dataSource = widget.dataSource;
    if (widget.initialData?.isNotEmpty == true) {
      _defaultSelectLeft = widget.initialData.keys.toList()[0];
    } else if (dataSource.isNotEmpty) {
      _defaultSelectLeft = dataSource.keys.toList()[0];
    }
    _tweenController.selectItems =
        widget.initialData == null ? {} : widget.initialData;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var leftList = dataSource.keys.toList(growable: false);
    //用ScrollView 包裹，防止弹出键盘的时候界面出现警告
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox.fromSize(
            size: const Size.fromHeight(300),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _LeftList<L, R>(
                    dataSource: leftList,
                    originDataSource: dataSource,
                    getTitleLabel: getLeftTitleLabel,
                    controller: _tweenController,
                    selectedItem: _defaultSelectLeft,
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: _RightList<L, R>(
                    key: _rightListKey,
                    getTitleLabel: getRightTitleLabel,
                    controller: _tweenController,
                    isSingleModel: widget.isSingleSelectModel,
                  ),
                  flex: 1,
                ),
              ],
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
                      _tweenController.clear();
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
                        onConfirm(_tweenController.selectItems);
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

///左列表
class _LeftList<L, R> extends StatefulWidget {
  ///数据源
  final List<L> dataSource;

  ///原始数据
  final Map<L, List<R>> originDataSource;

  ///获取标题文本
  final String Function(L) getTitleLabel;

  final _TweenController controller;

  final L selectedItem;

  _LeftList(
      {@required this.dataSource,
      @required this.originDataSource,
      @required this.getTitleLabel,
      @required this.controller,
      this.selectedItem});

  @override
  _LeftListState createState() => _LeftListState<L, R>(
      dataSource: dataSource,
      originDataSource: originDataSource,
      getTitleLabel: getTitleLabel);
}

class _LeftListState<L, R> extends State<_LeftList> {
  ///数据源
  List<L> dataSource;

  ///原始数据
  Map<L, List<R>> originDataSource;

  ///获取标题文本
  final String Function(L) getTitleLabel;

  L _selectedItem;

  _LeftListState({this.dataSource, this.originDataSource, this.getTitleLabel});

  @override
  void initState() {
    _selectedItem = widget.selectedItem;
    if (_selectedItem == null && dataSource?.isNotEmpty == true) {
      _selectedItem = dataSource[0];
    }
    () async {
      //延时操作, 等待右侧列表初始化完成
      await Future.delayed(Duration(milliseconds: 500));
      widget.controller
          .onSetRightDataSource(_selectedItem, originDataSource[_selectedItem]);
    }();
    super.initState();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    dataSource = widget.dataSource;
    originDataSource = widget.originDataSource;
    if (_selectedItem != null) {
      () async {
        //延时操作, 等待右侧列表初始化完成
        await Future.delayed(Duration(milliseconds: 500));
        if (mounted) {
          widget.controller.onSetRightDataSource(
              _selectedItem, originDataSource[_selectedItem]);
        }
      }();
    }
    widget.controller.refreshLeftSelect();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: const Color(0xFFEEEEEE),
        height: 1,
      ),
      itemCount: dataSource.length,
      itemBuilder: (context, index) {
        var item = dataSource[index];

        return StreamBuilder<Map<dynamic, List>>(
          stream: widget.controller.leftSelectStream,
          initialData: widget.controller.selectItems,
          builder: (context, snapshot) {
            bool isSelect = snapshot.data[item]?.isNotEmpty == true;

            return Material(
              color: _selectedItem == item
                  ? const Color(0xFFF4F4F4)
                  : Colors.white,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedItem = item;
                  });
                  widget.controller.onSetRightDataSource(
                      _selectedItem, originDataSource[_selectedItem]);
                },
                child: Container(
                  height: 44,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    getTitleLabel(dataSource[index]),
                    style: TextStyle(
                        fontSize: 14,
                        color: isSelect
                            ? Theme.of(context).primaryColor
                            : const Color(0xFF333333)),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

///右列表，可替换list tile
class _RightList<L, R> extends StatefulWidget {
  ///获取标题文本
  final String Function(R) getTitleLabel;

  final _TweenController controller;
  final bool isSingleModel;

  _RightList(
      {Key key,
      @required this.getTitleLabel,
      @required this.controller,
      this.isSingleModel = false})
      : super(key: key);

  @override
  _RightListState createState() =>
      _RightListState<L, R>(getTitleLabel: getTitleLabel);
}

class _RightListState<L, R> extends State<_RightList> {
  L _left;
  List<R> _dataSource;
  List<R> _originSource;
  Map<L, bool> _isSelectAll = {};
  TextEditingController _searchController = TextEditingController();

  ///获取标题文本
  final String Function(R) getTitleLabel;

  _RightListState({this.getTitleLabel});

  @override
  void initState() {
    //监听数据源
    widget.controller.onSetRightDataSource = (left, rightList) {
//        _searchController.text = "";
      _left = left;
      _originSource = rightList;
      if (_searchController.text.isNotEmpty) {
        _search(_searchController.text);
      } else {
        setState(() {
          _dataSource = rightList;
        });
      }
    };
    //监听清空操作
    widget.controller.onClear = () {
      setState(() {
        _isSelectAll.forEach((r, _) {
          _isSelectAll[r] = false;
        });
      });
    };
    super.initState();
  }

  ///搜索，通过标题匹配搜素关键字
  void _search(String key) {
    setState(() {
      _dataSource = _originSource.where((item) {
        return getTitleLabel(item).contains(key);
      }).toList();
    });
  }

  ///构建搜索框
  Widget _buildSearchBar() => Container(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        height: 44,
        child: TextField(
          controller: _searchController,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 14, color: const Color(0xFF333333)),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0, 6, 8, 6),
              hasFloatingPlaceholder: false,
              isDense: true,
              prefixIcon: Icon(
                Icons.search,
                size: 18,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: const Color(0xFFEAEAEA)),
          onChanged: (s) {
            _search(s);
          },
        ),
      );

  ///构建全选操作view
  Widget _buildSelectAll(L item) => InkWell(
        onTap: () {
          var select = _isSelectAll[item] ?? false;
          _isSelectAll[item] = !select;
          setState(() {
            if (_isSelectAll[item]) {
              widget.controller.selectRightAll(_left, _dataSource);
            } else {
              widget.controller.unselectRightAll(_left);
            }
          });
        },
        child: Container(
          height: 44,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text('全选',
                    style: TextStyle(
                        fontSize: 14, color: const Color(0xFF333333))),
              ),
              Checkbox(
                value: _isSelectAll[item] ?? false,
                onChanged: (check) {
                  _isSelectAll[item] = check;
                  setState(() {
                    if (_isSelectAll[item]) {
                      widget.controller.selectRightAll(_left, _dataSource);
                    } else {
                      widget.controller.unselectRightAll(_left);
                    }
                  });
                },
                activeColor: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      );

  ///构建单选列表项
  Widget _buildSingleListTile(R item) => InkWell(
        onTap: () {
          setState(() {
            widget.controller.onSelectItem(_left, item);
          });
        },
        child: Container(
          height: 44,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  getTitleLabel(item),
                  style: TextStyle(
                      fontSize: 14,
                      color: widget.controller.isItemSelected(_left, item)
                          ? Theme.of(context).primaryColor
                          : const Color(0xFF333333)),
                ),
              ),
              Radio(
                value: item,
                groupValue: widget.controller.getSingleSelectItem(_left),
                onChanged: (value) {
                  setState(() {
                    widget.controller.onSelectItem(_left, item);
                  });
                },
                activeColor: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      );

  ///构建多选列表项
  Widget _buildMultiListTile(R item) => InkWell(
        onTap: () {
          setState(() {
            widget.controller.onSelectItem(_left, item);
          });
        },
        child: Container(
          height: 44,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  getTitleLabel(item),
                  style: TextStyle(
                      fontSize: 14,
                      color: widget.controller.isItemSelected(_left, item)
                          ? Theme.of(context).primaryColor
                          : const Color(0xFF333333)),
                ),
              ),
              Checkbox(
                value: widget.controller.isItemSelected(_left, item),
                onChanged: (check) {
                  setState(() {
                    widget.controller.onSelectItem(_left, item);
                  });
                },
                activeColor: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF4F4F4),
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: const Color(0xFFEEEEEE),
          height: 1,
        ),
        //单选模式下显示搜索款，多选模式下显示多选框+全选
        itemCount: _dataSource == null
            ? 0
            : widget.isSingleModel
                ? _dataSource.length + 1
                : _dataSource.length + 2,
        itemBuilder: (context, index) {
          R item;
          if (widget.isSingleModel && index > 0) {
            item = _dataSource[index - 1];
          } else if (!widget.isSingleModel && index > 1) {
            item = _dataSource[index - 2];
          }
          if (index == 0) {
            return _buildSearchBar();
          } else if (!widget.isSingleModel && index == 1) {
            //多选模式中添加全选操作
            // print("SelectAll: $_isSelectAll");
            return _buildSelectAll(_left);
          } else {
            if (widget.isSingleModel) {
              return _buildSingleListTile(item);
            } else {
              return _buildMultiListTile(item);
            }
          }
        },
      ),
    );
  }
}

///双列表交互控制器
class _TweenController<L, R> {
  final bool isSingleSelectMode;

  _TweenController({this.isSingleSelectMode = false});

  Map<L, List<R>> selectItems = {};

  void Function(L, List<R>) onSetRightDataSource;
  VoidCallback onClear;

  BehaviorSubject<Map<L, List<R>>> _leftSelectObserver = BehaviorSubject();

  Observable<Map<L, List<R>>> get leftSelectStream =>
      _leftSelectObserver.stream;

  //选中操作
  void onSelectItem(L left, R right) {
    var rightList = selectItems[left];
    if (rightList == null) {
      rightList = [right];
      selectItems[left] = rightList;
    } else {
      if (isSingleSelectMode) {
        //单选模式
        if (rightList.contains(right)) {
          rightList.clear();
        } else {
          rightList.clear();
          rightList.add(right);
        }
      } else {
        //多选模式
        if (rightList.contains(right)) {
          rightList.remove(right);
          if (rightList.isEmpty) {
            selectItems.remove(left);
          }
        } else {
          rightList.add(right);
        }
      }
    }
    if (rightList.isNotEmpty) {
      _leftSelectObserver.sink.add(selectItems);
    } else {
      _leftSelectObserver.sink.add(selectItems);
    }
  }

  void refreshLeftSelect() {
    _leftSelectObserver.sink.add(selectItems);
  }

  ///获取单选模式下已选择项
  R getSingleSelectItem(L left) {
    var rightList = selectItems[left];
    if (rightList?.isNotEmpty == true) {
      return rightList[0];
    } else {
      return null;
    }
  }

  ///判单是否已选中
  bool isItemSelected(L left, R right) {
    var rightList = selectItems[left];
    if (rightList?.isNotEmpty == true) {
      return rightList.contains(right);
    } else {
      return false;
    }
  }

  ///右列表全选
  void selectRightAll(L left, List<R> list) {
    var copy = List<R>();
    copy.addAll(list);
    selectItems[left] = copy;
    _leftSelectObserver.sink.add(selectItems);
  }

  ///右列表取消全选
  void unselectRightAll(L left) {
    var rightList = selectItems[left];
    if (rightList != null) {
      rightList.clear();
      selectItems.remove(left);
    }
    _leftSelectObserver.sink.add(selectItems);
  }

  ///清空
  void clear() {
    selectItems.clear();
    onClear();
    _leftSelectObserver.sink.add(selectItems);
  }

  void dispose() {
    _leftSelectObserver.close();
  }
}
