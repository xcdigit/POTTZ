import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/role_master_bloc.dart';
import '../bloc/role_master_model.dart';
import 'role_master_title.dart';

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
    return BlocProvider<RoleMasterBloc>(
      create: (context) {
        return RoleMasterBloc(
          RoleMasterModel(context: context),
        );
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // 头部
              RoleMasterTitle(
                flag: 'change',
              ),
              // 表单内容
              RoleMasterFormContent(
                flag: widget.flag,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class RoleMasterFormContent extends StatefulWidget {
  int flag;
  RoleMasterFormContent({super.key, this.flag = 0});

  @override
  State<RoleMasterFormContent> createState() => _RoleMasterFormContentState();
}

class _RoleMasterFormContentState extends State<RoleMasterFormContent> {
  @override
  Widget build(BuildContext context) {
    //商品数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    //控制页面刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;
    return BlocBuilder<RoleMasterBloc, RoleMasterModel>(
      builder: (context, state) {
        if (currentFlag) {
          //明细按钮输入框不可输入
          if (widget.flag == 0) {
            context.read<RoleMasterBloc>().add(ShowSelectValueEvent(data, "2"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          } else {
            //登录和修正按钮，输入框可以输入
            context.read<RoleMasterBloc>().add(ShowSelectValueEvent(data, "1"));
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
              widthFactor: 0.4,
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
              widthFactor: 0.4,
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
            SizedBox(width: 50), //占位换行
            //ロール说明
            FractionallySizedBox(
              widthFactor: 0.4,
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
          ];
        }

        return Container(
          margin: EdgeInsets.only(
            bottom: 40,
          ),
          child: Column(
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
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: RoleMasterFormButton(state: state),
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
          height: 46,
          padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
          margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(44, 167, 176, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          constraints: BoxConstraints(
            minWidth: 160,
          ),
          child: Text(
            tabItemList[0]['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
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
  RoleMasterFormButton({super.key, required this.state});

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
          // onTap: () {},
          child: Container(
            margin: EdgeInsets.only(left: 20),
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
                if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                  //清除表单数据
                  context.read<RoleMasterBloc>().add(ClearFormEvent());
                } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE &&
                    widget.state.stateFlg == '1') {
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
      //清除
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.exit_input_form_button_clear,
      },
      //登录
      {
        'index': Config.NUMBER_ONE,
        'title': context.read<RoleMasterBloc>().state.formInfo['id'] == null ||
                context.read<RoleMasterBloc>().state.formInfo['id'] == '' ||
                context.read<RoleMasterBloc>().state.stateFlg == '2'
            ? WMSLocalizations.i18n(context)!.instruction_input_tab_button_add
            : WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_update,
      },
    ];

    return Row(
      children: _initButtonList(_buttonItemList),
    );
  }
}
