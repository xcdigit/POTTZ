import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/utils/common_utils.dart';
import 'package:wms/page/biz/inbound/confirmation/bloc/confirmation_data_bloc.dart';
import 'package:wms/page/biz/inbound/confirmation/bloc/confirmation_data_model.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';

/**
 * 内容：入荷確定データ出力 -表格
 * 作者：cuihr
 * 时间：2023/08/24
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List currentContent = [];
// 当前选择内容
List currentCheckContent = [];
// 全局主键-表格共通
// GlobalKey<WMSTableWidgetState> _tableWidgetKey = new GlobalKey();

class ConfirmationDataTable extends StatefulWidget {
  const ConfirmationDataTable({super.key});
  @override
  State<ConfirmationDataTable> createState() => _ConfirmationDataTableState();
}

class _ConfirmationDataTableState extends State<ConfirmationDataTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfirmationDataBloc, ConfirmationDataModel>(
        builder: (context, state) {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 80, 0, 80),
        child: Column(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConfirmationDataTableTab(),
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
                    )),
                child: ConfirmationDataTableContent(state: state),
              ),
            )
          ],
        ),
      );
    });
  }
}

// 入荷確定データ出力-表格Tab
// ignore: must_be_immutable
class ConfirmationDataTableTab extends StatefulWidget {
// // 初始化一覧表格
//   List initTableList;
  const ConfirmationDataTableTab({super.key});

  @override
  State<ConfirmationDataTableTab> createState() =>
      _ConfirmationDataTableTabState();
}

class _ConfirmationDataTableTabState extends State<ConfirmationDataTableTab> {
  // 当前下标
  int currentIndex = Config.NUMBER_ZERO;
  // 当前悬停下标
  int currentHoverIndex = Config.NUMBER_NEGATIVE;
  //初始化tab列表
  List<Widget> _initTabList(tabItemList) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        GestureDetector(
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
        // ),
      );
    }
    // Tab列表
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfirmationDataBloc, ConfirmationDataModel>(
      builder: (context, state) {
        // Tab单个列表
        List _tabItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'title': WMSLocalizations.i18n(context)!.instruction_input_tab_list,
            'number': state.total,
          },
        ];

        return Row(
          children: _initTabList(_tabItemList),
        );
      },
    );
  }
}

// 入荷確定データ出力-表格按钮/内容
// ignore: must_be_immutable
class ConfirmationDataTableContent extends StatefulWidget {
//参数
  ConfirmationDataModel state;
  ConfirmationDataTableContent({super.key, required this.state});

  @override
  State<ConfirmationDataTableContent> createState() =>
      _ConfirmationDataTableContentState();
}

class _ConfirmationDataTableContentState
    extends State<ConfirmationDataTableContent> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, ConfirmationDataModel state) {
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
            WMSLocalizations.i18n(context)!.menu_content_2_5_6,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'receive_no',
      );
      items.add(dropdownMenuItem2);
      DropdownMenuItem<String> dropdownMenuItem3 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.home_main_page_table_text1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'rcv_sch_date',
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
                                context.read<ConfirmationDataBloc>().add(
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
                            context.read<ConfirmationDataBloc>().add(
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
                    .read<ConfirmationDataBloc>()
                    .add(RecordCheckAllEvent(true));
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 全部取消
                context
                    .read<ConfirmationDataBloc>()
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
  _initButtonRightList(List buttonItemList) {
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
            return BlocBuilder<ConfirmationDataBloc, ConfirmationDataModel>(
              builder: (context, state) {
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
                      if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                        // csv 按钮
                        if (state.checkedRecords().length > 0) {
                          // 内容列表
                          List<Map<String, dynamic>> contentList = [];
                          // ID列表
                          List<int> idList = [];
                          // 表格选中列表
                          List<WmsRecordModel> wmsRecordModelList =
                              state.checkedRecords();
                          // 循环表格选中列表
                          for (int i = 0; i < wmsRecordModelList.length; i++) {
                            // 内容列表
                            contentList.add(wmsRecordModelList[i].data);
                            // ID列表
                            idList.add(wmsRecordModelList[i].data['id']);
                          }
                          // 导入CSV文件
                          WMSCommonFile().exportCSVFile(
                              ['id', 'receive_no', 'rcv_sch_date', 'name'],
                              contentList,
                              '入荷確定データ出力');
                          // 变更连携标记事件
                          context
                              .read<ConfirmationDataBloc>()
                              .add(UpdateCsvKbnEvent(idList));
                          // 插入操作履历 sys_log表
                          CommonUtils().createLogInfo(
                              '入荷確定データCSV' +
                                  Config.OPERATION_TEXT1 +
                                  Config.OPERATION_BUTTON_TEXT10 +
                                  Config.OPERATION_TEXT2,
                              "exportCSVFile()",
                              StoreProvider.of<WMSState>(context)
                                  .state
                                  .loginUser!
                                  .company_id,
                              StoreProvider.of<WMSState>(context)
                                  .state
                                  .loginUser!
                                  .id);
                        } else {
                          _showTipDialog(WMSLocalizations.i18n(context)!
                              .menu_content_2_5_13);
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
            );
          },
        ),
      );
    }
    ;
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
    return BlocBuilder<ConfirmationDataBloc, ConfirmationDataModel>(
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
                      children: _initButtonRightList(_buttonRightItemList),
                    ),
                  ),
                ),
              ],
            ),
          ),
          WMSTableWidget<ConfirmationDataBloc, ConfirmationDataModel>(
            columns: [
              {
                //行番号
                'key': 'id',
                'width': 2,
                'title': "ID",
              },
              {
                //入荷予定番号
                'key': 'receive_no',
                'width': 4,
                'title': WMSLocalizations.i18n(context)!
                    .confirmation_data_table_title_3,
              },
              {
                //入荷予定日
                'key': 'rcv_sch_date',
                'width': 4,
                'title': WMSLocalizations.i18n(context)!
                    .confirmation_data_table_title_4,
              },
              {
                //仕入先
                'key': 'name',
                'width': 4,
                'title': WMSLocalizations.i18n(context)!
                    .confirmation_data_table_title_5,
              },
            ],
          ),
        ],
      ),
    );
  }
}
