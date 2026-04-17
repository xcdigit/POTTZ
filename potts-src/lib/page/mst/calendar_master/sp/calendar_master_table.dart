import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/sp/wms_table_widget.dart';
import '../../../../widget/wms_dialog_widget.dart';
import '../bloc/calendar_master_bloc.dart';
import '../bloc/calendar_master_model.dart';

/**
 * 内容：営業日マスタ-表格
 * 作者：赵士淞
 * 时间：2023/12/01
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前悬停下标
int currentHoverIndex = Config.NUMBER_NEGATIVE;

class CalendarMasterTable extends StatefulWidget {
  const CalendarMasterTable({super.key});

  @override
  State<CalendarMasterTable> createState() => _CalendarMasterTableState();
}

class _CalendarMasterTableState extends State<CalendarMasterTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarMasterBloc, CalendarMasterModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 40),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: CalendarMasterTableTab(),
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
                  child: CalendarMasterTableContent(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 営業日マスタ-表格Tab
class CalendarMasterTableTab extends StatefulWidget {
  const CalendarMasterTableTab({super.key});

  @override
  State<CalendarMasterTableTab> createState() => _CalendarMasterTableTabState();
}

class _CalendarMasterTableTabState extends State<CalendarMasterTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList) {
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
              currentHoverIndex = tabItemList[i]['index'];
            });
          },
          onExit: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              currentHoverIndex = Config.NUMBER_NEGATIVE;
            });
          },
          child: GestureDetector(
            onPanDown: (details) {
              // 状态变更
              setState(() {
                // 当前下标
                currentIndex = tabItemList[i]['index'];
              });
            },
            child: Container(
              height: 40,
              padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              decoration: BoxDecoration(
                color: currentIndex == tabItemList[i]['index']
                    ? Color.fromRGBO(44, 167, 176, 1)
                    : currentHoverIndex == tabItemList[i]['index']
                        ? Color.fromRGBO(44, 167, 176, 0.6)
                        : Color.fromRGBO(245, 245, 245, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              constraints: BoxConstraints(
                minWidth: 108,
              ),
              child: Stack(
                children: [
                  Text(
                    tabItemList[i]['title'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: currentIndex == tabItemList[i]['index']
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : currentHoverIndex == tabItemList[i]['index']
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(6, 14, 15, 1),
                      height: 1.5,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      height: 20,
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
    // Tab单个列表
    List _tabItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.instruction_input_tab_list,
        'number': context.read<CalendarMasterBloc>().state.total,
      },
    ];

    return Row(
      children: _initTabList(_tabItemList),
    );
  }
}

// 営業日マスタ-表格内容
class CalendarMasterTableContent extends StatefulWidget {
  const CalendarMasterTableContent({super.key});

  @override
  State<CalendarMasterTableContent> createState() =>
      _CalendarMasterTableContentState();
}

class _CalendarMasterTableContentState
    extends State<CalendarMasterTableContent> {
  // 删除弹窗
  _deleteDialog(int calendarId) {
    CalendarMasterBloc bloc = context.read<CalendarMasterBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<CalendarMasterBloc>.value(
          value: bloc,
          child: BlocBuilder<CalendarMasterBloc, CalendarMasterModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .display_instruction_confirm_delete,
                contentText: WMSLocalizations.i18n(context)!
                        .mtb_calendar_text_1 +
                    '：' +
                    calendarId.toString() +
                    ' ' +
                    WMSLocalizations.i18n(context)!.display_instruction_delete,
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                buttonRightText:
                    WMSLocalizations.i18n(context)!.delivery_note_10,
                onPressedLeft: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                },
                onPressedRight: () {
                  // 删除营业事件
                  context
                      .read<CalendarMasterBloc>()
                      .add(DeleteCalendarEvent(calendarId));
                  // 关闭弹窗
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, CalendarMasterModel state) {
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
            WMSLocalizations.i18n(context)!.mtb_calendar_text_2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'calendar_date',
      );
      items.add(dropdownMenuItem2);
      DropdownMenuItem<String> dropdownMenuItem3 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.mtb_calendar_text_3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'calendar_type',
      );
      items.add(dropdownMenuItem3);
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
                                context.read<CalendarMasterBloc>().add(
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
                            context.read<CalendarMasterBloc>().add(SetSortEvent(
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
              // 页面标记
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshCurrentFlagAction(true));
              // 登录按钮跳转页面
              GoRouter.of(context)
                  .push('/' +
                      Config.PAGE_FLAG_8_21 +
                      '/details/' +
                      Config.NUMBER_NEGATIVE.toString() +
                      '/' +
                      Config.NUMBER_NEGATIVE.toString())
                  .then((value) {
                // 判断返回值
                if (value == 'refresh return') {
                  // 初始化事件
                  context.read<CalendarMasterBloc>().add(InitEvent());
                }
              });
            },
            child: Container(
              height: 37,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.fromLTRB(0, 10, 16, 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                border: Border.all(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Image.asset(
                    WMSICons.MASTER_LOGIN_ICON,
                    height: 17,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  ),
                  Text(
                    buttonItemList[i]['title'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(0, 122, 255, 1),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    // 按钮列表
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarMasterBloc, CalendarMasterModel>(
      builder: (context, state) {
        // 左侧按钮单个列表
        List _buttonLeftItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'title': WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_add,
            'sort': false,
          },
          {
            'index': Config.NUMBER_THREE,
            'title': WMSLocalizations.i18n(context)!.table_sort_column,
            'sort': true,
          },
        ];

        return Column(
          children: [
            Container(
              child: Row(
                children: _initButtonLeftList(_buttonLeftItemList, state),
              ),
            ),
            WMSTableWidget<CalendarMasterBloc, CalendarMasterModel>(
              headTitle: 'id',
              columns: [
                {
                  'key': 'calendar_date',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.mtb_calendar_text_2,
                },
                {
                  'key': 'calendar_type_text',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.mtb_calendar_text_3,
                },
                {
                  'key': 'note',
                  'width': 1.0,
                  'title': WMSLocalizations.i18n(context)!.mtb_calendar_text_4,
                },
              ],
              operatePopupHeight: 170,
              operatePopupOptions: [
                {
                  'title': WMSLocalizations.i18n(context)!.delivery_note_8,
                  'callback': (_, value) {
                    // 页面标记
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentFlagAction(true));
                    // 登录按钮跳转页面
                    GoRouter.of(context)
                        .push('/' +
                            Config.PAGE_FLAG_8_21 +
                            '/details/' +
                            value['id'].toString() +
                            '/' +
                            Config.NUMBER_ONE.toString())
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<CalendarMasterBloc>().add(InitEvent());
                      }
                    });
                  },
                },
                {
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_tab_button_update,
                  'callback': (_, value) {
                    // 页面标记
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentFlagAction(true));
                    // 登录按钮跳转页面
                    GoRouter.of(context)
                        .push('/' +
                            Config.PAGE_FLAG_8_21 +
                            '/details/' +
                            value['id'].toString() +
                            '/' +
                            Config.NUMBER_TWO.toString())
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<CalendarMasterBloc>().add(InitEvent());
                      }
                    });
                  },
                },
                {
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_operate_delete,
                  'callback': (_, value) {
                    // 删除弹窗
                    _deleteDialog(value['id']);
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
