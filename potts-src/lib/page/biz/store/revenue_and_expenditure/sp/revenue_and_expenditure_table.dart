import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../widget/table/sp/wms_table_widget.dart';
import '../bloc/revenue_and_expenditure_bloc.dart';
import '../bloc/revenue_and_expenditure_model.dart';
import 'revenue_and_expenditure_search.dart';

/**
 * 内容：受払照会-表格-sp
 * 作者：熊草云
 * 时间：2023/11/21
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 通信数据
List<Map<String, dynamic>> commData = [];
// 当前选择内容
List currentCheckContent = [];

class RevenueAndExpenditureTable extends StatefulWidget {
  const RevenueAndExpenditureTable({super.key});

  @override
  State<RevenueAndExpenditureTable> createState() =>
      _RevenueAndExpenditureTableState();
}

class _RevenueAndExpenditureTableState
    extends State<RevenueAndExpenditureTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: Column(
        children: [
          RevenueAndExpenditureSearch(), //xcy
          new Padding(padding: EdgeInsets.only(top: 16, bottom: 16)),
          FractionallySizedBox(
            widthFactor: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: RevenueAndExpenditureTableTab(),
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
                  RevenueAndExpenditureTableContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 受払照会-表格Tab
// ignore: must_be_immutable
class RevenueAndExpenditureTableTab extends StatefulWidget {
  RevenueAndExpenditureTableTab({super.key});

  @override
  State<RevenueAndExpenditureTableTab> createState() =>
      _RevenueAndExpenditureTableTabState();
}

class _RevenueAndExpenditureTableTabState
    extends State<RevenueAndExpenditureTableTab> {
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
              height: 40,
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
                minWidth: 108,
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
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
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

    return BlocBuilder<RevenueAndExpenditureBloc, RevenueAndExpenditureModel>(
      builder: (context, state) {
        return Row(
          children: _initTabList(_tabItemList, state.total),
        );
      },
    );
  }
}

// 受払照会-表格内容
class RevenueAndExpenditureTableContent extends StatefulWidget {
  const RevenueAndExpenditureTableContent({super.key});

  @override
  State<RevenueAndExpenditureTableContent> createState() =>
      _RevenueAndExpenditureTableContentState();
}

class _RevenueAndExpenditureTableContentState
    extends State<RevenueAndExpenditureTableContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RevenueAndExpenditureBloc, RevenueAndExpenditureModel>(
      builder: (context, state) {
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
                WMSLocalizations.i18n(context)!.exit_input_table_title_4,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            value: 'product_code',
          );
          items.add(dropdownMenuItem2);
          DropdownMenuItem<String> dropdownMenuItem3 =
              new DropdownMenuItem<String>(
            child: Container(
              width: double.infinity, // 设置宽度为无限
              child: Text(
                WMSLocalizations.i18n(context)!.exit_input_table_title_3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            value: 'location_cd',
          );
          items.add(dropdownMenuItem3);
          return items;
        }

        return Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 100),
          child: Column(
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
                                        .read<RevenueAndExpenditureBloc>()
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
                                context.read<RevenueAndExpenditureBloc>().add(
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
              WMSTableWidget<RevenueAndExpenditureBloc,
                  RevenueAndExpenditureModel>(
                columns: [
                  {
                    'key': 'id',
                    'width': .1,
                    'title': WMSLocalizations.i18n(context)!
                        .instruction_input_table_title_8,
                  },
                  {
                    'key': 'warehouse_name',
                    'width': .3,
                    'title': WMSLocalizations.i18n(context)!.warehouse_master_3,
                  },
                  {
                    'key': 'year_month',
                    'width': .2,
                    'title':
                        WMSLocalizations.i18n(context)!.menu_content_4_10_11,
                  },
                  {
                    'key': 'product_code',
                    'width': .7,
                    'title': WMSLocalizations.i18n(context)!
                        .exit_input_table_title_4,
                  },
                  {
                    'key': 'product_name',
                    'width': .3,
                    'title': WMSLocalizations.i18n(context)!
                        .exit_input_table_title_5,
                  },
                  {
                    'key': 'location_cd',
                    'width': .6,
                    'title': WMSLocalizations.i18n(context)!
                        .exit_input_table_title_3,
                  },
                  {
                    'key': 'num',
                    'width': .2,
                    'title':
                        WMSLocalizations.i18n(context)!.menu_content_4_10_12,
                  },
                  {
                    'key': 'action_name',
                    'width': .3,
                    'title':
                        WMSLocalizations.i18n(context)!.menu_content_4_10_1,
                  },
                ],
                showCheckboxColumn: true,
                operatePopupHeight: 100,
                operatePopupOptions: [
                  {
                    "title": WMSLocalizations.i18n(context)!.delivery_note_8,
                    'callback': (_, value) {
                      setState(() {
                        currentCheckContent.add(value);
                      });
                      //弹出明细弹框
                      _showDetailsDialog(value);
                    },
                  },
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //弹出明细弹框
  _showDetailsDialog(value) {
    return showDialog(
      context: context,
      builder: (context) {
        return RevenueAndExpenditureDetails(data: value);
      },
    );
  }
}

//受払照会-明细弹框
class RevenueAndExpenditureDetails extends StatefulWidget {
  final Map data;
  const RevenueAndExpenditureDetails({super.key, required this.data});

  @override
  State<RevenueAndExpenditureDetails> createState() =>
      _RevenueAndExpenditureDetailsState();
}

class _RevenueAndExpenditureDetailsState
    extends State<RevenueAndExpenditureDetails> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // xcy
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            WMSLocalizations.i18n(context)!.menu_content_4_10 +
                WMSLocalizations.i18n(context)!.delivery_note_8,
            style:
                TextStyle(color: Color.fromRGBO(44, 167, 176, 1), fontSize: 18),
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
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color.fromRGBO(224, 224, 224, 1),
          ),
        ),
        child: ListView(
          children: [
            Wrap(
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
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          width: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //倉庫名
              _detailsText(WMSLocalizations.i18n(context)!.warehouse_master_3),
              _detailsContainerText(
                  data['warehouse_name'].toString().toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //商品コード
              _detailsText(WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_3),
              _detailsContainerText(data['product_code'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //商品名
              _detailsText(WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_4),
              _detailsContainerText(data['product_name'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //ロケーションid
              _detailsText(
                  WMSLocalizations.i18n(context)!.exit_input_form_title_6),
              _detailsContainerText(data['location_cd'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //アクション
              _detailsText(WMSLocalizations.i18n(context)!.menu_content_4_10_1),
              _detailsContainerText(data['action_name'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //入/出荷予定明細行
              _detailsText(WMSLocalizations.i18n(context)!.menu_content_4_10_5),
              _detailsContainerText(data['rev_ship_line_no'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //入/出荷予定区分
              _detailsText(WMSLocalizations.i18n(context)!.menu_content_4_10_6),
              _detailsContainerText(data['rev_ship_kbn_name'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //数量
              _detailsText(WMSLocalizations.i18n(context)!.delivery_note_44),
              _detailsContainerText(data['num'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //入出庫区分
              _detailsText(WMSLocalizations.i18n(context)!.menu_content_4_10_7),
              _detailsContainerText(data['store_kbn_name'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //登録時間
              _detailsText(
                  WMSLocalizations.i18n(context)!.menu_content_4_10_10),
              _detailsContainerText(data['create_time'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 年月
              _detailsText(
                  WMSLocalizations.i18n(context)!.menu_content_4_10_11),
              _detailsContainerText(data['year_month'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //社内備考１
              _detailsText(WMSLocalizations.i18n(context)!.menu_content_4_10_8),
              _detailsContainerText(data['note1'].toString(), 136),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //社内備考2
              _detailsText(WMSLocalizations.i18n(context)!.menu_content_4_10_9),
              _detailsContainerText(data['note2'].toString(), 136),
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

  _detailsContainerText(String _text, double _height) {
    return WMSInputboxWidget(height: _height, text: _text, readOnly: true);
  }
}
