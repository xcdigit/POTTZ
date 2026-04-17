import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/page/home/bloc/home_menu_bloc.dart';
import 'package:wms/page/home/bloc/home_menu_model.dart';
import 'package:wms/page/biz/outbound/outbound/bloc/outbound_query_bloc.dart';
import 'package:wms/page/biz/outbound/outbound/bloc/outbound_query_model.dart';
import 'package:wms/widget/wms_dialog_widget.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/table/sp/wms_table_widget.dart';
import '/common/localization/default_localizations.dart';

/**
 * 内容：出庫照会
 * 作者：王光顺
 * 时间：2023/08/18
 */

// 当前下标
int currentIndex = Config.NUMBER_ZERO;

// 通信数据
List<Map<String, dynamic>> commData = [];

class OutboundQueryDataSheetPage extends StatefulWidget {
  final bool search;
  final ValueChanged<bool> onData;
  const OutboundQueryDataSheetPage(
      {super.key, required this.search, required this.onData});
  @override
  State<OutboundQueryDataSheetPage> createState() =>
      _OutboundQueryDataSheetPage();
}

class _OutboundQueryDataSheetPage extends State<OutboundQueryDataSheetPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 80),
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: InstructionInputTableTab(),
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
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
                  //   child: InstructionInputTableButton(),
                  // ),
                  InstructionInputTableContent(),
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
class InstructionInputTableTab extends StatefulWidget {
  InstructionInputTableTab({
    super.key,
  });

  @override
  State<InstructionInputTableTab> createState() =>
      _InstructionInputTableTabState();
}

class _InstructionInputTableTabState extends State<InstructionInputTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, OutboundQueryModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 40,
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
              minWidth: 108,
            ),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              onPressed: () {
                //     // 判断下标
                // if (tabItemList[i]['index'] == Config.NUMBER_ZERO) {
                //   // 状态变更
                //   setState(() {
                //     context.read<OutboundQueryBloc>().add(OutboundPageQueryEvent(
                //         ['2', '3', '4', '5', '6', '7'], state.companyId));
                //     // 当前下标
                //     currentIndex = tabItemList[i]['index'];
                //   });
                // } else if (tabItemList[i]['index'] == Config.NUMBER_ONE) {
                //   // 状态变更
                //   setState(() {
                //     context
                //         .read<OutboundQueryBloc>()
                //         .add(OutboundPageQueryEvent(['2'], state.companyId));
                //     // 当前下标
                //     currentIndex = tabItemList[i]['index'];
                //   });
                // } else if (tabItemList[i]['index'] == Config.NUMBER_TWO) {
                //   // 状态变更
                //   setState(() {
                //     context
                //         .read<OutboundQueryBloc>()
                //         .add(OutboundPageQueryEvent(['3'], state.companyId));
                //     // 当前下标
                //     currentIndex = tabItemList[i]['index'];
                //   });
                // } else if (tabItemList[i]['index'] == Config.NUMBER_THREE) {
                //   // 状态变更
                //   setState(() {
                //     context.read<OutboundQueryBloc>().add(OutboundPageQueryEvent(
                //         ['4', '5', '6', '7'], state.companyId));
                //     // 当前下标
                //     currentIndex = tabItemList[i]['index'];
                //   });
                // } else {
                //   setState(() {
                //     // 当前下标
                //     currentIndex = tabItemList[i]['index'];
                //   });
                // }
              },
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
                        state.count.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(44, 167, 176, 1),
                        ),
                      ),
                    ),
                  )
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
        'title': WMSLocalizations.i18n(context)!.transfer_inquiry_tab_list,
      }
    ];
    return BlocBuilder<OutboundQueryBloc, OutboundQueryModel>(
      builder: (context, state) => Row(
        children: _initTabList(_tabItemList, state),
      ),
    );
  }
}

// 出荷指示入力-表格内容
class InstructionInputTableContent extends StatefulWidget {
  const InstructionInputTableContent({super.key});

  @override
  State<InstructionInputTableContent> createState() =>
      _InstructionInputTableContentState();
}

