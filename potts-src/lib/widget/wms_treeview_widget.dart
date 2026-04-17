import 'package:flutter/material.dart';

/**
 * 内容：树形结构共通
 * 作者：赵士淞
 * 时间：2023/11/02
 */
// 处理数据列表
List handleDataList = [];

// ignore: must_be_immutable
class WMSTreeviewWidget extends StatefulWidget {
  // 展开
  bool? expanded;
  // 数据列表
  List dataList;
  // 树形主键
  String? treeKey;
  // 树形上级
  String treeSuper;
  // 树形标题
  String treeTitle;
  // 缩进
  double? indent;
  // 高度
  double? height;
  // 字体大小
  double? fontSize;
  // 字体颜色
  Color? fontColor;
  // 显示复选框
  bool? showCheckbox;
  // 复选框颜色
  Color? checkboxColor;
  // 多选
  bool? multipleChoice;
  // 树回调函数
  final treeCallBack;

  WMSTreeviewWidget({
    super.key,
    this.expanded = false,
    required this.dataList,
    this.treeKey = 'id',
    required this.treeSuper,
    required this.treeTitle,
    this.indent = 30,
    this.height = 40,
    this.fontSize = 14,
    this.fontColor = const Color.fromRGBO(0, 0, 0, 1),
    this.showCheckbox = true,
    this.checkboxColor = const Color.fromRGBO(44, 167, 176, 1),
    this.multipleChoice = false,
    this.treeCallBack,
  });

  @override
  State<WMSTreeviewWidget> createState() => _WMSTreeviewWidgetState();
}

class _WMSTreeviewWidgetState extends State<WMSTreeviewWidget> {
  @override
  Widget build(BuildContext context) {
    // 判断处理数据列表长度
    if (handleDataList.length == 0) {
      // 状态变更
      setState(() {
        // 处理数据列表
        handleDataList = _initTreeDataList();
      });
    }

    return Container(
      child: ListView(
        children: _initTreeNodeList(handleDataList, 0),
      ),
    );
  }

  // 初始化树数据列表
  List _initTreeDataList() {
    // 树数据列表
    List treeDataList = [];
    // 循环数据列表
    for (int i = 0; i < widget.dataList.length; i++) {
      // 判断父属性
      if (widget.dataList[i][widget.treeSuper] == null) {
        // 树数据列表
        treeDataList.add(_handleTreeData(i));
      }
    }
    // 返回
    return treeDataList;
  }

  // 初始化子树数据列表
  List _initChildTreeDataList(int keyValue) {
    // 树数据列表
    List treeDataList = [];
    // 循环数据列表
    for (int i = 0; i < widget.dataList.length; i++) {
      // 判断父属性
      if (widget.dataList[i][widget.treeSuper] != null &&
          widget.dataList[i][widget.treeSuper] == keyValue) {
        // 树数据列表
        treeDataList.add(_handleTreeData(i));
      }
    }
    // 返回
    return treeDataList;
  }

  // 处理树数据
  Map _handleTreeData(int i) {
    // 树数据
    Map treeData = widget.dataList[i];
    treeData['check'] = false;
    // 子树数据列表
    List childTreeDataList =
        _initChildTreeDataList(widget.dataList[i][widget.treeKey]);
    // 判断子树数据列表数量
    if (childTreeDataList.length != 0) {
      // 树数据
      treeData['children'] = childTreeDataList;
      treeData['expand'] = widget.expanded;
    } else {
      treeData['expand'] = true;
    }
    // 返回
    return treeData;
  }

