import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/file/wms_common_file.dart';
import 'package:wms/page/biz/store/adjust_inquiry/bloc/inventory_adjust_inquiry_bloc.dart';
import 'package:wms/page/biz/store/adjust_inquiry/bloc/inventory_adjust_inquiry_model.dart';
import 'package:wms/page/biz/store/adjust_inquiry/pc/inventory_adjust_inquiry_search.dart';
import 'package:wms/widget/table/bloc/wms_record_model.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';
import 'package:wms/widget/table/pc/wms_table_widget.dart';
import 'package:wms/widget/wms_dialog_widget.dart';

/**
 * content：在庫調整照会-表格
 * author：张博睿
 * date：2023/08/28
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
//按钮是否选中
bool flag = false;

class InventoryAdjustInquiryTable extends StatefulWidget {
  const InventoryAdjustInquiryTable({super.key});

  @override
  State<InventoryAdjustInquiryTable> createState() =>
      _InventoryAdjustInquiryTableState();
}

class _InventoryAdjustInquiryTableState
    extends State<InventoryAdjustInquiryTable> {
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
    return BlocBuilder<InventoryAdjustInquiryBloc, InventoryAdjustInquiryModel>(
        builder: (context, state) {
      return Container(
        child: Column(
          children: [
            //检索按钮弹框,未完成
            Container(
              child: InventoryAdjustInquirySearch(
                onSearchValue: () {
                  // 调用方法赋值并检索数据
                  context
                      .read<InventoryAdjustInquiryBloc>()
                      .add(PageQueryEvent());
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
                      state.locationBefore.id != null) &&
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
                                  .adjust_inquiry_note_1,
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
                                .adjust_inquiry_note_2,
                            state.productCode),
                      ),
                      Visibility(
                        visible: state.productName != '',
                        child: buildCondition(
                            WMSLocalizations.i18n(context)!
                                .adjust_inquiry_note_3,
                            state.productName),
                      ),
                      Visibility(
                        visible: state.queryLocCode != '',
                        child: buildCondition(
                            WMSLocalizations.i18n(context)!
                                .adjust_inquiry_note_4,
                            state.queryLocCode),
                      ),
                      Visibility(
                        visible: state.adjustDate != '',
                        child: buildCondition(
                            WMSLocalizations.i18n(context)!
                                .adjust_inquiry_note_5,
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
                child: InventoryAdjustInquiryTableTab(
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
                child: InventoryAdjustInquiryTableContent(
                  state: state,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  //检索条件内部数据
  BlocBuilder<InventoryAdjustInquiryBloc, InventoryAdjustInquiryModel>
      buildCondition(String queryLabel, String queryValue) {
    return BlocBuilder<InventoryAdjustInquiryBloc, InventoryAdjustInquiryModel>(
        builder: (bloc, state) {
      return Container(
        margin: EdgeInsets.only(right: 10, bottom: 8),
        padding: EdgeInsets.only(left: 10, right: 10),
        height: 35,
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
                    overflow: TextOverflow.ellipsis,
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
                                .adjust_inquiry_note_2) {
                          context
                              .read<InventoryAdjustInquiryBloc>()
                              .add(SetProductCodeEvent(''));
                          context
                              .read<InventoryAdjustInquiryBloc>()
                              .add(PageQueryEvent());
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .adjust_inquiry_note_3) {
                          context
                              .read<InventoryAdjustInquiryBloc>()
                              .add(SetProductNameEvent(''));
                          context
                              .read<InventoryAdjustInquiryBloc>()
                              .add(PageQueryEvent());
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .adjust_inquiry_note_4) {
                          bloc
                              .read<InventoryAdjustInquiryBloc>()
                              .add(SetAdjustInquiryEvent("id", ''));
                          bloc
                              .read<InventoryAdjustInquiryBloc>()
                              .add(SetAdjustInquiryEvent("loc_cd", ''));
                          context
                              .read<InventoryAdjustInquiryBloc>()
                              .add(PageQueryEvent());
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .adjust_inquiry_note_5) {
                          context
                              .read<InventoryAdjustInquiryBloc>()
                              .add(SetMoveDateEvent(''));
                          context
                              .read<InventoryAdjustInquiryBloc>()
                              .add(PageQueryEvent());
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

// ignore: must_be_immutable
class InventoryAdjustInquiryTableTab extends StatefulWidget {
  // 初始化一覧表格
  List initTableList;
  InventoryAdjustInquiryTableTab({
    super.key,
    required this.initTableList,
  });

  @override
  State<InventoryAdjustInquiryTableTab> createState() =>
      _InventoryAdjustInquiryTableTab();
}

class _InventoryAdjustInquiryTableTab
    extends State<InventoryAdjustInquiryTableTab> {
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
    return BlocBuilder<InventoryAdjustInquiryBloc, InventoryAdjustInquiryModel>(
        builder: (context, state) {
      // Tab单个列表
      List _tabItemList = [
        {
          'index': Config.NUMBER_ZERO,
          'title': WMSLocalizations.i18n(context)!.adjust_inquiry_tab_list,
          'number': state.total
        },
      ];

      return Row(
        children: _initTabList(_tabItemList),
      );
    });
  }
}

// 在庫調整照会-表格内容
// ignore: must_be_immutable
class InventoryAdjustInquiryTableContent extends StatefulWidget {
  // 在庫移動照会-参数
  InventoryAdjustInquiryModel state;
  InventoryAdjustInquiryTableContent({super.key, required this.state});

  @override
  State<InventoryAdjustInquiryTableContent> createState() =>
      _InventoryAdjustInquiryTableContentState();
}

class _InventoryAdjustInquiryTableContentState
    extends State<InventoryAdjustInquiryTableContent> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, InventoryAdjustInquiryModel state) {
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
            WMSLocalizations.i18n(context)!.adjust_inquiry_table_2,
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
            WMSLocalizations.i18n(context)!.adjust_inquiry_table_4,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'to_location_code',
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
                                context.read<InventoryAdjustInquiryBloc>().add(
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
                            context.read<InventoryAdjustInquiryBloc>().add(
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
                    .read<InventoryAdjustInquiryBloc>()
                    .add(RecordCheckAllEvent(true));
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 全部取消
                context
                    .read<InventoryAdjustInquiryBloc>()
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
  _initButtonRightList(List buttonItemList, InventoryAdjustInquiryModel state) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 悬停追踪
      bool _stop = false;
      // 按钮列表
      buttonList.add(
        Container(
          child: StatefulBuilder(builder: (context, setState) {
            // 使用StatefulBuilder包裹每个按钮
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
                    // csv 按钮
                    if (state.checkedRecords().length > 0) {
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
                      // 导入CSV文件
                      WMSCommonFile().exportCSVFile([
                        'id',
                        'code',
                        'name',
                        'from_location_code',
                        'before_ad_num',
                        'after_ad_num',
                        'adjust_date',
                        'adjust_reason'
                      ], contentList,
                          WMSLocalizations.i18n(context)!.menu_content_4_18);
                    } else {
                      _showTipDialog(
                        WMSLocalizations.i18n(context)!.menu_content_2_5_13,
                      );
                    }
                  } else {
                    print('');
                  }
                },
                child: Container(
                  height: 37,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
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
          }),
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

    // 右侧按钮单个列表
    List _buttonRightItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'icon': WMSICons.INSTRUCTION_INPUT_FILE_CSV,
        'title':
            WMSLocalizations.i18n(context)!.adjust_inquiry_tab_button_printing,
      },
    ];

    return BlocBuilder<InventoryAdjustInquiryBloc, InventoryAdjustInquiryModel>(
      builder: (context, state) => Column(
        children: [
          Container(
            height: 37,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
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
          ),
          WMSTableWidget<InventoryAdjustInquiryBloc,
              InventoryAdjustInquiryModel>(
            isFlex: false,
            columns: [
              {
                'key': 'id',
                'width': 80,
                'title': WMSLocalizations.i18n(context)!.adjust_inquiry_table_1,
              },
              {
                'key': 'code',
                'width': 240,
                'title': WMSLocalizations.i18n(context)!.adjust_inquiry_table_2,
              },
              {
                'key': 'name',
                'width': 300,
                'title': WMSLocalizations.i18n(context)!.adjust_inquiry_table_3,
              },
              {
                'key': 'to_location_code',
                'width': 200,
                'title': WMSLocalizations.i18n(context)!.adjust_inquiry_table_4,
              },
              {
                'key': 'before_ad_num',
                'width': 80,
                'title': WMSLocalizations.i18n(context)!.adjust_inquiry_table_5,
              },
              {
                'key': 'after_ad_num',
                'width': 80,
                'title': WMSLocalizations.i18n(context)!.adjust_inquiry_table_6,
              },
              {
                'key': 'adjust_date',
                'width': 180,
                'title': WMSLocalizations.i18n(context)!.adjust_inquiry_table_7,
              },
              {
                'key': 'adjust_reason',
                'width': 400,
                'title': WMSLocalizations.i18n(context)!.adjust_inquiry_table_8,
              },
            ],
          ),
        ],
      ),
    );
  }
}
