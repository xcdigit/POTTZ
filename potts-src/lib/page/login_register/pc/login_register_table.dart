import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/login_register/bloc/login_register_bloc.dart';
import 'package:wms/page/login_register/bloc/login_register_model.dart';

/**
 * 内容：申込-ライセンスtable
 * 作者：cuihr
 * 时间：2023/12/06
 */
class LoginRegisterTable extends StatefulWidget {
  const LoginRegisterTable({super.key});

  @override
  State<LoginRegisterTable> createState() => _LoginRegisterTableState();
}

class _LoginRegisterTableState extends State<LoginRegisterTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginRegisterBLoc, LoginRegisterModel>(
        builder: (context, state) {
      //创建单个表格
      Widget _buildSideBox(String title, bool isTitle, String index) {
        return Container(
            height: 100,
            alignment: Alignment.center,
            color: isTitle
                ? Color.fromRGBO(245, 245, 245, 1)
                : index == state.selected
                    ? Color.fromRGBO(44, 167, 176, 1)
                    : Colors.white,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  TextStyle(fontSize: isTitle ? 14 : 12, color: Colors.black),
            ));
      }

      //表格按钮
      Widget _buildBtnSideBox(Map<String, dynamic> map, bool isTitle,
          bool isSelected, String index, int index1) {
        return Container(
          height: 40,
          // width: 100,
          margin: EdgeInsets.fromLTRB(50, 30, 50, 30),
          // padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromRGBO(44, 167, 176, 1),
              ),
            ),
            onPressed: () {
              context
                  .read<LoginRegisterBLoc>()
                  .add(SetTableSelectEvent(index, map));
            },
            child: Text(
              WMSLocalizations.i18n(context)!.register_choose,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(255, 255, 255, 1),
                height: 1.28,
              ),
            ),
          ),
        );
      }

      //创建第一列tableRow
      TableRow _buildSingleColumnOne(int index) {
        String text = '';
        if (index == 0) {
          text = WMSLocalizations.i18n(context)!.register_table_1;
        } else if (index == 1) {
          text = WMSLocalizations.i18n(context)!.register_table_2;
        } else if (index == 2) {
          text = WMSLocalizations.i18n(context)!.register_table_3;
        } else if (index == 3) {
          text = WMSLocalizations.i18n(context)!.register_table_4;
        } else {
          text = '';
        }
        return TableRow(
            //第一行样式 添加背景色
            children: [
              //增加行高
              _buildSideBox(text, true, '-1'),
            ]);
      }

      //创建一行tableRow
      TableRow _buildSingleRow(LoginRegisterModel state, List<dynamic> list) {
        if (list.length > 0) {
          return TableRow(
              //第一行样式 添加背景色
              children: [
                for (int i = 0; i < list.length; i++)
                  _buildSideBox(list[i], false, i.toString()),
              ]);
        } else {
          return TableRow(
            children: [_buildSideBox('', false, '-1')],
          );
        }
      }

      TableRow _buildBtnRow(
          LoginRegisterModel state, List<Map<String, dynamic>> list) {
        if (list.length > 0) {
          return TableRow(
              //第一行样式 添加背景色
              children: [
                for (int i = 0; i < list.length; i++)
                  _buildBtnSideBox(
                      list[i], false, false, i.toString(), list.length),
              ]);
        } else {
          return TableRow(
            children: [_buildSideBox('', false, '-1')],
          );
        }
      }

      //首列
      List<TableRow> _buildTableColumnOne() {
        List<TableRow> returnList = [];
        for (int i = 0; i < 4; i++) {
          returnList.add(_buildSingleColumnOne(i));
        }
        returnList.add(_buildSingleColumnOne(-1));
        return returnList;
      }

