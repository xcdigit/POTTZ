import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/common/utils/common_utils.dart';
import 'package:wms/page/biz/stocktaking/inventory_output/bloc/inventory_output_bloc.dart';
import 'package:wms/page/biz/stocktaking/inventory_output/bloc/inventory_output_model.dart';
import 'package:wms/redux/wms_state.dart';
import 'package:wms/widget/wms_dialog_widget.dart';
import 'package:wms/widget/table/pc/wms_table_widget.dart';

import '../../../../../file/wms_common_file.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';

/**
 * 内容：棚卸データ出力
 * 作者：王光顺
 * 时间：2023/08/30
 */
class InventoryOutputTable extends StatefulWidget {
  const InventoryOutputTable({super.key});

  @override
  State<InventoryOutputTable> createState() => _InventoryOutputTableState();
}

class _InventoryOutputTableState extends State<InventoryOutputTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 80, 20, 80),
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IncomeConfirmationTableTab(),
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
                    child: IncomeConfirmationTableButton(),
                  ),
                  IncomeConfirmationTableContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 出荷确定-表格Tab
// ignore: must_be_immutable
class IncomeConfirmationTableTab extends StatefulWidget {
  IncomeConfirmationTableTab({super.key});

  @override
  State<IncomeConfirmationTableTab> createState() =>
      _IncomeConfirmationTableTabState();
}

class _IncomeConfirmationTableTabState
    extends State<IncomeConfirmationTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, InventoryOutputModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        GestureDetector(
          onPanDown: (details) {
            // 当前下标变更事件
            context
                .read<InventoryOutputBloc>()
                .add(CurrentIndexChangeEvent(tabItemList[i]['index']));
          },
          child: Container(
            height: 46,
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
                                  ? state.num1.toString()
                                  : state.num2.toString(),
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
                              (state.num1 + state.num2).toString(),
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
        'title': WMSLocalizations.i18n(context)!.inventory_output_1,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!.inventory_output_6,
      },
      {
        'index': Config.NUMBER_TWO,
        'title': WMSLocalizations.i18n(context)!.inventory_output_7,
      },
    ];
    return BlocBuilder<InventoryOutputBloc, InventoryOutputModel>(
      builder: (context, state) => Row(
        children: _initTabList(_tabItemList, state),
      ),
    );
  }
}

// 出荷确定-表格按钮
class IncomeConfirmationTableButton extends StatefulWidget {
  const IncomeConfirmationTableButton({super.key});

  @override
  State<IncomeConfirmationTableButton> createState() =>
      _IncomeConfirmationTableButtonState();
}

class _IncomeConfirmationTableButtonState
    extends State<IncomeConfirmationTableButton> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, InventoryOutputModel state) {
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
            WMSLocalizations.i18n(context)!.start_inventory_date,
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
                                context.read<InventoryOutputBloc>().add(
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
                            context.read<InventoryOutputBloc>().add(
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
                    .read<InventoryOutputBloc>()
                    .add(RecordCheckAllEvent(true));
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 全部取消
                context
                    .read<InventoryOutputBloc>()
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

  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList, InventoryOutputModel state) {
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
                //提示选中一条
                if (state.checkedRecords().length != 0) {
                  // 内容列表
                  List<Map<String, dynamic>> contentList = [];
                  // csv内容列表（）
                  List<Map<String, dynamic>> contentCsvList = [];
                  // 表格选中列表
                  List<WmsRecordModel> wmsRecordModelList =
                      state.checkedRecords();
                  List<int> Idlist = [];
                  // 循环表格选中列表
                  for (int i = 0; i < wmsRecordModelList.length; i++) {
                    //防止异步执行速率导致csv_kbn的脏数据产生，新建contentCsvList写死csv_kbn状态，去csv，防止影响页面展示
                    contentList.add(wmsRecordModelList[i].data);
                    contentCsvList.add(wmsRecordModelList[i].data);
                    Idlist.add(
                        wmsRecordModelList[i].data['id']); //装入id集合给bloc执行db更新
                    if (contentCsvList[i]['csv_kbn'] == '未連携') {
                      //导入前先改变新建list中csv_kbn状态
                      contentCsvList[i]['csv_kbn'] = '連携済';
                    }
                  }

                  //更新db
                  state.records.clear();
                  //
                  context.read<InventoryOutputBloc>().add(SetCsvEvent(Idlist));
                  // 插入操作履历 sys_log表
                  CommonUtils().createLogInfo(
                      '棚卸データCSV' +
                          Config.OPERATION_TEXT1 +
                          Config.OPERATION_BUTTON_TEXT10 +
                          Config.OPERATION_TEXT2,
                      "SetcsvEvent()",
                      StoreProvider.of<WMSState>(context)
                          .state
                          .loginUser!
                          .company_id,
                      StoreProvider.of<WMSState>(context).state.loginUser!.id);

                  // 导入CSV文件
                  WMSCommonFile().exportCSVFile(
                      ['id', 'name', 'start_date', 'confirm_flg', 'csv_kbn'],
                      contentCsvList,
                      '棚卸データ出力');
                } else {
                  // 错误提示
                  WMSCommonBlocUtils.errorTextToast(
                      WMSLocalizations.i18n(context)!
                          .Inventory_Confirmed_tip_1);
                  // _showTipDialog(
                  //   WMSLocalizations.i18n(context)!.Inventory_Confirmed_tip_1,
                  // );
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

  @override
  Widget build(BuildContext context) {
    // 左侧按钮单个列表
    List _buttonLeftItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_button_choice,
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
        'index': Config.NUMBER_THREE,
        'icon': WMSICons.WAREHOUSE_CSV_ICON,
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_button_csv,
      },
    ];

    return BlocBuilder<InventoryOutputBloc, InventoryOutputModel>(
        builder: (context, state) => Container(
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
                        children:
                            _initButtonRightList(_buttonRightItemList, state),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}

//出荷确定-表格内容
class IncomeConfirmationTableContent extends StatefulWidget {
  const IncomeConfirmationTableContent({super.key});

  @override
  State<IncomeConfirmationTableContent> createState() =>
      _IncomeConfirmationTableContentState();
}

class _IncomeConfirmationTableContentState
    extends State<IncomeConfirmationTableContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryOutputBloc, InventoryOutputModel>(
        builder: (context, state) {
      return WMSTableWidget<InventoryOutputBloc, InventoryOutputModel>(
        operatePopupHeight: 100,
        //表头
        columns: [
          //id
          {
            'key': 'id',
            'width': 1,
            'title': WMSLocalizations.i18n(context)!.inventory_output_2,
          },
          //倉庫
          {
            'key': 'name',
            'width': 1,
            'title': WMSLocalizations.i18n(context)!.inventory_output_3,
          },
          //棚卸日
          {
            'key': 'start_date',
            'width': 1,
            'title': WMSLocalizations.i18n(context)!.start_inventory_date,
          },
          //確定状態
          {
            'key': 'confirm_flg',
            'width': 1,
            'title': WMSLocalizations.i18n(context)!.inventory_output_4,
          },
          //連携状態
          {
            'key': 'csv_kbn',
            'width': 1,
            'title': WMSLocalizations.i18n(context)!.inventory_output_5,
          },
        ],

        showCheckboxColumn: true,
      );
    });
  }
}
