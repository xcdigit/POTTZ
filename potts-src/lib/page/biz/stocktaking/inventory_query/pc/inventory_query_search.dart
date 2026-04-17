import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../widget/wms_date_widget.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../bloc/inventory_query_bloc.dart';
import '../bloc/inventory_query_model.dart';

/**
 * 内容：棚卸照会 -文件
 * 作者：熊草云
 * 时间：2023/08/29
 */
class InventoryQuerySearch extends StatefulWidget {
  const InventoryQuerySearch({super.key});

  @override
  State<InventoryQuerySearch> createState() => _InventoryQuerySearchState();
}

class _InventoryQuerySearchState extends State<InventoryQuerySearch> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryQueryBloc, InventoryQueryModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                height: 48,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                margin: EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: OutlinedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                      BorderSide(
                        color: Color.fromRGBO(44, 167, 176, 1),
                      ),
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(44, 167, 176, 1),
                    ), // 设置文本颜色
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(120, 48)), // 设置按钮宽度和高度
                  ),
                  child: Text(WMSLocalizations.i18n(context)!.menu_content_5_1),
                  onPressed: () {
                    context.go('/page_flag_5_1');
                  },
                ),
              ),
              Container(
                height: 80,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(WMSLocalizations.i18n(context)!
                                .Inventory_Confirmed_Search_1),
                            Row(
                              children: [
                                Expanded(
                                  flex: 11,
                                  child: WMSDateWidget(
                                    text: state.queryStartDate,
                                    dateCallBack: (value) {
                                      // 检索日期事件
                                      context.read<InventoryQueryBloc>().add(
                                          SearchDateEvent(
                                              Config.NUMBER_ONE, value));
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("~"),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 11,
                                  child: WMSDateWidget(
                                    text: state.queryOverDate,
                                    dateCallBack: (value) {
                                      // 检索日期事件
                                      context.read<InventoryQueryBloc>().add(
                                          SearchDateEvent(
                                              Config.NUMBER_TWO, value));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(WMSLocalizations.i18n(context)!
                                .Inventory_Confirmed_Search_2),
                            WMSDropdownWidget(
                              dataList1: state.warehouseList,
                              inputInitialValue:
                                  state.queryWarehouseValue.toString(),
                              inputRadius: 4,
                              inputSuffixIcon: Container(
                                width: 24,
                                height: 24,
                                margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                ),
                              ),
                              inputFontSize: 14,
                              dropdownRadius: 4,
                              dropdownTitle: 'name',
                              dropdownKey: 'name',
                              selectedCallBack: (value) {
                                // 判断数值
                                if (value == '') {
                                  // 检索下拉事件
                                  context.read<InventoryQueryBloc>().add(
                                      SearchDropEvent(
                                          value, Config.NUMBER_NEGATIVE));
                                } else {
                                  // 检索下拉事件
                                  context.read<InventoryQueryBloc>().add(
                                      SearchDropEvent(
                                          value["name"], value["id"]));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(""),
                            Container(
                              width: 200,
                              height: 48,
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: WMSColors.textWhite,
                                  side: BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(44, 167, 176, 1),
                                  ),
                                ),
                                onPressed: () {
                                  // 查询检索事件
                                  context
                                      .read<InventoryQueryBloc>()
                                      .add(QuerySearchEvent());
                                },
                                child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .Inventory_Confirmed_Search_3,
                                  style: TextStyle(
                                    color: Color.fromRGBO(44, 167, 176, 1),
                                    fontSize: 14,
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
            ],
          ),
        );
      },
    );
  }
}
