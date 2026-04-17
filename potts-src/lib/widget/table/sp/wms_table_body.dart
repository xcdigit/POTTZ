import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/style/wms_style.dart';
import '../bloc/wms_record_bloc.dart';
import '../bloc/wms_record_model.dart';
import '../bloc/wms_table_bloc.dart';
import '../bloc/wms_table_model.dart';

class WmsTableBody<B extends WmsTableBloc<S>, S extends WmsTableModel>
    extends StatefulWidget {
  // 列数据
  final List<dynamic> columns;
  // 显示复选框列
  final bool showCheckboxColumn;
  // 操作弹窗选项
  final List operatePopupOptions;
  // 操作弹窗高度
  final double operatePopupHeight;
  // 行高度
  final double columnsHeight;
  // 头部标题
  final String headTitle;

  WmsTableBody(
    this.columns, {
    Key? key,
    this.showCheckboxColumn = true,
    this.operatePopupOptions = const <List>[],
    this.operatePopupHeight = 134,
    this.columnsHeight = 48.0,
    this.headTitle = '',
  });

  @override
  State<WmsTableBody<B, S>> createState() => _WmsTableBodyState<B, S>();
}

class _WmsTableBodyState<B extends WmsTableBloc<S>, S extends WmsTableModel>
    extends State<WmsTableBody<B, S>> {
  // 初始化表格行数据
  List<Widget> _initTableRows(WmsTableModel state) {
    // 行数据列表
    List<Widget> rowsList = [];
    // 循环列表数据
    for (int i = 0; i < state.records.length; i++) {
      WmsRecordBloc wmsRecordBloc = WmsRecordBloc(state.records[i]);
      // 行数据列表
      rowsList.add(
        Container(
          margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.0,
                color: Color.fromRGBO(224, 224, 224, 1),
              ),
            ),
          ),
          child: Column(
            children: [
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.1,
                    child: widget.showCheckboxColumn
                        ? _initTableRowsItemCheckbox(wmsRecordBloc)
                        : Container(
                            height: widget.columnsHeight,
                          ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.79,
                    child: _initTableRowsItemTitle(wmsRecordBloc),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.1,
                    child: widget.operatePopupOptions.length > 0
                        ? _initTableRowsItemOperate(wmsRecordBloc)
                        : Container(
                            height: widget.columnsHeight,
                          ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  children: _initTableRowsBody(wmsRecordBloc),
                ),
              ),
            ],
          ),
        ),
      );
    }
    // 返回
    return rowsList;
  }

  // 初始化表格行数据单条复选框
  Widget _initTableRowsItemCheckbox(WmsRecordBloc wmsRecordBloc) {
    return BlocBuilder<WmsRecordBloc, WmsRecordModel>(
      bloc: wmsRecordBloc,
      builder: (context, state) => Container(
        height: widget.columnsHeight,
        child: Checkbox(
          value: state.checked,
          activeColor: Color.fromRGBO(44, 167, 176, 1),
          onChanged: (value) {
            wmsRecordBloc.add(CheckRecordEvent(value!));
          },
        ),
      ),
    );
  }

  // 初始化表格行数据单条标题
  Widget _initTableRowsItemTitle(WmsRecordBloc wmsRecordBloc) {
    // 显示值
    final String value;
    // 判断表中是否存在
    if (widget.headTitle != '' &&
        wmsRecordBloc.state.data[widget.headTitle] != null) {
      // 显示值
      value = wmsRecordBloc.state.data[widget.headTitle].toString();
    } else {
      // 显示值
      value = '';
    }
    return BlocBuilder<WmsRecordBloc, WmsRecordModel>(
      bloc: wmsRecordBloc,
      builder: (context, state) => Container(
        padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
        height: widget.columnsHeight,
        child: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: state.checked
                ? Color.fromRGBO(44, 167, 176, 1)
                : Color.fromRGBO(6, 14, 15, 1),
            height: 2.4,
            decoration: TextDecoration.none,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // 初始化表格行数据单条操作
  Widget _initTableRowsItemOperate(WmsRecordBloc wmsRecordBloc) {
    return BlocBuilder<WmsRecordBloc, WmsRecordModel>(
      bloc: wmsRecordBloc,
      builder: (context, state) => GestureDetector(
        onPanDown: (details) {
          // 初始化表格行数据单条操作弹窗
          _initTableRowsItemOperatePopup(context, wmsRecordBloc,
              details.globalPosition.dx, details.globalPosition.dy);
        },
        child: Container(
          height: widget.columnsHeight,
          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Image.asset(
            WMSICons.INSTRUCTION_INPUT_TABLE_MORE,
            width: 18,
            height: 18,
          ),
        ),
      ),
    );
  }

  // 初始化表格行数据单条操作弹窗
  _initTableRowsItemOperatePopup(
      BuildContext context, WmsRecordBloc wmsRecordBloc, double dx, double dy) {
    showDialog(
      context: context,
      barrierColor: Color.fromRGBO(255, 255, 255, 0),
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: BlocProvider<WmsRecordBloc>(
            create: (context) => wmsRecordBloc,
            child: Stack(
              children: [
                Positioned(
                  top: dy - 32,
                  left: dx - 126,
                  child: Container(
                    width: 148,
                    height: widget.operatePopupHeight,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: 148,
                            padding: EdgeInsets.fromLTRB(0, 22, 0, 22),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(156, 156, 156, 0.36),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              children: _initTableRowsItemOperatePopupItem(
                                wmsRecordBloc,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              // 关闭
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(44, 167, 176, 1),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Image.asset(
                                  WMSICons.INSTRUCTION_INPUT_TABLE_CLOSE,
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 初始化表格行数据单条操作弹窗单条
  List<Widget> _initTableRowsItemOperatePopupItem(WmsRecordBloc wmsRecordBloc) {
    // 表格行数据单条操作弹窗单条列表
    List<Widget> tableRowsItemOperatePopupItemList = [];
    // 循环操作弹窗选项
    for (int i = 0; i < widget.operatePopupOptions.length; i++) {
      // 表格行数据单条操作弹窗单条列表
      tableRowsItemOperatePopupItemList.add(
        BlocBuilder<WmsRecordBloc, WmsRecordModel>(
          builder: (context, state) => GestureDetector(
            onTap: () {
              // 关闭
              Navigator.pop(context);
              if (widget.operatePopupOptions[i]['callback'] != null) {
                widget.operatePopupOptions[i]['callback'](context, state.data);
              }
            },
            child: Container(
              width: 148,
              height: 37,
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                widget.operatePopupOptions[i]['title'],
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(44, 167, 176, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      );
    }
    // 表格行数据单条操作弹窗单条列表
    return tableRowsItemOperatePopupItemList;
  }

  // 初始化表格行数据主体
  List<Widget> _initTableRowsBody(WmsRecordBloc wmsRecordBloc) {
    // 内容列表
    List<Widget> contentList = [];
    // 循环列数据
    for (int i = 0; i < widget.columns.length; i++) {
      // 显示值
      final String value;
      // 判断表中是否存在
      if (wmsRecordBloc.state.data[widget.columns[i]['key']] != null) {
        // 显示值
        value = wmsRecordBloc.state.data[widget.columns[i]['key']].toString();
      } else {
        // 显示值
        value = '';
      }
      // 内容列表
      contentList.add(
        BlocBuilder<WmsRecordBloc, WmsRecordModel>(
          bloc: wmsRecordBloc,
          builder: (context, state) => FractionallySizedBox(
            widthFactor: widget.columns[i]['width'],
            child: Container(
              height: widget.columnsHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.columns[i]['title'],
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                      color: state.checked
                          ? Color.fromRGBO(44, 167, 176, 1)
                          : Color.fromRGBO(156, 156, 156, 1),
                      decoration: TextDecoration.none,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: state.checked
                          ? Color.fromRGBO(44, 167, 176, 1)
                          : Color.fromRGBO(6, 14, 15, 1),
                      height: 1.5,
                      decoration: TextDecoration.none,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    // 返回
    return contentList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      builder: (context, state) {
        return Column(
          children: _initTableRows(state),
        );
      },
    );
  }
}
