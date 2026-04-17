import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../bloc/shipment_confirmation_export_bloc.dart';
import '../bloc/shipment_confirmation_export_model.dart';

/**
 * 内容：出荷確定データ出力-表格
 * 作者：张博睿
 * 时间：2023/08/22
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List currentContent = [];
// 当前选择内容
List currentCheckContent = [];

class ShipmentConfirmationExportTable extends StatefulWidget {
  const ShipmentConfirmationExportTable({super.key});

  @override
  State<ShipmentConfirmationExportTable> createState() =>
      _ShipmentConfirmationExportTable();
}

class _ShipmentConfirmationExportTable
    extends State<ShipmentConfirmationExportTable> {
  @override
  Widget build(BuildContext context) {
    // 判断当前下标
    return Container(
      margin: EdgeInsets.fromLTRB(0, 80, 0, 80),
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ShipmentConfirmationExportTableTab(),
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
                    child: ShipmentConfirmationExportTableButton(),
                  ),
                  ShipmentConfirmationExportTableContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 出荷確定データ出力-表格Tab
// ignore: must_be_immutable
class ShipmentConfirmationExportTableTab extends StatefulWidget {
  // 初始化一覧表格

  ShipmentConfirmationExportTableTab({
    super.key,
  });

  @override
  State<ShipmentConfirmationExportTableTab> createState() =>
      _ShipmentConfirmationExportTableTabState();
}

class _ShipmentConfirmationExportTableTabState
    extends State<ShipmentConfirmationExportTableTab> {
  // ignore: unused_field
  bool _hover = false;
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, state) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        StatefulBuilder(builder: (context, setState) {
          return MouseRegion(
            onEnter: (event) {
              setState(() {
                _hover = true;
              });
            },
            onExit: (event) {
              setState(() {
                _hover = false;
              });
            },
            child: GestureDetector(
              onPanDown: (details) {
                // 判断下标
                if (tabItemList[i]['index'] == Config.NUMBER_ZERO) {
                  // 状态变更
                  setState(() {
                    // 当前内容
                  });
                } else {
                  // 状态变更
                  setState(() {
                    // 当前内容
                    currentContent = [];
                  });
                }
                // 状态变更
                setState(() {
                  // 当前下标
                  currentIndex = tabItemList[i]['index'];
                });
              },
              child: Container(
                height: 46,
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
                            state.total.toString(),
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
        }),
      );
    }
    // Tab列表
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    // Tab单个列表
    return BlocBuilder<ShipmentConfirmationExportBloc,
        ShipmentConfirmationExportModel>(
      builder: (context, state) {
        List _tabItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'title': WMSLocalizations.i18n(context)!.instruction_input_tab_list,
          },
        ];

        return Row(
          children: _initTabList(_tabItemList, state),
        );
      },
    );
  }
}

// 出荷確定データ出力-表格按钮
class ShipmentConfirmationExportTableButton extends StatefulWidget {
  const ShipmentConfirmationExportTableButton({super.key});

  @override
  State<ShipmentConfirmationExportTableButton> createState() =>
      _ShipmentConfirmationExportTableButtonState();
}

class _ShipmentConfirmationExportTableButtonState
    extends State<ShipmentConfirmationExportTableButton> {
  // 初始化左侧按钮列表
  _initButtonLeftList(
      List buttonItemList, ShipmentConfirmationExportModel state) {
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
                                context
                                    .read<ShipmentConfirmationExportBloc>()
                                    .add(SetSortEvent(
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
                            context.read<ShipmentConfirmationExportBloc>().add(
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
                    .read<ShipmentConfirmationExportBloc>()
                    .add(RecordCheckAllEvent(true));
                // 全部选择
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 全部取消
                context
                    .read<ShipmentConfirmationExportBloc>()
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

  // 悬停追踪
  bool _stop = false;
  void setStop(stop) {
    setState(() {
      _stop = stop;
    });
  }

  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        MouseRegion(
          onEnter: (event) {
            setState(() {
              setStop(true);
            });
          },
          onExit: (event) {
            setState(() {
              setStop(false);
            });
          },
          child: GestureDetector(
            onTap: () {
              // 判断循环下标
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                // csv 按钮
                context
                    .read<ShipmentConfirmationExportBloc>()
                    .add(OutputCSVFileEvent(context));
              } else {
                print('');
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
                      color:
                          _stop ? Colors.white : Color.fromRGBO(0, 122, 255, 1),
                    ),
                  ),
                  Text(
                    buttonItemList[i]['title'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color:
                          _stop ? Colors.white : Color.fromRGBO(0, 122, 255, 1),
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentConfirmationExportBloc,
        ShipmentConfirmationExportModel>(builder: (context, state) {
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
          'icon': WMSICons.WAREHOUSE_CSV_ICON,
          'title':
              WMSLocalizations.i18n(context)!.instruction_input_tab_button_csv,
        },
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
                  children: _initButtonRightList(_buttonRightItemList),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// 出荷確定データ出力-表格内容
class ShipmentConfirmationExportTableContent extends StatefulWidget {
  const ShipmentConfirmationExportTableContent({super.key});

  @override
  State<ShipmentConfirmationExportTableContent> createState() =>
      _ShipmentConfirmationExportTableContentState();
}

class _ShipmentConfirmationExportTableContentState
    extends State<ShipmentConfirmationExportTableContent> {
  @override
  Widget build(BuildContext context) {
    return WMSTableWidget<ShipmentConfirmationExportBloc,
        ShipmentConfirmationExportModel>(
      columns: [
        {
          'key': 'id',
          'width': 2,
          'title': WMSLocalizations.i18n(context)!
              .shipment_confirmation_export_table_title_1,
        },
        {
          'key': 'ship_no',
          'width': 6,
          'title': WMSLocalizations.i18n(context)!
              .shipment_confirmation_export_table_title_2,
        },
        {
          'key': 'rcv_sch_date',
          'width': 3,
          'title': WMSLocalizations.i18n(context)!
              .shipment_confirmation_export_table_title_3,
        },
        {
          'key': 'rcv_real_date',
          'width': 3,
          'title': WMSLocalizations.i18n(context)!
              .shipment_confirmation_export_query_1,
        },
        {
          'key': 'cus_rev_date',
          'title': WMSLocalizations.i18n(context)!
              .shipment_confirmation_export_table_title_4,
        },
        {
          'key': 'customer_name',
          'width': 3,
          'title': WMSLocalizations.i18n(context)!
              .shipment_confirmation_export_table_title_5,
        },
        {
          'key': 'name',
          'width': 3,
          'title': WMSLocalizations.i18n(context)!
              .shipment_confirmation_export_table_title_6,
        },
      ],
      showCheckboxColumn: true,
    );
  }
}
