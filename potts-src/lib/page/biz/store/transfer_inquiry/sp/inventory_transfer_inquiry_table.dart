// ignore_for_file: unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/biz/store/transfer_inquiry/bloc/inventory_transfer_inquiry_bloc.dart';
import 'package:wms/page/biz/store/transfer_inquiry/bloc/inventory_transfer_inquiry_model.dart';
import 'package:wms/page/biz/store/transfer_inquiry/sp/inventory_transfer_inquiry_search.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';
import 'package:wms/widget/table/sp/wms_table_widget.dart';

/**
 * content：在庫移動照会-表格SP
 * author：张博睿
 * date：2023/11/24
 */

// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 通信数据
List<Map<String, dynamic>> commData = [];
// 当前内容
List currentContent = [];
// 当前选择内容
List currentCheckContent = [];
//引当选中数据
List<dynamic>? LockNumData;
// 絞り込み検索是否打开
bool flag = false;

class InventoryTransferInquiryTable extends StatefulWidget {
  const InventoryTransferInquiryTable({super.key});

  @override
  State<InventoryTransferInquiryTable> createState() =>
      _InventoryTransferInquiryTableState();
}

class _InventoryTransferInquiryTableState
    extends State<InventoryTransferInquiryTable> {
  @override
  Widget build(BuildContext context) {
    // 判断当前下标
    if (currentIndex == Config.NUMBER_ZERO) {
      // 状态变更
      setState(() {
        // 当前内容
        currentContent = [];
      });
    }

    return BlocBuilder<InventoryTransferInquiryBloc,
        InventoryTransferInquiryModel>(
      builder: (context, state) {
        return Container(
          child: Column(
            children: [
              //检索按钮弹框
              Container(
                child: InventoryTransferInquirySearch(
                  onSearchValue: () {
                    // 调用方法赋值并检索数据
                    context
                        .read<InventoryTransferInquiryBloc>()
                        .add(SetLoadingFlagEvent());
                  },
                  onValueChanged: (bool value) {
                    setState(() {
                      flag = value;
                    });
                  },
                  onbottomChanged: (bool value) {},
                ),
              ),
              Visibility(
                visible: (state.productCode != '' ||
                        state.productName != '' ||
                        state.adjustDate != '' ||
                        state.locationBefore.id != null ||
                        state.locationAfter.id != null) &&
                    !flag,
                child: Container(
                  // 检索条件小框
                  constraints: BoxConstraints(
                    minHeight: 50,
                  ),
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.only(left: 20, top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black12,
                      width: 1.0,
                    ),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10, bottom: 8),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          height: 35,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                WMSLocalizations.i18n(context)!
                                    .transfer_inquiry_note_1,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 122, 255, 1)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Visibility(
                          visible: state.productCode != '',
                          child: buildCondition(
                              WMSLocalizations.i18n(context)!
                                  .transfer_inquiry_note_2,
                              state.productCode),
                        ),
                        Visibility(
                          visible: state.productName != '',
                          child: buildCondition(
                              WMSLocalizations.i18n(context)!
                                  .transfer_inquiry_note_3,
                              state.productName),
                        ),
                        Visibility(
                          visible: state.queryFromLocCode != '',
                          child: buildCondition(
                              WMSLocalizations.i18n(context)!
                                  .transfer_inquiry_note_4,
                              state.queryFromLocCode),
                        ),
                        Visibility(
                          visible: state.queryToLocCode != '',
                          child: buildCondition(
                              WMSLocalizations.i18n(context)!
                                  .transfer_inquiry_note_5,
                              state.queryToLocCode),
                        ),
                        Visibility(
                          visible: state.adjustDate != '',
                          child: buildCondition(
                              WMSLocalizations.i18n(context)!
                                  .transfer_inquiry_note_6,
                              state.adjustDate),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [],
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: InventoryTransferInquiryTableTab(
                    initTableList: [],
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
                  child: InventoryTransferInquiryTableContent(
                    state: state,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //检索条件内部数据
  BlocBuilder<InventoryTransferInquiryBloc, InventoryTransferInquiryModel>
      buildCondition(String queryLabel, String queryValue) {
    return BlocBuilder<InventoryTransferInquiryBloc,
        InventoryTransferInquiryModel>(builder: (bloc, state) {
      return Container(
        margin: EdgeInsets.only(right: 10, bottom: 8),
        padding: EdgeInsets.only(left: 10, right: 10),
        constraints: BoxConstraints(minHeight: 35),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: Colors.black12,
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  child: Text(
                    queryLabel + ':' + queryValue,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(156, 156, 156, 1),
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    setState(
                      () {
                        if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .transfer_inquiry_note_2) {
                          bloc
                              .read<InventoryTransferInquiryBloc>()
                              .add(SetProductCodeEvent(''));
                          context
                              .read<InventoryTransferInquiryBloc>()
                              .add(SetLoadingFlagEvent());
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .transfer_inquiry_note_3) {
                          bloc
                              .read<InventoryTransferInquiryBloc>()
                              .add(SetProductNameEvent(''));
                          context
                              .read<InventoryTransferInquiryBloc>()
                              .add(SetLoadingFlagEvent());
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .transfer_inquiry_note_4) {
                          bloc
                              .read<InventoryTransferInquiryBloc>()
                              .add(SetTransferInquiryEvent("id", '', "Before"));
                          bloc.read<InventoryTransferInquiryBloc>().add(
                              SetTransferInquiryEvent("loc_cd", '', "Before"));
                          context
                              .read<InventoryTransferInquiryBloc>()
                              .add(SetLoadingFlagEvent());
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .transfer_inquiry_note_5) {
                          bloc
                              .read<InventoryTransferInquiryBloc>()
                              .add(SetTransferInquiryEvent("id", '', "After"));
                          bloc.read<InventoryTransferInquiryBloc>().add(
                              SetTransferInquiryEvent("loc_cd", '', "After"));
                          context
                              .read<InventoryTransferInquiryBloc>()
                              .add(SetLoadingFlagEvent());
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .transfer_inquiry_note_6) {
                          bloc
                              .read<InventoryTransferInquiryBloc>()
                              .add(SetMoveDateEvent(''));
                          context
                              .read<InventoryTransferInquiryBloc>()
                              .add(SetLoadingFlagEvent());
                        }
                      },
                    );
                  },
                  child: Icon(
                    Icons.close,
                    color: Color.fromRGBO(156, 156, 156, 1),
                    size: 14,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}

// 在庫移動照会-表格Tab
// ignore: must_be_immutable
class InventoryTransferInquiryTableTab extends StatefulWidget {
  // 初始化一覧表格
  List initTableList;

  InventoryTransferInquiryTableTab({
    super.key,
    required this.initTableList,
  });

  @override
  State<InventoryTransferInquiryTableTab> createState() =>
      _InventoryTransferInquiryTableTabState();
}

class _InventoryTransferInquiryTableTabState
    extends State<InventoryTransferInquiryTableTab> {
  bool _hover = false;
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
            // 判断下标
            if (tabItemList[i]['index'] == Config.NUMBER_ZERO) {
              // 状态变更
              setState(() {
                // 当前内容
                currentContent = widget.initTableList;
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
            padding: EdgeInsets.fromLTRB(12, 11, 12, 11),
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
            child: Stack(
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
      );
    }
    // Tab列表
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryTransferInquiryBloc,
        InventoryTransferInquiryModel>(builder: (context, state) {
      // Tab单个列表
      List _tabItemList = [
        {
          'index': Config.NUMBER_ZERO,
          'title': WMSLocalizations.i18n(context)!.transfer_inquiry_tab_list,
          'number': state.total
        },
      ];
      return Row(
        children: _initTabList(_tabItemList),
      );
    });
  }
}

// 在庫移動照会-表格内容
// ignore: must_be_immutable
class InventoryTransferInquiryTableContent extends StatefulWidget {
  // 在庫移動照会-参数
  InventoryTransferInquiryModel state;

  InventoryTransferInquiryTableContent({super.key, required this.state});

  @override
  State<InventoryTransferInquiryTableContent> createState() =>
      _InventoryTransferInquiryTableContentState();
}

class _InventoryTransferInquiryTableContentState
    extends State<InventoryTransferInquiryTableContent> {
  // 初始化左侧按钮列表
  _initButtonLeftList(
      List buttonItemList, InventoryTransferInquiryModel state) {
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
            WMSLocalizations.i18n(context)!.transfer_inquiry_table_2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'code',
      );
      items.add(dropdownMenuItem2);
      DropdownMenuItem<String> dropdownMenuItem3 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.transfer_inquiry_table_3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'from_location_code',
      );
      items.add(dropdownMenuItem3);
      DropdownMenuItem<String> dropdownMenuItem4 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.transfer_inquiry_table_4,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'to_location_code',
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
                                context
                                    .read<InventoryTransferInquiryBloc>()
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
                            context.read<InventoryTransferInquiryBloc>().add(
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
                    .read<InventoryTransferInquiryBloc>()
                    .add(RecordCheckAllEvent(true));
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 全部取消
                context
                    .read<InventoryTransferInquiryBloc>()
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

  @override
  Widget build(BuildContext context) {
    // 左侧按钮单个列表
    List _buttonLeftItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title':
            WMSLocalizations.i18n(context)!.transfer_inquiry_tab_button_choice,
        'sort': false,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!
            .transfer_inquiry_tab_button_cancellation,
        'sort': false,
      },
      {
        'index': Config.NUMBER_THREE,
        'title': WMSLocalizations.i18n(context)!.table_sort_column,
        'sort': true,
      },
    ];

    return BlocBuilder<InventoryTransferInquiryBloc,
        InventoryTransferInquiryModel>(
      builder: (context, state) => Column(
        children: [
          Container(
            // height: 37,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
            child: Stack(
              children: [
                Container(
                  child: Wrap(
                    children: _initButtonLeftList(_buttonLeftItemList, state),
                  ),
                ),
              ],
            ),
          ),
          WMSTableWidget<InventoryTransferInquiryBloc,
              InventoryTransferInquiryModel>(
            columns: [
              {
                'key': 'id',
                'width': 0.5,
                'title':
                    WMSLocalizations.i18n(context)!.transfer_inquiry_table_1,
              },
              {
                'key': 'code',
                'width': 0.5,
                'title':
                    WMSLocalizations.i18n(context)!.transfer_inquiry_table_2,
              },
              {
                'key': 'from_location_code',
                'width': 0.5,
                'title':
                    WMSLocalizations.i18n(context)!.transfer_inquiry_table_3,
              },
              {
                'key': 'to_location_code',
                'width': 0.5,
                'title':
                    WMSLocalizations.i18n(context)!.transfer_inquiry_table_4,
              },
              {
                'key': 'name',
                'width': 0.5,
                'title':
                    WMSLocalizations.i18n(context)!.transfer_inquiry_table_5,
              },
              {
                'key': 'move_num',
                'width': 0.5,
                'title':
                    WMSLocalizations.i18n(context)!.transfer_inquiry_table_6,
              },
              {
                'key': 'adjust_date',
                'width': 0.5,
                'title':
                    WMSLocalizations.i18n(context)!.transfer_inquiry_table_7,
              },
              {
                'key': 'adjust_reason',
                'width': 0.5,
                'title':
                    WMSLocalizations.i18n(context)!.transfer_inquiry_table_8,
              },
            ],
          ),
        ],
      ),
    );
  }
}
