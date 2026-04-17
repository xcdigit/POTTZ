import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/mst/delivery_operators_master/bloc/delivery_operators_master_bloc.dart';
import 'package:wms/page/mst/delivery_operators_master/bloc/delivery_operators_master_model.dart';
import 'package:wms/widget/wms_date_widget.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';
import 'package:wms/widget/wms_postal_code_widget.dart';

import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import 'delivery_operators_master_title.dart';

/**
 * 内容：配送業者マスタ管理-表单
 * 作者：cuihr
 * 时间：2023/12/01
 */
// ignore: must_be_immutable
class DeliveryOperatorsMasterForm extends StatefulWidget {
  int deliveryId; //id
  int flag; //按钮跳转判断
  DeliveryOperatorsMasterForm(
      {super.key, required this.deliveryId, required this.flag});

  @override
  State<DeliveryOperatorsMasterForm> createState() =>
      _DeliveryOperatorsMasterFormState();
}

class _DeliveryOperatorsMasterFormState
    extends State<DeliveryOperatorsMasterForm> {
  @override
  Widget build(BuildContext context) {
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;
    int companyId = 0;
    if (roleId != 1) {
      //获取当前登录用户会社ID
      companyId =
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    }
    return BlocProvider<DeliveryOperatorsMasterBloc>(
      create: (context) {
        return DeliveryOperatorsMasterBloc(
          DeliveryOperatorsMasterModel(
            context: context,
            companyId: companyId,
            roleId: roleId,
          ),
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
              DeliveryOperatorsMasterTitle(
                flag: 'change',
              ),
              // 表单内容
              DeliveryOperatorsMasterFormContent(
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
class DeliveryOperatorsMasterFormContent extends StatefulWidget {
  int flag;
  DeliveryOperatorsMasterFormContent({super.key, this.flag = 0});

  @override
  State<DeliveryOperatorsMasterFormContent> createState() =>
      _DeliveryOperatorsMasterFormContentState();
}

class _DeliveryOperatorsMasterFormContentState
    extends State<DeliveryOperatorsMasterFormContent> {
  @override
  Widget build(BuildContext context) {
    //商品数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    //控制页面刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;
    return BlocBuilder<DeliveryOperatorsMasterBloc,
        DeliveryOperatorsMasterModel>(
      builder: (context, state) {
        if (currentFlag) {
          //明细按钮输入框不可输入
          if (widget.flag == 0) {
            context
                .read<DeliveryOperatorsMasterBloc>()
                .add(ShowSelectValueEvent(data, "2"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          } else {
            //登录和修正按钮，输入框可以输入
            context
                .read<DeliveryOperatorsMasterBloc>()
                .add(ShowSelectValueEvent(data, "1"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          }
        }

        // 初始化基本情報入力表单
        List<Widget> _initFormBasic() {
          return [
            //運送会社ID
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.operator_text_1,
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
            //運送会社名称
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
                            WMSLocalizations.i18n(context)!.operator_text_2,
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
                            .read<DeliveryOperatorsMasterBloc>()
                            .add(SetOperatorsValueEvent('name', value));
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
                                .delivery_table_zipCode,
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
                      postalCodeCallBack: (value) {
                        // 设定值
                        context.read<DeliveryOperatorsMasterBloc>().add(
                            SetOperatorsValueEvent(
                                'postal_cd', value['postal_code']));
                        if (value['code'] == '0') {
                          //设定都道府县和市町村
                          context.read<DeliveryOperatorsMasterBloc>().add(
                              SetOperatorsValueEvent(
                                  'addr_1', value['data']['city']));
                          context.read<DeliveryOperatorsMasterBloc>().add(
                              SetOperatorsValueEvent(
                                  'addr_2', value['data']['region']));
                          context.read<DeliveryOperatorsMasterBloc>().add(
                              SetOperatorsValueEvent(
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
                                .delivery_table_prefecture,
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
                            .read<DeliveryOperatorsMasterBloc>()
                            .add(SetOperatorsValueEvent('addr_1', value));
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
                                .delivery_table_municipal,
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
                            .read<DeliveryOperatorsMasterBloc>()
                            .add(SetOperatorsValueEvent('addr_2', value));
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
                                .delivery_table_address,
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
                            .read<DeliveryOperatorsMasterBloc>()
                            .add(SetOperatorsValueEvent('addr_3', value));
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
                            WMSLocalizations.i18n(context)!.delivery_table_tel,
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
                            .read<DeliveryOperatorsMasterBloc>()
                            .add(SetOperatorsValueEvent('tel', value));
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
                      child: Text(
                        WMSLocalizations.i18n(context)!.delivery_table_fax,
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
                            .read<DeliveryOperatorsMasterBloc>()
                            .add(SetOperatorsValueEvent('fax', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
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
                                .delivery_table_chargePerson,
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
                            .read<DeliveryOperatorsMasterBloc>()
                            .add(SetOperatorsValueEvent('contact', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //担当者-電話番号
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
                            .read<DeliveryOperatorsMasterBloc>()
                            .add(SetOperatorsValueEvent('contact_tel', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //担当者-FAX番号
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
                        WMSLocalizations.i18n(context)!
                            .supplier_basic_contact_fax_number,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      numberIME: true,
                      text: state.formInfo['contact_fax'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<DeliveryOperatorsMasterBloc>()
                            .add(SetOperatorsValueEvent('contact_fax', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //担当者-EMAIL
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
                        context.read<DeliveryOperatorsMasterBloc>().add(
                            SetOperatorsValueEvent('contact_email', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            //適用開始日
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
                            WMSLocalizations.i18n(context)!.operator_text_3,
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
                    // 时间组件
                    WMSDateWidget(
                      //进入页面日期设置为当前日期
                      text: state.formInfo['start_date'].toString(),
                      //返回日期
                      readOnly: state.stateFlg == '2',
                      dateCallBack: (value) {
                        if (value != '') {
                          context
                              .read<DeliveryOperatorsMasterBloc>()
                              .add(SetOperatorsValueEvent('start_date', value));
                        } else {
                          context
                              .read<DeliveryOperatorsMasterBloc>()
                              .add(SetOperatorsValueEvent('start_date', ''));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            //適用終了日
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
                            WMSLocalizations.i18n(context)!.operator_text_4,
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
                    // 时间组件
                    WMSDateWidget(
                      //进入页面日期设置为当前日期
                      text: state.formInfo['end_date'].toString(),
                      readOnly: state.stateFlg == '2',
                      //返回日期
                      dateCallBack: (value) {
                        if (value != '') {
                          context
                              .read<DeliveryOperatorsMasterBloc>()
                              .add(SetOperatorsValueEvent('end_date', value));
                        } else {
                          context
                              .read<DeliveryOperatorsMasterBloc>()
                              .add(SetOperatorsValueEvent('end_date', ''));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            //会社名
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
                                  dataList1: state.companyList,
                                  inputInitialValue:
                                      state.formInfo['company_name'].toString(),
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
                                          .read<DeliveryOperatorsMasterBloc>()
                                          .add(SetDropdownValueEvent(
                                              'company_id', ''));
                                      context
                                          .read<DeliveryOperatorsMasterBloc>()
                                          .add(SetDropdownValueEvent(
                                              'company_name', ''));
                                    } else {
                                      // 设定值
                                      context
                                          .read<DeliveryOperatorsMasterBloc>()
                                          .add(SetDropdownValueEvent(
                                              'company_id',
                                              int.parse(value['id'])));
                                      context
                                          .read<DeliveryOperatorsMasterBloc>()
                                          .add(SetDropdownValueEvent(
                                              'company_name', value['name']));
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
                        context.read<DeliveryOperatorsMasterBloc>().add(
                            SetOperatorsValueEvent('company_note1', value));
                      },
                    ),
                  ],
                ),
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
                        context.read<DeliveryOperatorsMasterBloc>().add(
                            SetOperatorsValueEvent('company_note2', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
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
                        child: DeliveryOperatorsMasterFormTab(),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: DeliveryOperatorsMasterFormButton(state: state),
                      ),
                    ),
                  ],
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
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

// 配送業者マスタ-表单Tab
// ignore: must_be_immutable
class DeliveryOperatorsMasterFormTab extends StatefulWidget {
  DeliveryOperatorsMasterFormTab({super.key});

  @override
  State<DeliveryOperatorsMasterFormTab> createState() =>
      _DeliveryOperatorsMasterFormTabState();
}

class _DeliveryOperatorsMasterFormTabState
    extends State<DeliveryOperatorsMasterFormTab> {
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

// 配送業者マスタ-表单按钮
// ignore: must_be_immutable
class DeliveryOperatorsMasterFormButton extends StatefulWidget {
  DeliveryOperatorsMasterModel state;
  DeliveryOperatorsMasterFormButton({super.key, required this.state});

  @override
  State<DeliveryOperatorsMasterFormButton> createState() =>
      _DeliveryOperatorsMasterFormButtonState();
}

class _DeliveryOperatorsMasterFormButtonState
    extends State<DeliveryOperatorsMasterFormButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(List buttonItemList) {
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
                  context
                      .read<DeliveryOperatorsMasterBloc>()
                      .add(ClearFormEvent());
                } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE &&
                    widget.state.stateFlg == '1') {
                  //新增/修改数据
                  context
                      .read<DeliveryOperatorsMasterBloc>()
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
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.exit_input_form_button_clear,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': context
                        .read<DeliveryOperatorsMasterBloc>()
                        .state
                        .formInfo['id'] ==
                    null ||
                context
                        .read<DeliveryOperatorsMasterBloc>()
                        .state
                        .formInfo['id'] ==
                    '' ||
                context.read<DeliveryOperatorsMasterBloc>().state.stateFlg ==
                    '2'
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
