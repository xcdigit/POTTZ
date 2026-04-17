import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/widget/wms_dialog_widget.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/current_param_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/pc/wms_table_widget.dart';
import '../bloc/user_license_management_bloc.dart';
import '../bloc/user_license_management_model.dart';

/**
 * 内容：ユーザーライセンス管理-表格
 * 作者：熊草云
 * 时间：2023/12/07
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

class UserLicenseManagementTable extends StatefulWidget {
  const UserLicenseManagementTable({super.key});

  @override
  State<UserLicenseManagementTable> createState() =>
      _UserLicenseManagementTableState();
}

class _UserLicenseManagementTableState
    extends State<UserLicenseManagementTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserLicenseManagementBloc, UserLicenseManagementModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 40, 0, 80),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: UserLicenseManagementTableTab(),
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
                      UserLicenseManagementTableContent(),
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
class UserLicenseManagementTableTab extends StatefulWidget {
  UserLicenseManagementTableTab({
    super.key,
  });

  @override
  State<UserLicenseManagementTableTab> createState() =>
      _UserLicenseManagementTableTabState();
}

class _UserLicenseManagementTableTabState
    extends State<UserLicenseManagementTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, UserLicenseManagementModel state) {
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
    return BlocBuilder<UserLicenseManagementBloc, UserLicenseManagementModel>(
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
class UserLicenseManagementTableContent extends StatefulWidget {
  const UserLicenseManagementTableContent({super.key});

  @override
  State<UserLicenseManagementTableContent> createState() =>
      _UserLicenseManagementTableContentState();
}

class _UserLicenseManagementTableContentState
    extends State<UserLicenseManagementTableContent> {
  // 删除弹窗
  _deleteDialog(value) {
    UserLicenseManagementBloc bloc = context.read<UserLicenseManagementBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<UserLicenseManagementBloc>.value(
          value: bloc,
          child: BlocBuilder<UserLicenseManagementBloc,
              UserLicenseManagementModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .display_instruction_confirm_delete,
                contentText: WMSLocalizations.i18n(context)!
                        .user_license_management_form_1 +
                    '：' +
                    value['user_name'].toString() +
                    ' ' +
                    WMSLocalizations.i18n(context)!.display_instruction_delete,
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                buttonRightText:
                    WMSLocalizations.i18n(context)!.delivery_note_10,
                onPressedLeft: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                },
                onPressedRight: () async {
                  context.read<UserLicenseManagementBloc>().add(DeleteUserEvent(
                      context, value['id'], value['code'].toString()));

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

  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, UserLicenseManagementModel state) {
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
            WMSLocalizations.i18n(context)!.account_profile_user,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'email',
      );
      items.add(dropdownMenuItem2);
      DropdownMenuItem<String> dropdownMenuItem3 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.account_profile_roll,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'role_name',
      );
      items.add(dropdownMenuItem3);
      DropdownMenuItem<String> dropdownMenuItem4 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.organization_master_form_3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'organization_name',
      );
      items.add(dropdownMenuItem4);
      DropdownMenuItem<String> dropdownMenuItem5 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.company_information_2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'company_name',
      );
      items.add(dropdownMenuItem5);
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
                                context.read<UserLicenseManagementBloc>().add(
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
                            context.read<UserLicenseManagementBloc>().add(
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
    return BlocBuilder<UserLicenseManagementBloc, UserLicenseManagementModel>(
      builder: (context, state) {
        // 左侧按钮单个列表
        List _buttonLeftItemList = [
          {
            'index': Config.NUMBER_THREE,
            'title': WMSLocalizations.i18n(context)!.table_sort_column,
            'sort': true,
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
                ],
              ),
            ),
            WMSTableWidget<UserLicenseManagementBloc,
                UserLicenseManagementModel>(
              showCheckboxColumn: false,
              isFlex: true,
              columns: [
                {
                  'key': 'id',
                  'width': 2,
                  'title': 'ID',
                },
                {
                  //Email
                  'key': 'email',
                  'width': 6,
                  'title': WMSLocalizations.i18n(context)!.account_profile_user,
                },
                {
                  //ユーザー_名称
                  'key': 'user_name',
                  'width': 5,
                  'title': WMSLocalizations.i18n(context)!
                      .user_license_management_form_1,
                },
                {
                  //ロール
                  'key': 'role_name',
                  'width': 5,
                  'title': WMSLocalizations.i18n(context)!.account_profile_roll,
                },
                {
                  //組織
                  'key': 'organization_name',
                  'width': 5,
                  'title': WMSLocalizations.i18n(context)!
                      .organization_master_form_3,
                },
                {
                  //会社名
                  'key': 'company_name',
                  'width': 6,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_2,
                },
                {
                  //状態
                  'key': 'status_name',
                  'width': 3,
                  'title':
                      WMSLocalizations.i18n(context)!.account_profile_state,
                },
                // {
                //   //開始日
                //   'key': 'start_date',
                //   'width': 5,
                //   'title': WMSLocalizations.i18n(context)!.menu_content_4_10_3,
                // },
                // {
                //   //終了日
                //   'key': 'end_date',
                //   'width': 5,
                //   'title': WMSLocalizations.i18n(context)!.menu_content_4_10_4,
                // },
                {
                  //言語
                  'key': 'language_name',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!
                      .user_license_management_form_2,
                },
              ],
              operatePopupHeight: 170,
              operatePopupOptions: [
                {
                  //明細按钮
                  'title': WMSLocalizations.i18n(context)!.delivery_note_8,
                  'callback': (_, value) async {
                    //数据存入
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentParamAction(value));
                    GoRouter.of(context)
                        .push(
                      '/' +
                          Config.PAGE_FLAG_98_24 +
                          '/details/' +
                          value['id'].toString(),
                    )
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh') {
                        // 初始化事件
                        context
                            .read<UserLicenseManagementBloc>()
                            .add(InitEvent());
                      }
                    });
                  },
                },
                {
                  //删除按钮
                  'title': WMSLocalizations.i18n(context)!.delivery_note_10,
                  'callback': (_, value) async {
                    _deleteDialog(value);
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
