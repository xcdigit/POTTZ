import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../widget/table/sp/wms_table_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../../../../home/bloc/home_menu_bloc.dart' as bloc_home_menu;
import '../../../../home/bloc/home_menu_model.dart';
import '../bloc/inquiry_schedule_bloc.dart';
import '../bloc/inquiry_schedule_model.dart';
import 'inquiry_schedule_search.dart';

/**
 * 内容：入荷予定照会-表格
 * 作者：熊草云
 * 时间：2023/10/16
 */
class InquiryScheduleTable extends StatefulWidget {
  const InquiryScheduleTable({super.key});

  @override
  State<InquiryScheduleTable> createState() => _InquiryScheduleTableState();
}

class _InquiryScheduleTableState extends State<InquiryScheduleTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InquiryScheduleBloc, InquiryScheduleModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.all(1),
          child: Column(
            children: [
              InquiryScheduleSearch(),
              Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 50),
                child: Column(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: InquiryScheduleTableTab(),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromRGBO(224, 224, 224, 1),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: InquiryScheduleTableContent()),
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

// 入荷予定照会-表格Tab
class InquiryScheduleTableTab extends StatefulWidget {
  const InquiryScheduleTableTab({super.key});

  @override
  State<InquiryScheduleTableTab> createState() =>
      _InquiryScheduleTableTabState();
}

class _InquiryScheduleTableTabState extends State<InquiryScheduleTableTab> {
  // 当前悬停下标
  int _currentHoverIndex = Config.NUMBER_NEGATIVE;

  // 初始化Tab列表
  List<Widget> _initTabList(List tabItemList, InquiryScheduleModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        GestureDetector(
          onTap: () {
            // 表格Tab切换事件
            context
                .read<InquiryScheduleBloc>()
                .add(TableTabSwitchEvent(tabItemList[i]['index']));
          },
          child: Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
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
              minWidth: 138,
            ),
            child: Stack(
              children: [
                Text(
                  tabItemList[i]['title'],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
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
                    height: 20,
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
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
      );
    }
    // Tab列表
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InquiryScheduleBloc, InquiryScheduleModel>(
      builder: (context, state) {
        // Tab单个列表
        List _tabItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'title': WMSLocalizations.i18n(context)!.instruction_input_tab_list,
            'number': state.tableZeroNumber,
          },
          {
            'index': Config.NUMBER_ONE,
            'title': WMSLocalizations.i18n(context)!.menu_content_2_5_1,
            'number': state.tableOneNumber,
          },
          {
            'index': Config.NUMBER_TWO,
            'title': WMSLocalizations.i18n(context)!.menu_content_2_5_2,
            'number': state.tableTwoNumber,
          },
          {
            'index': Config.NUMBER_THREE,
            'title': WMSLocalizations.i18n(context)!.menu_content_2_5_14,
            'number': state.tableThreeNumber,
          },
          {
            'index': Config.NUMBER_FOUR,
            'title': WMSLocalizations.i18n(context)!.menu_content_2_5_3,
            'number': state.tableFourNumber,
          },
          {
            'index': Config.NUMBER_FIVE,
            'title': WMSLocalizations.i18n(context)!.menu_content_2_5_4,
            'number': state.tableFiveNumber,
          },
        ];

        return Row(
          children: _initTabList(_tabItemList, state),
        );
      },
    );
  }
}

// 入荷予定照会-表格内容
class InquiryScheduleTableContent extends StatefulWidget {
  const InquiryScheduleTableContent({super.key});

  @override
  State<InquiryScheduleTableContent> createState() =>
      _InquiryScheduleTableContentState();
}

