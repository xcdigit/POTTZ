import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../widget/table/pc/wms_table_widget.dart';
import '../bloc/application_cancel_bloc.dart';
import '../bloc/application_cancel_model.dart';

/**
 * 内容：解约受付-表格
 * 作者：赵士淞
 * 时间：2025/01/08
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

class ApplicationCancelTable extends StatefulWidget {
  const ApplicationCancelTable({super.key});

  @override
  State<ApplicationCancelTable> createState() => _ApplicationCancelTableState();
}

class _ApplicationCancelTableState extends State<ApplicationCancelTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationCancelBloc, ApplicationCancelModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 40, 0, 40),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ApplicationCancelTableTab(),
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
                      ApplicationCancelTableContent(),
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

// 表格标签
class ApplicationCancelTableTab extends StatefulWidget {
  const ApplicationCancelTableTab({super.key});

  @override
  State<ApplicationCancelTableTab> createState() =>
      _ApplicationCancelTableTabState();
}

class _ApplicationCancelTableTabState extends State<ApplicationCancelTableTab> {
  // 初始化标签列表
  List<Widget> _initTabList(tabItemList, ApplicationCancelModel state) {
    // 标签列表
    List<Widget> tabList = [];
    // 循环标签单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // 标签列表
      tabList.add(
        MouseRegion(
          onEnter: (event) {
            // 状态变更
            setState(() {
              // 当前下标
              currentIndex = tabItemList[i]['index'];
            });
          },
          onExit: (event) {
            // 状态变更
            setState(() {
              // 当前下标
              currentIndex = Config.NUMBER_NEGATIVE;
            });
          },
          child: GestureDetector(
            onPanDown: (details) {
              // 表格标签下标变更事件
              context
                  .read<ApplicationCancelBloc>()
                  .add(TableTabIndexChangeEvent(tabItemList[i]['index']));
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
        ),
      );
    }
    // Tab列表
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationCancelBloc, ApplicationCancelModel>(
      builder: (context, state) {
        // 标签单个列表
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

// 表格内容
class ApplicationCancelTableContent extends StatefulWidget {
  const ApplicationCancelTableContent({super.key});

  @override
  State<ApplicationCancelTableContent> createState() =>
      _ApplicationCancelTableContentState();
}

class _ApplicationCancelTableContentState
    extends State<ApplicationCancelTableContent> {
// 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, ApplicationCancelModel state) {
    List<DropdownMenuItem<String>> getListData() {
      List<DropdownMenuItem<String>> items = [];
      DropdownMenuItem<String> dropdownMenuItem1 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.app_cancel_time,
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
            WMSLocalizations.i18n(context)!.app_cancel_status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'admin_confirm_status',
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
                                context.read<ApplicationCancelBloc>().add(
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
                            context.read<ApplicationCancelBloc>().add(
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
    return BlocBuilder<ApplicationCancelBloc, ApplicationCancelModel>(
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
          WMSTableWidget<ApplicationCancelBloc, ApplicationCancelModel>(
            showCheckboxColumn: true,
            operatePopupHeight: 100,
            columns: [
              {
                // 公司名称
                'key': 'company_name',
                'width': 1,
                'title':
                    WMSLocalizations.i18n(context)!.app_cceptance_company_name,
              },
              {
                // 人员名称
                'key': 'user_name',
                'width': 1,
                'title':
                    WMSLocalizations.i18n(context)!.app_cceptance_user_name,
              },
              {
                // 电子邮箱
                'key': 'user_email',
                'width': 1,
                'title':
                    WMSLocalizations.i18n(context)!.app_cceptance_user_email,
              },
              {
                // 解约状态
                'key': 'admin_confirm_status_name',
                'width': 1,
                'title': WMSLocalizations.i18n(context)!.app_cancel_status,
              },
              {
                // 解约时间
                'key': 'create_time_format',
                'width': 1,
                'title': WMSLocalizations.i18n(context)!.app_cancel_time,
              },
            ],
            operatePopupOptions: [
              {
                // 确认按钮
                'title':
                    WMSLocalizations.i18n(context)!.app_cancel_status_confirm,
                'callback': (_, value) async {
                  print(value);
                  // 判断解约状态
                  if (value['admin_confirm_status'] ==
                      Config.NUMBER_ZERO.toString()) {
                    // 确认解约事件
                    context
                        .read<ApplicationCancelBloc>()
                        .add(ConfirmCancelEvent(value['id']));
                  } else if (value['admin_confirm_status'] ==
                      Config.NUMBER_ONE.toString()) {
                    // 消息提示
                    WMSCommonBlocUtils.tipTextToast(
                        WMSLocalizations.i18n(context)!
                            .app_cancel_confirmed_no_operation);
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
