import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/login_register/bloc/login_register_bloc.dart';
import 'package:wms/page/login_register/bloc/login_register_model.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';
import 'package:wms/widget/wms_postal_code_widget.dart';

/**
 * 内容：申込-会社情報PC
 * 作者：cuihr
 * 时间：2023/12/06
 */
class LoginRegisterCompanyForm extends StatefulWidget {
  const LoginRegisterCompanyForm({super.key});

  @override
  State<LoginRegisterCompanyForm> createState() =>
      _LoginRegisterCompanyFormState();
}

class _LoginRegisterCompanyFormState extends State<LoginRegisterCompanyForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginRegisterBLoc, LoginRegisterModel>(
      builder: (context, state) {
// 初始化基本情報入力表单
        List<Widget> _initFormBasic() {
          return [
            //1、会社名名称
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 102,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!.register_company_1,
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
                      text: state.formInfo['company_name'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<LoginRegisterBLoc>()
                            .add(SetRegisterValueEvent('company_name', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //2、会社名略称
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 102,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!.register_company_2,
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
                      text: state.formInfo['company_name_short'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定值
                        context.read<LoginRegisterBLoc>().add(
                            SetRegisterValueEvent('company_name_short', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //3、法人番号
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 102,
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
                                .company_information_4,
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
                      text: state.formInfo['company_corporate_cd'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定值
                        context.read<LoginRegisterBLoc>().add(
                            SetRegisterValueEvent(
                                'company_corporate_cd', value));
                      },
                    )
                  ],
                ),
              ),
            ),

            //4、適格請求登録番号
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 102,
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
                                .company_information_5,
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
                      text: state.formInfo['company_qrr_cd'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定值
                        context.read<LoginRegisterBLoc>().add(
                            SetRegisterValueEvent('company_qrr_cd', value));
                      },
                    )
                  ],
                ),
              ),
            ),
            //5、郵便番号
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 102,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!.register_company_3,
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
                    WMSPostalcodeWidget(
                      text: state.formInfo['company_postal_cd'].toString(),
                      postalCodeCallBack: (value) {
                        // 设定值
                        context.read<LoginRegisterBLoc>().add(
                            SetRegisterValueEvent(
                                'company_postal_cd', value['postal_code']));
                        if (value['code'] == '0') {
                          //设定都道府县和市町村
                          context.read<LoginRegisterBLoc>().add(
                              SetRegisterValueEvent(
                                  'company_addr_1', value['data']['city']));
                          context.read<LoginRegisterBLoc>().add(
                              SetRegisterValueEvent(
                                  'company_addr_2', value['data']['region']));
                          context.read<LoginRegisterBLoc>().add(
                              SetRegisterValueEvent(
                                  'company_addr_3', value['data']['addr']));
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            //6、都道府県
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 102,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!.register_company_4,
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
                      text: state.formInfo['company_addr_1'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定值
                        context.read<LoginRegisterBLoc>().add(
                            SetRegisterValueEvent('company_addr_1', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //7、市区町村
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 102,
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
                                .company_information_8,
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
                      text: state.formInfo['company_addr_2'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定值
                        context.read<LoginRegisterBLoc>().add(
                            SetRegisterValueEvent('company_addr_2', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //8、住所
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 102,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!.register_company_5,
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
                      text: state.formInfo['company_addr_3'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定值
                        context.read<LoginRegisterBLoc>().add(
                            SetRegisterValueEvent('company_addr_3', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //9、電話番号
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 102,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!.register_user_4,
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
                      text: state.formInfo['company_tel'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<LoginRegisterBLoc>()
                            .add(SetRegisterValueEvent('company_tel', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //10、FAX番号
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 102,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.register_company_6,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['company_fax'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<LoginRegisterBLoc>()
                            .add(SetRegisterValueEvent('company_fax', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //11、Webサイト
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 102,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.company_information_12,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['company_url'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<LoginRegisterBLoc>()
                            .add(SetRegisterValueEvent('company_url', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //12、E-MAIL
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 102,
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
                                .company_information_13,
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
                      text: state.formInfo['company_email'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<LoginRegisterBLoc>()
                            .add(SetRegisterValueEvent('company_email', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ];
        }

        return Container(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.15,
            right: MediaQuery.of(context).size.width * 0.15,
            top: MediaQuery.of(context).size.height * 0.01,
            bottom: MediaQuery.of(context).size.height * 0.01,
          ),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Stack(children: [
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: LoginRegisterCompanyFormTab(),
                    ),
                  )
                ]),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 10),
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
    );
  }
}

// ユーザー情報-表单Tab
class LoginRegisterCompanyFormTab extends StatefulWidget {
  const LoginRegisterCompanyFormTab({super.key});

  @override
  State<LoginRegisterCompanyFormTab> createState() =>
      _LoginRegisterCompanyFormTabState();
}

class _LoginRegisterCompanyFormTabState
    extends State<LoginRegisterCompanyFormTab> {
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
    List _tabItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.register_company_form_1,
      }
    ];
    return Row(
      children: _initTabList(_tabItemList),
    );
  }
}
