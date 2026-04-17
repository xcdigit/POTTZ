import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/style/wms_style.dart';
import '../../wms_tooltip_widget.dart';
import '../bloc/wms_record_bloc.dart';
import '../bloc/wms_record_model.dart';

class WmsTableRecordBuilder {
  final bool showCheckboxColumn;
  final List columns;
  final List operatePopupOptions;
  final double operatePopupHeight;
  final double columnsHeight;

  const WmsTableRecordBuilder({
    required this.columns,
    this.showCheckboxColumn = true,
    this.operatePopupOptions = const <List>[],
    this.operatePopupHeight = 0,
    this.columnsHeight = 48.0,
  });

  TableRow buildAll(WmsRecordBloc wmsRecordBloc) {
    return TableRow(
      children: _initTableRowsItemAll(wmsRecordBloc),
    );
  }

  TableRow buildData(WmsRecordBloc wmsRecordBloc) {
    return TableRow(
      children: _initTableRowsItem(wmsRecordBloc),
    );
  }

  TableRow buildCheckBox(WmsRecordBloc wmsRecordBloc) {
    return TableRow(
      children: [
        _initTableRowsItemCheckbox(wmsRecordBloc),
      ],
    );
  }

  TableRow buildItemOperate(WmsRecordBloc wmsRecordBloc) {
    return TableRow(
      children: [
        _initTableRowsItemOperate(wmsRecordBloc),
      ],
    );
  }

  List<Widget> _initTableRowsItemAll(WmsRecordBloc wmsRecordBloc) {
    // 表格行数据单条列表
    List<Widget> tableRowsItemList = [];
    // 是否包含复选框
    if (showCheckboxColumn) {
      tableRowsItemList.add(_initTableRowsItemCheckbox(wmsRecordBloc));
    }
    tableRowsItemList.addAll(_initTableRowsItem(wmsRecordBloc));
    if (operatePopupOptions.length > 0) {
      tableRowsItemList.add(_initTableRowsItemOperate(wmsRecordBloc));
    }
    return tableRowsItemList;
  }

  // 初始化表格行数据单条
  List<Widget> _initTableRowsItem(WmsRecordBloc wmsRecordBloc) {
    // 表格行数据单条列表
    List<Widget> tableRowsItemList = [];
    // 循环列数据
    for (int i = 0; i < columns.length; i++) {
      // 获取数据的显示值
      final String value;
      // 表中存在的场合
      if (wmsRecordBloc.state.data[columns[i]['key']] != null) {
        value = wmsRecordBloc.state.data[columns[i]['key']].toString();
        // 表中不存在的场合
      } else {
        value = '';
      }
      tableRowsItemList.add(
        BlocBuilder<WmsRecordBloc, WmsRecordModel>(
          bloc: wmsRecordBloc,
          builder: (context, state) => Container(
            height: columnsHeight,
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: WMSTooltipWidget(
              message: value,
              child: Text(
                value,
                maxLines: 1,
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
          ),
        ),
      );
    }
    // 表格行数据单条列表
    return tableRowsItemList;
  }

  // 初始化表格行数据单条复选框
  Widget _initTableRowsItemCheckbox(WmsRecordBloc wmsRecordBloc) {
    return BlocBuilder<WmsRecordBloc, WmsRecordModel>(
      bloc: wmsRecordBloc,
      builder: (context, state) => Container(
        height: columnsHeight,
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
          height: columnsHeight,
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
                  top: dy - 14,
                  left: dx - 126,
                  child: Container(
                    width: 148,
                    height: operatePopupHeight,
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
                                  wmsRecordBloc),
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
    for (int i = 0; i < operatePopupOptions.length; i++) {
      // 表格行数据单条操作弹窗单条列表
      tableRowsItemOperatePopupItemList
          .add(BlocBuilder<WmsRecordBloc, WmsRecordModel>(
        builder: (context, state) => GestureDetector(
          onTap: () {
            Navigator.pop(context);
            if (operatePopupOptions[i]['callback'] != null) {
              operatePopupOptions[i]['callback'](context, state.data);
            }
            // 关闭
          },
          child: Container(
            width: 148,
            height: 37,
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              operatePopupOptions[i]['title'],
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
      ));
    }
    // 表格行数据单条操作弹窗单条列表
    return tableRowsItemOperatePopupItemList;
  }
}
