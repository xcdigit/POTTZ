import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/redux/current_flag_reducer.dart';
import 'package:wms/redux/wms_state.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/menu_master_bloc.dart';
import '../bloc/menu_master_model.dart';

/**
 * 内容：メニューマスタ管理-表单
 * 作者：熊草云
 * 时间：2023/09/05
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

// ignore: must_be_immutable
class MenuMasterForm extends StatefulWidget {
  int menuId; //menuid
  int flag; //按钮跳转判断
  MenuMasterForm({super.key, required this.menuId, required this.flag});

  @override
  State<MenuMasterForm> createState() => _MenuMasterFormState();
}

class _MenuMasterFormState extends State<MenuMasterForm> {
  @override
  Widget build(BuildContext context) {
    //商品数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    //控制页面刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;

    return BlocProvider<MenuMasterBloc>(
      create: (context) {
        return MenuMasterBloc(
          MenuMasterModel(context: context),
        );
      },
      child: BlocBuilder<MenuMasterBloc, MenuMasterModel>(
        builder: (context, state) {
          if (currentFlag) {
            //明细按钮输入框不可输入
            if (widget.flag == 0) {
              context
                  .read<MenuMasterBloc>()
                  .add(ShowSelectValueEvent(data, "2"));
              //控制刷新
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshCurrentFlagAction(false));
            } else {
              //登录和修正按钮，输入框可以输入
              context
                  .read<MenuMasterBloc>()
                  .add(ShowSelectValueEvent(data, "1"));
              //控制刷新
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshCurrentFlagAction(false));
            }
          }
          // 初始化基本情報入力表单
          List<Widget> _initFormBasic() {
            return [
              //メニューID
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.menu_master_form_1,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSInputboxWidget(
                        text: state.formInfo['id'].toString(),
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
              ),
              //親メニュー
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.menu_master_form_2,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      state.stateFlg != '2'
                          ? WMSDropdownWidget(
                              saveInput: true,
                              dataList1: state.parentList,
                              inputInitialValue:
                                  state.formInfo['parent_name'].toString(),
                              inputRadius: 4,
                              inputSuffixIcon: Container(
                                width: 24,
                                height: 24,
                                margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                ),
                              ),
                              inputFontSize: 14,
                              dropdownRadius: 4,
                              dropdownTitle: 'name',
                              selectedCallBack: (value) {
                                // 判断数值
                                if (value == '') {
                                  // 设定值
                                  context.read<MenuMasterBloc>().add(
                                      SetDropdownValueEvent('parent_id', ''));
                                  context.read<MenuMasterBloc>().add(
                                      SetDropdownValueEvent('parent_name', ''));
                                } else if (value is String) {
                                  // 设定出荷指示值事件
                                  context.read<MenuMasterBloc>().add(
                                      SetDropdownValueEvent(
                                          'parent_name', value));
                                } else {
                                  // 设定值
                                  context.read<MenuMasterBloc>().add(
                                      SetDropdownValueEvent(
                                          'parent_id', value['id']));
                                  context.read<MenuMasterBloc>().add(
                                      SetDropdownValueEvent(
                                          'parent_name', value['name']));
                                  // context.read<MenuMasterBloc>().add(
                                  //     SetDropdownValueEvent(
                                  //         value['id'].toString(), value['name']));
                                }
                              },
                            )
                          : WMSInputboxWidget(
                              text: state.formInfo['parent_name'].toString(),
                              readOnly: true,
                            ),
                    ],
                  ),
                ),
              ),
              //メニュー_名称
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!
                                  .menu_master_form_3,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 0, 0, 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      WMSInputboxWidget(
                        text: state.formInfo['name'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定值
                          context
                              .read<MenuMasterBloc>()
                              .add(SetMenuValueEvent('name', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //メニュー_説明
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.menu_master_form_4,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSInputboxWidget(
                        text: state.formInfo['description'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定值
                          context
                              .read<MenuMasterBloc>()
                              .add(SetMenuValueEvent('description', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //メニュー_パス
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!
                                  .menu_master_form_5,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 0, 0, 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      WMSInputboxWidget(
                        text: state.formInfo['path'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定值
                          context
                              .read<MenuMasterBloc>()
                              .add(SetMenuValueEvent('path', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //表单按钮
              Visibility(
                visible: widget.flag == 1,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: MenuMasterFormButton(
                      state: state,
                      menuId: widget.menuId,
                    ),
                  ),
                ),
              ),
            ];
          }

          return Container(
            margin: EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: ListView(
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.6,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: MenuMasterFormTab(),
                        ),
                      ),
                    ],
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
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceBetween,
                      children: _initFormBasic(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 出荷指示入力-表单Tab
// ignore: must_be_immutable
class MenuMasterFormTab extends StatefulWidget {
  MenuMasterFormTab({super.key});

  @override
  State<MenuMasterFormTab> createState() => _MenuMasterFormTabState();
}

class _MenuMasterFormTabState extends State<MenuMasterFormTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList) {
    // Tab列表
    List<Widget> tabList = [];
    tabList.add(
      Container(
        child: Container(
          height: 40,
          padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
          margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(44, 167, 176, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          constraints: BoxConstraints(
            minWidth: 108,
          ),
          child: Text(
            tabItemList[0]['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
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
    // Tab单个列表
    List _tabItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.reserve_input_2,
      },
    ];

    return Row(
      children: _initTabList(_tabItemList),
    );
  }
}

// 出荷指示入力-表单按钮
// ignore: must_be_immutable
class MenuMasterFormButton extends StatefulWidget {
  MenuMasterModel state;
  int menuId;
  MenuMasterFormButton({super.key, required this.state, required this.menuId});

  @override
  State<MenuMasterFormButton> createState() => _MenuMasterFormButtonState();
}

class _MenuMasterFormButtonState extends State<MenuMasterFormButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(List buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        GestureDetector(
          child: Container(
            height: 37,
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  buttonItemList[i]['index'] == Config.NUMBER_ZERO
                      ? Color.fromRGBO(44, 167, 176, 1)
                      : (widget.state.stateFlg == '2'
                          ? Color.fromRGBO(95, 97, 97, 1)
                          : Color.fromRGBO(44, 167, 176, 1)),
                ), // 设置按钮背景颜色
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white), // 设置按钮文本颜色
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(80, 37),
                ), // 设置按钮宽度和高度
              ),
              onPressed: () {
                // 判断循环下标
                if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                  //新增/修改数据
                  context.read<MenuMasterBloc>().add(UpdateFormEvent(context));
                }
              },
              child: Text(
                buttonItemList[i]['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(255, 255, 255, 1),
                  height: 1.28,
                ),
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
    // 按钮单个列表
    List _buttonItemList = [
      // {
      //   'index': Config.NUMBER_ZERO,
      //   'title': WMSLocalizations.i18n(context)!.exit_input_form_button_clear,
      // },
      {
        'index': Config.NUMBER_ONE,
        'title': widget.menuId == 0
            ? WMSLocalizations.i18n(context)!.instruction_input_tab_button_add
            : WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_update,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _initButtonList(_buttonItemList),
    );
  }
}
