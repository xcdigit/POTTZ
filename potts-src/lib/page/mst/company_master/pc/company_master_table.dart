import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/current_param_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/pc/wms_table_widget.dart';
import '../bloc/company_master_bloc.dart';
import '../bloc/company_master_model.dart';

/**
 * 内容：会社情報マスタ管理-表格
 * 作者：王光顺
 * 时间：2023/09/05
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

class CompanyMasterTable extends StatefulWidget {
  const CompanyMasterTable({super.key});

  @override
  State<CompanyMasterTable> createState() => _CompanyMasterTableState();
}

class _CompanyMasterTableState extends State<CompanyMasterTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyMasterBloc, CompanyMasterModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 40, 0, 80),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: CompanyMasterTableTab(),
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
                      CompanyMasterTableContent(),
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
class CompanyMasterTableTab extends StatefulWidget {
  CompanyMasterTableTab({
    super.key,
  });

  @override
  State<CompanyMasterTableTab> createState() => _CompanyMasterTableTabState();
}

class _CompanyMasterTableTabState extends State<CompanyMasterTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, CompanyMasterModel state) {
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
    return BlocBuilder<CompanyMasterBloc, CompanyMasterModel>(
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
class CompanyMasterTableContent extends StatefulWidget {
  const CompanyMasterTableContent({super.key});

  @override
  State<CompanyMasterTableContent> createState() =>
      _CompanyMasterTableContentState();
}

class _CompanyMasterTableContentState extends State<CompanyMasterTableContent> {
  // 当前悬停下标
  int _currentHoverIndex = Config.NUMBER_NEGATIVE;
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, CompanyMasterModel state) {
    List<DropdownMenuItem<String>> getListData() {
      List<DropdownMenuItem<String>> items = [];
      DropdownMenuItem<String> dropdownMenuItem1 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.company_information_1,
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
            WMSLocalizations.i18n(context)!.company_information_4,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'corporate_cd',
      );
      items.add(dropdownMenuItem2);
      DropdownMenuItem<String> dropdownMenuItem3 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.company_information_6,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'postal_cd',
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
                                context.read<CompanyMasterBloc>().add(
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
                            context.read<CompanyMasterBloc>().add(SetSortEvent(
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

  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList, CompanyMasterModel state) {
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
                    .push('/companyMaster/details/0/1')
                    .then((value) {
                  // 判断返回值
                  if (value == 'refresh return') {
                    // 初始化事件
                    context.read<CompanyMasterBloc>().add(InitEvent());
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
    return BlocBuilder<CompanyMasterBloc, CompanyMasterModel>(
      builder: (context, state) {
        // 左侧按钮单个列表
        List _buttonLeftItemList = [
          {
            'index': Config.NUMBER_THREE,
            'title': WMSLocalizations.i18n(context)!.table_sort_column,
            'sort': true,
          },
        ];
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
            Visibility(
              visible: !state.onlyMyselfData,
              child: Container(
                height: 37,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
                child: Stack(
                  children: [
                    Container(
                      child: Row(
                        children:
                            _initButtonLeftList(_buttonLeftItemList, state),
                      ),
                    ),
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
            ),
            WMSTableWidget<CompanyMasterBloc, CompanyMasterModel>(
              showCheckboxColumn: false,
              isFlex: false,
              columns: [
                {
                  'key': 'id',
                  'width': 50,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_1,
                },
                {
                  //会社名
                  'key': 'name',
                  'width': 300,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_2,
                },
                {
                  //略称
                  'key': 'name_short',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_3,
                },
                {
                  //法人番号
                  'key': 'corporate_cd',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_4,
                },
                {
                  //適格請求登録番号
                  'key': 'qrr_cd',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_5,
                },
                {
                  //郵便番号
                  'key': 'postal_cd',
                  'width': 150,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_6,
                },
                {
                  //都道府県
                  'key': 'addr_1',
                  'width': 100,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_7,
                },
                {
                  //市区町村
                  'key': 'addr_2',
                  'width': 100,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_8,
                },
                {
                  //住所
                  'key': 'addr_3',
                  'width': 300,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_9,
                },
                {
                  //電話番号
                  'key': 'tel',
                  'width': 150,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_10,
                },
                {
                  //FAX番号
                  'key': 'fax',
                  'width': 150,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_11,
                },
                {
                  //URL
                  'key': 'url',
                  'width': 150,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_12,
                },
                {
                  //email
                  'key': 'email',
                  'width': 150,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_13,
                },
                {
                  //状態
                  'key': 'status_name',
                  'width': 100,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_14,
                },
                {
                  //強制出荷
                  'key': 'forced_shipment_flag_name',
                  'width': 100,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_15,
                },
              ],
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
                        .push('/companyMaster/details/' +
                            value['id'].toString() +
                            '/0')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<CompanyMasterBloc>().add(InitEvent());
                      }
                    });
                  },
                },
                {
                  //修正按钮
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_tab_button_update,
                  'callback': (_, value) async {
                    //数据存入
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentParamAction(value));
                    //页面取值
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentFlagAction(true));
                    // 跳转页面
                    GoRouter.of(context)
                        .push('/companyMaster/details/' +
                            value['id'].toString() +
                            '/1')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<CompanyMasterBloc>().add(InitEvent());
                      }
                    });
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
