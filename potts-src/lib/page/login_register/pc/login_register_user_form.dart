import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/login_register/bloc/login_register_bloc.dart';
import 'package:wms/page/login_register/bloc/login_register_model.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

/**
 * 内容：申込-ユーザー情報PC
 * 作者：cuihr
 * 时间：2023/12/06
 * 作者：luxy
 * 时间：2024/06/21
 */
class LoginRegisterUserForm extends StatefulWidget {
  const LoginRegisterUserForm({super.key});

  @override
  State<LoginRegisterUserForm> createState() => _LoginRegisterUserFormState();
}

class _LoginRegisterUserFormState extends State<LoginRegisterUserForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginRegisterBLoc, LoginRegisterModel>(
      builder: (context, state) {
        // 初始化基本情報入力表单
        List<Widget> _initFormBasic() {
          return [
            //会社名（アカウント登録名）
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 102,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            height: 27,
                            child: Row(
                              children: [
                                Text(
                                  WMSLocalizations.i18n(context)!
                                      .register_user_1,
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
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            width: 32.71,
                            height: 20.39,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 39, 72, 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  WMSLocalizations.i18n(context)!
                                      .register_text_2,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 5,
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['user_email'].toString(),
                      borderColor: Color.fromRGBO(234, 238, 241, 1),
                      backgroundColor: Color.fromRGBO(234, 238, 241, 1),
                      hintText: "例：株式会社 BX",
                      hintFontColor: Color.fromRGBO(163, 163, 163, 1),
                      hintFontSize: 16,
                      hintFontWeight: FontWeight.w500,
                      inputBoxCallBack: (value) {
                        // 设定值
                        context.read<LoginRegisterBLoc>().add(
                              SetRegisterValueEvent(
                                'user_email',
                                value,
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),
            //担当者名
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 102,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            height: 27,
                            child: Row(
                              children: [
                                Text(
                                  WMSLocalizations.i18n(context)!
                                      .register_user_2,
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
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            width: 32.71,
                            height: 20.39,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 39, 72, 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  WMSLocalizations.i18n(context)!
                                      .register_text_2,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 5,
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['user_email'].toString(),
                      borderColor: Color.fromRGBO(234, 238, 241, 1),
                      backgroundColor: Color.fromRGBO(234, 238, 241, 1),
                      hintText: "例：山田　太郎",
                      hintFontColor: Color.fromRGBO(163, 163, 163, 1),
                      hintFontSize: 16,
                      hintFontWeight: FontWeight.w500,
                      inputBoxCallBack: (value) {
                        // 设定值
                        context.read<LoginRegisterBLoc>().add(
                              SetRegisterValueEvent(
                                'user_email',
                                value,
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),
            //電話番号
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 102,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            height: 27,
                            child: Row(
                              children: [
                                Text(
                                  WMSLocalizations.i18n(context)!
                                      .register_user_3,
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
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            width: 32.71,
                            height: 20.39,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 39, 72, 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  WMSLocalizations.i18n(context)!
                                      .register_text_2,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 5,
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['user_email'].toString(),
                      borderColor: Color.fromRGBO(234, 238, 241, 1),
                      backgroundColor: Color.fromRGBO(234, 238, 241, 1),
                      hintText: "例：012-3456-7890",
                      hintFontColor: Color.fromRGBO(163, 163, 163, 1),
                      hintFontSize: 16,
                      hintFontWeight: FontWeight.w500,
                      inputBoxCallBack: (value) {
                        // 设定值
                        context.read<LoginRegisterBLoc>().add(
                              SetRegisterValueEvent(
                                'user_email',
                                value,
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),
            //メールアドレス
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 102,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            height: 27,
                            child: Row(
                              children: [
                                Text(
                                  WMSLocalizations.i18n(context)!
                                      .register_user_4,
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
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            width: 32.71,
                            height: 20.39,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 39, 72, 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  WMSLocalizations.i18n(context)!
                                      .register_text_2,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 5,
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['user_email'].toString(),
                      borderColor: Color.fromRGBO(234, 238, 241, 1),
                      backgroundColor: Color.fromRGBO(234, 238, 241, 1),
                      hintText: "例：xxxxxx@bx-corporation.jp",
                      hintFontColor: Color.fromRGBO(163, 163, 163, 1),
                      hintFontSize: 16,
                      hintFontWeight: FontWeight.w500,
                      inputBoxCallBack: (value) {
                        // 设定值
                        context.read<LoginRegisterBLoc>().add(
                              SetRegisterValueEvent(
                                'user_email',
                                value,
                              ),
                            );
                      },
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
                child: Container(
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
class LoginRegisterUserFormTab extends StatefulWidget {
  const LoginRegisterUserFormTab({super.key});

  @override
  State<LoginRegisterUserFormTab> createState() =>
      _LoginRegisterUserFormTabState();
}

class _LoginRegisterUserFormTabState extends State<LoginRegisterUserFormTab> {
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
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
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
        'title': WMSLocalizations.i18n(context)!.register_user_form_1,
      }
    ];
    return Row(
      children: _initTabList(_tabItemList),
    );
  }
}
