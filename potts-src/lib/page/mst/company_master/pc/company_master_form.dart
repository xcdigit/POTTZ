import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../../../../widget/wms_postal_code_widget.dart';
import '../bloc/company_master_bloc.dart';
import '../bloc/company_master_model.dart';
import 'company_master_title.dart';

/**
 * 内容：会社情報マスタ管理-表单
 * 作者：王光顺
 * 时间：2023/09/05
 */
// ignore: must_be_immutable
class CompanyMasterForm extends StatefulWidget {
  int companyId;
  int flag;
  CompanyMasterForm({super.key, this.companyId = 0, this.flag = 0});

  @override
  State<CompanyMasterForm> createState() => _CompanyMasterFormState();
}

class _CompanyMasterFormState extends State<CompanyMasterForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompanyMasterBloc>(
      create: (context) {
        return CompanyMasterBloc(
          CompanyMasterModel(context: context),
        );
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // 头部
              CompanyMasterTitle(
                flag: 'change',
              ),
              // 表单内容
              CompanyMasterFormContent(
                flag: widget.flag,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CompanyMasterFormContent extends StatefulWidget {
  int flag;
  CompanyMasterFormContent({super.key, this.flag = 0});

  @override
  State<CompanyMasterFormContent> createState() =>
      _CompanyMasterFormContentState();
}

class _CompanyMasterFormContentState extends State<CompanyMasterFormContent> {
  @override
  Widget build(BuildContext context) {
    //商品数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    //控制页面刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;
    return BlocBuilder<CompanyMasterBloc, CompanyMasterModel>(
      builder: (context, state) {
        if (currentFlag) {
          //明细按钮输入框不可输入
          if (widget.flag == 0) {
            context
                .read<CompanyMasterBloc>()
                .add(ShowSelectValueEvent(data, "2"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          } else {
            //登录和修正按钮，输入框可以输入
            context
                .read<CompanyMasterBloc>()
                .add(ShowSelectValueEvent(data, "1"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          }
        }
        // 初始化基本情報入力表单
        List<Widget> _initFormBasic() {
          return [
            FractionallySizedBox(
              //1会社ID
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.company_information_1,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['id'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //2会社名
              widthFactor: 0.3,
              child: Container(
                height: 72,
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
                                .company_information_2,
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
                      text: state.formInfo['name'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<CompanyMasterBloc>()
                            .add(SetCompanyValueEvent('name', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //3略称
              widthFactor: 0.3,
              child: Container(
                height: 72,
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
                                .company_information_3,
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
                      text: state.formInfo['name_short'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<CompanyMasterBloc>()
                            .add(SetCompanyValueEvent('name_short', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //4法人番号
              widthFactor: 0.3,
              child: Container(
                height: 72,
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
                      text: state.formInfo['corporate_cd'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<CompanyMasterBloc>()
                            .add(SetCompanyValueEvent('corporate_cd', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //5適格請求登録番号
              widthFactor: 0.3,
              child: Container(
                height: 72,
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
                      text: state.formInfo['qrr_cd'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<CompanyMasterBloc>()
                            .add(SetCompanyValueEvent('qrr_cd', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //6郵便番号
              widthFactor: 0.3,
              child: Container(
                height: 72,
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
                                .company_information_6,
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
                      text: state.formInfo['postal_cd'].toString(),
                      readOnly: state.stateFlg == '2',
                      country: 'JP',
                      postalCodeCallBack: (value) {
                        context.read<CompanyMasterBloc>().add(
                            SetCompanyValueEvent(
                                'postal_cd', value['postal_code']));
                        if (value['code'] == '0') {
                          //设定都道府县和市町村
                          context.read<CompanyMasterBloc>().add(
                              SetCompanyValueEvent(
                                  'addr_1', value['data']['city']));
                          context.read<CompanyMasterBloc>().add(
                              SetCompanyValueEvent(
                                  'addr_2', value['data']['region']));
                          context.read<CompanyMasterBloc>().add(
                              SetCompanyValueEvent(
                                  'addr_3', value['data']['addr']));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //7都道府県
              widthFactor: 0.3,
              child: Container(
                height: 72,
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
                                .company_information_7,
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
                      text: state.formInfo['addr_1'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<CompanyMasterBloc>()
                            .add(SetCompanyValueEvent('addr_1', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //8市区町村
              widthFactor: 0.3,
              child: Container(
                height: 72,
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
                      text: state.formInfo['addr_2'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<CompanyMasterBloc>()
                            .add(SetCompanyValueEvent('addr_2', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //9住所
              widthFactor: 0.3,
              child: Container(
                height: 72,
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
                                .company_information_9,
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
                      text: state.formInfo['addr_3'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<CompanyMasterBloc>()
                            .add(SetCompanyValueEvent('addr_3', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //10電話番号
              widthFactor: 0.3,
              child: Container(
                height: 72,
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
                                .company_information_10,
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
                      numberIME: true,
                      text: state.formInfo['tel'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<CompanyMasterBloc>()
                            .add(SetCompanyValueEvent('tel', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //11FAX番号
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.company_information_11,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      numberIME: true,
                      text: state.formInfo['fax'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<CompanyMasterBloc>()
                            .add(SetCompanyValueEvent('fax', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //12Webサイト
              widthFactor: 0.3,
              child: Container(
                height: 72,
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
                      text: state.formInfo['url'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<CompanyMasterBloc>()
                            .add(SetCompanyValueEvent('url', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //13E-MAIL
              widthFactor: 0.3,
              child: Container(
                height: 72,
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
                      text: state.formInfo['email'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<CompanyMasterBloc>()
                            .add(SetCompanyValueEvent('email', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //14状態
              widthFactor: 0.3,
              child: Container(
                height: 72,
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
                                .company_information_14,
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
                    state.stateFlg != '2' && state.onlyMyselfData == false
                        ? WMSDropdownWidget(
                            dataList1: state.statusList,
                            inputInitialValue:
                                state.formInfo['status_name'].toString(),
                            inputRadius: 4,
                            inputSuffixIcon: Container(
                              width: 24,
                              height: 24,
                              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                            ),
                            inputFontSize: 14,
                            dropdownRadius: 4,
                            dropdownTitle: 'name',
                            selectedCallBack: (value) {
                              // 判断数值
                              if (value == '') {
                                // 设定值
                                context
                                    .read<CompanyMasterBloc>()
                                    .add(SetCompanyValueEvent('status', ''));
                                context.read<CompanyMasterBloc>().add(
                                    SetCompanyValueEvent('status_name', ''));
                                // context
                                //     .read<CompanyMasterBloc>()
                                //     .add(SetDropdownValueEvent('1', '', ''));
                              } else {
                                // 设定值
                                context.read<CompanyMasterBloc>().add(
                                    SetCompanyValueEvent(
                                        'status', value['id']));
                                context.read<CompanyMasterBloc>().add(
                                    SetCompanyValueEvent(
                                        'status_name', value['name']));
                                // context.read<CompanyMasterBloc>().add(
                                //     SetDropdownValueEvent(
                                //         '1', value['id'], value['name']));
                              }
                            },
                          )
                        : WMSInputboxWidget(
                            text: state.formInfo['status_name'].toString(),
                            readOnly: true),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //15強制出荷
              widthFactor: 0.3,
              child: Container(
                height: 72,
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
                                .company_information_15,
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
                    state.stateFlg != '2'
                        ? WMSDropdownWidget(
                            dataList1: state.forcedList,
                            inputInitialValue: state
                                .formInfo['forced_shipment_flag_name']
                                .toString(),
                            inputRadius: 4,
                            inputSuffixIcon: Container(
                              width: 24,
                              height: 24,
                              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                            ),
                            inputFontSize: 14,
                            dropdownRadius: 4,
                            dropdownTitle: 'name',
                            selectedCallBack: (value) {
                              // 判断数值
                              if (value == '') {
                                // 设定值
                                context.read<CompanyMasterBloc>().add(
                                    SetCompanyValueEvent(
                                        'forced_shipment_flag', ''));
                                context.read<CompanyMasterBloc>().add(
                                    SetCompanyValueEvent(
                                        'forced_shipment_flag_name', ''));
                                // context
                                //     .read<CompanyMasterBloc>()
                                //     .add(SetDropdownValueEvent('2', '', ''));
                              } else {
                                // 设定值
                                context.read<CompanyMasterBloc>().add(
                                    SetCompanyValueEvent(
                                        'forced_shipment_flag', value['id']));
                                context.read<CompanyMasterBloc>().add(
                                    SetCompanyValueEvent(
                                        'forced_shipment_flag_name',
                                        value['name']));
                                // context.read<CompanyMasterBloc>().add(
                                //     SetDropdownValueEvent(
                                //         '2', value['id'], value['name']));
                              }
                            },
                          )
                        : WMSInputboxWidget(
                            text: state.formInfo['forced_shipment_flag_name']
                                .toString(),
                            readOnly: true),
                  ],
                ),
              ),
            ),
          ];
        }

        return Container(
          margin: EdgeInsets.only(
            bottom: 40,
          ),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: CompanyMasterFormTab(),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: CompanyMasterFormButton(state: state),
                      ),
                    ),
                  ],
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  padding: EdgeInsets.all(24),
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

// 会社マスタ-表单Tab
// ignore: must_be_immutable
class CompanyMasterFormTab extends StatefulWidget {
  CompanyMasterFormTab({super.key});

  @override
  State<CompanyMasterFormTab> createState() => _CompanyMasterFormTabState();
}

class _CompanyMasterFormTabState extends State<CompanyMasterFormTab> {
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
    // Tab单个列表
    List _tabItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.reserve_input_2,
      },
    ];

    return Row(
      children: _initTabList(_tabItemList),
    );
  }
}

// 会社-表单按钮
// ignore: must_be_immutable
class CompanyMasterFormButton extends StatefulWidget {
  CompanyMasterModel state;
  CompanyMasterFormButton({super.key, required this.state});

  @override
  State<CompanyMasterFormButton> createState() =>
      _CompanyMasterFormButtonState();
}

class _CompanyMasterFormButtonState extends State<CompanyMasterFormButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        GestureDetector(
          // onTap: () {},
          child: Container(
            margin: EdgeInsets.only(left: 20),
            height: 37,
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  buttonItemList[i]['index'] == Config.NUMBER_ZERO
                      ? Color.fromRGBO(44, 167, 176, 1)
                      : (widget.state.stateFlg == '2'
                          ? Color.fromRGBO(95, 97, 97, 1)
                          : Color.fromRGBO(44, 167, 176, 1)),
                ), // 设置按钮背景颜色
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white), // 设置按钮文本颜色
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(80, 37),
                ), // 设置按钮宽度和高度
              ),
              onPressed: () {
                // 判断循环下标
                if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                  //清除表单数据
                  context.read<CompanyMasterBloc>().add(ClearFormEvent());
                } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE &&
                    widget.state.stateFlg == '1') {
                  //新增/修改数据
                  context
                      .read<CompanyMasterBloc>()
                      .add(UpdateFormEvent(context));
                }
              },
              child: Text(
                buttonItemList[i]['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(255, 255, 255, 1),
                  height: 1.28,
                ),
              ),
            ),
          ),
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    // 按钮单个列表
    List _buttonItemList = [];

    if (context.read<CompanyMasterBloc>().state.onlyMyselfData) {
      if (context.read<CompanyMasterBloc>().state.formInfo['id'] == null ||
          context.read<CompanyMasterBloc>().state.formInfo['id'] == '') {
        _buttonItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'title':
                WMSLocalizations.i18n(context)!.exit_input_form_button_clear,
          },
        ];
      } else {
        _buttonItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'title':
                WMSLocalizations.i18n(context)!.exit_input_form_button_clear,
          },
          {
            'index': Config.NUMBER_ONE,
            'title': context.read<CompanyMasterBloc>().state.stateFlg == '2'
                ? WMSLocalizations.i18n(context)!
                    .instruction_input_tab_button_add
                : WMSLocalizations.i18n(context)!
                    .instruction_input_tab_button_update,
          },
        ];
      }
    } else {
      _buttonItemList = [
        {
          'index': Config.NUMBER_ZERO,
          'title': WMSLocalizations.i18n(context)!.exit_input_form_button_clear,
        },
        {
          'index': Config.NUMBER_ONE,
          'title': context.read<CompanyMasterBloc>().state.formInfo['id'] ==
                      null ||
                  context.read<CompanyMasterBloc>().state.formInfo['id'] ==
                      '' ||
                  context.read<CompanyMasterBloc>().state.stateFlg == '2'
              ? WMSLocalizations.i18n(context)!.instruction_input_tab_button_add
              : WMSLocalizations.i18n(context)!
                  .instruction_input_tab_button_update,
        },
      ];
    }

    return Row(
      children: _initButtonList(_buttonItemList),
    );
  }
}
