import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/config/config.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../redux/current_param_reducer.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/account_ticket/pc/wms_account_ticket_widget.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../bloc/pick_list_bloc.dart';
import '../bloc/pick_list_model.dart';
import '/common/localization/default_localizations.dart';

/**
 * 内容：ピッキングリスト(シングル)   table一览
 * 作者：王光顺
 * 时间：2023/08/17
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List currentContent = [];
// 全局主键-表格共通
// GlobalKey<WMSTableWidgetState> _deliveryNoteTable = new GlobalKey();
// GlobalKey<WMSTableWidgetState> _deliveryNoteDetailTable = new GlobalKey();

class PickListDataSheetPage extends StatefulWidget {
  final bool search;
  final ValueChanged<bool> onData;
  const PickListDataSheetPage(
      {super.key, required this.search, required this.onData});
  @override
  State<PickListDataSheetPage> createState() => _PickListDataSheetPageState();
}

class _PickListDataSheetPageState extends State<PickListDataSheetPage> {
  @override
  Widget build(BuildContext context) {
    // 判断当前下标
    if (currentIndex == Config.NUMBER_ZERO) {
      // 状态变更
      setState(() {
        // 当前内容
        // currentContent = _initTableList();
      });
    }
    return Container(
      margin: EdgeInsets.fromLTRB(0, 40, 0, 80),
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DeliveryNoteTab(
                  // initTableList: _initTableList(),
                  ),
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
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: DeliveryNoteTableButton(),
                  ),
                  DeliveryNoteTableContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 表格Tab
// ignore: must_be_immutable
class DeliveryNoteTab extends StatefulWidget {
  // List initTableList;
  DeliveryNoteTab({super.key});

  @override
  State<DeliveryNoteTab> createState() => _DeliveryNoteTabState();
}

class _DeliveryNoteTabState extends State<DeliveryNoteTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, PickListModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        GestureDetector(
          onPanDown: (details) {},
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
                        (state.total).toString(),
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
        'title': WMSLocalizations.i18n(context)!.delivery_note_3,
      },
    ];
    return BlocBuilder<PickListBloc, PickListModel>(
      builder: (context, state) => Row(
        children: _initTabList(_tabItemList, state),
      ),
    );
  }
}

// 表格按钮
class DeliveryNoteTableButton extends StatefulWidget {
  const DeliveryNoteTableButton({super.key});

  @override
  State<DeliveryNoteTableButton> createState() =>
      _DeliveryNoteTableButtonState();
}

class _DeliveryNoteTableButtonState extends State<DeliveryNoteTableButton> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, PickListModel state) {
    List<DropdownMenuItem<String>> getListData() {
      List<DropdownMenuItem<String>> items = [];
      DropdownMenuItem<String> dropdownMenuItem1 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            'ID',
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
            WMSLocalizations.i18n(context)!.delivery_note_14,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'ship_no',
      );
      items.add(dropdownMenuItem2);
      DropdownMenuItem<String> dropdownMenuItem3 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.delivery_note_16,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'rcv_sch_date',
      );
      items.add(dropdownMenuItem3);
      DropdownMenuItem<String> dropdownMenuItem4 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.delivery_note_18,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'cus_rev_date',
      );
      items.add(dropdownMenuItem4);
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
                                context.read<PickListBloc>().add(SetSortEvent(
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
                            context.read<PickListBloc>().add(SetSortEvent(
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
      } else {
        // 按钮列表
        buttonList.add(
          GestureDetector(
            onTap: () {
              // 判断循环下标
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                // 全部选择
                context.read<PickListBloc>().add(RecordCheckAllEvent(true));
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 全部取消
                context.read<PickListBloc>().add(RecordCheckAllEvent(false));
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
    }
    // 按钮列表
    return buttonList;
  }

  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList, PickListModel state) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      bool _stop = false; // 将_stop变量移至循环内部
      // 按钮列表
      buttonList.add(
        StatefulBuilder(builder: (context, setState) {
          // 使用StatefulBuilder包裹每个按钮
          return MouseRegion(
            onEnter: (event) {
              setState(() {
                _stop = true;
              });
            },
            onExit: (event) {
              setState(() {
                _stop = false;
              });
            },
            child: GestureDetector(
              onTap: () {
                if (state.checkedRecords().length != 0) {
                  // 内容列表
                  List<Map<String, dynamic>> contentList = [];
                  // 表格选中列表
                  List<WmsRecordModel> wmsRecordModelList =
                      state.checkedRecords();
                  List<int> data = [];
                  // 循环表格选中列表
                  for (int i = 0; i < wmsRecordModelList.length; i++) {
                    // 内容列表
                    contentList.add(wmsRecordModelList[i].data);
                    data.add(contentList[i]['id']);
                  }

                  context.read<PickListBloc>().add(updateShipFormEvent(data));

                  // 跳转打印页面
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => (WMSAccountTicketWidget(
                        formKbn: Config.NUMBER_TWO.toString(),
                        idList: data,
                      )),
                    ),
                  );
                }
              },
              child: Container(
                height: 37,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                decoration: BoxDecoration(
                  color: _stop ? Color.fromRGBO(0, 122, 255, .6) : Colors.white,
                  border: Border.all(
                    color: _stop
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
                        color: _stop
                            ? Colors.white
                            : Color.fromRGBO(0, 122, 255, 1),
                      ),
                    ),
                    Text(
                      buttonItemList[i]['title'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: _stop
                            ? Colors.white
                            : Color.fromRGBO(0, 122, 255, 1),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    }

    // 按钮列表
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    // 左侧按钮单个列表
    List _buttonLeftItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_button_choice,
        'sort': false,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!
            .instruction_input_tab_button_cancellation,
        'sort': false,
      },
      {
        'index': Config.NUMBER_THREE,
        'title': WMSLocalizations.i18n(context)!.table_sort_column,
        'sort': true,
      },
    ];
    // 右侧按钮单个列表
    List<Map<String, dynamic>> _buttonRightItemList = [
      // if (!widget.detailState)
      {
        'index': Config.NUMBER_ONE,
        'icon': WMSICons.WAREHOUSE_PRINTING_ICON,
        'title': WMSLocalizations.i18n(context)!.delivery_note_9,
      }
    ];

    return BlocBuilder<PickListBloc, PickListModel>(
        builder: (context, state) => Container(
              height: 37,
              child: Stack(
                children: [
                  Container(
                    child: Row(
                      children: _initButtonLeftList(_buttonLeftItemList, state),
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
            ));
  }
}

class DeliveryNoteTableContent extends StatefulWidget {
  // 明细按钮点击传数据

  const DeliveryNoteTableContent({super.key});

  @override
  State<DeliveryNoteTableContent> createState() =>
      _DeliveryNoteTableContentState();
}

class _DeliveryNoteTableContentState extends State<DeliveryNoteTableContent> {
  @override
  Widget build(BuildContext context) {
    return WMSTableWidget<PickListBloc, PickListModel>(
      columns: [
        {
          'key': 'id',
          'width': 1,
          'title': 'ID',
        },
        {
          'key': 'ship_no',
          'width': 3,
          'title': WMSLocalizations.i18n(context)!.exit_input_form_title_2,
        },
        {
          'key': 'rcv_sch_date',
          'width': 3,
          'title': WMSLocalizations.i18n(context)!
              .shipment_confirmation_export_table_title_3,
        },
        {
          'key': 'cus_rev_date',
          'width': 3,
          'title': WMSLocalizations.i18n(context)!
              .shipment_confirmation_export_table_title_4,
        },
        {
          'key': 'customer_name',
          'width': 3,
          'title': WMSLocalizations.i18n(context)!.exit_input_form_title_3,
        },
        {
          'key': 'name',
          'width': 3,
          'title': WMSLocalizations.i18n(context)!.exit_input_form_title_4,
        },
      ],
      showCheckboxColumn: true,
      operatePopupOptions: [
        {
          'title': WMSLocalizations.i18n(context)!.delivery_note_8,
          'callback': (_, value) {
            // 查询出荷指示明细事件

            context.go('/page_flag_3_8/details');
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentParamAction(value));
          },
        },
      ],
      operatePopupHeight: 100,
    );
  }
}

// 明细数据查询提示
class DetailDialog extends StatefulWidget {
  const DetailDialog({super.key});

  @override
  State<DetailDialog> createState() => _DetailDialogState();
}

class _DetailDialogState extends State<DetailDialog> {
  @override
  Widget build(BuildContext context) {
    return WMSDiaLogWidget(
      titleText: "提示",
      contentText: "一次只能查询一条",
      buttonLeftFlag: false,
      buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
      onPressedRight: () {
        // 页面++
        setState(() {});
        // 关闭弹窗
        Navigator.pop(context);
      },
    );
  }
}
