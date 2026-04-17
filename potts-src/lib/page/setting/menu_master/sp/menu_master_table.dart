import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/redux/current_flag_reducer.dart';
import 'package:wms/redux/current_param_reducer.dart';
import 'package:wms/redux/wms_state.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../widget/table/sp/wms_table_widget.dart';
import '../../../../widget/wms_dialog_widget.dart';
import '../bloc/menu_master_bloc.dart';
import '../bloc/menu_master_model.dart';

/**
 * 内容：メニューマスタ管理-表格
 * 作者：熊草云
 * 时间：2023/09/05
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

class MenuMasterTable extends StatefulWidget {
  const MenuMasterTable({super.key});

  @override
  State<MenuMasterTable> createState() => _MenuMasterTableState();
}

class _MenuMasterTableState extends State<MenuMasterTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuMasterBloc, MenuMasterModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 40),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: MenuMasterTableTab(),
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
                      MenuMasterTableContent(),
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
class MenuMasterTableTab extends StatefulWidget {
  MenuMasterTableTab({
    super.key,
  });

  @override
  State<MenuMasterTableTab> createState() => _MenuMasterTableTabState();
}

class _MenuMasterTableTabState extends State<MenuMasterTableTab> {
  // 初始化Tab列表
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
              minWidth: 108,
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
      );
    }
    // Tab列表
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuMasterBloc, MenuMasterModel>(
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

// -表格内容
class MenuMasterTableContent extends StatefulWidget {
  const MenuMasterTableContent({super.key});

  @override
  State<MenuMasterTableContent> createState() => _MenuMasterTableContentState();
}

class _MenuMasterTableContentState extends State<MenuMasterTableContent> {
  // 删除弹窗
  _deleteDialog(int id, BuildContext parentContext) {
    MenuMasterBloc bloc = context.read<MenuMasterBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<MenuMasterBloc>.value(
          value: bloc,
          child: BlocBuilder<MenuMasterBloc, MenuMasterModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .display_instruction_confirm_delete,
                contentText: WMSLocalizations.i18n(context)!
                        .instruction_input_table_title_8 +
                    '：' +
                    id.toString() +
                    ' ' +
                    WMSLocalizations.i18n(context)!.display_instruction_delete,
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                buttonRightText:
                    WMSLocalizations.i18n(context)!.delivery_note_10,
                onPressedLeft: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                },
                onPressedRight: () {
                  // 删除商品事件
                  context
                      .read<MenuMasterBloc>()
                      .add(DeleteMenuEvent(parentContext, id));
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
  _initButtonLeftList(List buttonItemList, MenuMasterModel state) {
    List<DropdownMenuItem<String>> getListData() {
      List<DropdownMenuItem<String>> items = [];
      DropdownMenuItem<String> dropdownMenuItem1 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.menu_master_form_1,
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
            WMSLocalizations.i18n(context)!.menu_master_form_2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'parent_id',
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
                                context.read<MenuMasterBloc>().add(SetSortEvent(
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
                            context.read<MenuMasterBloc>().add(SetSortEvent(
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
  _initButtonRightList(List buttonItemList, MenuMasterModel state) {
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
                    Map<String, dynamic> value = {};
                    //数据存入
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentParamAction(value));
                    //页面取值
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentFlagAction(true));
                    // 登录按钮跳转页面
                    GoRouter.of(context)
                        .push('/menuMaster/details/0/1')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<MenuMasterBloc>().add(InitEvent());
                      }
                    });
                  }
                },
                child: Container(
                  height: 37,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        WMSICons.MASTER_LOGIN_ICON,
                        height: 17,
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
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
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  // 获取表格数据
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuMasterBloc, MenuMasterModel>(
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
            'title': WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_add,
          },
        ];
        return Column(
          children: [
            Container(
              child: Row(children: [
                _initButtonLeftList(_buttonLeftItemList, state),
                _initButtonRightList(_buttonRightItemList, state),
              ]),
            ),
            WMSTableWidget<MenuMasterBloc, MenuMasterModel>(
              operatePopupHeight: 170,
              headTitle: 'id',
              columns: [
                {
                  //メニューID
                  'key': 'id',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.menu_master_form_1,
                },
                {
                  //親メニュー
                  'key': 'parent_name',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.menu_master_form_2,
                },
                {
                  //メニュー_名称
                  'key': 'name',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.menu_master_form_3,
                },
                {
                  //メニュー_説明
                  'key': 'description',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.menu_master_form_4,
                },
                {
                  //メニューパス
                  'key': 'path',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.menu_master_form_5,
                }
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
                        .push('/menuMaster/details/' +
                            value['id'].toString() +
                            '/0')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<MenuMasterBloc>().add(InitEvent());
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
                        .push('/menuMaster/details/' +
                            value['id'].toString() +
                            '/1')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<MenuMasterBloc>().add(InitEvent());
                      }
                    });
                  },
                },
                {
                  //消除按钮
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_operate_delete,
                  'callback': (_, value) async {
                    //消除弹窗
                    _deleteDialog(value['id'], context);
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
