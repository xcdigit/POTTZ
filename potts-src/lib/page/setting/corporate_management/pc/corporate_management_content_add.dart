import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/localization/default_localizations.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/corporate_management_bloc.dart';
import '../bloc/corporate_management_model.dart';

/**
 * 内容：法人管理-添加帐户
 * 作者：赵士淞
 * 时间：2024/07/02
 */
class CorporateManagementContentAdd extends StatefulWidget {
  const CorporateManagementContentAdd({super.key});

  @override
  State<CorporateManagementContentAdd> createState() =>
      _CorporateManagementContentAddState();
}

class _CorporateManagementContentAddState
    extends State<CorporateManagementContentAdd> {
  // 初始化标题列表
  List<Widget> _initTitleList() {
    // 标题列表
    List<Widget> titleList = [];

    titleList.add(
      Text(
        WMSLocalizations.i18n(context)!.corporate_management_button_2,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color.fromRGBO(6, 14, 15, 1),
        ),
      ),
    );

    titleList.add(
      Padding(
        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
      ),
    );

    titleList.add(
      Text(
        WMSLocalizations.i18n(context)!.corporate_management_text_8,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color.fromRGBO(156, 156, 156, 1),
        ),
      ),
    );

    titleList.add(
      Text(
        WMSLocalizations.i18n(context)!.corporate_management_text_9,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color.fromRGBO(156, 156, 156, 1),
        ),
      ),
    );

    return titleList;
  }

  // 初始化表单列表
  List<Widget> _initFormList() {
    // 表单列表
    List<Widget> formList = [];

    formList.add(
      Container(
        padding: EdgeInsets.fromLTRB(0, 28, 0, 0),
        child: WMSInputboxWidget(
          height: 56,
          borderColor: Color.fromRGBO(255, 255, 255, 1),
          text: context.read<CorporateManagementBloc>().state.companyName,
          hintText:
              WMSLocalizations.i18n(context)!.login_application_company_name,
          inputBoxCallBack: (value) {
            // 设置公司名称事件
            context
                .read<CorporateManagementBloc>()
                .add(SetCompanyNameEvent(value));
          },
        ),
      ),
    );

    formList.add(
      Container(
        padding: EdgeInsets.fromLTRB(0, 28, 0, 0),
        child: WMSInputboxWidget(
          height: 56,
          borderColor: Color.fromRGBO(255, 255, 255, 1),
          text: context.read<CorporateManagementBloc>().state.personCharge,
          hintText:
              WMSLocalizations.i18n(context)!.login_application_person_charge,
          inputBoxCallBack: (value) {
            // 设置联系人姓名事件
            context
                .read<CorporateManagementBloc>()
                .add(SetPersonChargeEvent(value));
          },
        ),
      ),
    );

    formList.add(
      Container(
        padding: EdgeInsets.fromLTRB(0, 28, 0, 0),
        child: WMSInputboxWidget(
          height: 56,
          borderColor: Color.fromRGBO(255, 255, 255, 1),
          text: context.read<CorporateManagementBloc>().state.emailAddress,
          hintText:
              WMSLocalizations.i18n(context)!.login_application_email_address,
          inputBoxCallBack: (value) {
            // 设置电子邮件地址事件
            context
                .read<CorporateManagementBloc>()
                .add(SetEmailAddressEvent(value));
          },
        ),
      ),
    );

    formList.add(
      Container(
        padding: EdgeInsets.fromLTRB(0, 28, 0, 0),
        child: WMSInputboxWidget(
          numberIME: true,
          height: 56,
          borderColor: Color.fromRGBO(255, 255, 255, 1),
          text: context.read<CorporateManagementBloc>().state.phoneNumber,
          hintText:
              WMSLocalizations.i18n(context)!.login_application_phone_number,
          inputBoxCallBack: (value) {
            // 设置电话号码事件
            context
                .read<CorporateManagementBloc>()
                .add(SetPhoneNumberEvent(value));
          },
        ),
      ),
    );

    formList.add(
      Container(
        padding: EdgeInsets.fromLTRB(0, 28, 0, 0),
        child: WMSInputboxWidget(
          height: 56,
          borderColor: Color.fromRGBO(255, 255, 255, 1),
          text: context.read<CorporateManagementBloc>().state.campaignCode,
          hintText:
              WMSLocalizations.i18n(context)!.login_application_campaign_code,
          inputBoxCallBack: (value) {
            // 设置活动代码事件
            context
                .read<CorporateManagementBloc>()
                .add(SetCampaignCodeEvent(value));
          },
        ),
      ),
    );

    return formList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CorporateManagementBloc, CorporateManagementModel>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.fromLTRB(63, 33, 63, 33),
          decoration: BoxDecoration(
            color: Color.fromRGBO(102, 199, 206, 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _initTitleList(),
                ),
              ),
              Container(
                width: 400,
                child: Column(
                  children: _initFormList(),
                ),
              ),
              GestureDetector(
                onPanDown: (details) {
                  // 添加帐户提交事件
                  context
                      .read<CorporateManagementBloc>()
                      .add(AddAccountSubmitEvent());
                },
                child: Container(
                  width: 400,
                  height: 56,
                  margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(44, 167, 176, 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    WMSLocalizations.i18n(context)!.login_register_text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(255, 255, 255, 1),
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
