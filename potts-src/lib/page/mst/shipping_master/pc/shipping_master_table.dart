import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../redux/current_param_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../widget/wms_dialog_widget.dart';
import '../bloc/shipping_master_bloc.dart';
import '../bloc/shipping_master_model.dart';

/**
 * 内容：荷主マスタ-表格
 * 作者：王光顺
 * 时间：2023/11/29
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

class ShippingMasterTable extends StatefulWidget {
  const ShippingMasterTable({super.key});

  @override
  State<ShippingMasterTable> createState() => _ShippingMasterTableState();
}

class _ShippingMasterTableState extends State<ShippingMasterTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShippingMasterBloc, ShippingMasterModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 40, 0, 80),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ShippingMasterTableTab(),
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
                      ShippingMasterTableContent(),
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
class ShippingMasterTableTab extends StatefulWidget {
  ShippingMasterTableTab({
    super.key,
  });

  @override
  State<ShippingMasterTableTab> createState() => _ShippingMasterTableTabState();
}

class _ShippingMasterTableTabState extends State<ShippingMasterTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, ShippingMasterModel state) {
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
    return BlocBuilder<ShippingMasterBloc, ShippingMasterModel>(
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
class ShippingMasterTableContent extends StatefulWidget {
  const ShippingMasterTableContent({super.key});

  @override
  State<ShippingMasterTableContent> createState() =>
      _ShippingMasterTableContentState();
}

class _ShippingMasterTableContentState
    extends State<ShippingMasterTableContent> {
  // 当前悬停下标
  int _currentHoverIndex = Config.NUMBER_NEGATIVE;

  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, ShippingMasterModel state) {
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
            WMSLocalizations.i18n(context)!.shipping_master_form_2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'name',
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
                                context.read<ShippingMasterBloc>().add(
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
                            context.read<ShippingMasterBloc>().add(SetSortEvent(
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
  _initButtonRightList(List buttonItemList, ShippingMasterModel state) {
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
                //传递数据
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentParamAction(value));
                GoRouter.of(context)
                    .push('/shippingMaster/form/0')
                    .then((value) {
                  // 判断返回值
                  if (value == 'refresh return') {
                    // 初始化事件
                    context.read<ShippingMasterBloc>().add(InitEvent());
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
    return BlocBuilder<ShippingMasterBloc, ShippingMasterModel>(
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
                  Container(
                    child: Row(
                      children: _initButtonLeftList(_buttonLeftItemList, state),
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
            WMSTableWidget<ShippingMasterBloc, ShippingMasterModel>(
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
                  'key': 'name',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_2,
                },
                {
                  'key': 'name_kana',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_3,
                },
                {
                  'key': 'name_short',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_4,
                },
                {
                  'key': 'postal_cd',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_5,
                },
                // 都道府県
                {
                  'key': 'addr_1',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_6,
                },
                // 市区町村
                {
                  'key': 'addr_2',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_7,
                },
                // 住所
                {
                  'key': 'addr_3',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_8,
                },
                {
                  'key': 'tel',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_9,
                },
                {
                  'key': 'fax',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_10,
                },
                {
                  'key': 'owner_name',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_11,
                },
                {
                  'key': 'contact',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_12,
                },
                {
                  'key': 'contact_tel',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_13,
                },
                {
                  'key': 'contact_fax',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_14,
                },
                {
                  'key': 'contact_email',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_15,
                },
                {
                  'key': 'start_date',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_16,
                },
                {
                  'key': 'end_date',
                  'width': 200,
                  'title':
                      WMSLocalizations.i18n(context)!.shipping_master_form_17,
                },

                if (state.roleId == 1)
                  {
                    'key': 'company_name',
                    'width': 200,
                    'title':
                        WMSLocalizations.i18n(context)!.company_information_2,
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
                    // 跳转页面
                    GoRouter.of(context)
                        .push('/shippingMaster/form/2')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<ShippingMasterBloc>().add(InitEvent());
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
                    GoRouter.of(context)
                        .push('/shippingMaster/form/1')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<ShippingMasterBloc>().add(InitEvent());
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
    ShippingMasterBloc bloc = context.read<ShippingMasterBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<ShippingMasterBloc>.value(
          value: bloc,
          child: BlocBuilder<ShippingMasterBloc, ShippingMasterModel>(
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
                      .read<ShippingMasterBloc>()
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
