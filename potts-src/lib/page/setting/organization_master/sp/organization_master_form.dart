import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/organization_master_bloc.dart';
import '../bloc/organization_master_model.dart';

/**
 * 内容：組織マスタ-表单
 * 作者：熊草云
 * 时间：2023/11/29
 */
class OrganizationMasterForm extends StatefulWidget {
  final String flag_num;
  const OrganizationMasterForm({super.key, required this.flag_num});
  @override
  State<OrganizationMasterForm> createState() => _OrganizationMasterFormState();
}

class _OrganizationMasterFormState extends State<OrganizationMasterForm> {
  Map<String, dynamic> currentParam = {};
  @override
  Widget build(BuildContext context) {
    //获取当前登录用户会社ID
    int companyId = 0;
    if (StoreProvider.of<WMSState>(context).state.loginUser!.company_id !=
        null) {
      companyId = StoreProvider.of<WMSState>(context)
          .state
          .loginUser!
          .company_id as int;
    }
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;
    //接收传过来的参数
    currentParam = StoreProvider.of<WMSState>(context).state.currentParam;
    return BlocProvider<OrganizationMasterBloc>(
      create: (context) {
        return OrganizationMasterBloc(
          OrganizationMasterModel(
              context: context,
              companyId: companyId,
              roleId: roleId,
              flag_num: widget.flag_num,
              currentParam: currentParam),
        );
      },
      child: BlocBuilder<OrganizationMasterBloc, OrganizationMasterModel>(
        builder: (context, state) {
          // 初始化基本情報入力表单
          List<Widget> _initFormBasic() {
            return [
              // id
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
                          "ID",
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
              // 親ID
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
                          WMSLocalizations.i18n(context)!
                              .organization_master_form_1,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSInputboxWidget(
                        readOnly: widget.flag_num == '2',
                        text: state.formInfo['parent_id'] == null
                            ? ''
                            : state.formInfo['parent_id'].toString(),
                        inputBoxCallBack: (value) {
                          // 设定值
                          context
                              .read<OrganizationMasterBloc>()
                              .add(SetMessageValueEvent('parent_id', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // 組織コード
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
                                  .organization_master_form_2,
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
                        readOnly: widget.flag_num == '2',
                        text: state.formInfo['code'].toString(),
                        inputBoxCallBack: (value) {
                          // 设定值
                          context
                              .read<OrganizationMasterBloc>()
                              .add(SetMessageValueEvent('code', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // 組織名称
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
                                  .organization_master_form_3,
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
                        readOnly: widget.flag_num == '2',
                        text: state.formInfo['name'].toString(),
                        inputBoxCallBack: (value) {
                          // 设定值
                          context
                              .read<OrganizationMasterBloc>()
                              .add(SetMessageValueEvent('name', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // 会社名称
              Visibility(
                visible: state.roleId == 1,
                child: FractionallySizedBox(
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
                                    .company_information_2,
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
                        widget.flag_num != '2'
                            ? WMSDropdownWidget(
                                saveInput: true,
                                inputInitialValue:
                                    state.formInfo['company_name'] == null
                                        ? ''
                                        : state.formInfo['company_name']
                                            .toString(),
                                dropdownKey: 'name',
                                dropdownTitle: 'name',
                                dataList1: state.salesCompanyInfoList,
                                inputRadius: 4,
                                inputSuffixIcon: Container(
                                  width: 24,
                                  height: 24,
                                  margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                  ),
                                ),
                                selectedCallBack: (value) {
                                  // 设定值
                                  if (value is! String) {
                                    context.read<OrganizationMasterBloc>().add(
                                        SetMessageValueEvent(
                                            'company_name', value['name']));
                                    context.read<OrganizationMasterBloc>().add(
                                        SetNowCompanyIDEvent(
                                            int.parse(value['id'].toString())));
                                  } else {
                                    context.read<OrganizationMasterBloc>().add(
                                        SetMessageValueEvent(
                                            'company_name', null));
                                    // ignore: unnecessary_null_comparison
                                    if (value.trim() != '' && value != null) {
                                      WMSCommonBlocUtils.errorTextToast(
                                          WMSLocalizations.i18n(context)!
                                              .organization_master_tip_5);
                                    }
                                  }
                                },
                              )
                            : WMSInputboxWidget(
                                readOnly: true,
                                text: state.formInfo['company_name'] == null
                                    ? ''
                                    : state.formInfo['company_name'].toString(),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              // 説明
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
                          WMSLocalizations.i18n(context)!
                              .organization_master_form_4,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSInputboxWidget(
                        readOnly: widget.flag_num == '2',
                        height: 136,
                        maxLines: 5,
                        text: state.formInfo['content'].toString(),
                        inputBoxCallBack: (value) {
                          // 设定值
                          context
                              .read<OrganizationMasterBloc>()
                              .add(SetMessageValueEvent('content', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: widget.flag_num != '2',
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * .28),
                    width: MediaQuery.of(context).size.width - 100,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: OrganizationMasterFormButton(state: state),
                  ),
                ),
              ),
            ];
          }

          return Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: ListView(
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: OrganizationMasterFormTab(),
                        ),
                      ),
                    ],
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 200),
                    padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
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

// 組織マスタ-表单Tab
// ignore: must_be_immutable
class OrganizationMasterFormTab extends StatefulWidget {
  OrganizationMasterFormTab({super.key});
  @override
  State<OrganizationMasterFormTab> createState() =>
      _OrganizationMasterFormTabState();
}

class _OrganizationMasterFormTabState extends State<OrganizationMasterFormTab> {
  // 初始化Tab列表

  List<Widget> _initTabList(tabItemList) {
    // Tab列表
    List<Widget> tabList = [];
    tabList.add(
      Container(
        child: Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(44, 167, 176, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            constraints: BoxConstraints(
              minWidth: 108,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tabItemList[0]['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(255, 255, 255, 1)),
                ),
              ],
            )),
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

// 組織マスタ-表单按钮
// ignore: must_be_immutable
class OrganizationMasterFormButton extends StatefulWidget {
  OrganizationMasterModel state;
  OrganizationMasterFormButton({super.key, required this.state});
  @override
  State<OrganizationMasterFormButton> createState() =>
      _OrganizationMasterFormButtonState();
}

class _OrganizationMasterFormButtonState
    extends State<OrganizationMasterFormButton> {
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
                //新增/修改数据
                context
                    .read<OrganizationMasterBloc>()
                    .add(UpdateFormEvent(context));
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
      {
        'index': Config.NUMBER_ZERO,
        'title': (widget.state.formInfo['id'] == '' ||
                widget.state.formInfo['id'] == null ||
                widget.state.stateFlg == '2')
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
