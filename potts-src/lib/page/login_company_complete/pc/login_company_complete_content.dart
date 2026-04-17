import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../../common/style/wms_style.dart';
import '../../../widget/wms_inputbox_widget.dart';
import '../bloc/login_company_complete_bloc.dart';
import '../bloc/login_company_complete_model.dart';

/**
 * 内容：登录公司完整性-内容
 * 作者：赵士淞
 * 时间：2024/12/16
 */
// 公司内容值
String companyContentValue = '';

class LoginCompanyCompleteContent extends StatefulWidget {
  const LoginCompanyCompleteContent({super.key});

  @override
  State<LoginCompanyCompleteContent> createState() =>
      _LoginCompanyCompleteContentState();
}

class _LoginCompanyCompleteContentState
    extends State<LoginCompanyCompleteContent> {
  // 初始化公司列表
  List<Widget> _initCompanyList(
      List companyItemList, LoginCompanyCompleteModel state) {
    // 公司列表
    List<Widget> companyList = [];
    // 循环公司单项列表
    for (int i = 0; i < companyItemList.length; i++) {
      // 公司列表
      companyList.add(
        FractionallySizedBox(
          widthFactor: 1,
          child: Container(
            margin: EdgeInsets.fromLTRB(24, 0, 24, 16),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
              ),
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(18, 16, 18, 16),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        companyItemList[i]['icon'],
                        width: 44,
                        height: 44,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companyItemList[i]['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(6, 14, 15, 1),
                                height: 1.12,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              constraints: BoxConstraints(
                                maxWidth: 197,
                              ),
                              child: Text(
                                companyItemList[i]['content'] != null
                                    ? companyItemList[i]['content']
                                    : '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                  height: 1.28,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    child: Visibility(
                      visible: companyItemList[i]['button'],
                      maintainState: true,
                      child: GestureDetector(
                        onPanDown: (details) {
                          // 公司内容值
                          companyContentValue = '';
                          // 编辑弹窗
                          showDialog(
                            context: context,
                            builder: (contextDialog) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.zero,
                                content: Container(
                                  width: 560,
                                  height: 200,
                                  padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(102, 199, 206, 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        companyItemList[i]['title'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(6, 14, 15, 1),
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(24, 16, 24, 16),
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: WMSInputboxWidget(
                                          text: companyItemList[i]['content'],
                                          height: 52,
                                          borderColor:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          inputBoxCallBack: (value) {
                                            // 公司内容值
                                            companyContentValue = value;
                                          },
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onPanDown: (details) {
                                              // 关闭弹窗
                                              Navigator.pop(contextDialog);
                                            },
                                            child: Container(
                                              height: 36,
                                              constraints: BoxConstraints(
                                                minWidth: 144,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color.fromRGBO(
                                                      44, 167, 176, 1),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ),
                                              margin: EdgeInsets.fromLTRB(
                                                  12, 0, 12, 0),
                                              child: Center(
                                                child: Text(
                                                  WMSLocalizations.i18n(
                                                          context)!
                                                      .account_profile_cancel,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        44, 167, 176, 1),
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // 保存公司事件
                                              context
                                                  .read<
                                                      LoginCompanyCompleteBloc>()
                                                  .add(SaveCompanyEvent(
                                                      companyItemList[i]
                                                          ['index'],
                                                      companyContentValue));
                                              // 关闭弹窗
                                              Navigator.pop(contextDialog);
                                            },
                                            child: Container(
                                              height: 36,
                                              constraints: BoxConstraints(
                                                minWidth: 144,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Color.fromRGBO(
                                                    44, 167, 176, 1),
                                              ),
                                              margin: EdgeInsets.fromLTRB(
                                                  12, 0, 12, 0),
                                              child: Center(
                                                child: Text(
                                                  WMSLocalizations.i18n(
                                                          context)!
                                                      .account_profile_registration,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          WMSLocalizations.i18n(context)!.account_profile_edit,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 122, 255, 1),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return companyList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCompanyCompleteBloc, LoginCompanyCompleteModel>(
      builder: (context, state) {
        // 公司单项列表
        List _companyItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_USER,
            'title': WMSLocalizations.i18n(context)!.company_information_2,
            'content': state.companyData['name'],
            'button': true,
          },
          {
            'index': Config.NUMBER_ONE,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_USER,
            'title': WMSLocalizations.i18n(context)!.company_information_3,
            'content': state.companyData['name_short'],
            'button': true,
          },
          {
            'index': Config.NUMBER_TWO,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_USER,
            'title': WMSLocalizations.i18n(context)!.company_information_4,
            'content': state.companyData['corporate_cd'],
            'button': true,
          },
          {
            'index': Config.NUMBER_THREE,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_USER,
            'title': WMSLocalizations.i18n(context)!.company_information_5,
            'content': state.companyData['qrr_cd'],
            'button': true,
          },
          {
            'index': Config.NUMBER_FOUR,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_USER,
            'title': WMSLocalizations.i18n(context)!.company_information_6,
            'content': state.companyData['postal_cd'],
            'button': true,
          },
          {
            'index': Config.NUMBER_FIVE,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_USER,
            'title': WMSLocalizations.i18n(context)!.company_information_7,
            'content': state.companyData['addr_1'],
            'button': true,
          },
          {
            'index': Config.NUMBER_SIX,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_USER,
            'title': WMSLocalizations.i18n(context)!.company_information_8,
            'content': state.companyData['addr_2'],
            'button': true,
          },
          {
            'index': Config.NUMBER_SEVEN,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_USER,
            'title': WMSLocalizations.i18n(context)!.company_information_9,
            'content': state.companyData['addr_3'],
            'button': true,
          },
          {
            'index': Config.NUMBER_EIGHT,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_USER,
            'title': WMSLocalizations.i18n(context)!.company_information_10,
            'content': state.companyData['tel'],
            'button': true,
          },
          {
            'index': Config.NUMBER_NINE,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_USER,
            'title': WMSLocalizations.i18n(context)!.company_information_13,
            'content': state.companyData['email'],
            'button': true,
          },
        ];

        return Container(
          height: MediaQuery.of(context).size.height - 100 - 96,
          child: Center(
            child: Container(
              width: 560,
              margin: EdgeInsets.fromLTRB(0, 50, 0, 50),
              padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
              decoration: BoxDecoration(
                color: Color.fromRGBO(102, 199, 206, 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView(
                children: _initCompanyList(_companyItemList,
                    context.read<LoginCompanyCompleteBloc>().state),
              ),
            ),
          ),
        );
      },
    );
  }
}
