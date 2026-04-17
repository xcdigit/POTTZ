import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/model/receive.dart';
import 'package:wms/widget/wms_dialog_widget.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../bloc/returns_note_bloc.dart';
import '../bloc/returns_note_model.dart';
import 'returns_note_search.dart';

/**
 * 内容：返品照会
 * 作者：王光顺
 * 时间：2023/09/05
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List<Receive> currentContent = [];
// 当前选择内容
List currentCheckContent = [];

class ReturnsNoteTable extends StatefulWidget {
  const ReturnsNoteTable({super.key});

  @override
  State<ReturnsNoteTable> createState() => _ReturnsNoteTableState();
}

class _ReturnsNoteTableState extends State<ReturnsNoteTable> {
  List<Map<String, dynamic>> data = [];
  @override
  void initState() {
    super.initState();
    _getTableData();
  }

  // 初始化一覧表格
  _getTableData() async {
    data = await SupabaseUtils.getClient().from("dtb_receive").select('*');
    setState(() {
      currentContent = data.map((json) => Receive.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          //检索按钮
          ReturnsNoteearch(),

          new Padding(padding: EdgeInsets.only(top: 16, bottom: 16)),
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: InquiryScheduleTableTab(
                      initTableList: currentContent,
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
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
                          child: InquiryScheduleTableButton(),
                        ),
                        InquiryScheduleTableContent(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 返品照会-表格Tab
// ignore: must_be_immutable
class InquiryScheduleTableTab extends StatefulWidget {
  // 初始化一覧表格
  List initTableList;
  InquiryScheduleTableTab({
    super.key,
    required this.initTableList,
  });

  @override
  State<InquiryScheduleTableTab> createState() =>
      _InquiryScheduleTableTabState();
}

class _InquiryScheduleTableTabState extends State<InquiryScheduleTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, sum) {
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
                currentContent = widget.initTableList as List<Receive>;
              });
            } else if (tabItemList[i]['index'] == Config.NUMBER_ONE) {
              // 状态变更
              setState(() {
                // 当前内容
                currentContent = widget.initTableList as List<Receive>;
              });
            } else if (tabItemList[i]['index'] == Config.NUMBER_TWO) {
              // 状态变更
              setState(() {
                // 当前内容
                currentContent = widget.initTableList as List<Receive>;
              });
            } else if (tabItemList[i]['index'] == Config.NUMBER_THREE) {
              // 状态变更
              setState(() {
                // 当前内容
                currentContent = widget.initTableList as List<Receive>;
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
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                  width: 24,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      sum.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(44, 167, 176, 1),
                      ),
                    ),
                  ),
                )
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
    // Tab单个列表
    List _tabItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.instruction_input_tab_list,
      },
    ];

    return BlocBuilder<ReturnNoteBloc, ReturnNoteModel>(
      builder: (context, state) {
        return Row(
          children: _initTabList(_tabItemList, state.total),
        );
      },
    );
  }
}

// 表格按钮
class InquiryScheduleTableButton extends StatefulWidget {
  const InquiryScheduleTableButton({super.key});

  @override
  State<InquiryScheduleTableButton> createState() =>
      _InquiryScheduleTableButtonState();
}

class _InquiryScheduleTableButtonState
    extends State<InquiryScheduleTableButton> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, ReturnNoteModel state) {
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
            WMSLocalizations.i18n(context)!.returns_note_2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'rev_ship_line_no',
      );
      items.add(dropdownMenuItem2);
      DropdownMenuItem<String> dropdownMenuItem3 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.exit_input_form_title_11,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'loc_cd',
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
                                context.read<ReturnNoteBloc>().add(SetSortEvent(
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
                            context.read<ReturnNoteBloc>().add(SetSortEvent(
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
                context.read<ReturnNoteBloc>().add(RecordCheckAllEvent(true));
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 全部取消
                context.read<ReturnNoteBloc>().add(RecordCheckAllEvent(false));
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
  _initButtonRightList(List buttonItemList, state) {
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
                setState(() {});
                // 判断循环下标
                if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                  List<Map<String, dynamic>> contentList = [];
                  // 表格选中列表
                  List<WmsRecordModel> wmsRecordModelList =
                      state.checkedRecords();
                  // 循环表格选中列表
                  for (int i = 0; i < wmsRecordModelList.length; i++) {
                    // 内容列表
                    contentList.add(wmsRecordModelList[i].data);
                  }
                  if (contentList.length == 0) {
                    WMSCommonBlocUtils.tipTextToast(
                        WMSLocalizations.i18n(context)!
                            .Inventory_Confirmed_tip_1);
                  } else {
                    // 导入CSV文件
                    WMSCommonFile().exportCSVFile([
                      'id',
                      'rev_ship_line_no',
                      'return_kbn_name',
                      'product_name',
                      'loc_cd',
                      'return_num'
                    ], contentList,
                        WMSLocalizations.i18n(context)!.menu_content_4_8);
                  }
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
        'index': Config.NUMBER_ZERO,
        'icon': WMSICons.WAREHOUSE_CSV_ICON,
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_button_csv,
      },
    ];

    return BlocBuilder<ReturnNoteBloc, ReturnNoteModel>(
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
                    children: _initButtonRightList(_buttonRightItemList, state),
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

//表格内容
class InquiryScheduleTableContent extends StatefulWidget {
  const InquiryScheduleTableContent({super.key});

  @override
  State<InquiryScheduleTableContent> createState() =>
      _InquiryScheduleTableContentState();
}

class _InquiryScheduleTableContentState
    extends State<InquiryScheduleTableContent> {
  @override
  Widget build(BuildContext context) {
    return WMSTableWidget<ReturnNoteBloc, ReturnNoteModel>(
      columns: [
        {
          'key': 'id',
          'width': 2,
          'title': WMSLocalizations.i18n(context)!.returns_note_id,
        },
        {
          'key': 'rev_ship_line_no',
          'width': 4,
          'title': WMSLocalizations.i18n(context)!.returns_note_2,
        },
        {
          'key': 'product_name',
          'width': 5,
          'title':
              WMSLocalizations.i18n(context)!.instruction_input_table_title_4,
        },
        {
          'key': 'loc_cd',
          'width': 4,
          'title': WMSLocalizations.i18n(context)!.exit_input_form_title_11,
        },
        {
          'key': 'return_kbn_name',
          'width': 3,
          'title': WMSLocalizations.i18n(context)!.returns_note_1,
        },
        {
          'key': 'return_num',
          'width': 2,
          'title': WMSLocalizations.i18n(context)!.return_product_form_4,
        },
      ],
      operatePopupOptions: [
        {
          'title': WMSLocalizations.i18n(context)!.exit_input_table_delete,
          'callback': (_, value) {
            _deleteDialog(value);
          }
        }
      ],
      showCheckboxColumn: true,
      operatePopupHeight: 100,
    );
  }

  // 删除弹窗
  _deleteDialog(value) {
    ReturnNoteBloc bloc = context.read<ReturnNoteBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<ReturnNoteBloc>.value(
          value: bloc,
          child: BlocBuilder<ReturnNoteBloc, ReturnNoteModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .display_instruction_confirm_delete,
                contentText: WMSLocalizations.i18n(context)!.returns_note_id +
                    '：' +
                    value['id'].toString() +
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
                  context.read<ReturnNoteBloc>().add(DeleteReturnEvent(value));
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
}
