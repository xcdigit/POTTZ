import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/outbound/ship/bloc/shipment_determination_bloc.dart';
import 'package:wms/page/biz/outbound/ship/bloc/shipment_determination_model.dart';
import 'package:wms/page/biz/outbound/ship/sp/shipment_determination_detail_page.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../redux/current_page_reducer.dart';
import '../../../../../redux/current_param_reducer.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/table/sp/wms_table_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';

/**
 * 内容：出荷确定-表格
 * 作者：cuihr
 * 时间：2023/08/18
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

class ShipmentDeterminationTable extends StatefulWidget {
  const ShipmentDeterminationTable({super.key});

  @override
  State<ShipmentDeterminationTable> createState() =>
      _ShipmentDeterminationTableState();
}

class _ShipmentDeterminationTableState
    extends State<ShipmentDeterminationTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDeterminationBloc, ShipmentDeterminationModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 40),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ShipmentDeterminationTableTab(),
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
                  child: ShipmentDeterminationTableContent(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 出荷确定-表格Tab
// ignore: must_be_immutable
class ShipmentDeterminationTableTab extends StatefulWidget {
  const ShipmentDeterminationTableTab({super.key});

  @override
  State<ShipmentDeterminationTableTab> createState() =>
      _ShipmentDeterminationTableTabState();
}

class _ShipmentDeterminationTableTabState
    extends State<ShipmentDeterminationTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, ShipmentDeterminationModel state) {
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
              color: tabItemList[i]['index'] == state.currentIndex
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
                // 判断下标
                //一览
                if (tabItemList[i]['index'] == Config.NUMBER_ZERO) {
                  // 状态变更
                  setState(() {
                    context
                        .read<ShipmentDeterminationBloc>()
                        .add(QueryShipEvent('0', ['6', '7']));
                    // 当前下标
                    currentIndex = state.currentIndex;
                  });
                  //未确定
                } else if (tabItemList[i]['index'] == Config.NUMBER_ONE) {
                  // 状态变更
                  setState(() {
                    context
                        .read<ShipmentDeterminationBloc>()
                        .add(QueryShipEvent('1', ['6']));
                    // 当前下标
                    currentIndex = state.currentIndex;
                  });
                  //确定完
                } else if (tabItemList[i]['index'] == Config.NUMBER_TWO) {
                  // 状态变更
                  setState(() {
                    context
                        .read<ShipmentDeterminationBloc>()
                        .add(QueryShipEvent('2', ['7']));
                    // 当前下标
                    currentIndex = state.currentIndex;
                  });
                } else {
                  // 当前下标
                  currentIndex = state.currentIndex;
                }
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
                      color: tabItemList[i]['index'] == state.currentIndex
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(6, 14, 15, 1),
                      height: 1.0,
                    ),
                  ),
                  i > 0
                      ? Container(
                          margin: EdgeInsets.only(left: 20),
                          height: 24,
                          width: 32,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              i == 1
                                  ? state.count1.toString()
                                  : state.count2.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(left: 20),
                          height: 24,
                          width: 32,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              state.count3.toString(),
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
      // 一览表
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.instruction_input_tab_list,
      },
      // 未确定
      {
        'index': Config.NUMBER_ONE,
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_Undetermined,
      },
      //已确认
      {
        'index': Config.NUMBER_TWO,
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_Determined,
      },
    ];
    return BlocBuilder<ShipmentDeterminationBloc, ShipmentDeterminationModel>(
      builder: (context, state) => Row(
        children: _initTabList(_tabItemList, state),
      ),
    );
  }
}

//出荷确定-表格内容
class ShipmentDeterminationTableContent extends StatefulWidget {
  const ShipmentDeterminationTableContent({super.key});

  @override
  State<ShipmentDeterminationTableContent> createState() =>
      _ShipmentDeterminationTableContentState();
}

class _ShipmentDeterminationTableContentState
    extends State<ShipmentDeterminationTableContent> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, ShipmentDeterminationModel state) {
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
                                context.read<ShipmentDeterminationBloc>().add(
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
                            context.read<ShipmentDeterminationBloc>().add(
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
                // 全部选择
                context
                    .read<ShipmentDeterminationBloc>()
                    .add(RecordCheckAllEvent(true));
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 全部选择
                context
                    .read<ShipmentDeterminationBloc>()
                    .add(RecordCheckAllEvent(false));
              } else {
                print('');
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

  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList, ShipmentDeterminationModel state) {
    //根据tab页面显示按钮
    if (state.currentIndex == 1) {
      buttonItemList.removeAt(1);
    } else if (state.currentIndex == 2) {
      buttonItemList.removeAt(0);
    }
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 将_stop变量移至循环内部
      bool _stop = false;
      // 按钮列表
      buttonList.add(
        StatefulBuilder(
          builder: (context, setState) {
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
                  // 判断循环下标
                  //确定
                  if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                    if (state.checkedRecords().length == 1) {
                      context
                          .read<ShipmentDeterminationBloc>()
                          .selectShipEventBefore('1', context, state);
                    } else {
                      _showTipDialog(
                        WMSLocalizations.i18n(context)!
                            .display_instruction_message1,
                      );
                    }
                    //取消
                  } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                    if (state.checkedRecords().length >= 1) {
                      bool res = false;
                      List<Map<String, dynamic>> list = [];
                      state.checkedRecords().forEach((element) {
                        list.add(element.data);
                      });
                      if (list.length > 0) {
                        for (var i = 0; i < list.length; i++) {
                          if (list[i]['csv_kbn'] == '1') {
                            res = true;
                            break;
                          }
                        }
                      }
                      if (res) {
                        _WarningDialog(
                            WMSLocalizations.i18n(context)!.ship_cancel_error,
                            context);
                      } else {
                        context
                            .read<ShipmentDeterminationBloc>()
                            .selectShipEventBefore('2', context, state);
                      }
                    } else {
                      _showTipDialog(
                        WMSLocalizations.i18n(context)!.menu_content_2_5_13,
                      );
                    }
                  }
                },
                child: Container(
                  height: 37,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                  decoration: BoxDecoration(
                    color:
                        _stop ? Color.fromRGBO(0, 122, 255, .6) : Colors.white,
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
          },
        ),
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

  // 警告弹窗
  _WarningDialog(String text, BuildContext parentContext) {
    ShipmentDeterminationBloc bloc = context.read<ShipmentDeterminationBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<ShipmentDeterminationBloc>.value(
          value: bloc,
          child: BlocBuilder<ShipmentDeterminationBloc,
              ShipmentDeterminationModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .login_tip_title_modify_pwd_text,
                contentText: text,
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                buttonRightText:
                    WMSLocalizations.i18n(context)!.table_tab_confirm,
                onPressedLeft: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                },
                onPressedRight: () {
                  bloc.selectShipEventBefore('2', parentContext, state);
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
    return BlocBuilder<ShipmentDeterminationBloc, ShipmentDeterminationModel>(
      builder: (context, state) {
        // 左侧按钮单个列表
        List _buttonLeftItemList = [
          //全选
          {
            'index': Config.NUMBER_ZERO,
            'title': WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_choice,
            'sort': false,
          },
          //全部取消
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
          //确定按钮
          {
            'index': Config.NUMBER_ZERO,
            'icon': WMSICons.WAREHOUSE_DETAILS_ICON,
            'title': WMSLocalizations.i18n(context)!.table_tab_confirm,
          },
          // //取消
          {
            'index': Config.NUMBER_ONE,
            'icon': WMSICons.WAREHOUSE_DETAILS_ICON,
            'title': WMSLocalizations.i18n(context)!.app_cancel,
          },
          // //印刷
          // {
          //   'index': Config.NUMBER_TWO,
          //   'icon': WMSICons.WAREHOUSE_PRINTING_ICON,
          //   'title': WMSLocalizations.i18n(context)!
          //       .instruction_input_tab_button_print,
          // },
        ];
        return Column(
          children: [
            Container(
              child: Wrap(
                children: _initButtonLeftList(_buttonLeftItemList, state),
              ),
            ),
            Container(
              child: Row(
                children: _initButtonRightList(_buttonRightItemList, state),
              ),
            ),
            Divider(thickness: 1),
            WMSTableWidget<ShipmentDeterminationBloc,
                ShipmentDeterminationModel>(
              operatePopupHeight: 100,
              headTitle: 'id',
              columns: [
                //ID
                {
                  'key': 'id',
                  'width': 0.5,
                  'title': 'ID',
                },
                //出荷指示番号
                {
                  'key': 'ship_no',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_form_basic_1,
                },
                //出荷指示日
                {
                  'key': 'rcv_sch_date',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_form_basic_3,
                },
                //纳入日
                {
                  'key': 'cus_rev_date',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_form_basic_5,
                },
                //得意先
                {
                  'key': 'customer_name',
                  'width': 0.5,
                  'title':
                      WMSLocalizations.i18n(context)!.exit_input_form_title_3,
                },
                //纳入先
                {
                  'key': 'name',
                  'width': 0.5,
                  'title':
                      WMSLocalizations.i18n(context)!.exit_input_form_title_4,
                },
                //出荷状态
                {
                  'key': 'ship_kbn_meg',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!
                      .display_instruction_shipping_status,
                },
              ],
              // //复选框
              // showCheckboxColumn: true,
              // 操作弹窗
              operatePopupOptions: [
                //明细
                {
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_tab_button_details,
                  'callback': (_, value) {
                    // 持久化状态更新
                    StoreProvider.of<WMSState>(context).dispatch(
                        RefreshCurrentPageAction(Config.PAGE_FLAG_60_3_26));
                    //传递数据
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentParamAction(value));
                    try {
                      //出荷指示id
                      int shipId = value['id'];
                      String shipNo = value['ship_no'];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShipmentDeterminationPageDetail(
                              shipId: shipId, shipNo: shipNo),
                        ),
                      );
                    } catch (e) {
                      print('Invalid shipId: $e');
                    }
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
