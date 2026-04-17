import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/mst/supplier_master/bloc/supplier_master_bloc.dart';
import 'package:wms/page/mst/supplier_master/bloc/supplier_master_model.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../../../../widget/wms_postal_code_widget.dart';
import 'supplier_master_title.dart';

/**
* 内容：仕入先マスタ管理 -基本信息
 * 作者：cuihr
 * 时间：2023/09/06
 */
class SupplierMasterInformation extends StatefulWidget {
  final String flag_num;
  const SupplierMasterInformation({super.key, required this.flag_num});

  @override
  State<SupplierMasterInformation> createState() =>
      _SupplierMasterInformationState();
}

class _SupplierMasterInformationState extends State<SupplierMasterInformation> {
  @override
  Widget build(BuildContext context) {
    //获取当前登录用户会社ID
    int companyId = 0;
    if (StoreProvider.of<WMSState>(context).state.loginUser!.company_id !=
        null) {
      companyId =
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    }
    //获取当前登录用户角色ID
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;

    return BlocProvider<SupplierMasterBloc>(
      create: (context) {
        return SupplierMasterBloc(
          SupplierMasterModel(
              context: context, companyId: companyId, roleId: roleId),
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
              SupplierMasterTitle(
                flag: 'change',
              ),
              // 表单内容
              SupplierMasterInformationContent(
                flag_num: widget.flag_num,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SupplierMasterInformationContent extends StatefulWidget {
  final String flag_num;
  const SupplierMasterInformationContent({super.key, required this.flag_num});

  @override
  State<SupplierMasterInformationContent> createState() =>
      _SupplierMasterInformationContentState();
}

class _SupplierMasterInformationContentState
    extends State<SupplierMasterInformationContent> {
  Map<String, dynamic> currentParam = {};
  @override
  Widget build(BuildContext context) {
    setState(() {
      //接收传过来的参数
      currentParam = StoreProvider.of<WMSState>(context).state.currentParam;
    });
    //控制页面刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;

    return BlocBuilder<SupplierMasterBloc, SupplierMasterModel>(
      builder: (context, state) {
        if (currentFlag) {
          if (widget.flag_num == '2') {
            context
                .read<SupplierMasterBloc>()
                .add(ShowSelectValueEvent(currentParam, "2"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          } else {
            //登录和修正按钮，输入框可以输入
            context
                .read<SupplierMasterBloc>()
                .add(ShowSelectValueEvent(currentParam, "1"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          }
        }

        // 初始化基本情報入力表单
        List<Widget> _initBasicInfo() {
          return [
            //仕入先id
            FractionallySizedBox(
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
                        WMSLocalizations.i18n(context)!.supplier_basic_id,
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
            //仕入先名称
            FractionallySizedBox(
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
                            WMSLocalizations.i18n(context)!.supplier_basic_name,
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
                            .read<SupplierMasterBloc>()
                            .add(SetSupplierValueEvent('name', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //カナ名称
            FractionallySizedBox(
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
                            WMSLocalizations.i18n(context)!.supplier_basic_kana,
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
                      text: state.formInfo['name_kana'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<SupplierMasterBloc>()
                            .add(SetSupplierValueEvent('name_kana', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //略称
            FractionallySizedBox(
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
                                .supplier_basic_abbreviation,
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
                            .read<SupplierMasterBloc>()
                            .add(SetSupplierValueEvent('name_short', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //郵便番号
            FractionallySizedBox(
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
                                .supplier_basic_zip_code,
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
                        context.read<SupplierMasterBloc>().add(
                            SetSupplierValueEvent(
                                'postal_cd', value['postal_code']));
                        if (value['code'] == '0') {
                          //设定都道府县和市町村
                          context.read<SupplierMasterBloc>().add(
                              SetSupplierValueEvent(
                                  'addr_1', value['data']['city']));
                          context.read<SupplierMasterBloc>().add(
                              SetSupplierValueEvent(
                                  'addr_2', value['data']['region']));
                          context.read<SupplierMasterBloc>().add(
                              SetSupplierValueEvent(
                                  'addr_3', value['data']['addr']));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            //都道府県
            FractionallySizedBox(
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
                                .supplier_basic_province,
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
                            .read<SupplierMasterBloc>()
                            .add(SetSupplierValueEvent('addr_1', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //市区町村
            FractionallySizedBox(
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
                                .supplier_basic_villages,
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
                            .read<SupplierMasterBloc>()
                            .add(SetSupplierValueEvent('addr_2', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //住所
            FractionallySizedBox(
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
                                .supplier_basic_address,
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
                            .read<SupplierMasterBloc>()
                            .add(SetSupplierValueEvent('addr_3', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //電話番号
            FractionallySizedBox(
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
                                .supplier_basic_telephone_number,
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
                            .read<SupplierMasterBloc>()
                            .add(SetSupplierValueEvent('tel', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //FAX番号
            FractionallySizedBox(
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
                                .supplier_basic_fax_number,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    WMSInputboxWidget(
                      numberIME: true,
                      text: state.formInfo['fax'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<SupplierMasterBloc>()
                            .add(SetSupplierValueEvent('fax', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            //代表者名
            FractionallySizedBox(
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
                                .supplier_basic_representative_name,
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
                      text: state.formInfo['owner_name'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<SupplierMasterBloc>()
                            .add(SetSupplierValueEvent('owner_name', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //会社
            // FractionallySizedBox(
            //   widthFactor: 0.3,
            //   child: Container(
            //     height: 72,
            //     margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Container(
            //           height: 24,
            //           child: Text(
            //             WMSLocalizations.i18n(context)!.supplier_basic_company,
            //             style: TextStyle(
            //               fontWeight: FontWeight.w400,
            //               fontSize: 14,
            //               color: Color.fromRGBO(6, 14, 15, 1),
            //             ),
            //           ),
            //         ),
            //         WMSInputboxWidget(
            //           inputBoxCallBack: (value) {
            //             print(value);
            //           },
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            //担当者名
            FractionallySizedBox(
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
                                .supplier_basic_contact_name,
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
                      text: state.formInfo['contact'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<SupplierMasterBloc>()
                            .add(SetSupplierValueEvent('contact', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 担当者名 -電話番号
            FractionallySizedBox(
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
                                .supplier_basic_contact_telephone_number,
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
                      text: state.formInfo['contact_tel'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<SupplierMasterBloc>()
                            .add(SetSupplierValueEvent('contact_tel', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 担当者名 -FAX番号
            FractionallySizedBox(
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
                                .supplier_basic_contact_fax_number,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    WMSInputboxWidget(
                      numberIME: true,
                      text: state.formInfo['contact_fax'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<SupplierMasterBloc>()
                            .add(SetSupplierValueEvent('contact_fax', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //担当者名 -email
            FractionallySizedBox(
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
                                .supplier_basic_contact_email,
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
                      text: state.formInfo['contact_email'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<SupplierMasterBloc>()
                            .add(SetSupplierValueEvent('contact_email', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //社内備考1
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 160,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .supplier_basic_internal_remarks_1,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      height: 136,
                      maxLines: 5,
                      text: state.formInfo['company_note1'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<SupplierMasterBloc>()
                            .add(SetSupplierValueEvent('company_note1', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
// 会社名称
            FractionallySizedBox(
              widthFactor: 0.3,
              child: state.roleId == 1
                  ? Container(
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
                          state.stateFlg != '2'
                              ? WMSDropdownWidget(
                                  dataList1: state.salesCompanyInfoList,
                                  inputInitialValue:
                                      state.formInfo['company_name'] == null
                                          ? ''
                                          : state.formInfo['company_name']
                                              .toString(),
                                  dropdownTitle: 'name',
                                  inputRadius: 4,
                                  inputFontSize: 14,
                                  dropdownRadius: 4,
                                  inputSuffixIcon: Container(
                                    width: 24,
                                    height: 24,
                                    margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                    child: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                    ),
                                  ),
                                  selectedCallBack: (value) {
                                    // 设定值
                                    if (value != '') {
                                      context.read<SupplierMasterBloc>().add(
                                          SetSupplierValueEvent(
                                              'company_name', value['name']));
                                      context.read<SupplierMasterBloc>().add(
                                          SetSupplierValueEvent('company_id',
                                              int.parse(value['id'])));
                                    } else {
                                      context.read<SupplierMasterBloc>().add(
                                          SetSupplierValueEvent(
                                              'company_name', ''));
                                      context.read<SupplierMasterBloc>().add(
                                          SetSupplierValueEvent(
                                              'company_id', ''));
                                    }
                                  },
                                )
                              : WMSInputboxWidget(
                                  text:
                                      state.formInfo['company_name'].toString(),
                                  readOnly: true,
                                ),
                        ],
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    ),
            ),

            //社内備考2
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 160,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .supplier_basic_internal_remarks_2,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      height: 136,
                      maxLines: 5,
                      text: state.formInfo['company_note2'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<SupplierMasterBloc>()
                            .add(SetSupplierValueEvent('company_note2', value));
                      },
                    ),
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
                        child: SupplierMasterInformationTab(),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: SupplierMasterInformationButton(state: state),
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
                    children: _initBasicInfo(),
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

//基本信息tab
class SupplierMasterInformationTab extends StatefulWidget {
  const SupplierMasterInformationTab({super.key});

  @override
  State<SupplierMasterInformationTab> createState() =>
      _SupplierMasterInformationTabState();
}

class _SupplierMasterInformationTabState
    extends State<SupplierMasterInformationTab> {
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

// ignore: must_be_immutable
class SupplierMasterInformationButton extends StatefulWidget {
  SupplierMasterModel state;
  SupplierMasterInformationButton({super.key, required this.state});

  @override
  State<SupplierMasterInformationButton> createState() =>
      _SupplierMasterInformationButtonState();
}

class _SupplierMasterInformationButtonState
    extends State<SupplierMasterInformationButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        GestureDetector(
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
                  context.read<SupplierMasterBloc>().add(ClearFormEvent());
                } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE &&
                    widget.state.stateFlg == '1') {
                  //新增/修改数据
                  context
                      .read<SupplierMasterBloc>()
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
    List _buttonItemList = [
      //清除
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.exit_input_form_button_clear,
      },
      //登录
      {
        'index': Config.NUMBER_ONE,
        'title': context.read<SupplierMasterBloc>().state.formInfo['id'] ==
                    null ||
                context.read<SupplierMasterBloc>().state.formInfo['id'] == '' ||
                context.read<SupplierMasterBloc>().state.stateFlg == '2'
            ? WMSLocalizations.i18n(context)!.instruction_input_tab_button_add
            : WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_update,
      },
    ];

    return Row(
      children: _initButtonList(_buttonItemList),
    );
  }
}
