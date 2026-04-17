import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../home/bloc/home_menu_bloc.dart';
import '../../../home/bloc/home_menu_model.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_model.dart';

class AccountContentPlanCancel extends StatefulWidget {
  const AccountContentPlanCancel({super.key});

  @override
  State<AccountContentPlanCancel> createState() =>
      _AccountContentPlanCancelState();
}

class _AccountContentPlanCancelState extends State<AccountContentPlanCancel> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) {
        return AccountBloc(
          AccountModel(
            rootContext: context,
          ),
        );
      },
      child: BlocBuilder<AccountBloc, AccountModel>(
        builder: (context, state) {
          // 判断切换标记
          if (state.switchFlag) {
            // 切换标记
            state.switchFlag = false;
            // 保存位置标记和位置下标
            context.read<AccountBloc>().add(
                SaveLocationFlagAndLocationIndexEvent(
                    false, Config.NUMBER_ZERO));
          }

          return Scaffold(
            backgroundColor: Color.fromRGBO(102, 199, 206, 0.1),
            body: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: AccountContentPlanCancelContent(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AccountContentPlanCancelContent extends StatefulWidget {
  const AccountContentPlanCancelContent({super.key});

  @override
  State<AccountContentPlanCancelContent> createState() =>
      _AccountContentPlanCancelContentState();
}

class _AccountContentPlanCancelContentState
    extends State<AccountContentPlanCancelContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountModel>(
      builder: (context, state) {
        return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
          builder: (menuBloc, menuState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: Text(
                    WMSLocalizations.i18n(context)!.account_cancel_title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(6, 14, 15, 1),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Text(
                    WMSLocalizations.i18n(context)!.account_cancel_text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(255, 0, 0, 1),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(24, 34, 24, 0),
                  child: Text(
                    WMSLocalizations.i18n(context)!.account_cancel_user,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(6, 14, 15, 1),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Text(
                    WMSLocalizations.i18n(context)!.account_cancel_user_name +
                        (state.planData['user_name'] != null
                            ? state.planData['user_name']
                            : ''),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(6, 14, 15, 1),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: Text(
                    WMSLocalizations.i18n(context)!.account_cancel_user_email +
                        (state.planData['user_email'] != null
                            ? state.planData['user_email']
                            : ''),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(6, 14, 15, 1),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(24, 34, 24, 0),
                  child: Text(
                    WMSLocalizations.i18n(context)!.account_cancel_data,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(6, 14, 15, 1),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Text(
                    WMSLocalizations.i18n(context)!
                        .account_cancel_data_content_1,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(6, 14, 15, 1),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: Text(
                    WMSLocalizations.i18n(context)!
                        .account_cancel_data_content_2,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(6, 14, 15, 1),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: Text(
                    WMSLocalizations.i18n(context)!
                        .account_cancel_data_content_3,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(6, 14, 15, 1),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: Text(
                    WMSLocalizations.i18n(context)!
                        .account_cancel_data_content_4,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(6, 14, 15, 1),
                    ),
                  ),
                ),
                Visibility(
                  visible: state.cancelData['admin_confirm_status'] != null &&
                      state.cancelData['admin_confirm_status'] ==
                          Config.NUMBER_ONE.toString(),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(24, 34, 24, 0),
                    child: Text(
                      WMSLocalizations.i18n(context)!.account_cancel_prompt_2,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(255, 0, 0, 1),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(24, 34, 24, 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onPanDown: (details) {
                          // 跳转页面
                          context.read<HomeMenuBloc>().add(PageJumpEvent('/' +
                              Config.PAGE_FLAG_50_1 +
                              '/plan/formDetail'));
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
                          state.cancelData['admin_confirm_status'] != null &&
                                  state.cancelData['admin_confirm_status'] ==
                                      Config.NUMBER_ONE.toString()
                              ? context
                                  .read<AccountBloc>()
                                  .add(ConfirmCancelEvent())
                              : context
                                  .read<AccountBloc>()
                                  .add(ProposeCancelEvent());
                        },
                        child: Container(
                          height: 36,
                          constraints: BoxConstraints(
                            minWidth: 144,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: state.cancelData['admin_confirm_status'] !=
                                        null &&
                                    state.cancelData['admin_confirm_status'] ==
                                        Config.NUMBER_ONE.toString()
                                ? Color.fromRGBO(217, 56, 40, 1)
                                : Color.fromRGBO(44, 167, 176, 1),
                          ),
                          margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: Center(
                            child: Text(
                              state.cancelData['admin_confirm_status'] !=
                                          null &&
                                      state.cancelData[
                                              'admin_confirm_status'] ==
                                          Config.NUMBER_ONE.toString()
                                  ? WMSLocalizations.i18n(context)!
                                      .account_cancel_button_2
                                  : WMSLocalizations.i18n(context)!
                                      .account_cancel_button_1,
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: state.cancelData['admin_confirm_status'] == null ||
                      state.cancelData['admin_confirm_status'] == '' ||
                      state.cancelData['admin_confirm_status'] ==
                          Config.NUMBER_ZERO.toString(),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(24, 4, 24, 30),
                    alignment: Alignment.center,
                    child: Text(
                      WMSLocalizations.i18n(context)!.account_cancel_prompt_1,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(156, 156, 156, 1),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
