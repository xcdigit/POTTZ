import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../bloc/inventory_inquiry_bloc.dart';
import '../bloc/inventory_inquiry_dialog_bloc.dart';
import '../bloc/inventory_inquiry_dialog_model.dart';
import '../bloc/inventory_inquiry_model.dart';
import 'inventory_inquiry_search.dart';

/**
 * 内容：在庫照会-表格
 * 作者：王光顺
 * 时间：2023/08/24
 * 作者：赵士淞
 * 时间：2023/10/08
 */
class InventoryInquiryTable extends StatefulWidget {
  const InventoryInquiryTable({super.key});

  @override
  State<InventoryInquiryTable> createState() => _InventoryInquiryTableState();
}

class _InventoryInquiryTableState extends State<InventoryInquiryTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryInquiryBloc, InventoryInquiryModel>(
      builder: (context, state) {
        return Container(
          child: Column(
            children: [
              InventoryInquirySearch(),
              Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 50),
                child: Column(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: InventoryInquiryTableTab(),
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
                        child: InventoryInquiryTableContent(),
                      ),
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

// 在庫照会-表格Tab
class InventoryInquiryTableTab extends StatefulWidget {
  const InventoryInquiryTableTab({super.key});

  @override
  State<InventoryInquiryTableTab> createState() =>
      _InventoryInquiryTableTabState();
}

class _InventoryInquiryTableTabState extends State<InventoryInquiryTableTab> {
  // 当前悬停下标
  int _currentHoverIndex = Config.NUMBER_NEGATIVE;

  // 初始化Tab列表
  List<Widget> _initTabList(List tabItemList, InventoryInquiryModel state) {
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
              // 表格Tab切换事件
              context
                  .read<InventoryInquiryBloc>()
                  .add(TableTabSwitchEvent(tabItemList[i]['index']));
            },
            child: Container(
              height: 46,
              padding: EdgeInsets.fromLTRB(12, 11, 12, 11),
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
                minWidth: 158,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tabItemList[i]['title'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: state.tableTabIndex == tabItemList[i]['index']
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : _currentHoverIndex == tabItemList[i]['index']
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(6, 14, 15, 1),
                      height: 1.5,
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
                        (state.total).toString(),
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
    return BlocBuilder<InventoryInquiryBloc, InventoryInquiryModel>(
      builder: (context, state) {
        // Tab单个列表
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

// 在庫照会-表格内容
class InventoryInquiryTableContent extends StatefulWidget {
  const InventoryInquiryTableContent({super.key});

  @override
  State<InventoryInquiryTableContent> createState() =>
      _InventoryInquiryTableContentState();
}

class _InventoryInquiryTableContentState
    extends State<InventoryInquiryTableContent> {
  // 当前悬停下标
  int _currentHoverIndex = Config.NUMBER_NEGATIVE;

  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, InventoryInquiryModel state) {
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
            WMSLocalizations.i18n(context)!.exit_input_table_title_4,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'product_code',
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
                                context.read<InventoryInquiryBloc>().add(
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
                            context.read<InventoryInquiryBloc>().add(
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
                    .read<InventoryInquiryBloc>()
                    .add(RecordCheckAllEvent(true));
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 全部取消
                context
                    .read<InventoryInquiryBloc>()
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
  _initButtonRightList(List buttonItemList, InventoryInquiryModel state) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        MouseRegion(
          onEnter: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              _currentHoverIndex = buttonItemList[i]['index'];
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
            onTap: () {
              // 判断循环下标
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                // 导出CSV文件事件
                context.read<InventoryInquiryBloc>().add(ExportCSVFileEvent());
              }
            },
            child: Container(
              height: 37,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
              decoration: BoxDecoration(
                color: _currentHoverIndex == buttonItemList[i]['index']
                    ? Color.fromRGBO(0, 122, 255, .6)
                    : Colors.white,
                border: Border.all(
                  color: _currentHoverIndex == buttonItemList[i]['index']
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
                      color: _currentHoverIndex == buttonItemList[i]['index']
                          ? Colors.white
                          : Color.fromRGBO(0, 122, 255, 1),
                    ),
                  ),
                  Text(
                    buttonItemList[i]['title'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: _currentHoverIndex == buttonItemList[i]['index']
                          ? Colors.white
                          : Color.fromRGBO(0, 122, 255, 1),
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

  // 显示明细弹窗
  _showDetailDialog() {
    InventoryInquiryDialogBloc bloc =
        context.read<InventoryInquiryDialogBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<InventoryInquiryDialogBloc>.value(
          value: bloc,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  WMSLocalizations.i18n(context)!.delivery_note_8,
                  style: TextStyle(
                    color: Color.fromRGBO(44, 167, 176, 1),
                    fontSize: 24,
                  ),
                ),
                Container(
                  height: 36,
                  child: Row(
                    children: [
                      OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(255, 255, 255, 1),
                          ),
                          minimumSize: MaterialStatePropertyAll(
                            Size(90, 36),
                          ),
                        ),
                        onPressed: () {
                          // 关闭弹窗
                          Navigator.pop(context);
                        },
                        child: Text(
                          WMSLocalizations.i18n(context)!.delivery_note_close,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            content: Container(
              width: 1072,
              height: 400,
              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
              ),
              child: ListView(
                children: [
                  _showDetailDialogContent(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 显示明细弹窗详情
  _showDetailDialogContent() {
    return BlocBuilder<InventoryInquiryDialogBloc, InventoryInquiryDialogModel>(
      builder: (context, state) {
        return WMSTableWidget<InventoryInquiryDialogBloc,
            InventoryInquiryDialogModel>(
          needPageInfo: false,
          showCheckboxColumn: false,
          columns: [
            {
              'key': 'id',
              'width': 2,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_8,
            },
            {
              'key': 'location_loc_cd',
              'width': 6,
              'title': WMSLocalizations.i18n(context)!.exit_input_table_title_3,
            },
            {
              'key': 'stock',
              'width': 3,
              'title': WMSLocalizations.i18n(context)!
                  .goods_transfer_entry_stock_count,
            },
            {
              'key': 'lock_stock',
              'width': 3,
              'title':
                  WMSLocalizations.i18n(context)!.outbound_adjust_table_btn_2,
            },
            {
              'key': 'limit_date',
              'width': 3,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_form_detail_14,
            },
            {
              'key': 'lot_no',
              'width': 3,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_form_detail_15,
            },
            {
              'key': 'serial_no',
              'width': 3,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_form_detail_16,
            },
            {
              'key': 'note',
              'width': 6,
              'title': WMSLocalizations.i18n(context)!
                  .goods_receipt_input_information,
            },
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryInquiryBloc, InventoryInquiryModel>(
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
        List _buttonRightItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'icon': WMSICons.WAREHOUSE_CSV_ICON,
            'title': WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_csv,
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
            WMSTableWidget<InventoryInquiryBloc, InventoryInquiryModel>(
              isFlex: false,
              operatePopupHeight: 100,
              columns: [
                {
                  'key': 'id',
                  'width': 80,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_8,
                },
                {
                  'key': 'product_code',
                  'width': 150,
                  'title':
                      WMSLocalizations.i18n(context)!.exit_input_table_title_4,
                },
                {
                  'key': 'product_name',
                  'width': 150,
                  'title':
                      WMSLocalizations.i18n(context)!.exit_input_table_title_5,
                },
                {
                  'key': 'stock',
                  'width': 80,
                  'title': WMSLocalizations.i18n(context)!
                      .outbound_adjust_table_btn_1,
                },
                {
                  'key': 'lock_stock',
                  'width': 80,
                  'title': WMSLocalizations.i18n(context)!
                      .outbound_adjust_table_btn_2,
                },
                {
                  'key': 'before_stock',
                  'width': 80,
                  'title': WMSLocalizations.i18n(context)!
                      .inventory_inquiry_last_month,
                },
                {
                  'key': 'in_stock',
                  'width': 80,
                  'title': WMSLocalizations.i18n(context)!
                      .goods_receipt_input_number,
                },
                {
                  'key': 'out_stock',
                  'width': 80,
                  'title': WMSLocalizations.i18n(context)!
                      .shipment_inspection_number,
                },
                {
                  'key': 'adjust_stock',
                  'width': 80,
                  'title': WMSLocalizations.i18n(context)!
                      .inventory_inquiry_adjustment_number,
                },
                {
                  'key': 'inventory_stock',
                  'width': 80,
                  'title': WMSLocalizations.i18n(context)!
                      .inventory_inquiry_inventory,
                },
                {
                  'key': 'move_in_stock',
                  'width': 80,
                  'title': WMSLocalizations.i18n(context)!
                      .inventory_inquiry_entry_number,
                },
                {
                  'key': 'move_out_stock',
                  'width': 80,
                  'title': WMSLocalizations.i18n(context)!
                      .inventory_inquiry_exit_number,
                },
                {
                  'key': 'return_stock',
                  'width': 80,
                  'title': WMSLocalizations.i18n(context)!
                      .inventory_inquiry_return_stock,
                },
              ],
              operatePopupOptions: [
                {
                  'title': WMSLocalizations.i18n(context)!
                      .inventory_inquiry_location_details,
                  'callback': (_, value) {
                    // 查询商品在庫位置事件
                    context
                        .read<InventoryInquiryDialogBloc>()
                        .add(QueryProductLocationEvent(value['product_id']));
                    // 显示明细弹窗
                    _showDetailDialog();
                  },
                },
              ],
            ),
          ],
        );
      },
    );
  }
}
