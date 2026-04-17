import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../bloc/inventory_confirmed_bloc.dart';
import '../bloc/inventory_confirmed_model.dart';

/**
 * content：棚卸確定-表格
 * author：张博睿
 * date：2023/08/30
 */
class InventoryConfirmedTable extends StatefulWidget {
  const InventoryConfirmedTable({super.key});

  @override
  State<InventoryConfirmedTable> createState() =>
      _InventoryConfirmedTableState();
}

class _InventoryConfirmedTableState extends State<InventoryConfirmedTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 62, 0, 30),
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: InventoryConfirmedTableTab(),
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
                    child: InventoryConfirmedTableButton(),
                  ),
                  InventoryConfirmedTableContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 棚卸確定-表格Tab
class InventoryConfirmedTableTab extends StatefulWidget {
  InventoryConfirmedTableTab({super.key});

  @override
  State<InventoryConfirmedTableTab> createState() =>
      _InventoryConfirmedTableTabState();
}

class _InventoryConfirmedTableTabState
    extends State<InventoryConfirmedTableTab> {
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
                .read<InventoryConfirmedBloc>()
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
                                .read<InventoryConfirmedBloc>()
                                .state
                                .sum1
                                .toString()
                            : tabItemList[i]['index'] == Config.NUMBER_ONE
                                ? context
                                    .read<InventoryConfirmedBloc>()
                                    .state
                                    .sum2
                                    .toString()
                                : tabItemList[i]['index'] == Config.NUMBER_TWO
                                    ? context
                                        .read<InventoryConfirmedBloc>()
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
        'title':
            WMSLocalizations.i18n(context)!.Inventory_Confirmed_Table_Tab_1,
      },
      {
        'index': Config.NUMBER_ONE,
        'title':
            WMSLocalizations.i18n(context)!.Inventory_Confirmed_Table_Tab_2,
      },
      {
        'index': Config.NUMBER_TWO,
        'title':
            WMSLocalizations.i18n(context)!.Inventory_Confirmed_Table_Tab_3,
      },
    ];

    return BlocBuilder<InventoryConfirmedBloc, InventoryConfirmedModel>(
      builder: (context, state) {
        return Row(
          children: _initTabList(_tabItemList),
        );
      },
    );
  }
}

// 棚卸確定-表格按钮
class InventoryConfirmedTableButton extends StatefulWidget {
  const InventoryConfirmedTableButton({super.key});

  @override
  State<InventoryConfirmedTableButton> createState() =>
      _InventoryConfirmedTableButtonState();
}

class _InventoryConfirmedTableButtonState
    extends State<InventoryConfirmedTableButton> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, InventoryConfirmedModel state) {
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
            WMSLocalizations.i18n(context)!.Inventory_Confirmed_Table_3,
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
                                context.read<InventoryConfirmedBloc>().add(
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
                            context.read<InventoryConfirmedBloc>().add(
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
                    .read<InventoryConfirmedBloc>()
                    .add(RecordCheckAllEvent(true));
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 全部取消
                context
                    .read<InventoryConfirmedBloc>()
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

  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 赵士淞 - 始
      // 检索确认标记
      var queryConfirmFlg =
          context.read<InventoryConfirmedBloc>().state.queryConfirmFlg;
      // 判断检索确认标记长度
      if (queryConfirmFlg.length == 1) {
        // 判断检索确认标记和按钮下标
        if (queryConfirmFlg[0] == '2' &&
            buttonItemList[i]['index'] == Config.NUMBER_ONE) {
          // 跳过当前循环
          continue;
        } else if (queryConfirmFlg[0] == '1' &&
            buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
          // 跳过当前循环
          continue;
        }
      }
      // 赵士淞 - 终
      // 悬停追踪
      bool _stop = false;
      // 按钮列表
      buttonList.add(
        Container(
          child: StatefulBuilder(
            builder: (context, setState) {
              return MouseRegion(
                onEnter: (event) {
                  setState(() {
                    _stop = !_stop;
                  });
                },
                onExit: (event) {
                  setState(() {
                    _stop = !_stop;
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    // 判断循环下标
                    if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                      // 确认事件
                      context
                          .read<InventoryConfirmedBloc>()
                          .add(ConfirmedEvent(Config.NUMBER_ONE, {}));
                    } else {
                      // 取消事件
                      context
                          .read<InventoryConfirmedBloc>()
                          .add(CancelEvent(Config.NUMBER_ONE, {}));
                    }
                  },
                  child: Container(
                    height: 37,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                    decoration: BoxDecoration(
                      color: _stop
                          ? Color.fromRGBO(0, 122, 255, .6)
                          : Colors.white,
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
        ),
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
            WMSLocalizations.i18n(context)!.Inventory_Confirmed_Table_Buttton_1,
        'sort': false,
      },
      {
        'index': Config.NUMBER_ONE,
        'title':
            WMSLocalizations.i18n(context)!.Inventory_Confirmed_Table_Buttton_2,
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
        'title':
            WMSLocalizations.i18n(context)!.Inventory_Confirmed_Table_Buttton_3,
      },
      {
        'index': Config.NUMBER_ONE,
        'icon': WMSICons.WAREHOUSE_DETAILS_ICON,
        'title':
            WMSLocalizations.i18n(context)!.Inventory_Confirmed_Table_Buttton_4,
      },
    ];

    return BlocBuilder<InventoryConfirmedBloc, InventoryConfirmedModel>(
      builder: (context, state) {
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
      },
    );
  }
}

class InventoryConfirmedTableContent extends StatefulWidget {
  const InventoryConfirmedTableContent({super.key});

  @override
  State<InventoryConfirmedTableContent> createState() =>
      _InventoryConfirmedTableContentState();
}

class _InventoryConfirmedTableContentState
    extends State<InventoryConfirmedTableContent> {
  @override
  Widget build(BuildContext context) {
    return WMSTableWidget<InventoryConfirmedBloc, InventoryConfirmedModel>(
      columns: [
        {
          'key': 'id',
          'width': 4,
          'title': WMSLocalizations.i18n(context)!.Inventory_Confirmed_Table_1,
        },
        {
          'key': 'warehouse_name',
          'width': 4,
          'title': WMSLocalizations.i18n(context)!.Inventory_Confirmed_Table_2,
        },
        {
          'key': 'start_date',
          'width': 4,
          'title': WMSLocalizations.i18n(context)!.Inventory_Confirmed_Table_3,
        },
        {
          'key': 'confirm_name',
          'width': 4,
          'title': WMSLocalizations.i18n(context)!.Inventory_Confirmed_Table_4,
        },
      ],

      // 多选框
      showCheckboxColumn: true,
    );
  }
}
