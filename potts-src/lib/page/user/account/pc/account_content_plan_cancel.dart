import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
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
    return BlocBuilder<AccountBloc, AccountModel>(
      builder: (context, state) {
        return Container(
          width: 560,
          margin: EdgeInsets.fromLTRB(100, 0, 0, 0),
          padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
          decoration: BoxDecoration(
            color: Color.fromRGBO(102, 199, 206, 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                WMSLocalizations.i18n(context)!.account_cancel_title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(6, 14, 15, 1),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 8,
                ),
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
                margin: EdgeInsets.only(
                  top: 34,
                ),
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
                margin: EdgeInsets.only(
                  top: 8,
                ),
                child: Text(
                  WMSLocalizations.i18n(context)!.account_cancel_user_name +
                      state.planData['user_name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
              Text(
                WMSLocalizations.i18n(context)!.account_cancel_user_email +
                    state.planData['user_email'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(6, 14, 15, 1),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 34,
                ),
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
                margin: EdgeInsets.only(
                  top: 8,
                ),
                child: Text(
                  WMSLocalizations.i18n(context)!.account_cancel_data_content_1,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
              Text(
                WMSLocalizations.i18n(context)!.account_cancel_data_content_2,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(6, 14, 15, 1),
                ),
              ),
              Text(
                WMSLocalizations.i18n(context)!.account_cancel_data_content_3,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(6, 14, 15, 1),
                ),
              ),
              Text(
                WMSLocalizations.i18n(context)!.account_cancel_data_content_4,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(6, 14, 15, 1),
                ),
              ),
              Visibility(
                visible: state.cancelData['admin_confirm_status'] != null &&
                    state.cancelData['admin_confirm_status'] ==
                        Config.NUMBER_ONE.toString(),
                child: Container(
                  margin: EdgeInsets.only(
                    top: 34,
                  ),
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
                margin: EdgeInsets.only(
                  top: 34,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onPanDown: (details) {
                        // 保存位置标记和位置下标
                        context.read<AccountBloc>().add(
                            SaveLocationFlagAndLocationIndexEvent(
                                true, Config.NUMBER_ONE));
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
                            state.cancelData['admin_confirm_status'] != null &&
                                    state.cancelData['admin_confirm_status'] ==
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
                  margin: EdgeInsets.only(
                    top: 4,
                  ),
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
          ),
        );
      },
    );
  }
}
