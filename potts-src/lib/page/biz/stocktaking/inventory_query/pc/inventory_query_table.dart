import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../bloc/inventory_query_bloc.dart';
import '../bloc/inventory_query_model.dart';

/**
 * 内容：棚卸照会 -文件
 * 作者：熊草云
 * 时间：2023/08/29
 */
class InventoryQueryTable extends StatefulWidget {
  const InventoryQueryTable({super.key});

  @override
  State<InventoryQueryTable> createState() => _InventoryQueryTableState();
}

class _InventoryQueryTableState extends State<InventoryQueryTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 40, 20, 80),
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: InventoryQueryTableTab(),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: InventoryQueryTableContent(),
            ),
          ),
        ],
      ),
    );
  }
}

// 棚卸照会-表格Tab
class InventoryQueryTableTab extends StatefulWidget {
  InventoryQueryTableTab({super.key});

  @override
  State<InventoryQueryTableTab> createState() => _InventoryQueryTableTabState();
}

class _InventoryQueryTableTabState extends State<InventoryQueryTableTab> {
  // 当前下标
  int currentIndex = Config.NUMBER_ZERO;
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        GestureDetector(
          onPanDown: (details) {
            // 检索Tab事件
            context
                .read<InventoryQueryBloc>()
                .add(SearchTabEvent(tabItemList[i]['index']));
            // 状态变更
            setState(() {
              // 当前下标
              currentIndex = tabItemList[i]['index'];
            });
          },
          child: Container(
            height: 46,
            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
            decoration: BoxDecoration(
              color: tabItemList[i]['index'] == currentIndex
                  ? Color.fromRGBO(44, 167, 176, 1)
                  : Color.fromRGBO(245, 245, 245, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            constraints: BoxConstraints(
              minWidth: 158,
            ),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              onPressed: () {},
              hoverColor: Color.fromRGBO(44, 167, 176, .6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tabItemList[i]['title'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: tabItemList[i]['index'] == currentIndex
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(6, 14, 15, 1),
                      height: 1.0,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    height: 24,
                    width: 32,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        tabItemList[i]['index'] == Config.NUMBER_ZERO
                            ? context
                                .read<InventoryQueryBloc>()
                                .state
                                .sum1
                                .toString()
                            : tabItemList[i]['index'] == Config.NUMBER_ONE
                                ? context
                                    .read<InventoryQueryBloc>()
                                    .state
                                    .sum2
                                    .toString()
                                : tabItemList[i]['index'] == Config.NUMBER_TWO
                                    ? context
                                        .read<InventoryQueryBloc>()
                                        .state
                                        .sum3
                                        .toString()
                                    : '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(44, 167, 176, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    // Tab列表
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    // Tab单个列表
    List _tabItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.inventory_query_in_progress,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!.inventory_query_confirmed,
      },
      {
        'index': Config.NUMBER_TWO,
        'title': WMSLocalizations.i18n(context)!.delivery_note_22,
      },
    ];
    return BlocBuilder<InventoryQueryBloc, InventoryQueryModel>(
      builder: (context, state) {
        return Row(
          children: _initTabList(_tabItemList),
        );
      },
    );
  }
}

//棚卸照会-表格内容
class InventoryQueryTableContent extends StatefulWidget {
  const InventoryQueryTableContent({super.key});

  @override
  State<InventoryQueryTableContent> createState() =>
      _InventoryQueryTableContentState();
}

class _InventoryQueryTableContentState
    extends State<InventoryQueryTableContent> {
  // 删除弹窗
  _showDetailDialog(value) {
    InventoryQueryBloc bloc = context.read<InventoryQueryBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<InventoryQueryBloc>.value(
          value: bloc,
          child: BlocBuilder<InventoryQueryBloc, InventoryQueryModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .display_instruction_confirm_delete,
                contentText:
                    "${WMSLocalizations.i18n(context)!.inventory_query_id}：${value['id']}${WMSLocalizations.i18n(context)!.display_instruction_delete}",
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                buttonRightText:
                    WMSLocalizations.i18n(context)!.delivery_note_10,
                onPressedLeft: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                },
                onPressedRight: () {
                  // 删除事件
                  context
                      .read<InventoryQueryBloc>()
                      .add(DeleteEvent(context, value));
                },
              );
            },
          ),
        );
      },
    );
  }

  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, InventoryQueryModel state) {
    List<DropdownMenuItem<String>> getListData() {
      List<DropdownMenuItem<String>> items = [];
      DropdownMenuItem<String> dropdownMenuItem1 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.inventory_query_id,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'id',
      );
      items.add(dropdownMenuItem1);
      DropdownMenuItem<String> dropdownMenuItem2 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.start_inventory_date,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'start_date',
      );
      items.add(dropdownMenuItem2);
      return items;
    }

    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      if (buttonItemList[i]['sort']) {
        buttonList.add(
          Container(
            child: Row(
              children: [
                Container(
                  height: 37,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: state.sortCol,
                            isExpanded: true, // 使 DropdownButton 填满宽度
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ),
                            items: getListData(),
                            onChanged: (String? newValue) {
                              setState(() {
                                state.sortCol = newValue!;
                                context.read<InventoryQueryBloc>().add(
                                    SetSortEvent(
                                        state.sortCol, state.ascendingFlg));
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 70, // 设置 Switch 的宽度
                  height: 37, // 设置 Switch 的高度
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CupertinoSwitch(
                        value: state.ascendingFlg,
                        onChanged: (bool value) {
                          setState(() {
                            state.ascendingFlg = !state.ascendingFlg;
                            context.read<InventoryQueryBloc>().add(SetSortEvent(
                                state.sortCol, state.ascendingFlg));
                          });
                        },
                      ),
                      Positioned(
                        left: state.ascendingFlg ? 17 : null, // 开时文字在左侧
                        right: state.ascendingFlg ? null : 17, // 关时文字在右侧
                        child: Text(
                          state.ascendingFlg ? 'A' : 'D', // 根据开关状态显示文本
                          style: TextStyle(
                            color: Colors.black, // 设置文字颜色
                            fontSize: 14, // 设置字体大小
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {}
    }
    // 按钮列表
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryQueryBloc, InventoryQueryModel>(
      builder: (context, state) {
        // 左侧按钮单个列表
        List _buttonLeftItemList = [
          {
            'index': Config.NUMBER_THREE,
            'title': WMSLocalizations.i18n(context)!.table_sort_column,
            'sort': true,
          },
        ];
        return Column(
          children: [
            Container(
              height: 37,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
              child: Stack(
                children: [
                  Container(
                    child: Row(
                      children: _initButtonLeftList(_buttonLeftItemList, state),
                    ),
                  ),
                ],
              ),
            ),
            WMSTableWidget<InventoryQueryBloc, InventoryQueryModel>(
              //表头
              columns: [
                // 棚卸ID
                {
                  'key': 'id',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!.inventory_query_id,
                },
                // 倉庫
                {
                  'key': 'warehouse_name',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!
                      .home_main_page_table_text3,
                },
                // 棚卸日
                {
                  'key': 'start_date',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!.start_inventory_date,
                },
                // 入力完了数
                {
                  'key': 'total_end_num',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!
                      .inventory_query_completed_number,
                },
                // 合計数
                {
                  'key': 'total_logic_num',
                  'width': 3,
                  'title':
                      WMSLocalizations.i18n(context)!.shipment_inspection_sum,
                },
                // 差異数
                {
                  'key': 'total_diff_num',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!
                      .inventory_query_different_number,
                },
                // 状態
                {
                  'key': 'confirm_name',
                  'width': 3,
                  'title':
                      WMSLocalizations.i18n(context)!.account_profile_state,
                },
              ],
              showCheckboxColumn: true,
              operatePopupOptions: [
                {
                  'title': WMSLocalizations.i18n(context)!.delivery_note_8,
                  'callback': (_, value) {
                    // 查询出荷指示明细事件
                    context.go('/' +
                        Config.PAGE_FLAG_5_9 +
                        '/details/' +
                        value['id'].toString());
                  },
                },
                {
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_operate_delete,
                  'callback': (_, value) {
                    // 删除
                    _showDetailDialog(value);
                  },
                }
              ],
            ),
          ],
        );
      },
    );
  }
}
