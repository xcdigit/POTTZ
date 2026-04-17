import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/widget/table/pc/wms_table_record.dart';

import '../../../common/localization/default_localizations.dart';
import '../bloc/wms_record_bloc.dart';
import '../bloc/wms_table_bloc.dart';
import '../bloc/wms_table_model.dart';

class WmsTableBody<B extends WmsTableBloc<S>, S extends WmsTableModel>
    extends StatefulWidget {
  // 列数据
  final List<dynamic> columns;
  final bool isFlex;
  // 显示复选框列
  final bool showCheckboxColumn;
  // 操作弹窗选项
  final List operatePopupOptions;
  // 操作弹窗高度
  final double operatePopupHeight;
  // 记录构建器
  final WmsTableRecordBuilder wmsTableRecordBuilder;
  //行高度
  final double columnsHeight;

  WmsTableBody(
    this.columns, {
    Key? key,
    this.isFlex = true,
    this.showCheckboxColumn = true,
    this.operatePopupOptions = const <List>[],
    this.operatePopupHeight = 134,
    this.columnsHeight = 48.0,
  })  : wmsTableRecordBuilder = WmsTableRecordBuilder(
            columns: columns,
            showCheckboxColumn: showCheckboxColumn,
            operatePopupOptions: operatePopupOptions,
            operatePopupHeight: operatePopupHeight,
            columnsHeight: columnsHeight),
        super(key: key);

  @override
  State<WmsTableBody<B, S>> createState() => _WmsTableBodyState<B, S>();
}

