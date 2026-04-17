import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../bloc/inventory_query_detail_bloc.dart';
import '../bloc/inventory_query_detail_model.dart';

/**
 * 内容：棚卸照会-表格
 * 作者：熊草云
 * 时间：2023/08/29
 * 作者：赵士淞
 * 时间：2023/10/26
 */
class InventoryQueryDetailTable extends StatefulWidget {
  const InventoryQueryDetailTable({super.key});

  @override
  State<InventoryQueryDetailTable> createState() =>
      _InventoryQueryDetailTableState();
}

class _InventoryQueryDetailTableState extends State<InventoryQueryDetailTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 50, 0, 50),
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: InventoryQueryDetailTableTab(),
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
              child: InventoryQueryDetailTableContent(),
            ),
          ),
        ],
      ),
    );
  }
}

// 棚卸照会-表格Tab
class InventoryQueryDetailTableTab extends StatefulWidget {
  const InventoryQueryDetailTableTab({super.key});

  @override
  State<InventoryQueryDetailTableTab> createState() =>
      _InventoryQueryDetailTableTabState();
}

class _InventoryQueryDetailTableTabState
    extends State<InventoryQueryDetailTableTab> {
  // 当前悬停下标
  int _currentHoverIndex = Config.NUMBER_NEGATIVE;

  // 初始化Tab列表
  List<Widget> _initTabList(List tabItemList, InventoryQueryDetailModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        MouseRegion(
          onEnter: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              _currentHoverIndex = tabItemList[i]['index'];
            });
          },
          onExit: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              _currentHoverIndex = Config.NUMBER_NEGATIVE;
            });
          },
          child: GestureDetector(
            onPanDown: (details) {
              // 表格Tab切换事件
              context
                  .read<InventoryQueryDetailBloc>()
                  .add(TableTabSwitchEvent(tabItemList[i]['index']));
            },
            child: Container(
              height: 46,
              padding: EdgeInsets.fromLTRB(12, 11, 12, 11),
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              decoration: BoxDecoration(
                color: state.tableTabIndex == tabItemList[i]['index']
                    ? Color.fromRGBO(44, 167, 176, 1)
                    : _currentHoverIndex == tabItemList[i]['index']
                        ? Color.fromRGBO(44, 167, 176, 0.6)
                        : Color.fromRGBO(245, 245, 245, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              constraints: BoxConstraints(
                minWidth: 158,
              ),
              child: Stack(
                children: [
                  Text(
                    tabItemList[i]['title'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: state.tableTabIndex == tabItemList[i]['index']
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : _currentHoverIndex == tabItemList[i]['index']
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(6, 14, 15, 1),
                      height: 1.5,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      height: 24,
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          tabItemList[i]['number'].toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
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
    return BlocBuilder<InventoryQueryDetailBloc, InventoryQueryDetailModel>(
      builder: (context, state) {
        // Tab单个列表
        List _tabItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'title': WMSLocalizations.i18n(context)!.instruction_input_tab_list,
            'number': state.total,
          },
        ];

        return Row(
          children: _initTabList(_tabItemList, state),
        );
      },
    );
  }
}

// 棚卸照会-表格内容
class InventoryQueryDetailTableContent extends StatefulWidget {
  const InventoryQueryDetailTableContent({super.key});

  @override
  State<InventoryQueryDetailTableContent> createState() =>
      _InventoryQueryDetailTableContentState();
}

class _InventoryQueryDetailTableContentState
    extends State<InventoryQueryDetailTableContent> {
  // 当前悬停下标
  int _currentHoverIndex = Config.NUMBER_NEGATIVE;

  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        GestureDetector(
          onTap: () {
            // 判断循环下标
            if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
              // 全部选择
              context
                  .read<InventoryQueryDetailBloc>()
                  .add(RecordCheckAllEvent(true));
            } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
              // 全部取消
              context
                  .read<InventoryQueryDetailBloc>()
                  .add(RecordCheckAllEvent(false));
            } else {}
          },
          child: Container(
            height: 37,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(224, 224, 224, 1),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              buttonItemList[i]['title'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(44, 167, 176, 1),
              ),
            ),
          ),
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList, InventoryQueryDetailModel state) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        MouseRegion(
          onEnter: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              _currentHoverIndex = buttonItemList[i]['index'];
            });
          },
          onExit: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              _currentHoverIndex = Config.NUMBER_NEGATIVE;
            });
          },
          child: GestureDetector(
            onTap: () {
              // 判断循环下标
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                // 判断表格选中列表数量
                if (state.checkedRecords().length > 0) {
                  // 内容列表
                  List<Map<String, dynamic>> contentList = [];
                  // 表格选中列表
                  List<WmsRecordModel> wmsRecordModelList =
                      state.checkedRecords();
                  // 循环表格选中列表
                  for (int i = 0; i < wmsRecordModelList.length; i++) {
                    // 内容列表
                    contentList.add(wmsRecordModelList[i].data);
                  }
                  // 导入CSV文件
                  WMSCommonFile().exportCSVFile([
                    'id',
                    'product_name',
                    'location_loc_cd',
                    'real_num',
                    'logic_num',
                    'diff_num',
                    'diff_reason'
                  ], contentList, '棚卸明細');
                } else {
                  // 错误提示
                  WMSCommonBlocUtils.errorTextToast(
                      WMSLocalizations.i18n(context)!
                          .Inventory_Confirmed_tip_1);
                  // // 提示弹框
                  // _showTipDialog(WMSLocalizations.i18n(context)!
                  //     .Inventory_Confirmed_tip_1);
                }
              }
            },
            child: Container(
              height: 37,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
              decoration: BoxDecoration(
                color: _currentHoverIndex == buttonItemList[i]['index']
                    ? Color.fromRGBO(0, 122, 255, .6)
                    : Colors.white,
                border: Border.all(
                  color: _currentHoverIndex == buttonItemList[i]['index']
                      ? Color.fromRGBO(0, 122, 255, .6)
                      : Color.fromRGBO(224, 224, 224, 1),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
                    child: Image.asset(
                      buttonItemList[i]['icon'],
                      width: 17,
                      height: 19.43,
                      color: _currentHoverIndex == buttonItemList[i]['index']
                          ? Colors.white
                          : Color.fromRGBO(0, 122, 255, 1),
                    ),
                  ),
                  Text(
                    buttonItemList[i]['title'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: _currentHoverIndex == buttonItemList[i]['index']
                          ? Colors.white
                          : Color.fromRGBO(0, 122, 255, 1),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  // 提示弹框
  _showTipDialog(text) {
    return showDialog(
      context: context,
      builder: (context) {
        return WMSDiaLogWidget(
          titleText: WMSLocalizations.i18n(context)!.menu_content_3_5,
          contentText: text,
          buttonLeftFlag: false,
          buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
          onPressedRight: () {
            // 关闭弹窗
            Navigator.pop(context);
          },
        );
      },
    );
  }

  // 删除弹窗
  _showDeleteDialog(value) {
    InventoryQueryDetailBloc bloc = context.read<InventoryQueryDetailBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<InventoryQueryDetailBloc>.value(
          value: bloc,
          child:
              BlocBuilder<InventoryQueryDetailBloc, InventoryQueryDetailModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .display_instruction_confirm_delete,
                contentText:
                    "${WMSLocalizations.i18n(context)!.inventory_query_Inventory_item_id}：${value['id']}${WMSLocalizations.i18n(context)!.display_instruction_delete}",
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                buttonRightText:
                    WMSLocalizations.i18n(context)!.delivery_note_10,
                onPressedLeft: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                },
                onPressedRight: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                  // 判断完成状态
                  if (state.inventoryInfo['confirm_flg'] ==
                      Config.CONFIRM_KBN_1) {
                    // 消息提示
                    WMSCommonBlocUtils.tipTextToast(
                        WMSLocalizations.i18n(context)!.inventory_query_tip_1);
                    return;
                  }
                  // 判断完成状态
                  if (value['end_kbn'] == Config.END_KBN_2) {
                    WMSCommonBlocUtils.tipTextToast(
                        WMSLocalizations.i18n(context)!.inventory_query_tip_2);
                    return;
                  }
                  // 删除事件
                  context
                      .read<InventoryQueryDetailBloc>()
                      .add(DeleteEvent(value['id']));
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryQueryDetailBloc, InventoryQueryDetailModel>(
      builder: (context, state) {
        // 左侧按钮单个列表
        List _buttonLeftItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'title': WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_choice,
          },
          {
            'index': Config.NUMBER_ONE,
            'title': WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_cancellation,
          },
        ];

        // 右侧按钮单个列表
        List _buttonRightItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'icon': WMSICons.WAREHOUSE_CSV_ICON,
            'title': WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_csv,
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
                      children: _initButtonLeftList(_buttonLeftItemList),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      child: Row(
                        children:
                            _initButtonRightList(_buttonRightItemList, state),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            WMSTableWidget<InventoryQueryDetailBloc, InventoryQueryDetailModel>(
              //表头
              columns: [
                // 棚卸明細ID
                {
                  'key': 'id',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!
                      .inventory_query_Inventory_item_id,
                },
                // 商品名
                {
                  'key': 'product_name',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!.delivery_note_20,
                },
                // ロケーションコード
                {
                  'key': 'location_loc_cd',
                  'width': 5,
                  'title':
                      WMSLocalizations.i18n(context)!.exit_input_table_title_3,
                },
                // 棚卸数量
                {
                  'key': 'real_num',
                  'width': 3,
                  'title':
                      WMSLocalizations.i18n(context)!.inventory_query_quantity,
                },
                // 在庫数量
                {
                  'key': 'logic_num',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!
                      .inventory_query_quantity_in_stock,
                },
                // 差異数量
                {
                  'key': 'diff_num',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!
                      .inventory_query_variance_quantity,
                },
                // 差異理由
                {
                  'key': 'diff_reason',
                  'width': 3,
                  'title':
                      WMSLocalizations.i18n(context)!.inventory_query_reason,
                },
              ],
              showCheckboxColumn: true,
              operatePopupOptions: [
                {
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_tab_button_update,
                  'callback': (_, value) {
                    // 判断完成状态
                    if (state.inventoryInfo['confirm_flg'] ==
                            Config.CONFIRM_KBN_1 ||
                        value['end_kbn'] == Config.END_KBN_2) {
                      // 消息提示
                      WMSCommonBlocUtils.tipTextToast(
                          WMSLocalizations.i18n(context)!.inventory_query_tip);
                      return;
                    }
                    // 跳转页面
                    GoRouter.of(context)
                        .push(
                      '/' +
                          Config.PAGE_FLAG_5_9 +
                          '/' +
                          'details/' +
                          state.detailId.toString() +
                          '/' +
                          Config.PAGE_FLAG_60_5_2 +
                          '/' +
                          value['id'].toString() +
                          '/' +
                          state.inventoryInfo['id'].toString() +
                          '/' +
                          Config.NUMBER_TWO.toString() +
                          '/' +
                          state.inventoryInfo['start_date'].toString() +
                          '/' +
                          state.inventoryInfo['warehouse_name'].toString(),
                    )
                        .then((value) {
                      if (value == 'refresh return') {
                        context
                            .read<InventoryQueryDetailBloc>()
                            .add(InitEvent());
                      }
                    });
                  },
                },
                {
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_operate_delete,
                  'callback': (_, value) {
                    // 删除弹窗
                    _showDeleteDialog(value);
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