//创建tableRows
      List<TableRow> _buildTableRow(LoginRegisterModel state) {
        List<TableRow> returnList = [];
        List<dynamic> firstList = [];
        List<dynamic> secondList = [];
        List<dynamic> thirdList = [];
        List<dynamic> fourthList = [];
        List<Map<String, dynamic>> fifList = [];
        if (state.useTypeTableList.length > 0) {
          state.useTypeTableList.forEach((element) {
            firstList.add(element['type'] != '' || element['type'] != null
                ? element['type']
                : '');
          });
          state.useTypeTableList.forEach((element) {
            secondList.add(element['support_cotent'] != '' ||
                    element['support_cotent'] != null
                ? element['support_cotent']
                : '');
          });
          state.useTypeTableList.forEach((element) {
            thirdList.add(
                element['amount'] != null ? element['amount'].toString() : '');
          });
          state.useTypeTableList.forEach((element) {
            String year = element['expiration_year'] != null ||
                    element['expiration_year'] != ''
                ? element['expiration_year'].toString()
                : '';
            String month = element['expiration_month'] != null ||
                    element['expiration_month'] != ''
                ? element['expiration_month'].toString()
                : '';
            String day = element['expiration_day'] != null ||
                    element['expiration_day'] != ''
                ? element['expiration_day'].toString()
                : '';
            String date = year + '-' + month + '-' + day;
            fourthList.add(date);
          });
          fifList = state.useTypeTableList;
          returnList.add(_buildSingleRow(state, firstList));
          returnList.add(_buildSingleRow(state, secondList));
          returnList.add(_buildSingleRow(state, thirdList));
          returnList.add(_buildSingleRow(state, fourthList));
          returnList.add(_buildBtnRow(state, fifList));
        } else {
          returnList.add(_buildSingleRow(state, firstList));
          returnList.add(_buildSingleRow(state, secondList));
          returnList.add(_buildSingleRow(state, thirdList));
          returnList.add(_buildSingleRow(state, fourthList));
        }
        return returnList;
      }

      return Container(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.15,
          right: MediaQuery.of(context).size.width * 0.15,
          top: MediaQuery.of(context).size.height * 0.01,
          bottom: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Stack(children: [
                FractionallySizedBox(
                  widthFactor: 0.6,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: LoginRegisterTableTab(),
                  ),
                )
              ]),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(35, 35, 35, 35),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(224, 224, 224, 1),
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(224, 224, 224, 1),
                        ),
                      ),
                      //表格
                      child: Row(
                        children: [
                          Container(
                            // width: 160, //固定第一列,
                            decoration: BoxDecoration(color: Colors.grey),
                            child: Table(
                              border: TableBorder.all(
                                // 边框颜色
                                color: Color.fromRGBO(224, 224, 224, 1),
                                // 边框大小
                                width: 1,
                                // 边框样式
                                //   solid - 有边框
                                //   none - 无边框
                                style: BorderStyle.solid,
                              ),
                              columnWidths: {0: FixedColumnWidth(200)},
                              children: _buildTableColumnOne(),
                            ),
                          ),
                          Expanded(
                              child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              //单个表宽
                              // width: 1200,
                              child: Table(
                                  border: TableBorder.all(
                                    // 边框颜色
                                    color: Color.fromRGBO(224, 224, 224, 1),
                                    // 边框大小
                                    width: 1,
                                    // 边框样式
                                    //   solid - 有边框
                                    //   none - 无边框
                                    style: BorderStyle.solid,
                                  ),
                                  columnWidths: {
                                    ///固定列宽度
                                    for (int i = 0;
                                        i < state.useTypeTableList.length;
                                        i++)
                                      i: FixedColumnWidth(200),
                                  },
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: _buildTableRow(state)),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// 表格Tab
class LoginRegisterTableTab extends StatefulWidget {
  const LoginRegisterTableTab({super.key});

  @override
  State<LoginRegisterTableTab> createState() => _LoginRegisterTableTabState();
}

class _LoginRegisterTableTabState extends State<LoginRegisterTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList) {
    // Tab列表
    List<Widget> tabList = [];
    tabList.add(
      Container(
        child: Container(
          height: 46,
          padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
          margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(44, 167, 176, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          constraints: BoxConstraints(
            minWidth: 160,
          ),
          child: Text(
            tabItemList[0]['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(255, 255, 255, 1)),
          ),
        ),
      ),
    );
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    List _tabItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.account_menu_5,
      }
    ];
    return Row(
      children: _initTabList(_tabItemList),
    );
  }
}
