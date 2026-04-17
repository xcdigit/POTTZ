import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/mst/customer_master/bloc/customer_master_bloc.dart';
import 'package:wms/page/mst/customer_master/bloc/customer_master_model.dart';
import 'package:wms/redux/current_flag_reducer.dart';
import 'package:wms/redux/wms_state.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../widget/wms_date_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../../../../widget/wms_postal_code_widget.dart';
import 'package:wms/widget/wms_label_radio.dart';

/**
 * 内容：得意先マスタ管理-表单
 * 作者：王光顺
 * 时间：2023/09/05
 */
// ignore: must_be_immutable
class CustomerMasterForm extends StatefulWidget {
  int customerId; //id
  int flag; //按钮跳转判断
  CustomerMasterForm({super.key, this.customerId = 0, this.flag = 0});

  @override
  State<CustomerMasterForm> createState() => _CustomerMasterFormState();
}

class _CustomerMasterFormState extends State<CustomerMasterForm> {
  @override
  Widget build(BuildContext context) {
    //获取当前登录用户会社ID
    int companyId = 0;

    if (StoreProvider.of<WMSState>(context).state.loginUser!.company_id !=
        null) {
      companyId =
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    }
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;

    //仓库数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    //控制页面刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;
    return BlocProvider<CustomerMasterBloc>(
      create: (context) {
        return CustomerMasterBloc(
          CustomerMasterModel(
              context: context, companyId: companyId, roleId: roleId),
        );
      },
      child: BlocBuilder<CustomerMasterBloc, CustomerMasterModel>(
        builder: (context, state) {
          if (currentFlag) {
            //明细按钮输入框不可输入
            if (widget.flag == 0) {
              context
                  .read<CustomerMasterBloc>()
                  .add(ShowSelectValueEvent(data, "2"));
              //控制刷新
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshCurrentFlagAction(false));
            } else {
              //登录和修正按钮，输入框可以输入
              context
                  .read<CustomerMasterBloc>()
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
                //1  id
                widthFactor: 1,
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.customer_master_1,
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
                //2 名称
                widthFactor: 1,
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
                              WMSLocalizations.i18n(context)!.customer_master_2,
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
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('name', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                //3 カナ名称
                widthFactor: 1,
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
                              WMSLocalizations.i18n(context)!.customer_master_3,
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
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('name_kana', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                //4 //略称
                widthFactor: 1,
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
                              WMSLocalizations.i18n(context)!.customer_master_4,
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
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('name_short', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                // 法人番号
                widthFactor: 1,
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
                                  .customer_master_20,
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
                        text: state.formInfo['corporation_number'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定值
                          context.read<CustomerMasterBloc>().add(
                              SetCustomerValueEvent(
                                  'corporation_number', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                //5 郵便番号
                widthFactor: 1,
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
                              WMSLocalizations.i18n(context)!.customer_master_5,
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
                          context.read<CustomerMasterBloc>().add(
                              SetCustomerValueEvent(
                                  'postal_cd', value['postal_code']));
                          if (value['code'] == '0') {
                            //设定都道府县和市町村
                            context.read<CustomerMasterBloc>().add(
                                SetCustomerValueEvent(
                                    'addr_1', value['data']['city']));
                            context.read<CustomerMasterBloc>().add(
                                SetCustomerValueEvent(
                                    'addr_2', value['data']['region']));
                            context.read<CustomerMasterBloc>().add(
                                SetCustomerValueEvent(
                                    'addr_3', value['data']['addr']));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                // 大分類
                widthFactor: 1,
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
                                  .customer_master_21,
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
                        text: state.formInfo['classify_1'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定值
                          context
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('classify_1', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                // 中分類
                widthFactor: 1,
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
                                  .customer_master_22,
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
                        text: state.formInfo['classify_2'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定值
                          context
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('classify_2', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                // 小分類
                widthFactor: 1,
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
                                  .customer_master_23,
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
                        text: state.formInfo['classify_3'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定值
                          context
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('classify_3', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                // 国
                widthFactor: 1,
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
                                  .customer_master_24,
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
                        text: state.formInfo['country'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定值
                          context
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('country', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                // 地域
                widthFactor: 1,
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
                                  .customer_master_25,
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
                        text: state.formInfo['region'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定值
                          context
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('region', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                //6 都道府県
                widthFactor: 1,
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
                              WMSLocalizations.i18n(context)!.customer_master_6,
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
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('addr_1', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                //7 市区町村
                widthFactor: 1,
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
                              WMSLocalizations.i18n(context)!.customer_master_7,
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
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('addr_2', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                //8 住所
                widthFactor: 1,
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
                                  .customer_master_29,
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
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('addr_3', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                // 住所詳細2
                widthFactor: 1,
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
                                  .customer_master_26,
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
                        text: state.formInfo['addr_4'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定值
                          context
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('addr_4', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                //9 電話番号
                widthFactor: 1,
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
                              WMSLocalizations.i18n(context)!.customer_master_9,
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
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('tel', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                //10 FAX番号
                widthFactor: 1,
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.customer_master_10,
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
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('fax', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                //11 代表者名
                widthFactor: 1,
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
                                  .customer_master_11,
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
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('owner_name', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                //12 担当者名
                widthFactor: 1,
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
                                  .customer_master_12,
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
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('contact', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                //13 担当者名 -電話番号
                widthFactor: 1,
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
                                  .customer_master_13,
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
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('contact_tel', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                //14  担当者名 -FAX番号
                widthFactor: 1,
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.customer_master_14,
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
                              .read<CustomerMasterBloc>()
                              .add(SetCustomerValueEvent('contact_fax', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                //15 担当者名 -email
                widthFactor: 1,
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
                                  .customer_master_15,
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
                          context.read<CustomerMasterBloc>().add(
                              SetCustomerValueEvent('contact_email', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                // 適用開始日
                widthFactor: 1,
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
                                  .customer_master_27,
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
                      WMSDateWidget(
                        text:
                            state.formInfo['application_start_date'].toString(),
                        readOnly: state.stateFlg == '2',
                        dateCallBack: (value) {
                          // 设定值
                          context.read<CustomerMasterBloc>().add(
                              SetCustomerValueEvent(
                                  'application_start_date', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                // 適用終了日
                widthFactor: 1,
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
                                  .customer_master_28,
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
                      WMSDateWidget(
                        text: state.formInfo['application_end_date'].toString(),
                        readOnly: state.stateFlg == '2',
                        dateCallBack: (value) {
                          // 设定值
                          context.read<CustomerMasterBloc>().add(
                              SetCustomerValueEvent(
                                  'application_end_date', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                //16 社内備考1
                widthFactor: 1,
                child: Container(
                  height: 160,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.customer_master_16,
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
                          context.read<CustomerMasterBloc>().add(
                              SetCustomerValueEvent('company_note1', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                //17 社内備考2
                widthFactor: 1,
                child: Container(
                  height: 160,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.customer_master_17,
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
                          context.read<CustomerMasterBloc>().add(
                              SetCustomerValueEvent('company_note2', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                // 消費期限
                widthFactor: 1,
                child: Container(
                  height: 216,
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
                                  .customer_master_31,
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
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromRGBO(224, 224, 224, 1),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: WMSInputboxWidget(
                                borderColor: Colors.transparent,
                                text: state.formInfo['limit_date'].toString(),
                                readOnly: state.stateFlg == '2',
                                inputBoxCallBack: (value) {
                                  // 设定值
                                  context.read<CustomerMasterBloc>().add(
                                      SetCustomerValueEvent(
                                          'limit_date', value));
                                },
                              ),
                            ),
                            Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Color.fromRGBO(224, 224, 224, 1),
                                  ),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(WMSLocalizations.i18n(context)!
                                    .customer_master_day),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IgnorePointer(
                        ignoring: state.stateFlg == '2',
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <WMSLabelRadio>[
                              WMSLabelRadio(
                                label: 'OFF',
                                value: 0,
                                groupValue:
                                    state.formInfo['limit_date_flg'] == null
                                        ? 0
                                        : int.parse(
                                            state.formInfo['limit_date_flg']),
                                onChanged: (int? value) {
                                  // 设定值
                                  context.read<CustomerMasterBloc>().add(
                                      SetCustomerValueEvent(
                                          'limit_date_flg', value.toString()));
                                },
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                              ),
                              WMSLabelRadio(
                                label: '出荷エラー',
                                value: 1,
                                groupValue:
                                    state.formInfo['limit_date_flg'] == null
                                        ? 0
                                        : int.parse(
                                            state.formInfo['limit_date_flg']),
                                onChanged: (int? value) {
                                  // 设定值
                                  context.read<CustomerMasterBloc>().add(
                                      SetCustomerValueEvent(
                                          'limit_date_flg', value.toString()));
                                },
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                              ),
                              WMSLabelRadio(
                                label: '出荷ワーニング',
                                value: 2,
                                groupValue:
                                    state.formInfo['limit_date_flg'] == null
                                        ? 0
                                        : int.parse(
                                            state.formInfo['limit_date_flg']),
                                onChanged: (int? value) {
                                  // 设定值
                                  context.read<CustomerMasterBloc>().add(
                                      SetCustomerValueEvent(
                                          'limit_date_flg', value.toString()));
                                },
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //18 会社名
              FractionallySizedBox(
                widthFactor: 1,
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
                                    inputInitialValue: state
                                        .formInfo['company_name']
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
                                        context.read<CustomerMasterBloc>().add(
                                            SetCustomerValueEvent(
                                                'company_id', ''));
                                        context.read<CustomerMasterBloc>().add(
                                            SetCustomerValueEvent(
                                                'company_name', ''));
                                      } else {
                                        // 设定值
                                        context.read<CustomerMasterBloc>().add(
                                            SetCustomerValueEvent('company_id',
                                                int.parse(value['id'])));
                                        context.read<CustomerMasterBloc>().add(
                                            SetCustomerValueEvent(
                                                'company_name', value['name']));
                                      }
                                    },
                                  )
                                : WMSInputboxWidget(
                                    text: state.formInfo['company_name']
                                        .toString(),
                                    readOnly: true,
                                  ),
                          ],
                        ),
                      )
                    : Container(),
              ),
              Visibility(
                visible: widget.flag == 1,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: CustomerMasterFormButton(
                      state: state,
                      customerId: widget.customerId,
                    ),
                  ),
                ),
              ),
            ];
          }

          return Container(
            margin: EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: ListView(
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.6,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: CustomerMasterFormTab(),
                        ),
                      ),
                    ],
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    padding: EdgeInsets.all(24),
                    margin: EdgeInsets.only(bottom: 200),
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
      ),
    );
  }
}

//表单Tab
// ignore: must_be_immutable
class CustomerMasterFormTab extends StatefulWidget {
  CustomerMasterFormTab({super.key});

  @override
  State<CustomerMasterFormTab> createState() => _CustomerMasterFormTabState();
}

class _CustomerMasterFormTabState extends State<CustomerMasterFormTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList) {
    // Tab列表
    List<Widget> tabList = [];
    tabList.add(
      Container(
        child: Container(
          height: 40,
          padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
          margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(44, 167, 176, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          constraints: BoxConstraints(
            minWidth: 108,
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

// 表单按钮
// ignore: must_be_immutable
class CustomerMasterFormButton extends StatefulWidget {
  CustomerMasterModel state;
  int customerId;
  CustomerMasterFormButton(
      {super.key, required this.state, required this.customerId});

  @override
  State<CustomerMasterFormButton> createState() =>
      _CustomerMasterFormButtonState();
}

class _CustomerMasterFormButtonState extends State<CustomerMasterFormButton> {
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
                if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                  //新增/修改数据
                  context
                      .read<CustomerMasterBloc>()
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
        'index': Config.NUMBER_ONE,
        'title': widget.customerId == 0
            ? WMSLocalizations.i18n(context)!.instruction_input_tab_button_add
            : WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_update,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _initButtonList(_buttonItemList),
    );
  }
}
