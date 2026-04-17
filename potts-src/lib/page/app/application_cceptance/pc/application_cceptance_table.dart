import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/app/application_cceptance/bloc/application_cceptance_bloc.dart';
import 'package:wms/page/app/application_cceptance/bloc/application_cceptance_model.dart';
import 'package:wms/page/app/application_cceptance/pc/application_cceptance_detail.dart';
import 'package:wms/widget/table/pc/wms_table_widget.dart';

/**
 * 内容：申込受付 -表格
 * 作者：cuihr
 * 时间：2023/12/18
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

class ApplicationCceptanceTable extends StatefulWidget {
  const ApplicationCceptanceTable({super.key});

  @override
  State<ApplicationCceptanceTable> createState() =>
      _ApplicationCceptanceTableState();
}

class _ApplicationCceptanceTableState extends State<ApplicationCceptanceTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationCceptanceBloc, ApplicationCceptanceModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 40, 0, 40),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ApplicationCceptanceTableTab(),
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
                      ApplicationCceptanceTableContent(),
                    ],
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

// -表格Tab
// ignore: must_be_immutable
class ApplicationCceptanceTableTab extends StatefulWidget {
  const ApplicationCceptanceTableTab({super.key});

  @override
  State<ApplicationCceptanceTableTab> createState() =>
      _ApplicationCceptanceTableTabState();
}

class _ApplicationCceptanceTableTabState
    extends State<ApplicationCceptanceTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, ApplicationCceptanceModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        GestureDetector(
          onPanDown: (details) {
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
              color: state.tableTabIndex == tabItemList[i]['index']
                  ? Color.fromRGBO(44, 167, 176, 1)
                  : currentIndex == tabItemList[i]['index']
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
            child: Stack(
              children: [
                Text(
                  tabItemList[i]['title'],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: state.tableTabIndex == tabItemList[i]['index']
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : tabItemList == tabItemList[i]['index']
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
    return BlocBuilder<ApplicationCceptanceBloc, ApplicationCceptanceModel>(
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
          children: _initTabList(_tabItemList, state),
        );
      },
    );
  }
}

// -表格内容
class ApplicationCceptanceTableContent extends StatefulWidget {
  const ApplicationCceptanceTableContent({super.key});

  @override
  State<ApplicationCceptanceTableContent> createState() =>
      _ApplicationCceptanceTableContentState();
}

class _ApplicationCceptanceTableContentState
    extends State<ApplicationCceptanceTableContent> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, ApplicationCceptanceModel state) {
    List<DropdownMenuItem<String>> getListData() {
      List<DropdownMenuItem<String>> items = [];
      DropdownMenuItem<String> dropdownMenuItem1 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.app_cceptance_time,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'create_time',
      );
      items.add(dropdownMenuItem1);
      DropdownMenuItem<String> dropdownMenuItem2 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.app_cceptance_pay_status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'pay_status',
      );
      items.add(dropdownMenuItem2);
      DropdownMenuItem<String> dropdownMenuItem3 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.app_cceptance_status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'application_status',
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
                                context.read<ApplicationCceptanceBloc>().add(
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
                            context.read<ApplicationCceptanceBloc>().add(
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
      } else {}
    }
    // 按钮列表
    return buttonList;
  }

  // 获取表格数据
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
    return BlocBuilder<ApplicationCceptanceBloc, ApplicationCceptanceModel>(
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
          WMSTableWidget<ApplicationCceptanceBloc, ApplicationCceptanceModel>(
            showCheckboxColumn: true,
            operatePopupHeight: 100,
            columns: [
              {
                //会社名
                'key': 'company_name',
                'width': 3,
                'title':
                    WMSLocalizations.i18n(context)!.app_cceptance_company_name,
              },
              {
                //担当者名
                'key': 'user_name',
                'width': 3,
                'title':
                    WMSLocalizations.i18n(context)!.app_cceptance_user_name,
              },
              {
                //メールアドレス
                'key': 'user_email',
                'width': 4,
                'title':
                    WMSLocalizations.i18n(context)!.app_cceptance_user_email,
              },
              {
                //電話番号
                'key': 'user_phone',
                'width': 3,
                'title':
                    WMSLocalizations.i18n(context)!.app_cceptance_user_phone,
              },
              {
                //支払金額
                'key': 'pay_total',
                'width': 3,
                'title':
                    WMSLocalizations.i18n(context)!.app_cceptance_pay_total,
              },
              {
                //支払状態
                'key': 'pay_status_name',
                'width': 3,
                'title':
                    WMSLocalizations.i18n(context)!.app_cceptance_pay_status,
              },
              {
                //申込状態
                'key': 'application_status_name',
                'width': 3,
                'title': WMSLocalizations.i18n(context)!.app_cceptance_status,
              },
              {
                //申込时间
                'key': 'create_time',
                'width': 6,
                'title': WMSLocalizations.i18n(context)!.app_cceptance_time,
              },
            ],
            operatePopupOptions: [
              {
                //明細按钮
                'title': WMSLocalizations.i18n(context)!.delivery_note_8,
                'callback': (_, value) async {
                  try {
                    int appId = value['id'];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ApplicationCceptanceDetail(appId: appId),
                      ),
                    ).then((value) => {
                          // 判断返回值
                          if (value == 'refresh return')
                            {
                              // 初始化事件
                              context
                                  .read<ApplicationCceptanceBloc>()
                                  .add(InitEvent())
                            }
                        });
                  } catch (e) {
                    print('Invalid appId: $e');
                  }
                },
              },
            ],
          ),
        ],
      ),
    );
  }
}
