import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/redux/current_flag_reducer.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/role_master_bloc.dart';
import '../bloc/role_master_model.dart';

/**
* 内容：ロールマスタ管理 -基本信息
 * 作者：cuihr
 * 时间：2023/09/05
 */

// ignore: must_be_immutable
class RoleMasterForm extends StatefulWidget {
  int roleId; //角色id
  int flag; //按钮跳转判断
  RoleMasterForm({super.key, required this.roleId, required this.flag});

  @override
  State<RoleMasterForm> createState() => _RoleMasterFormState();
}

class _RoleMasterFormState extends State<RoleMasterForm> {
  @override
  Widget build(BuildContext context) {
    //仓库数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    //控制页面刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;

    return BlocProvider<RoleMasterBloc>(
      create: (context) {
        return RoleMasterBloc(
          RoleMasterModel(
            context: context,
          ),
        );
      },
      child: BlocBuilder<RoleMasterBloc, RoleMasterModel>(
        builder: (context, state) {
          if (currentFlag) {
            //明细按钮输入框不可输入
            if (widget.flag == 0) {
              context
                  .read<RoleMasterBloc>()
                  .add(ShowSelectValueEvent(data, "2"));
              //控制刷新
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshCurrentFlagAction(false));
            } else {
              //登录和修正按钮，输入框可以输入
              context
                  .read<RoleMasterBloc>()
                  .add(ShowSelectValueEvent(data, "1"));
              //控制刷新
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshCurrentFlagAction(false));
            }
          }
          // 初始化基本情報入力表单
          List<Widget> _initBasicInfo() {
            return [
              //ロールid
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
                          WMSLocalizations.i18n(context)!.role_basic_id,
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
              //ロール名称
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
                              WMSLocalizations.i18n(context)!.role_basic_name,
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
                          // 设定ロール名称
                          context
                              .read<RoleMasterBloc>()
                              .add(SetRoleValueEvent('name', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(width: 50), //占位换行
              //ロール说明
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 160,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.role_basic_explain,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSInputboxWidget(
                        height: 136,
                        maxLines: 5,
                        text: state.formInfo['description'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // ロール说明
                          context
                              .read<RoleMasterBloc>()
                              .add(SetRoleValueEvent('description', value));
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
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: RoleMasterFormButton(
                      state: state,
                      roleId: widget.roleId,
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
                          child: RoleMasterFormTab(),
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
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceBetween,
                      children: _initBasicInfo(),
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

//基本信息tab
class RoleMasterFormTab extends StatefulWidget {
  const RoleMasterFormTab({super.key});

  @override
  State<RoleMasterFormTab> createState() => _RoleMasterFormTabState();
}

class _RoleMasterFormTabState extends State<RoleMasterFormTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList) {
    // Tab列表
    List<Widget> tabList = [];
    tabList.add(
      Container(
        child: Container(
          height: 40,
          padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
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

//基本信息 按钮
// ignore: must_be_immutable
class RoleMasterFormButton extends StatefulWidget {
  RoleMasterModel state;
  int roleId;
  RoleMasterFormButton({super.key, required this.state, required this.roleId});

  @override
  State<RoleMasterFormButton> createState() => _RoleMasterFormButtonState();
}

class _RoleMasterFormButtonState extends State<RoleMasterFormButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        GestureDetector(
          child: Container(
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
                  context.read<RoleMasterBloc>().add(UpdateFormEvent(context));
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
      //登录
      {
        'index': Config.NUMBER_ONE,
        'title': widget.roleId == 0
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
