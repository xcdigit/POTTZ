import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/widget/table/pc/wms_table_paging.dart';

import '../../../common/localization/default_localizations.dart';
import 'wms_table_body.dart';
import '../bloc/wms_table_model.dart';
import '../bloc/wms_table_bloc.dart';

/**
 * 内容：表格共通
 * 作者：赵士淞
 * 时间：2023/08/18
 */
class WMSTableWidget<B extends WmsTableBloc<S>, S extends WmsTableModel>
    extends StatelessWidget {
  // 列数据
  final List columns;
  // 显示复选框列
  final bool showCheckboxColumn;
  // 操作弹窗选项
  final List operatePopupOptions;
  // 操作弹窗高度
  final double operatePopupHeight;
  // 是否存在分页组件
  final bool needPageInfo;
  // 是否是flex布局
  final bool isFlex;
  //行高度
  final double columnsHeight;

  const WMSTableWidget({
    required this.columns,
    this.showCheckboxColumn = true,
    this.operatePopupOptions = const <List>[],
    this.operatePopupHeight = 134,
    this.isFlex = true,
    this.needPageInfo = true,
    this.columnsHeight = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(builder: (context, S state) {
      return Column(
        children: [
          WmsTableBody<B, S>(
            columns,
            isFlex: isFlex,
            showCheckboxColumn: showCheckboxColumn,
            operatePopupOptions: state.operatePopupOptions.length != 0
                ? state.operatePopupOptions
                : operatePopupOptions,
            operatePopupHeight: state.operatePopupHeight != 134
                ? state.operatePopupHeight
                : operatePopupHeight,
            columnsHeight: columnsHeight,
          ),
          state.records.length == 0
              ? Container(
                  height: 96,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        WMSLocalizations.i18n(context)!.no_items_found,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(6, 14, 15, 1),
                          height: 2.4,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          this.needPageInfo ? WmsPageManger<B>() : Container(),
        ],
      );
    });
  }
}