  // 初始化树节点列表
  List<Widget> _initTreeNodeList(List handleDataList, int wheel) {
    // 树节点列表
    List<Widget> treeNodeList = [];
    // 循环处理数据列表
    for (int i = 0; i < handleDataList.length; i++) {
      // 树节点列表
      treeNodeList.add(
        Container(
          height: widget.height,
          margin: EdgeInsets.fromLTRB((wheel * widget.indent!), 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: handleDataList[i]['expand'] == true &&
                    handleDataList[i]['children'] != null,
                child: GestureDetector(
                  onTap: () {
                    // 处理数据展开变更
                    _handleDataExpandChange(handleDataList[i]);
                  },
                  child: Container(
                    width: 20,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: widget.fontColor,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: handleDataList[i]['expand'] == false &&
                    handleDataList[i]['children'] != null,
                child: GestureDetector(
                  onTap: () {
                    // 处理数据展开变更
                    _handleDataExpandChange(handleDataList[i]);
                  },
                  child: Container(
                    width: 20,
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: widget.fontColor,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: handleDataList[i]['children'] == null,
                child: Container(
                  width: 20,
                ),
              ),
              Visibility(
                visible: widget.showCheckbox == true,
                child: Container(
                  width: 20,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Checkbox(
                    fillColor: MaterialStateColor.resolveWith(
                      (states) => widget.checkboxColor!,
                    ),
                    value: handleDataList[i]['check'],
                    onChanged: (value) {
                      // 处理数据选择变更
                      _handleDataCheckChange(handleDataList[i]);
                    },
                  ),
                ),
              ),
              Visibility(
                visible: widget.showCheckbox == false,
                child: Container(
                  width: 10,
                ),
              ),
              Text(
                handleDataList[i][widget.treeTitle],
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.fontColor,
                ),
              ),
            ],
          ),
        ),
      );
      // 判断树数据子级
      if (handleDataList[i]['expand'] == true &&
          handleDataList[i]['children'] != null) {
        // 树节点列表
        treeNodeList.addAll(
            _initTreeNodeList(handleDataList[i]['children'], wheel + 1));
      }
    }
    // 返回
    return treeNodeList;
  }

  // 处理数据展开变更
  void _handleDataExpandChange(Map handleData) {
    // 处理数据展开
    handleData['expand'] = !handleData['expand'];
    // 状态变更
    setState(() {
      // 处理数据列表
      handleDataList = handleDataList;
    });
  }

  // 处理数据选择变更
  void _handleDataCheckChange(Map handleData) {
    // 判断多选
    if (widget.multipleChoice == false) {
      // 处理数据选择还原
      _handleDataCheckRevert(handleDataList, handleData[widget.treeKey]);
    }
    // 处理数据选择
    handleData['check'] = !handleData['check'];
    // 状态变更
    setState(() {
      // 处理数据列表
      handleDataList = handleDataList;
    });
    // 树回调函数
    widget.treeCallBack(_handleDataCallBack(handleDataList));
  }

  // 处理数据选择还原
  void _handleDataCheckRevert(List handleDataList, int keyValue) {
    // 循环处理数据列表
    for (int i = 0; i < handleDataList.length; i++) {
      // 判断处理数据主键
      if (handleDataList[i][widget.treeKey] != keyValue) {
        // 处理数据选中
        handleDataList[i]['check'] = false;
      }
      // 判断处理数据子级
      if (handleDataList[i]['children'] != null) {
        // 处理数据选择还原
        _handleDataCheckRevert(handleDataList[i]['children'], keyValue);
      }
    }
  }

  // 处理数据回调函数
  List _handleDataCallBack(List handleDataList) {
    // 选择列表
    List checkList = [];
    // 循环处理数据列表
    for (int i = 0; i < handleDataList.length; i++) {
      // 判断处理数据选中
      if (handleDataList[i]['check'] == true) {
        // 选择列表
        checkList.add(_dataCallBack(handleDataList[i][widget.treeKey]));
      }
      // 判断处理数据子级
      if (handleDataList[i]['children'] != null) {
        // 选择列表
        checkList.addAll(_handleDataCallBack(handleDataList[i]['children']));
      }
    }
    // 返回
    return checkList;
  }

  // 数据回调函数
  Map _dataCallBack(int keyValue) {
    // 选择
    Map check = {};
    // 循环数据列表
    for (int i = 0; i < widget.dataList.length; i++) {
      // 判断数据主键
      if (widget.dataList[i][widget.treeKey] == keyValue) {
        // 选择
        check = widget.dataList[i];
      }
    }
    // 返回
    return check;
  }
}
