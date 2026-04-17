import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/localization/default_localizations.dart';
import '../bloc/login_company_complete_bloc.dart';
import '../bloc/login_company_complete_model.dart';

/**
 * 内容：登录公司完整性-按钮
 * 作者：赵士淞
 * 时间：2024/12/16
 */
class LoginCompanyCompleteButton extends StatefulWidget {
  const LoginCompanyCompleteButton({super.key});

  @override
  State<LoginCompanyCompleteButton> createState() =>
      _LoginCompanyCompleteButtonState();
}

class _LoginCompanyCompleteButtonState
    extends State<LoginCompanyCompleteButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCompanyCompleteBloc, LoginCompanyCompleteModel>(
      builder: (context, state) {
        return Center(
          child: GestureDetector(
            onTap: () {
              // 提交按钮点击事件
              context
                  .read<LoginCompanyCompleteBloc>()
                  .add(SubmitButtonClickEvent());
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              width: 320,
              height: 56,
              margin: EdgeInsets.only(
                bottom: 40,
              ),
              child: Center(
                child: Text(
                  WMSLocalizations.i18n(context)!.login_company_complete_submit,
                  style: TextStyle(
                    color: Color.fromRGBO(44, 167, 176, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
