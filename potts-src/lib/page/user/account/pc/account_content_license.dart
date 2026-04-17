import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_model.dart';

/**
 * 内容：账户-许可证
 * 作者：赵士淞
 * 时间：2023/08/15
 */
class AccountContentLicense extends StatefulWidget {
  const AccountContentLicense({super.key});

  @override
  State<AccountContentLicense> createState() => _AccountContentLicenseState();
}

class _AccountContentLicenseState extends State<AccountContentLicense> {
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

        return AccountContentLicenseForm();
      },
    );
  }
}

// 账户-许可证-列表
class AccountContentLicenseForm extends StatefulWidget {
  const AccountContentLicenseForm({super.key});

  @override
  State<AccountContentLicenseForm> createState() =>
      _AccountContentLicenseFormState();
}

class _AccountContentLicenseFormState extends State<AccountContentLicenseForm> {
  // 初始化许可列表
  List<Widget> _initLicenseList(List licenseItemList) {
    // 许可列表
    List<Widget> licenseList = [];
    // 循环许可单个列表
    for (int i = 0; i < licenseItemList.length; i++) {
      // 许可列表
      licenseList.add(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    WMSLocalizations.i18n(context)!.account_license_type +
                        ': ' +
                        (licenseItemList[i]['use_type_name'].toString() ==
                                'null'
                            ? ''
                            : licenseItemList[i]['use_type_name']),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(6, 14, 15, 1),
                      height: 1.28,
                    ),
                  ),
                  Text(
                    WMSLocalizations.i18n(context)!.account_license_start +
                        ': ' +
                        (licenseItemList[i]['start_date'].toString() == 'null'
                            ? ''
                            : licenseItemList[i]['start_date']
                                    .toString()
                                    .substring(0, 4) +
                                '年' +
                                licenseItemList[i]['start_date']
                                    .toString()
                                    .substring(5, 7) +
                                '月' +
                                licenseItemList[i]['start_date']
                                    .toString()
                                    .substring(8, 10) +
                                '日'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(6, 14, 15, 1),
                      height: 1.28,
                    ),
                  ),
                  Text(
                    WMSLocalizations.i18n(context)!.account_license_end +
                        ': ' +
                        (licenseItemList[i]['end_date'].toString() == 'null'
                            ? ''
                            : licenseItemList[i]['end_date']
                                    .toString()
                                    .substring(0, 4) +
                                '年' +
                                licenseItemList[i]['end_date']
                                    .toString()
                                    .substring(5, 7) +
                                '月' +
                                licenseItemList[i]['end_date']
                                    .toString()
                                    .substring(8, 10) +
                                '日'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(6, 14, 15, 1),
                      height: 1.28,
                    ),
                  ),
                  Text(
                    WMSLocalizations.i18n(context)!.account_license_payment +
                        ': ' +
                        (licenseItemList[i]['pay_status'].toString() == 'null'
                            ? ''
                            : licenseItemList[i]['pay_status'] ==
                                    Config.NUMBER_ZERO.toString()
                                ? WMSLocalizations.i18n(context)!
                                    .manage_pay_status_text_1
                                : licenseItemList[i]['pay_status'] ==
                                        Config.NUMBER_ONE.toString()
                                    ? WMSLocalizations.i18n(context)!
                                        .manage_pay_status_text_2
                                    : ''),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(6, 14, 15, 1),
                      height: 1.28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    // 许可列表
    return licenseList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountModel>(
      builder: (context, state) {
        return Column(
          children: _initLicenseList(state.manageList),
        );
      },
    );
  }
}
