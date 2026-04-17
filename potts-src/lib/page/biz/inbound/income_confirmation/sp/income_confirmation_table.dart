import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../redux/current_page_reducer.dart';
import '../../../../../redux/current_param_reducer.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/table/sp/wms_table_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../bloc/income_confirmation_bloc.dart';
import '../bloc/income_confirmation_model.dart';
import 'income_confirmation_detail.dart';

/**
 * 内容：入荷確定 -文件
 * 作者：熊草云
 * 时间：2023/08/24
 */

// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List currentContent = [];
List currentContent_1 = [];

class IncomeConfirmationTable extends StatefulWidget {
  const IncomeConfirmationTable({super.key});

  @override
  State<IncomeConfirmationTable> createState() =>
      _IncomeConfirmationTableState();
}

class _IncomeConfirmationTableState extends State<IncomeConfirmationTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomeConfirmationBloc, IncomeConfirmationModel>(
      builder: (context, state) {
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
                WMSLocalizations.i18n(context)!.income_confirmation_confirmed,
          },
          //已确认
          {
            'index': Config.NUMBER_TWO,
            'title':
                WMSLocalizations.i18n(context)!.income_confirmation_composition,
          },
        ];
        List<DropdownMenuItem<String>> getListData() {
          List<DropdownMenuItem<String>> items = [];
          DropdownMenuItem<String> dropdownMenuItem1 =
              new DropdownMenuItem<String>(
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
          DropdownMenuItem<String> dropdownMenuItem2 =
              new DropdownMenuItem<String>(
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
          DropdownMenuItem<String> dropdownMenuItem3 =
              new DropdownMenuItem<String>(
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

        return Container(
          margin: EdgeInsets.fromLTRB(20, 40, 20, 100),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _initTabList(_tabItemList, state),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // 全部选择
                      context
                          .read<IncomeConfirmationBloc>()
                          .add(RecordCheckAllEvent(true));
                    },
                    child: Text(
                      WMSLocalizations.i18n(context)!
                          .instruction_input_tab_button_choice,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(44, 167, 176, 1),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () {
                      // 全部选择
                      context
                          .read<IncomeConfirmationBloc>()
                          .add(RecordCheckAllEvent(false));
                    },
                    child: Text(
                      WMSLocalizations.i18n(context)!
                          .instruction_input_tab_button_cancellation,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(44, 167, 176, 1),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
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
                                            .read<IncomeConfirmationBloc>()
                                            .add(SetSortEvent(state.sortCol,
                                                state.ascendingFlg));
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
                                    context.read<IncomeConfirmationBloc>().add(
                                        SetSortEvent(
                                            state.sortCol, state.ascendingFlg));
                                  });
                                },
                              ),
                              Positioned(
                                left: state.ascendingFlg ? 17 : null, // 开时文字在左侧
                                right:
                                    state.ascendingFlg ? null : 17, // 关时文字在右侧
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
                ],
              ),
              Row(
                children: [
                  //确定
                  OutlinedButton(
                    onPressed: () {
                      if (state.checkedRecords().length >= 1) {
                        context
                            .read<IncomeConfirmationBloc>()
                            .add(foreachUpdateReceiveEvent('1', context));
                      } else {
                        _showTipDialog(
                          WMSLocalizations.i18n(context)!.menu_content_2_5_13,
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
                          child: Image.asset(
                            WMSICons.WAREHOUSE_DETAILS_ICON,
                            width: 17,
                            height: 19.43,
                            color: Color.fromRGBO(0, 122, 255, 1),
                          ),
                        ),
                        Text(
                          WMSLocalizations.i18n(context)!.table_tab_confirm,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(0, 122, 255, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  //取消
                  OutlinedButton(
                    onPressed: () {
                      if (state.checkedRecords().length >= 1) {
                        bool res1 = false;
                        bool res2 = false;
                        List<Map<String, dynamic>> list = [];
                        state.checkedRecords().forEach((element) {
                          list.add(element.data);
                        });
                        if (list.length > 0) {
                          for (var i = 0; i < list.length; i++) {
                            if (list[i]['csv_kbn'] == '1') {
                              res1 = true;
                            }
                            if (list[i]['receive_kbn'] == '5') {
                              res2 = true;
                            }
                          }
                        }
                        if (res1) {
                          _WarningDialog(
                              '1',
                              WMSLocalizations.i18n(context)!
                                  .income_cancel_error,
                              context);
                        } else if (res2) {
                          _WarningDialog(
                              '2',
                              WMSLocalizations.i18n(context)!
                                  .income_cancel_error_2,
                              context);
                        } else {
                          context
                              .read<IncomeConfirmationBloc>()
                              .add(foreachUpdateReceiveEvent('2', context));
                        }
                      } else {
                        _showTipDialog(
                          WMSLocalizations.i18n(context)!.menu_content_2_5_13,
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
                          child: Image.asset(
                            WMSICons.WAREHOUSE_DETAILS_ICON,
                            width: 17,
                            height: 19.43,
                            color: Color.fromRGBO(0, 122, 255, 1),
                          ),
                        ),
                        Text(
                          WMSLocalizations.i18n(context)!.app_cancel,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(0, 122, 255, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              WMSTableWidget<IncomeConfirmationBloc, IncomeConfirmationModel>(
                operatePopupHeight: 100,
                headTitle: 'id',
                //表头
                columns: [
                  //id
                  {
                    'key': 'id',
                    'width': 0.5,
                    'title': 'ID',
                  },
                  //入荷予定番号
                  {
                    'key': 'receive_no',
                    'width': 0.5,
                    'title': WMSLocalizations.i18n(context)!
                        .incoming_inspection_expected_id,
                  },
                  //入荷予定日
                  {
                    'key': 'rcv_sch_date',
                    'width': 0.5,
                    'title': WMSLocalizations.i18n(context)!
                        .home_main_page_table_text1,
                  },
                  //仕入先
                  {
                    'key': 'name',
                    'width': 0.5,
                    'title': WMSLocalizations.i18n(context)!
                        .incoming_inspection_supplier,
                  },
                  //入荷状态
                  {
                    'key': 'receive_kbn_msg',
                    'width': 0.5,
                    'title': WMSLocalizations.i18n(context)!.receive_status,
                  },
                ],
                //复选框
                showCheckboxColumn: true,
                operatePopupOptions: [
                  //明细
                  {
                    'title': WMSLocalizations.i18n(context)!
                        .instruction_input_tab_button_details,
                    'callback': (_, value) {
                      // 持久化状态更新
                      StoreProvider.of<WMSState>(context).dispatch(
                          RefreshCurrentPageAction(Config.PAGE_FLAG_60_2_12_1));
                      //传递数据
                      StoreProvider.of<WMSState>(context)
                          .dispatch(RefreshCurrentParamAction(value));
                      try {
                        //出荷指示id
                        int receiveId = value['id'];
                        String receiveNo = value['receive_no'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IncomeConfirmationDetail(
                                receiveId: receiveId, receiveNo: receiveNo),
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
          ),
        );
      },
    );
  }

  List<Widget> _initTabList(List tabItemList, IncomeConfirmationModel state) {
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
            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
            padding: EdgeInsets.fromLTRB(12, 11, 12, 11),
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
              minWidth: 58,
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
                    // 当前内容
                    context
                        .read<IncomeConfirmationBloc>()
                        .add(QueryIncomeEvent('0', ['4', '5']));
                    // currentContent = widget.initTableList;
                    // 当前下标
                    currentIndex = tabItemList[i]['index'];
                  });
                } else if (tabItemList[i]['index'] == Config.NUMBER_ONE) {
                  // 状态变更
                  setState(() {
                    // 当前内容
                    context
                        .read<IncomeConfirmationBloc>()
                        .add(QueryIncomeEvent('1', ['4']));
                    // 当前下标
                    currentIndex = tabItemList[i]['index'];
                  });
                } else if (tabItemList[i]['index'] == Config.NUMBER_TWO) {
                  // 状态变更
                  setState(() {
                    // 当前内容
                    context
                        .read<IncomeConfirmationBloc>()
                        .add(QueryIncomeEvent('2', ['5']));
                    // 当前下标
                    currentIndex = tabItemList[i]['index'];
                  });
                } else {
                  // 当前下标
                  currentIndex = tabItemList[i]['index'];
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
                      color: tabItemList[i]['index'] == currentIndex
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(6, 14, 15, 1),
                      height: 1.0,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30),
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        i == 0
                            ? state.count.toString()
                            : i == 1
                                ? state.count1.toString()
                                : state.count2.toString(),
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
  _WarningDialog(String flag, String text, BuildContext parentContext) {
    IncomeConfirmationBloc bloc = context.read<IncomeConfirmationBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<IncomeConfirmationBloc>.value(
          value: bloc,
          child: BlocBuilder<IncomeConfirmationBloc, IncomeConfirmationModel>(
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
                  bloc.add(foreachUpdateReceiveEvent('2', context));
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
