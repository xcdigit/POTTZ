import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../common/localization/default_localizations.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_model.dart';

/**
 * 内容：账户-内容扫码
 * 作者：赵士淞
 * 时间：2025/01/10
 */
class AccountContentCode extends StatefulWidget {
  const AccountContentCode({super.key});

  @override
  State<AccountContentCode> createState() => _AccountContentCodeState();
}

class _AccountContentCodeState extends State<AccountContentCode> {
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
          //判断是否存在验证秘钥
          if (state.userCustomize['authenticator_key'] == null ||
              state.userCustomize['authenticator_key'] == '') {
            context.read<AccountBloc>().add(JudgeQREvent());
          }
          return Scaffold(
            backgroundColor: Color.fromRGBO(102, 199, 206, 0.1),
            body: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Column(
                      children: [
                        state.userCustomize['email'] != null &&
                                state.userCustomize['email'] != '' &&
                                state.userCustomize['authenticator_key'] !=
                                    null &&
                                state.userCustomize['authenticator_key'] != ''
                            ? QrImageView(
                                data: 'otpauth://totp/POTTZ:' +
                                    state.userCustomize['email'] +
                                    '?secret=' +
                                    state.userCustomize['authenticator_key'] +
                                    '&issuer=POTTZ',
                                version: QrVersions.auto,
                                size: 200.0,
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .login_application_verify_tab_1_text,
                            style: TextStyle(
                              color: Color.fromRGBO(51, 51, 51, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
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
