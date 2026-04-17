import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/current_param_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/pc/wms_table_widget.dart';
import '../bloc/license_management_bloc.dart';
import '../bloc/license_management_model.dart';

/**
 * 内容：ライセンス管理-表格
 * 作者：王光顺
 * 时间：2023/12/05
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

class LicenseManagementTable extends StatefulWidget {
  const LicenseManagementTable({super.key});

  @override
  State<LicenseManagementTable> createState() => _LicenseManagementTableState();
}

class _LicenseManagementTableState extends State<LicenseManagementTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LicenseManagementBloc, LicenseManagementModel>(
      builder: (context, state) {
        return Scrollbar(
          thumbVisibility: true,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 40, 0, 80),
            child: Column(
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: LicenseManagementTableTab(),
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
                        LicenseManagementTableContent(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ライセンス管理-表格Tab
// ignore: must_be_immutable
class LicenseManagementTableTab extends StatefulWidget {
  LicenseManagementTableTab({
    super.key,
  });

  @override
  State<LicenseManagementTableTab> createState() =>
      _LicenseManagementTableTabState();
}

class _LicenseManagementTableTabState extends State<LicenseManagementTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, LicenseManagementModel state) {
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
    return BlocBuilder<LicenseManagementBloc, LicenseManagementModel>(
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

// ライセンス管理-表格内容
class LicenseManagementTableContent extends StatefulWidget {
  const LicenseManagementTableContent({super.key});

  @override
  State<LicenseManagementTableContent> createState() =>
      _LicenseManagementTableContentState();
}

class _LicenseManagementTableContentState
    extends State<LicenseManagementTableContent> {
  // 当前悬停下标
  int _currentHoverIndex = Config.NUMBER_NEGATIVE;

  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList, LicenseManagementModel state) {
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
                Map<String, dynamic> value = {};
                //数据存入
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentParamAction(value));
                //页面取值
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentFlagAction(true));
                // 登录按钮跳转页面
                GoRouter.of(context)
                    .push('/' + Config.PAGE_FLAG_98_23 + '/details/0/1')
                    .then((value) {
                  // 判断返回值
                  if (value == 'refresh return') {
                    // 初始化事件
                    context.read<LicenseManagementBloc>().add(InitEvent());
                  }
                });
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LicenseManagementBloc, LicenseManagementModel>(
      builder: (context, state) {
        // 右侧按钮单个列表
        List _buttonRightItemList = [
          //登录新增按钮
          {
            'index': Config.NUMBER_ZERO,
            'icon': WMSICons.MASTER_LOGIN_ICON,
            'title': WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_add,
          },
        ];

        return Column(
          children: [
            Container(
              height: 37,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
              child: Stack(
                children: [
                  Container(),
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
            WMSTableWidget<LicenseManagementBloc, LicenseManagementModel>(
              //复选框关闭
              showCheckboxColumn: false,
              isFlex: false,
              columns: [
                {
                  'key': 'id',
                  'width': 100,
                  'title': "ID",
                },
                {
                  //ロール
                  'key': 'role',
                  'width': 200,
                  'title': WMSLocalizations.i18n(context)!.account_profile_roll,
                },
                {
                  //ライセンスの種類
                  'key': 'type',
                  'width': 200,
                  'title': WMSLocalizations.i18n(context)!.account_license_type,
                },
                {
                  //サポート内容
                  'key': 'support_cotent',
                  'width': 200,
                  'title': WMSLocalizations.i18n(context)!.license_management_1,
                },
                {
                  //金額
                  'key': 'amount',
                  'width': 200,
                  'title': WMSLocalizations.i18n(context)!.delivery_note_43,
                },
                // 有効期間(年)
                {
                  'key': 'expiration_year',
                  'width': 200,
                  'title': WMSLocalizations.i18n(context)!.license_management_2,
                },
                // 有効期間(月)
                {
                  'key': 'expiration_month',
                  'width': 200,
                  'title': WMSLocalizations.i18n(context)!.license_management_3,
                },
                // 有効期間(日)
                {
                  'key': 'expiration_day',
                  'width': 200,
                  'title': WMSLocalizations.i18n(context)!.license_management_4,
                },
                {
                  //開始日
                  'key': 'start_date',
                  'width': 200,
                  'title': WMSLocalizations.i18n(context)!.menu_content_4_10_3,
                },
                {
                  //終了日
                  'key': 'end_date',
                  'width': 200,
                  'title': WMSLocalizations.i18n(context)!.menu_content_4_10_4,
                },
              ],
              operatePopupHeight: 135,
              operatePopupOptions: [
                {
                  //明細按钮
                  'title': WMSLocalizations.i18n(context)!.delivery_note_8,
                  'callback': (_, value) async {
                    //数据存入
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentParamAction(value));
                    //页面取值
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentFlagAction(true));
                    // 跳转页面
                    GoRouter.of(context)
                        .push('/' +
                            Config.PAGE_FLAG_98_23 +
                            '/details/' +
                            value['id'].toString() +
                            '/0')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<LicenseManagementBloc>().add(InitEvent());
                      }
                    });
                  },
                },
                {
                  //修正按钮
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_tab_button_update,
                  'callback': (_, value) async {
                    if (value['push_kbn'] == 1) {
                      // 失败提示
                      WMSCommonBlocUtils.errorTextToast(
                          WMSLocalizations.i18n(context)!.message_master_6);
                      return false;
                    }
                    //数据存入
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentParamAction(value));
                    //页面取值
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentFlagAction(true));
                    // 跳转页面
                    GoRouter.of(context)
                        .push('/' +
                            Config.PAGE_FLAG_98_23 +
                            '/details/' +
                            value['id'].toString() +
                            '/1')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<LicenseManagementBloc>().add(InitEvent());
                      }
                    });
                  },
                },
              ],
            )
          ],
        );
      },
    );
  }
}