class _InquiryScheduleTableContentState
    extends State<InquiryScheduleTableContent> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, InquiryScheduleModel state) {
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
            WMSLocalizations.i18n(context)!.menu_content_2_5_6,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'receive_no',
      );
      items.add(dropdownMenuItem2);
      DropdownMenuItem<String> dropdownMenuItem3 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.home_main_page_table_text1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'dr_rcv_sch_date',
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
                                context.read<InquiryScheduleBloc>().add(
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
                            context.read<InquiryScheduleBloc>().add(
                                SetSortEvent(
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

  // 删除弹窗
  _deleteDialog(int id) {
    InquiryScheduleBloc bloc = context.read<InquiryScheduleBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<InquiryScheduleBloc>.value(
          value: bloc,
          child: BlocBuilder<InquiryScheduleBloc, InquiryScheduleModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .display_instruction_confirm_delete,
                contentText: WMSLocalizations.i18n(context)!
                        .home_main_page_text6 +
                    '：' +
                    id.toString() +
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
                  // 删除入荷指示事件
                  context
                      .read<InquiryScheduleBloc>()
                      .add(DeleteReceiveEvent(id));
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bloc_home_menu.HomeMenuBloc, HomeMenuModel>(
      builder: (menuContext, menuState) {
        return BlocBuilder<InquiryScheduleBloc, InquiryScheduleModel>(
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
                          children:
                              _initButtonLeftList(_buttonLeftItemList, state),
                        ),
                      ),
                    ],
                  ),
                ),
                WMSTableWidget<InquiryScheduleBloc, InquiryScheduleModel>(
                  operatePopupHeight: 170,
                  columns: [
                    {
                      'key': 'id',
                      'width': 0.2,
                      'title': WMSLocalizations.i18n(context)!
                          .instruction_input_table_title_8,
                    },
                    {
                      'key': 'receive_no',
                      'width': 0.8,
                      'title':
                          WMSLocalizations.i18n(context)!.menu_content_2_5_6,
                    },
                    {
                      'key': 'dr_rcv_sch_date',
                      'width': 0.5,
                      'title': WMSLocalizations.i18n(context)!
                          .home_main_page_table_text1,
                    },
                    {
                      'key': 'name',
                      'width': 0.5,
                      'title':
                          WMSLocalizations.i18n(context)!.menu_content_2_5_5,
                    },
                    {
                      'key': 'receive_kbn_name',
                      'width': 0.5,
                      'title': WMSLocalizations.i18n(context)!
                          .inquiry_schedule_table_title_5,
                    },
                    {
                      'key': 'importerror_flg_name',
                      'width': 0.5,
                      'title': WMSLocalizations.i18n(context)!
                          .display_instruction_ingestion_state,
                    },
                  ],
                  operatePopupOptions: [
                    {
                      'title':
                          WMSLocalizations.i18n(context)!.menu_content_2_5_11,
                      'callback': (_, value) async {
                        // 查询入荷指示明细事件
                        bool tempBool = await context
                            .read<InquiryScheduleBloc>()
                            .queryReceiveEvent(value['id']);
                        if (tempBool) {
                          // 跳转页面
                          context.read<bloc_home_menu.HomeMenuBloc>().add(
                              bloc_home_menu.PageJumpEvent('/' +
                                  Config.PAGE_FLAG_2_5 +
                                  '/details/' +
                                  value['id'].toString()));
                        } else {
                          //数据被删除
                          WMSCommonBlocUtils.tipTextToast(
                              WMSLocalizations.i18n(state.rootContext)!
                                  .data_changed_operate_again);
                          // 初始化事件
                          context.read<InquiryScheduleBloc>().add(InitEvent());
                        }
                      },
                    },
                    {
                      'title': WMSLocalizations.i18n(context)!
                          .instruction_input_tab_button_update,
                      'callback': (_, value) async {
                        // 检查可操作状态
                        bool checkFlag = await context
                            .read<InquiryScheduleBloc>()
                            .checkOperationalStatus(value['id'], '1');
                        // 检查结果
                        if (checkFlag) {
                          // 跳转页面
                          context.read<bloc_home_menu.HomeMenuBloc>().add(
                              bloc_home_menu.PageJumpEvent('/' +
                                  Config.PAGE_FLAG_2_1 +
                                  '/' +
                                  value['id'].toString()));
                        }
                      },
                    },
                    {
                      'title': WMSLocalizations.i18n(context)!
                          .instruction_input_table_operate_delete,
                      'callback': (_, value) async {
                        // 检查可操作状态
                        bool checkFlag = await context
                            .read<InquiryScheduleBloc>()
                            .checkOperationalStatus(value['id'], '2');
                        // 检查结果
                        if (checkFlag) {
                          // 删除弹窗
                          _deleteDialog(value['id']);
                        }
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
