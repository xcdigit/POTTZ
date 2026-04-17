import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../widget/wms_date_widget.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../../../../home/bloc/home_menu_bloc.dart';
import '../../../../home/bloc/home_menu_model.dart';
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
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
      builder: (menuBloc, menuState) {
        return BlocBuilder<InventoryQueryBloc, InventoryQueryModel>(
          builder: (context, state) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 48,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
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
                      child: Text(
                          WMSLocalizations.i18n(context)!.menu_content_5_1),
                      onPressed: () {
                        //设定显示标题
                        menuBloc
                            .read<HomeMenuBloc>()
                            .add(SPPageJumpEvent('/' + Config.PAGE_FLAG_5_1));
                        context.go('/page_flag_5_1');
                      },
                    ),
                  ),
                  Container(
                    child: Wrap(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Wrap(
                              children: [
                                FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Container(
                                    height: 24,
                                    child: Text(WMSLocalizations.i18n(context)!
                                        .Inventory_Confirmed_Search_1),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: .45,
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
                                FractionallySizedBox(
                                  widthFactor: .1,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 16),
                                    alignment: Alignment.center,
                                    child: Text("~"),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: .45,
                                  child: WMSDateWidget(
                                    text: state.queryOverDate,
                                    dateCallBack: (value) {
                                      // 检索日期事件
                                      context.read<InventoryQueryBloc>().add(
                                            SearchDateEvent(
                                                Config.NUMBER_TWO, value),
                                          );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 24,
                                  child: Text(WMSLocalizations.i18n(context)!
                                      .Inventory_Confirmed_Search_2),
                                ),
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
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: double.infinity,
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
      },
    );
  }
}
