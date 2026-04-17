import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../redux/current_page_reducer.dart';
import '../../../../../redux/current_param_reducer.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/table/sp/wms_table_widget.dart';

import '../../../../home/bloc/home_menu_bloc.dart';
import '../../../../home/bloc/home_menu_model.dart';
import '../../warehouse/bloc/warehouse_bloc.dart';
import '../../warehouse/bloc/warehouse_model.dart';

/**
 * 内容：納品書-表格
 * 作者：王光顺
 * 时间：2023/11/02
 */

// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List currentContent = [];
List currentContent_1 = [];
// 全局主键-表格共通
// GlobalKey<WMSTableWidgetState> _deliveryNoteTable = new GlobalKey();

class DataSheetPage extends StatefulWidget {
  final bool search;
  final ValueChanged<bool> onData;
  const DataSheetPage({super.key, required this.search, required this.onData});

  @override
  State<DataSheetPage> createState() => _DataSheetPageState();
}

class _DataSheetPageState extends State<DataSheetPage> {
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
              child: DeliveryNoteTab(),
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

// 纳品书-表格Tab
class DeliveryNoteTab extends StatefulWidget {
  DeliveryNoteTab({super.key});

  @override
  State<DeliveryNoteTab> createState() => _DeliveryNoteTabState();
}

class _DeliveryNoteTabState extends State<DeliveryNoteTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, WarehouseModel state) {
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
                if (tabItemList[i]['index'] == Config.NUMBER_ZERO) {
                  // 状态变更
                  setState(() {
                    context.read<WarehouseBloc>().add(QueryShipEvent(
                        ['1', '2', '3'],
                        state.conditionLabelList,
                        '',
                        state.keyword));

                    //设置当前下标
                    context
                        .read<WarehouseBloc>()
                        .add(SetValueEvent(tabItemList[i]['index']));
                  });
                } else if (tabItemList[i]['index'] == Config.NUMBER_ONE) {
                  // 状态变更
                  setState(() {
                    context.read<WarehouseBloc>().add(QueryShipEvent(
                        ['1'], state.conditionLabelList, '', state.keyword));

                    //设置当前下标
                    context
                        .read<WarehouseBloc>()
                        .add(SetValueEvent(tabItemList[i]['index']));
                  });
                } else {
                  // 状态变更
                  setState(() {
                    context.read<WarehouseBloc>().add(QueryShipEvent(['2', '3'],
                        state.conditionLabelList, '', state.keyword));

                    //设置当前下标
                    context
                        .read<WarehouseBloc>()
                        .add(SetValueEvent(tabItemList[i]['index']));
                  });
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
                      fontSize: 14,
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
                              (state.count).toString(),
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
        'title': WMSLocalizations.i18n(context)!.delivery_note_3,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!.delivery_note_4,
      },
      {
        'index': Config.NUMBER_TWO,
        'title': WMSLocalizations.i18n(context)!.delivery_note_5,
      },
    ];

    return BlocBuilder<WarehouseBloc, WarehouseModel>(
      builder: (context, state) => Row(
        children: _initTabList(_tabItemList, state),
      ),
    );
  }
}

// 纳品书-表格按钮
class DeliveryNoteTableButton extends StatefulWidget {
  const DeliveryNoteTableButton({super.key});

  @override
  State<DeliveryNoteTableButton> createState() =>
      _DeliveryNoteTableButtonState();
}

class _DeliveryNoteTableButtonState extends State<DeliveryNoteTableButton> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, WarehouseModel state) {
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
                                context.read<WarehouseBloc>().add(SetSortEvent(
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
                            context.read<WarehouseBloc>().add(SetSortEvent(
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
                context.read<WarehouseBloc>().add(RecordCheckAllEvent(true));
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 全部取消
                context.read<WarehouseBloc>().add(RecordCheckAllEvent(false));
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

  @override
  Widget build(BuildContext context) {
    // 左侧按钮单个列表
    List _buttonLeftItemList = [
      {
        'index': Config.NUMBER_THREE,
        'title': WMSLocalizations.i18n(context)!.table_sort_column,
        'sort': true,
      },
    ];
    return BlocBuilder<WarehouseBloc, WarehouseModel>(
        builder: (context, state) => Container(
              // height: 37,
              child: Wrap(
                children: [
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      child: Wrap(
                        children:
                            _initButtonLeftList(_buttonLeftItemList, state),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}

class DeliveryNoteTableContent extends StatefulWidget {
  const DeliveryNoteTableContent({super.key});

  @override
  State<DeliveryNoteTableContent> createState() =>
      _DeliveryNoteTableContentState();
}

class _DeliveryNoteTableContentState extends State<DeliveryNoteTableContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
        builder: (menuBloc, menuState) {
      return BlocBuilder<WarehouseBloc, WarehouseModel>(
          builder: (context, state) {
        return WMSTableWidget<WarehouseBloc, WarehouseModel>(
          columns: [
            {
              'key': 'id',
              'width': .2,
              'title': 'ID',
            },
            {
              'key': 'ship_no',
              'width': .8,
              'title': WMSLocalizations.i18n(context)!.delivery_note_14,
            },
            {
              'key': 'rcv_sch_date',
              'width': .5,
              'title': WMSLocalizations.i18n(context)!.delivery_note_16,
            },
            {
              'key': 'cus_rev_date',
              'width': .5,
              'title': WMSLocalizations.i18n(context)!.delivery_note_18,
            },
            {
              'key': 'customer_name',
              'width': .5,
              'title': WMSLocalizations.i18n(context)!.delivery_note_15,
            },
            {
              'key': 'name',
              'width': .5,
              'title': WMSLocalizations.i18n(context)!.delivery_note_17,
            },
          ],
          showCheckboxColumn: true,
          operatePopupOptions: [
            {
              'title': WMSLocalizations.i18n(context)!.menu_content_60_3_21,
              'callback': (_, value) {
                // 持久化状态更新
                StoreProvider.of<WMSState>(context).dispatch(
                    RefreshCurrentPageAction(Config.PAGE_FLAG_60_3_21));
                //传递数据
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentParamAction(value));

                try {
                  int shipId = value['id'];
                  menuBloc.read<HomeMenuBloc>().add(
                        PageJumpEvent(
                          '/' +
                              Config.PAGE_FLAG_3_21 +
                              '/details' +
                              '/' +
                              shipId.toString(),
                        ),
                      );
                } catch (e) {
                  print('Invalid shipId: $e');
                }
              },
            }
          ],
          operatePopupHeight: 100,
        );
      });
    });
  }
}