class _InstructionInputTableContentState
    extends State<InstructionInputTableContent> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, OutboundQueryModel state) {
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
            margin: EdgeInsets.fromLTRB(0, 16, 5, 0),
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
                                context.read<OutboundQueryBloc>().add(
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
                            context.read<OutboundQueryBloc>().add(SetSortEvent(
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
                context
                    .read<OutboundQueryBloc>()
                    .add(RecordCheckAllEvent(true));
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 全部取消
                context
                    .read<OutboundQueryBloc>()
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
    }
    // 按钮列表
    return buttonList;
  }

  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList, OutboundQueryModel state) {
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
                if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                  if (contentList.length == 0) {
                    context.go('/' +
                        Config.PAGE_FLAG_3_12 +
                        '/' +
                        Config.NUMBER_ZERO.toString());
                  } else if (contentList.length == 1) {
                    Map<String, dynamic> tempMap =
                        state.checkedRecords().elementAt(0).data;
                    if (tempMap['ship_kbn'] == Config.NUMBER_TWO.toString()) {
                      context.go('/' +
                          Config.PAGE_FLAG_3_12 +
                          '/' +
                          state
                              .checkedRecords()
                              .elementAt(0)
                              .data['id']
                              .toString());
                    } else {
                      // 消息提示
                      WMSCommonBlocUtils.tipTextToast(
                          WMSLocalizations.i18n(context)!
                              .outbound_notes_toast_1);
                    }
                  } else {
                    _showTipDialog(
                      WMSLocalizations.i18n(context)!.outbound_notes_6,
                    );
                  }
                }
                //  else {
                //   if (contentList.length > 0) {
                //     WMSCommonFile().exportCSVFile([
                //       'id',
                //       'ship_no',
                //       'rcv_sch_date',
                //       'cus_rev_date',
                //       'customer_name',
                //       'name'
                //     ], contentList,
                //         WMSLocalizations.i18n(context)!.menu_content_3_16);
                //   } else {
                //     _showTipDialog(
                //       WMSLocalizations.i18n(context)!.Inventory_Confirmed_tip_1,
                //     );
                //   }
                // }
              },
              child: Container(
                height: 37,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
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

  //提示弹框
  _showTipDialog(String text) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return WMSDiaLogWidget(
          titleText:
              WMSLocalizations.i18n(context)!.login_tip_title_modify_pwd_text,
          contentText: text,
          buttonLeftFlag: false,
          buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
          onPressedRight: () {
            //关闭对话框并返回true
            Navigator.of(context).pop(true);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OutboundQueryBloc, OutboundQueryModel>(
        builder: (context, state) {
      return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
        builder: (menuContext, menuState) {
          // 左侧按钮单个列表
          List _buttonLeftItemList = [
            {
              'index': Config.NUMBER_ZERO,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_tab_button_choice,
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
          List _buttonRightItemList = [
            {
              'index': Config.NUMBER_ZERO,
              'icon': WMSICons.WAREHOUSE_DETAILS_ICON,
              'title': WMSLocalizations.i18n(context)!.menu_content_3_12,
            },
            // {
            //   'index': Config.NUMBER_ONE,
            //   'icon': WMSICons.WAREHOUSE_PRINTING_ICON,
            //   'title': WMSLocalizations.i18n(context)!
            //       .instruction_input_tab_button_print,
            // },
          ];
          return Column(
            children: [
              Container(
                // height: 95,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Column(
                  children: [
                    Container(
                      child: Wrap(
                        children:
                            _initButtonLeftList(_buttonLeftItemList, state),
                      ),
                    ),
                    Container(
                      child: SizedBox(height: 10, width: double.infinity),
                    ),
                    Container(
                      child: Container(
                        child: Row(
                          children:
                              _initButtonRightList(_buttonRightItemList, state),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              WMSTableWidget<OutboundQueryBloc, OutboundQueryModel>(
                headTitle: 'id',
                operatePopupHeight: 100,
                columns: [
                  // 赵士淞 - 始
                  // {
                  //   'key': 'id',
                  //   'width': 0.5,
                  //   'title': 'ID',
                  // },
                  {
                    'key': 'ship_no',
                    'width': 1.0,
                    'title': WMSLocalizations.i18n(context)!.delivery_note_14,
                  },
                  // 赵士淞 - 终
                  {
                    'key': 'rcv_sch_date',
                    'width': 0.5,
                    'title': WMSLocalizations.i18n(context)!.delivery_note_16,
                  },
                  {
                    'key': 'cus_rev_date',
                    'width': 0.5,
                    'title': WMSLocalizations.i18n(context)!
                        .instruction_input_form_basic_5,
                  },
                  {
                    'key': 'customer_name',
                    'width': 0.5,
                    'title':
                        WMSLocalizations.i18n(context)!.exit_input_form_title_3,
                  },
                  {
                    'key': 'name',
                    'width': 0.5,
                    'title':
                        WMSLocalizations.i18n(context)!.exit_input_form_title_4,
                  },
                  {
                    'key': 'ship_kbn_name',
                    'width': 0.5,
                    'title': WMSLocalizations.i18n(context)!
                        .display_instruction_shipping_status,
                  },
                ],
                operatePopupOptions: [
                  {
                    'title': WMSLocalizations.i18n(context)!.menu_content_3_12,
                    'callback': (_, value) {
                      state.checkedRecords().forEach((record) {
                        state.ckId = record.data['id'];
                      });
                      if (value['ship_kbn'] == Config.NUMBER_TWO.toString() ||
                          value['ship_kbn'] == Config.NUMBER_THREE.toString()) {
                        context.go('/' +
                            Config.PAGE_FLAG_3_12 +
                            '/' +
                            value['id'].toString());
                      } else {
                        // 消息提示
                        WMSCommonBlocUtils.tipTextToast(
                            WMSLocalizations.i18n(context)!
                                .outbound_notes_toast_1);
                      }
                    },
                  },
                ],
              ),
            ],
          );
        },
      );
    });
  }
}
