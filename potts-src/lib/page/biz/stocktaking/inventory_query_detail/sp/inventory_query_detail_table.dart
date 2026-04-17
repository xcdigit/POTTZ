import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../widget/table/sp/wms_table_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../../../../home/bloc/home_menu_model.dart';
import '../bloc/inventory_query_detail_bloc.dart';
import '../bloc/inventory_query_detail_model.dart';
import '../../../../home/bloc/home_menu_bloc.dart' as menu_bloc;

/**
 * 内容：棚卸照会-表格
 * 作者：熊草云
 * 时间：2023/11/22
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
    return BlocBuilder<menu_bloc.HomeMenuBloc, HomeMenuModel>(
      builder: (menuBloc, menuState) {
        return BlocBuilder<InventoryQueryDetailBloc, InventoryQueryDetailModel>(
          builder: (context, state) {
            return Column(
              children: [
                WMSTableWidget<InventoryQueryDetailBloc,
                    InventoryQueryDetailModel>(
                  //表头
                  columns: [
                    // 棚卸明細ID
                    {
                      'key': 'id',
                      'width': .2,
                      'title': WMSLocalizations.i18n(context)!
                          .inventory_query_Inventory_item_id,
                    },
                    // 商品名
                    {
                      'key': 'product_name',
                      'width': .8,
                      'title': WMSLocalizations.i18n(context)!.delivery_note_20,
                    },
                    // ロケーションコード
                    {
                      'key': 'location_loc_cd',
                      'width': .8,
                      'title': WMSLocalizations.i18n(context)!
                          .exit_input_table_title_3,
                    },
                    // 棚卸数量
                    {
                      'key': 'real_num',
                      'width': .2,
                      'title': WMSLocalizations.i18n(context)!
                          .inventory_query_quantity,
                    },
                    // 在庫数量
                    {
                      'key': 'logic_num',
                      'width': .2,
                      'title': WMSLocalizations.i18n(context)!
                          .inventory_query_quantity_in_stock,
                    },
                    // 差異数量
                    {
                      'key': 'diff_num',
                      'width': .2,
                      'title': WMSLocalizations.i18n(context)!
                          .inventory_query_variance_quantity,
                    },
                    // 差異理由
                    {
                      'key': 'diff_reason',
                      'width': .6,
                      'title': WMSLocalizations.i18n(context)!
                          .inventory_query_reason,
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
                              WMSLocalizations.i18n(context)!
                                  .inventory_query_tip);
                          return;
                        }
                        //设定显示标题
                        menuBloc.read<menu_bloc.HomeMenuBloc>().add(
                            menu_bloc.SPPageJumpEvent(
                                '/' + Config.PAGE_FLAG_60_5_2));
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
                            //设定回显标题
                            menuBloc.read<menu_bloc.HomeMenuBloc>().add(
                                menu_bloc.SPPageJumpEvent('/' +
                                    Config.PAGE_FLAG_5_9 +
                                    '/' +
                                    'details/' +
                                    state.detailId.toString()));
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
      },
    );
  }
}
