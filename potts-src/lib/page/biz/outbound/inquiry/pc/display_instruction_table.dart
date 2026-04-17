import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../redux/current_param_reducer.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../bloc/display_instruction_bloc.dart';
import '../bloc/display_instruction_modle.dart';

/**
 * 内容：出荷指示照会-表格
 * 作者：熊草云
 * 时间：2023/08/10
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List currentContent = [];
List currentContent_1 = [];
// 删除值
Map deletedata = {};
// 全局主键-表格共通
List reservationLists = [];

class DisplayInstructionTable extends StatefulWidget {
  const DisplayInstructionTable({super.key});

  @override
  State<DisplayInstructionTable> createState() =>
      _DisplayInstructionTableState();
}

class _DisplayInstructionTableState extends State<DisplayInstructionTable> {
  // 初始化一覧表格
  @override
  Widget build(BuildContext context) {
    // 判断当前下标

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DisplayInstructionTab(),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              margin: EdgeInsets.only(bottom: 40),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: DisplayInstructionButton(bloc: context),
                  ),
                  DisplayInstructionContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 出荷指示照会-表格Tab
// ignore: must_be_immutable
class DisplayInstructionTab extends StatefulWidget {
  DisplayInstructionTab({super.key});

  @override
  State<DisplayInstructionTab> createState() => _DisplayInstructionTabState();
}

class _DisplayInstructionTabState extends State<DisplayInstructionTab> {
  // 当前悬停下标
  int _currentHoverIndex = Config.NUMBER_NEGATIVE;
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, state) {
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
              // 判断下标
              if (tabItemList[i]['index'] == Config.NUMBER_ZERO) {
                // 状态变更
                setState(() {
                  context.read<DisplayInstructionBloc>().add(
                      QueryShipStateEvent(
                          ['0', '1', '2', '3', '4', '5', '6', '7'],
                          tabItemList[i]['index']));
                  // 当前内容
                  // currentContent = widget.initTableList;
                });
              } else if (tabItemList[i]['index'] == Config.NUMBER_ONE) {
                setState(() {
                  context
                      .read<DisplayInstructionBloc>()
                      .add(QueryShipStateEvent(['1'], tabItemList[i]['index']));
                  // 当前内容
                  // currentContent = widget.initTableList;
                });
              } else if (tabItemList[i]['index'] == Config.NUMBER_TWO) {
                setState(() {
                  context
                      .read<DisplayInstructionBloc>()
                      .add(QueryShipStateEvent(['2'], tabItemList[i]['index']));
                });
              } else if (tabItemList[i]['index'] == Config.NUMBER_THREE) {
                setState(() {
                  context.read<DisplayInstructionBloc>().add(
                      QueryShipStateEvent(
                          ['3', '4', '5', '6'], tabItemList[i]['index']));
                });
              } else if (tabItemList[i]['index'] == Config.NUMBER_FOUR) {
                setState(() {
                  context
                      .read<DisplayInstructionBloc>()
                      .add(QueryShipStateEvent(['7'], tabItemList[i]['index']));
                });
              }
            },
            child: Container(
              height: 46,
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              decoration: BoxDecoration(
                color: state.tabState == tabItemList[i]['index']
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
                        color: state.tabState == tabItemList[i]['index']
                            ? Color.fromRGBO(255, 255, 255, 1)
                            : _currentHoverIndex == tabItemList[i]['index']
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
                          i == 0
                              ? state.tabCount1.toString()
                              : i == 1
                                  ? state.tabCount2.toString()
                                  : i == 2
                                      ? state.tabCount3.toString()
                                      : i == 3
                                          ? state.tabCount4.toString()
                                          : state.tabCount5.toString(),
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
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!.display_instruction_allowance,
      },
      {
        'index': Config.NUMBER_TWO,
        'title': WMSLocalizations.i18n(context)!.display_instruction_waiting,
      },
      {
        'index': Config.NUMBER_THREE,
        'title': WMSLocalizations.i18n(context)!.display_instruction_work,
      },
      {
        'index': Config.NUMBER_FOUR,
        'title': WMSLocalizations.i18n(context)!.display_instruction_complete,
      },
    ];

    return BlocBuilder<DisplayInstructionBloc, DisplayInstructionModel>(
      builder: (context, state) {
        return Row(
          children: _initTabList(_tabItemList, state),
        );
      },
    );
  }
}

// 出荷指示照会-表格按钮
class DisplayInstructionButton extends StatefulWidget {
  final BuildContext bloc;
  const DisplayInstructionButton({super.key, required this.bloc});

  @override
  State<DisplayInstructionButton> createState() =>
      _DisplayInstructionButtonState();
}

class _DisplayInstructionButtonState extends State<DisplayInstructionButton> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, DisplayInstructionModel state) {
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
                                context.read<DisplayInstructionBloc>().add(
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
                            context.read<DisplayInstructionBloc>().add(
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
      } else {
        // 按钮列表
        buttonList.add(
          GestureDetector(
            onTap: () {
              // 判断循环下标
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                context
                    .read<DisplayInstructionBloc>()
                    .add(RecordCheckAllEvent(true));
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 全部取消
                context
                    .read<DisplayInstructionBloc>()
                    .add(RecordCheckAllEvent(false));
              }
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

// 悬停追踪
  List<bool> _stop = [false, false];
  void updateStop(bool stop, int i) {
    setState(() {
      _stop[i] = stop;
    });
  }

//提示弹框
  _showTipDialog(String text) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return WMSDiaLogWidget(
          titleText: WMSLocalizations.i18n(context)!.menu_content_3_5,
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

  // 初始化右侧按钮列表
  _initButtonRightList(
      List buttonItemList, List<Map<String, dynamic>> printValue, bloc) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // bool _stop = false;
      // 按钮列表
      buttonList.add(
        BlocBuilder<DisplayInstructionBloc, DisplayInstructionModel>(
          builder: (bloc, state) {
            return Container(
              child: StatefulBuilder(builder: (bloc, setState) {
                // 使用StatefulBuilder包裹每个按钮
                return MouseRegion(
                  onEnter: (event) {
                    setState(() {
                      updateStop(true, i);
                    });
                  },
                  onExit: (event) {
                    setState(() {
                      updateStop(false, i);
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
                      // 判断循环下标
                      if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                        // 引当
                        bloc.read<DisplayInstructionBloc>().add(
                            ReservationShipLineEvent(
                                reservationLists, context));
                      } else if (buttonItemList[i]['index'] ==
                          Config.NUMBER_ONE) {
                        // 引当解除
                        bloc
                            .read<DisplayInstructionBloc>()
                            .add(ReservationCancelShipLineEvent(context));
                      } else {
                        if (contentList.length >= 1) {
                          // 导入CSV文件
                          WMSCommonFile().exportCSVFile([
                            'id',
                            'ship_no',
                            'rcv_sch_date',
                            'cus_rev_date',
                            'customer_name',
                            'name',
                            'importerror_flg',
                            'ship_kbn',
                          ], contentList,
                              WMSLocalizations.i18n(context)!.menu_content_3_5);
                        } else {
                          // 错误提示
                          WMSCommonBlocUtils.errorTextToast(
                              WMSLocalizations.i18n(context)!
                                  .Inventory_Confirmed_tip_1);
                          // //提示
                          // _showTipDialog(
                          //   WMSLocalizations.i18n(context)!
                          //       .Inventory_Confirmed_tip_1,
                          // );
                        }
                      }
                    },
                    child: Container(
                      height: 37,
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: _stop[i]
                            ? Color.fromRGBO(0, 122, 255, .6)
                            : Colors.white,
                        border: Border.all(
                          color: _stop[i]
                              ? Color.fromRGBO(0, 122, 255, .6)
                              : Color.fromRGBO(224, 224, 224, 1),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          if (buttonItemList[i]['icon'] != null)
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
                              child: Image.asset(
                                buttonItemList[i]['icon'],
                                width: 17,
                                height: 19.43,
                                color: _stop[i]
                                    ? Colors.white
                                    : Color.fromRGBO(0, 122, 255, 1),
                              ),
                            ),
                          Text(
                            buttonItemList[i]['title'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: _stop[i]
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
          },
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayInstructionBloc, DisplayInstructionModel>(
        builder: (context, state) {
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
      List<Map<String, dynamic>> _buttonRightItemList = [
        if (state.tabState == Config.NUMBER_ONE)
          {
            'index': Config.NUMBER_ZERO,
            'icon': WMSICons.WAREHOUSE_DETAILS_ICON,
            'title': WMSLocalizations.i18n(context)!.menu_content_3_11_1,
          },
        if (state.tabState == Config.NUMBER_TWO ||
            state.tabState == Config.NUMBER_THREE)
          {
            'index': Config.NUMBER_ONE,
            'icon': WMSICons.WAREHOUSE_DETAILS_ICON,
            'title': WMSLocalizations.i18n(context)!.display_instruction_button,
          },
        {
          'index': Config.NUMBER_TWO,
          'icon': WMSICons.WAREHOUSE_CSV_ICON,
          'title':
              WMSLocalizations.i18n(context)!.instruction_input_tab_button_csv,
        }
      ];

      return Container(
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
                  children: _initButtonRightList(
                      _buttonRightItemList, state.printValueList, widget.bloc),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class DisplayInstructionContent extends StatefulWidget {
  const DisplayInstructionContent({super.key});

  @override
  State<DisplayInstructionContent> createState() =>
      _DisplayInstructionContentState();
}

class _DisplayInstructionContentState extends State<DisplayInstructionContent> {
  @override
  Widget build(BuildContext context) {
    return WMSTableWidget<DisplayInstructionBloc, DisplayInstructionModel>(
      columns: [
        {
          'key': 'id',
          'width': 1,
          'title':
              WMSLocalizations.i18n(context)!.instruction_input_table_title_1,
        },
        {
          'key': 'ship_no',
          'width': 5,
          'title': WMSLocalizations.i18n(context)!.delivery_note_14,
        },
        {
          'key': 'rcv_sch_date',
          'width': 3,
          'title': WMSLocalizations.i18n(context)!.delivery_note_16,
        },
        {
          'key': 'cus_rev_date',
          'width': 3,
          'title': WMSLocalizations.i18n(context)!.delivery_note_18,
        },
        {
          'key': 'customer_name',
          'width': 2,
          'title': WMSLocalizations.i18n(context)!.delivery_note_15,
        },
        {
          'key': 'name',
          'width': 2,
          'title': WMSLocalizations.i18n(context)!.delivery_note_17,
        },
        {
          'key': 'importerror_flg',
          'width': 6,
          'title': WMSLocalizations.i18n(context)!
              .display_instruction_ingestion_state,
        },
        {
          'key': 'ship_kbn_name',
          'width': 2,
          'title': WMSLocalizations.i18n(context)!
              .display_instruction_shipping_status,
        },
      ],
      operatePopupOptions: [
        {
          'title': WMSLocalizations.i18n(context)!
              .instruction_input_table_operate_detail,
          'callback': (_, value) {
            // 查询出荷指示明细事件
            GoRouter.of(context)
                .push(
              '/' + Config.PAGE_FLAG_3_5 + '/details/' + value['id'].toString(),
            )
                .then((value) {
              // 判断返回值
              if (value != 'return') {
                // 初始化事件
                context.read<DisplayInstructionBloc>().add(InitEvent());
              }
            });
            //传递数据
            // 查询出荷指示明细事件
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentParamAction(value));
          },
        },
        if (currentIndex != Config.NUMBER_ONE)
          {
            'title': WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_update,
            'callback': (_, value) {
              // 修正
              context.go('/instructioninput/' + value["id"].toString());
            },
          },
        {
          'title': WMSLocalizations.i18n(context)!
              .instruction_input_table_operate_delete,
          'callback': (_, value) {
            context.read<DisplayInstructionBloc>().add(SetDeleteIdEvent(value));
            _showDetailDialog();
          },
        },
      ],
      operatePopupHeight: 170,
    );
  }

  _showDetailDialog() {
    DisplayInstructionBloc bloc = context.read<DisplayInstructionBloc>();
    showDialog(
        context: context,
        builder: (context) {
          return BlocProvider<DisplayInstructionBloc>.value(
            value: bloc,
            child: BlocBuilder<DisplayInstructionBloc, DisplayInstructionModel>(
              builder: (context, state) {
                return WMSDiaLogWidget(
                  titleText: WMSLocalizations.i18n(context)!
                      .display_instruction_confirm_delete,
                  contentText:
                      "${WMSLocalizations.i18n(context)!.delivery_note_14}:${state.deleteList['ship_no']}${WMSLocalizations.i18n(context)!.display_instruction_delete}",
                  buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                  buttonRightText:
                      WMSLocalizations.i18n(context)!.delivery_note_10,
                  onPressedLeft: () {
                    // 关闭弹窗
                    Navigator.pop(context);
                  },
                  onPressedRight: () {
                    // 删除数据
                    setState(() {});
                    // 关闭弹窗
                    context
                        .read<DisplayInstructionBloc>()
                        .add(DeleteShipEvent(state.deleteList['id']));
                    currentIndex = Config.NUMBER_ZERO;
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          );
        });
  }
}
