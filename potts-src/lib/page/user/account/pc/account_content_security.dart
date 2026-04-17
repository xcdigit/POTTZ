import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_model.dart';

/**
 * 内容：账户-内容安全
 * 作者：赵士淞
 * 时间：2023/08/15
 */
class AccountContentSecurity extends StatefulWidget {
  const AccountContentSecurity({super.key});

  @override
  State<AccountContentSecurity> createState() => _AccountContentSecurityState();
}

class _AccountContentSecurityState extends State<AccountContentSecurity> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountModel>(
      builder: (context, state) {
        // 判断切换标记
        if (state.switchFlag) {
          // 切换标记
          state.switchFlag = false;
          // 保存位置标记和位置下标
          context.read<AccountBloc>().add(
              SaveLocationFlagAndLocationIndexEvent(false, Config.NUMBER_ZERO));
        }

        return state.locationFlag
            ? AccountContentSecurityForm()
            : AccountContentSecurityList();
      },
    );
  }
}

// 账户-内容安全-列表
class AccountContentSecurityList extends StatefulWidget {
  const AccountContentSecurityList({super.key});

  @override
  State<AccountContentSecurityList> createState() =>
      _AccountContentSecurityListState();
}

class _AccountContentSecurityListState
    extends State<AccountContentSecurityList> {
  // 初始化安全列表
  List<Widget> _initSecurityList(List securityItemList, AccountModel state) {
    // 安全列表
    List<Widget> securityList = [];
    // 循环安全单个列表
    for (int i = 0; i < securityItemList.length; i++) {
      // 安全列表
      securityList.add(
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
                        securityItemList[i]['icon'],
                        width: 44,
                        height: 44,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              securityItemList[i]['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(6, 14, 15, 1),
                                height: 1.12,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              constraints: BoxConstraints(
                                maxWidth: 197,
                              ),
                              child: Text(
                                securityItemList[i]['content'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                  height: 1.28,
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
                    child: GestureDetector(
                      onPanDown: (details) {
                        // 保存位置标记和位置下标
                        context.read<AccountBloc>().add(
                            SaveLocationFlagAndLocationIndexEvent(
                                true, securityItemList[i]['index']));
                      },
                      child: Text(
                        WMSLocalizations.i18n(context)!.account_profile_edit,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 122, 255, 1),
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
    // 安全列表
    return securityList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountModel>(
      builder: (context, state) {
        // 安全单个列表
        List _securityItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'icon': WMSICons.ACCOUNT_CONTENT_SECURITY_PASSWORD,
            'title': WMSLocalizations.i18n(context)!.account_security_password,
            'content': '•••••••••••••',
          },
        ];

        return Column(
          children: _initSecurityList(_securityItemList, state),
        );
      },
    );
  }
}

// 账户-内容安全-列表
class AccountContentSecurityForm extends StatefulWidget {
  const AccountContentSecurityForm({super.key});

  @override
  State<AccountContentSecurityForm> createState() =>
      _AccountContentSecurityFormState();
}

class _AccountContentSecurityFormState
    extends State<AccountContentSecurityForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountModel>(
      builder: (context, state) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.locationIndex == Config.NUMBER_ZERO
                    ? WMSLocalizations.i18n(context)!
                        .account_security_password_change
                    : '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(6, 14, 15, 1),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(24, 16, 24, 16),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: WMSInputboxWidget(
                  text: state.tempValue,
                  height: 52,
                  borderColor: Color.fromRGBO(255, 255, 255, 1),
                  hintText: state.locationIndex == Config.NUMBER_ZERO
                      ? WMSLocalizations.i18n(context)!
                          .account_security_password_new
                      : '',
                  hintFontColor: Color.fromRGBO(156, 156, 156, 1),
                  inputBoxCallBack: (value) {
                    // 保存临时值事件
                    context.read<AccountBloc>().add(SaveTempValueEvent(value));
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onPanDown: (details) {
                      // 保存位置标记和位置下标
                      context.read<AccountBloc>().add(
                          SaveLocationFlagAndLocationIndexEvent(
                              false, Config.NUMBER_ZERO));
                    },
                    child: Container(
                      height: 36,
                      constraints: BoxConstraints(
                        minWidth: 144,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(44, 167, 176, 1),
                        ),
                        borderRadius: BorderRadius.circular(4),
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Center(
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .account_profile_cancel,
                          style: TextStyle(
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // 判断位置下标
                      if (state.locationIndex == Config.NUMBER_ZERO) {
                        // 保存登录事件
                        context.read<AccountBloc>().add(SaveLoginEvent());
                      }
                    },
                    child: Container(
                      height: 36,
                      constraints: BoxConstraints(
                        minWidth: 144,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color.fromRGBO(44, 167, 176, 1),
                      ),
                      margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Center(
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .account_profile_registration,
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