class _WmsTableBodyState<B extends WmsTableBloc<S>, S extends WmsTableModel>
    extends State<WmsTableBody<B, S>> {
  // 初始化列宽度
  Map<int, TableColumnWidth> _initColumnWidths(List rows) {
    int index = 0;
    // 列宽度集合
    Map<int, TableColumnWidth> columnWidthsMap = {};
    // 判断显示复选框列
    if (widget.showCheckboxColumn) {
      // 宽数据单条
      final columnWidthsItem = <int, TableColumnWidth>{
        index++: FlexColumnWidth(1)
      };
      // 列宽度集合
      columnWidthsMap.addEntries(columnWidthsItem.entries);
    }
    for (int i = 0; i < widget.columns.length; i++) {
      // 宽数据单条
      final columnWidthsItem = <int, TableColumnWidth>{
        index++: FlexColumnWidth(
            widget.columns[i]['width'] != null ? widget.columns[i]['width'] : 2)
      };
      // 列宽度集合
      columnWidthsMap.addEntries(columnWidthsItem.entries);
    }
    // 判断显示操作列
    if (widget.operatePopupOptions.length > 0) {
      // 宽数据单条
      final columnWidthsItem = <int, TableColumnWidth>{
        index++: FixedColumnWidth(40)
      };
      // 列宽度集合
      columnWidthsMap.addEntries(columnWidthsItem.entries);
    }
    // 列宽度集合
    return columnWidthsMap;
  }

  // 初始化表头
  TableRow _initTitle() {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(224, 224, 224, 1),
          ),
        ),
      ),
      children: _initTitleColumns(),
    );
  }

  // 初始化表格列数据
  List<Widget> _initTitleColumns() {
    // 表格列数据列表
    List<Widget> tableColumnsList = [];
    // 判断显示复选框列
    if (widget.showCheckboxColumn) {
      // 表格列数据列表
      tableColumnsList.add(
        Container(
          height: 32,
        ),
      );
    }
    // 循环列数据
    for (int i = 0; i < widget.columns.length; i++) {
      // 表格列数据列表
      tableColumnsList.add(
        Container(
          height: 32,
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Text(
            widget.columns[i]['title'],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(156, 156, 156, 1),
              height: 2.0,
            ),
          ),
        ),
      );
    }
    // 判断显示操作列
    if (widget.operatePopupOptions.length > 0) {
      // 表格列数据列表
      tableColumnsList.add(
        Container(
          height: 32,
          child: Text(
            WMSLocalizations.i18n(context)!.delivery_note_32,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(156, 156, 156, 1),
              height: 2.0,
            ),
          ),
        ),
      );
    }
    // 表格列数据列表
    return tableColumnsList;
  }

  // 初始化表格
  List<TableRow> _initTable(List rows) {
    // 表格列表
    List<TableRow> tableRowList = [];
    // 添加表头
    tableRowList.add(_initTitle());
    // 添加内容
    tableRowList.addAll(_initTableRows(rows));
    // 表格列表
    return tableRowList;
  }

  List<TableRow> _initTableRows(List rows) {
    List<TableRow> tableRowsList = [];
    for (int i = 0; i < rows.length; i++) {
      // 表格行数据列表
      WmsRecordBloc wmsRecordBloc = WmsRecordBloc(rows[i]);
      tableRowsList.add(widget.wmsTableRecordBuilder.buildAll(wmsRecordBloc));
    }
    return tableRowsList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(builder: (context, state) {
      if (widget.isFlex) {
        return Table(
          columnWidths: _initColumnWidths(state.records),
          children: _initTable(state.records),
        );
      }

      // CheckBox列宽度
      Map<int, TableColumnWidth> checkBoxWidthMap =
          Map.from(<int, TableColumnWidth>{0: FixedColumnWidth(20)});
      // 列宽度集合
      Map<int, TableColumnWidth> columnWidthsMap = {};
      for (int i = 0; i < widget.columns.length; i++) {
        // 宽数据单条
        final columnWidthsItem = <int, TableColumnWidth>{
          i: FixedColumnWidth(widget.columns[i]['width'] != null
              ? widget.columns[i]['width']
              : 50)
        };
        // 列宽度集合
        columnWidthsMap.addEntries(columnWidthsItem.entries);
      }
      // 行操作列宽度
      Map<int, TableColumnWidth> itemOperateWidthMap =
          Map.from(<int, TableColumnWidth>{0: FixedColumnWidth(20)});

      // 复选框列
      List<TableRow> checkBoxRows = [];
      // 表头
      checkBoxRows.add(
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(224, 224, 224, 1),
              ),
            ),
          ),
          children: [
            Container(
              height: 32,
            )
          ],
        ),
      );
      // 数据列
      List<TableRow> columnRows = [];
      List<Widget> children = [];
      // 循环列数据
      for (int i = 0; i < widget.columns.length; i++) {
        // 表格列数据列表
        children.add(
          Container(
            height: 32,
            child: Text(
              widget.columns[i]['title'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(156, 156, 156, 1),
                height: 2.0,
              ),
            ),
          ),
        );
      }
      columnRows.add(
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(224, 224, 224, 1),
              ),
            ),
          ),
          children: children,
        ),
      );
      // 操作列
      List<TableRow> itemOperateRows = [];
      itemOperateRows.add(
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(224, 224, 224, 1),
              ),
            ),
          ),
          children: [
            Container(
              height: 32,
              child: Text(
                WMSLocalizations.i18n(context)!.delivery_note_32,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(156, 156, 156, 1),
                  height: 2.0,
                ),
              ),
            ),
          ],
        ),
      );

      for (int i = 0; i < state.records.length; i++) {
        WmsRecordBloc wmsRecordBloc = WmsRecordBloc(state.records[i]);
        // 复选框
        checkBoxRows
            .add(widget.wmsTableRecordBuilder.buildCheckBox(wmsRecordBloc));
        // 数据列
        columnRows.add(widget.wmsTableRecordBuilder.buildData(wmsRecordBloc));
        // 操作列
        itemOperateRows
            .add(widget.wmsTableRecordBuilder.buildItemOperate(wmsRecordBloc));
      }
      return Container(
        child: Row(
          children: <Widget>[
            widget.showCheckboxColumn
                ? Container(
                    child: Table(
                      columnWidths: checkBoxWidthMap,
                      children: checkBoxRows,
                    ),
                    width: 40.0, //固定第一列
                  )
                : Container(),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  child: Table(
                    columnWidths: columnWidthsMap,
                    children: columnRows,
                  ),
                ),
              ),
            ),
            widget.operatePopupOptions.length > 0
                ? Container(
                    child: Table(
                      columnWidths: itemOperateWidthMap,
                      children: itemOperateRows,
                    ),
                    width: 40.0, //固定第一列
                  )
                : Container(),
          ],
        ),
      );
    });
  }
}
