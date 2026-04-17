import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/pc/wms_table_widget.dart';
import '../bloc/operate_log_bloc.dart';
import '../bloc/operate_log_model.dart';
import 'operate_log_search.dart';

/**
 * 内容：操作ログ-表格
 * 作者：luxy
 * 时间：2023/11/27
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 通信数据
List<Map<String, dynamic>> commData = [];

class OperateLogTable extends StatefulWidget {
  const OperateLogTable({super.key});

  @override
  State<OperateLogTable> createState() => _OperateLogTableState();
}

class _OperateLogTableState extends State<OperateLogTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 20, 30),
      child: Column(
        children: [
          OperateLogSearch(), //luxy
          new Padding(padding: EdgeInsets.only(top: 16, bottom: 16)),
          FractionallySizedBox(
            widthFactor: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: OperateLogTableTab(),
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
                  OperateLogTableContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 操作ログ-表格Tab
// ignore: must_be_immutable
class OperateLogTableTab extends StatefulWidget {
  OperateLogTableTab({super.key});

  @override
  State<OperateLogTableTab> createState() => _OperateLogTableTabState();
}

class _OperateLogTableTabState extends State<OperateLogTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, tab1) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        GestureDetector(
          onPanDown: (details) {
            if (i == 0) {
              // 状态变更
              setState(() {
                // 当前下标
                currentIndex = tabItemList[i]['index'];
              });
            }
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
                    width: 32,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        tab1.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(44, 167, 176, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
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

    return BlocBuilder<OperateLogBloc, OperateLogModel>(
      builder: (context, state) {
        return Row(
          children: _initTabList(_tabItemList, state.total),
        );
      },
    );
  }
}

// 操作ログ-表格内容
class OperateLogTableContent extends StatefulWidget {
  const OperateLogTableContent({super.key});

  @override
  State<OperateLogTableContent> createState() => _OperateLogTableContentState();
}

class _OperateLogTableContentState extends State<OperateLogTableContent> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, OperateLogModel state) {
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
            WMSLocalizations.i18n(context)!.menu_content_99_6_6,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'create_time',
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
                                context.read<OperateLogBloc>().add(SetSortEvent(
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
                            context.read<OperateLogBloc>().add(SetSortEvent(
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
      } else {}
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
    //超级管理员账号
    return BlocBuilder<OperateLogBloc, OperateLogModel>(
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
              ],
            ),
          ),
          StoreProvider.of<WMSState>(context).state.loginUser!.role_id ==
                  Config.NUMBER_ONE
              ? WMSTableWidget<OperateLogBloc, OperateLogModel>(
                  columns: [
                    {
                      'key': 'id',
                      'width': 1,
                      'title': WMSLocalizations.i18n(context)!
                          .instruction_input_table_title_8,
                    },
                    {
                      'key': 'content',
                      'width': 6,
                      'title':
                          WMSLocalizations.i18n(context)!.menu_content_99_6_1,
                    },
                    {
                      'key': 'log_type',
                      'width': 2,
                      'title':
                          WMSLocalizations.i18n(context)!.menu_content_99_6_2,
                    },
                    {
                      'key': 'request_ip',
                      'width': 3,
                      'title':
                          WMSLocalizations.i18n(context)!.menu_content_99_6_5,
                    },
                    {
                      'key': 'create_time',
                      'width': 4,
                      'title':
                          WMSLocalizations.i18n(context)!.menu_content_99_6_6,
                    },
                    {
                      'key': 'user_name',
                      'width': 3,
                      'title':
                          WMSLocalizations.i18n(context)!.menu_content_99_6_7,
                    },
                    {
                      'key': 'company_name',
                      'width': 5,
                      'title':
                          WMSLocalizations.i18n(context)!.company_information_2,
                    }
                  ],
                  showCheckboxColumn: true,
                  operatePopupHeight: 100,
                  operatePopupOptions: [
                    {
                      "title": WMSLocalizations.i18n(context)!.delivery_note_8,
                      'callback': (_, value) {
                        //弹出明细弹框
                        _showDetailsDialog(value);
                      },
                    },
                  ],
                )
              //其余账号
              : WMSTableWidget<OperateLogBloc, OperateLogModel>(
                  columns: [
                    {
                      'key': 'id',
                      'width': 1,
                      'title': WMSLocalizations.i18n(context)!
                          .instruction_input_table_title_8,
                    },
                    {
                      'key': 'content',
                      'width': 6,
                      'title':
                          WMSLocalizations.i18n(context)!.menu_content_99_6_1,
                    },
                    {
                      'key': 'log_type',
                      'width': 2,
                      'title':
                          WMSLocalizations.i18n(context)!.menu_content_99_6_2,
                    },
                    {
                      'key': 'request_ip',
                      'width': 3,
                      'title':
                          WMSLocalizations.i18n(context)!.menu_content_99_6_5,
                    },
                    {
                      'key': 'create_time',
                      'width': 4,
                      'title':
                          WMSLocalizations.i18n(context)!.menu_content_99_6_6,
                    },
                    {
                      'key': 'user_name',
                      'width': 3,
                      'title':
                          WMSLocalizations.i18n(context)!.menu_content_99_6_7,
                    }
                  ],
                  showCheckboxColumn: true,
                  operatePopupHeight: 100,
                  operatePopupOptions: [
                    {
                      "title": WMSLocalizations.i18n(context)!.delivery_note_8,
                      'callback': (_, value) {
                        //弹出明细弹框
                        _showDetailsDialog(value);
                      },
                    },
                  ],
                ),
        ],
      ),
    );
  }

  //弹出明细弹框
  _showDetailsDialog(value) {
    return showDialog(
      context: context,
      builder: (context) {
        return OperateLogDetails(data: value);
      },
    );
  }
}

//操作ログ-明细弹框
class OperateLogDetails extends StatefulWidget {
  final Map data;
  const OperateLogDetails({super.key, required this.data});

  @override
  State<OperateLogDetails> createState() => _OperateLogDetailsState();
}

class _OperateLogDetailsState extends State<OperateLogDetails> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // luxy
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            WMSLocalizations.i18n(context)!.menu_content_99_6 +
                WMSLocalizations.i18n(context)!.delivery_note_8,
            style:
                TextStyle(color: Color.fromRGBO(44, 167, 176, 1), fontSize: 24),
          ),
          Container(
            height: 36,
            child: OutlinedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
                side: MaterialStateProperty.all(
                  const BorderSide(
                    width: 1,
                    color: Color.fromRGBO(44, 167, 176, 1),
                  ),
                ),
              ),
              child: Text(
                WMSLocalizations.i18n(context)!.delivery_note_close,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); //关闭对话框
              },
            ),
          ),
        ],
      ),
      content: Container(
        width: 1072,
        height: 500,
        padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color.fromRGBO(224, 224, 224, 1),
          ),
        ),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _showDialogContent(widget.data),
            ),
          ],
        ),
      ),
    );
  }

//弹框中间内容
  _showDialogContent(data) {
    return [
      Expanded(
        flex: 1,
        child: Container(
          width: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //操作内容
              _detailsText(WMSLocalizations.i18n(context)!.menu_content_99_6_1),
              _detailsContainerText(
                  data['content'].toString().toString(), 136, 5),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //ログレベル
              _detailsText(WMSLocalizations.i18n(context)!.menu_content_99_6_2),
              _detailsContainerText(data['log_type'].toString(), 48, 1),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //超级管理员账号显示此内容
              Visibility(
                visible: StoreProvider.of<WMSState>(context)
                        .state
                        .loginUser!
                        .role_id ==
                    Config.NUMBER_ONE,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //会社名
                    _detailsText(
                        WMSLocalizations.i18n(context)!.company_information_2),
                    _detailsContainerText(
                        data['company_name'].toString(), 48, 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(padding: EdgeInsets.only(right: 24)),
      Expanded(
        flex: 1,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //異常詳細
              _detailsText(WMSLocalizations.i18n(context)!.menu_content_99_6_4),
              _detailsContainerText(
                  data['exception_detail'].toString(), 136, 5),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //リクエスト
              _detailsText(WMSLocalizations.i18n(context)!.menu_content_99_6_5),
              _detailsContainerText(data['request_ip'].toString(), 48, 1),
            ],
          ),
        ),
      ),
      Padding(padding: EdgeInsets.only(right: 24)),
      Expanded(
        flex: 1,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //方法
              _detailsText(WMSLocalizations.i18n(context)!.menu_content_99_6_3),
              _detailsContainerText(data['method'].toString(), 48, 1),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //操作時間
              _detailsText(WMSLocalizations.i18n(context)!.menu_content_99_6_6),
              _detailsContainerText(data['create_time'].toString(), 48, 1),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //操作者
              _detailsText(WMSLocalizations.i18n(context)!.menu_content_99_6_7),
              _detailsContainerText(data['user_name'].toString(), 48, 1),
            ],
          ),
        ),
      ),
    ];
  }

  _detailsText(String _text) {
    return Container(
      height: 24,
      child: Text(
        _text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color.fromRGBO(6, 14, 15, 1),
        ),
      ),
    );
  }

  _detailsContainerText(String _text, double _height, int _maxLines) {
    return WMSInputboxWidget(
      height: _height,
      text: _text,
      readOnly: true,
      maxLines: _maxLines,
    );
  }
}
