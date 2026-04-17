import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../redux/current_param_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/sp/wms_table_widget.dart';
import '../../../../widget/wms_dialog_widget.dart';
import '../bloc/organization_master_bloc.dart';
import '../bloc/organization_master_model.dart';

/**
 * 内容：組織マスタ-表格
 * 作者：熊草云
 * 时间：2023/11/29
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

class OrganizationMasterTable extends StatefulWidget {
  const OrganizationMasterTable({super.key});

  @override
  State<OrganizationMasterTable> createState() =>
      _OrganizationMasterTableState();
}

class _OrganizationMasterTableState extends State<OrganizationMasterTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizationMasterBloc, OrganizationMasterModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 15, 0, 80),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: OrganizationMasterTableTab(),
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
                      Container(
                        child: OrganizationMasterInformationTableButton(),
                      ),
                      OrganizationMasterTableContent(),
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

// 組織マスタ-表格Tab
// ignore: must_be_immutable
class OrganizationMasterTableTab extends StatefulWidget {
  OrganizationMasterTableTab({
    super.key,
  });

  @override
  State<OrganizationMasterTableTab> createState() =>
      _OrganizationMasterTableTabState();
}

class _OrganizationMasterTableTabState
    extends State<OrganizationMasterTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, OrganizationMasterModel state) {
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
            height: 40,
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
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
              minWidth: 108,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tabItemList[i]['title'],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: state.tableTabIndex == tabItemList[i]['index']
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : tabItemList == tabItemList[i]['index']
                            ? Color.fromRGBO(255, 255, 255, 1)
                            : Color.fromRGBO(6, 14, 15, 1),
                    height: 1.5,
                  ),
                ),
                Container(
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
    return BlocBuilder<OrganizationMasterBloc, OrganizationMasterModel>(
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

class OrganizationMasterInformationTableButton extends StatefulWidget {
  const OrganizationMasterInformationTableButton({super.key});

  @override
  State<OrganizationMasterInformationTableButton> createState() =>
      _OrganizationMasterInformationTableButtonState();
}

class _OrganizationMasterInformationTableButtonState
    extends State<OrganizationMasterInformationTableButton> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, state) {
    List<DropdownMenuItem<String>> getListData() {
      List<DropdownMenuItem<String>> items = [];
      DropdownMenuItem<String> dropdownMenuItem1 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.organization_master_form_2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'code',
      );
      items.add(dropdownMenuItem1);
      DropdownMenuItem<String> dropdownMenuItem2 = new DropdownMenuItem<String>(
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
      items.add(dropdownMenuItem2);
      DropdownMenuItem<String> dropdownMenuItem3 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.organization_master_form_1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'parent_id',
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
                        width: 70,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: state.sortCol,
                            isExpanded: true, // 使 DropdownButton 填满宽度
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ),
                            items: getListData(),
                            onChanged: (String? newValue) {
                              setState(() {
                                state.sortCol = newValue!;
                                context.read<OrganizationMasterBloc>().add(
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
                            context.read<OrganizationMasterBloc>().add(
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
                            fontSize: 12, // 设置字体大小
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
      } else {
        // 按钮列表
        buttonList.add(
          GestureDetector(
            onTap: () {
              Map<String, dynamic> value = {};
              //传递数据
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshCurrentParamAction(value));
              GoRouter.of(context)
                  .push('/organizationMaster/from/0')
                  .then((value) {
                // 判断返回值
                if (value == 'refresh return') {
                  // 初始化事件
                  context.read<OrganizationMasterBloc>().add(InitEvent());
                }
              });
            },
            child: Container(
              height: 37,
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      color: Color.fromRGBO(0, 122, 255, 1),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    // 按钮列表
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    // 左侧按钮单个列表
    List _buttonLeftItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_button_add,
        'sort': false,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!.table_sort_column,
        'sort': true,
      },
    ];

    return BlocBuilder<OrganizationMasterBloc, OrganizationMasterModel>(
      builder: (context, state) {
        return Container(
          height: 37,
          child: Stack(
            children: [
              Container(
                child: Row(
                  children: _initButtonLeftList(_buttonLeftItemList, state),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 組織マスタ-表格内容
class OrganizationMasterTableContent extends StatefulWidget {
  const OrganizationMasterTableContent({super.key});

  @override
  State<OrganizationMasterTableContent> createState() =>
      _OrganizationMasterTableContentState();
}

class _OrganizationMasterTableContentState
    extends State<OrganizationMasterTableContent> {
  // 获取表格数据

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizationMasterBloc, OrganizationMasterModel>(
      builder: (context, state) {
        return Column(
          children: [
            WMSTableWidget<OrganizationMasterBloc, OrganizationMasterModel>(
              //复选框关闭
              showCheckboxColumn: false,
              columns: [
                {
                  'key': 'id',
                  'width': .2,
                  'title': "ID",
                },
                {
                  'key': 'parent_id',
                  'width': .2,
                  'title': WMSLocalizations.i18n(context)!
                      .organization_master_form_1,
                },
                {
                  'key': 'code',
                  'width': .6,
                  'title': WMSLocalizations.i18n(context)!
                      .organization_master_form_2,
                },
                {
                  'key': 'name',
                  'width': .5,
                  'title': WMSLocalizations.i18n(context)!
                      .organization_master_form_3,
                },
                if (state.roleId == 1)
                  {
                    'key': 'company_name',
                    'width': .5,
                    'title':
                        WMSLocalizations.i18n(context)!.company_information_2,
                  },
                {
                  'key': 'content',
                  'width': .5,
                  'title': WMSLocalizations.i18n(context)!
                      .organization_master_form_4,
                }
              ],
              operatePopupHeight: 170,
              operatePopupOptions: [
                {
                  //明細按钮
                  'title': WMSLocalizations.i18n(context)!.delivery_note_8,
                  'callback': (_, value) async {
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentParamAction(value)); //页面取值
                    GoRouter.of(context)
                        .push('/organizationMaster/from/2')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<OrganizationMasterBloc>().add(InitEvent());
                      }
                    });
                  },
                },
                {
                  //修正按钮
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_tab_button_update,
                  'callback': (_, value) async {
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentParamAction(value)); //页面取值
                    GoRouter.of(context)
                        .push('/organizationMaster/from/1')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<OrganizationMasterBloc>().add(InitEvent());
                      }
                    });
                  },
                },
                {
                  //删除按钮
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_operate_delete,
                  'callback': (_, value) async {
                    // // 删除弹窗
                    _deleteDialog(value['id'], context);
                  },
                },
              ],
            )
          ],
        );
      },
    );
  }

  // 删除弹窗
  _deleteDialog(int id, BuildContext parentContext) {
    OrganizationMasterBloc bloc = context.read<OrganizationMasterBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<OrganizationMasterBloc>.value(
          value: bloc,
          child: BlocBuilder<OrganizationMasterBloc, OrganizationMasterModel>(
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
                  // 删除出荷指示明细事件
                  context
                      .read<OrganizationMasterBloc>()
                      .add(DeleteMessageDataEvent(parentContext, id));
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
