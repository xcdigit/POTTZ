import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/model/user.dart';
import 'package:wms/page/login/pc/login_page.dart';
import 'package:wms/redux/contract_param_reducer.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_date_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../../../../widget/wms_postal_code_widget.dart';
import '../bloc/contract_bloc.dart';
import '../bloc/contract_model.dart';

/**
 * 内容：サービス解約-表单
 * 作者：王光顺
 * 时间：2023/12/07
 */
class ContractForm extends StatefulWidget {
  const ContractForm({super.key});

  @override
  State<ContractForm> createState() => _InformationSocietyFormtate();
}

class _InformationSocietyFormtate extends State<ContractForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContractBloc, ContractModel>(
      builder: (context, state) {
        // 初始化会社情報表单
        List<Widget> _initCompanyFormBasic() {
          return [
            FractionallySizedBox(
              //1会社名名称
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
                        WMSLocalizations.i18n(context)!.contract_text_3,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['name'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //2会社名略称
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
                        WMSLocalizations.i18n(context)!.contract_text_4,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['name_short'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //3郵便番号
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
                        WMSLocalizations.i18n(context)!.company_information_6,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSPostalcodeWidget(
                      text: state.formInfo['postal_cd'].toString(),
                      country: 'JP',
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //4都道府県
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
                        WMSLocalizations.i18n(context)!.company_information_7,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['addr_1'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //5市区町村
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
                        WMSLocalizations.i18n(context)!.company_information_8,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['addr_2'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //6住所
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
                        WMSLocalizations.i18n(context)!.company_information_9,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['addr_3'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //7電話番号
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
                        WMSLocalizations.i18n(context)!.company_information_10,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['tel'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //8FAX番号
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
                        WMSLocalizations.i18n(context)!.company_information_11,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['fax'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
          ];
        }

        // 初始化ライセンス表单
        List<Widget> _initLicenseFormBasic() {
          return [
            FractionallySizedBox(
              //3運用開始日
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
                        WMSLocalizations.i18n(context)!.account_license_start,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSDateWidget(
                      text: state.formDateInfo['start_date'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //4運用終了日
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
                        WMSLocalizations.i18n(context)!.account_license_end,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSDateWidget(
                      text: state.formDateInfo['end_date'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
          ];
        }

        return Container(
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
                        child: ContractFormTab(),
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
                    children: _initCompanyFormBasic(),
                  ),
                ),
              ),
              //空格
              FractionallySizedBox(
                  widthFactor: 1,
                  child: SizedBox(
                    height: 50,
                  )),

//---------------------------------------------
              FractionallySizedBox(
                widthFactor: 1,
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ContractLicensFormTab(),
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
                    children: _initLicenseFormBasic(),
                  ),
                ),
              ),

              //按钮
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //キャンセル按钮
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BuildButtom(
                              WMSLocalizations.i18n(context)!
                                  .account_profile_cancel,
                              0,
                              state,
                              context),
                        ],
                      ),
                    ),
                    SizedBox(width: 40),
                    //次へ按钮
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BuildButtom(
                              WMSLocalizations.i18n(context)!.contract_text_2,
                              1,
                              state,
                              context)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              FractionallySizedBox(
                  widthFactor: 1,
                  child: SizedBox(
                    height: 100,
                  )),
            ],
          ),
        );
      },
    );
  }
}

// 底部キャンセル按钮和次へ按钮
Container BuildButtom(
    String text, int differ, ContractModel state, BuildContext context) {
  return Container(
    color: Colors.white,
    height: 48,
    width: 180,
    child: OutlinedButton(
      onPressed: () async {
        if (differ == 0) {
          //恢复迁移元
          StoreProvider.of<WMSState>(context).state.contractFlag = false;
          // 持久化状态更新
          StoreProvider.of<WMSState>(context).state.login = false;
          // 持久化状态更新
          StoreProvider.of<WMSState>(context).state.userInfo = null;
          // 持久化状态
          StoreProvider.of<WMSState>(context).state.loginUser = User.empty();
          // キャンセル按钮跳转登录页面
          GoRouter.of(context).replaceNamed(LoginPage.sName);
        } else {
          if (state.formInfo.length != 0) {
            if (state.formInfo['status'] == Config.NUMBER_THREE.toString() ||
                state.formInfo['status'] == Config.NUMBER_FOUR.toString()) {
              WMSCommonBlocUtils.tipTextToast(
                  WMSLocalizations.i18n(state.context)!
                      .company_terminated_cannot_again);
            } else {
              //传参初始化
              List<Map<String, dynamic>> date = [{}, {}];
              if (state.formInfo.length != 0 &&
                  state.formDateInfo.length != 0) {
                date[0] = state.formInfo;
                date[1] = state.formDateInfo;
              }

              //数据存入
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshContractParamAction(date));
              // 跳转页面
              GoRouter.of(context).go('/contract/affirm');
            }
          } else {
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(context)!.company_not_exist);
          }
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: differ == 0 ? Color.fromRGBO(44, 167, 176, 1) : Colors.white,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: differ == 0
            ? MaterialStateProperty.all(Colors.white)
            : MaterialStateProperty.all(Color.fromRGBO(44, 167, 176, 1)),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        side: MaterialStateProperty.all(
          const BorderSide(
            width: 1,
            color: Color.fromRGBO(44, 167, 176, 1),
          ),
        ),
      ),
    ),
  );
}

// 表单Tab
// ignore: must_be_immutable
class ContractFormTab extends StatefulWidget {
  ContractFormTab({super.key});

  @override
  State<ContractFormTab> createState() => _ContractFormTabState();
}

class _ContractFormTabState extends State<ContractFormTab> {
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
        'title': WMSLocalizations.i18n(context)!.contract_text_5,
      },
    ];

    return Row(
      children: _initTabList(_tabItemList),
    );
  }
}

// 表单Tab
// ignore: must_be_immutable
class ContractLicensFormTab extends StatefulWidget {
  ContractLicensFormTab({super.key});

  @override
  State<ContractLicensFormTab> createState() => _ContractLicenseFormTabState();
}

class _ContractLicenseFormTabState extends State<ContractLicensFormTab> {
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
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!.account_menu_5,
      },
    ];

    return Row(
      children: _initTabList(_tabItemList),
    );
  }
}

// 会社-表单按钮
// ignore: must_be_immutable
class ContractFormButton extends StatefulWidget {
  ContractModel state;
  ContractFormButton({super.key, required this.state});

  @override
  State<ContractFormButton> createState() => _ContractFormButtonState();
}

class _ContractFormButtonState extends State<ContractFormButton> {
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
                    Color.fromRGBO(44, 167, 176, 1)), // 设置按钮背景颜色
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white), // 设置按钮文本颜色
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(80, 37),
                ), // 设置按钮宽度和高度
              ),
              onPressed: () {},
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
        'title': WMSLocalizations.i18n(context)!.exit_input_form_button_clear,
      },
      {
        'index': Config.NUMBER_ONE,
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_button_add,
      },
    ];

    return Row(
      children: _initButtonList(_buttonItemList),
    );
  }
}
