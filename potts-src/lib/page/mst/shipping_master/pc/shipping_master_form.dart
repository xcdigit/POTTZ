import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_date_widget.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../../../../widget/wms_postal_code_widget.dart';
import '../bloc/shipping_master_bloc.dart';
import '../bloc/shipping_master_model.dart';
import 'shipping_master_title.dart';

/**
 * 内容：荷主マスタ-表单
 * 作者：王光顺
 * 时间：2023/11/29
 */
// ignore: must_be_immutable
class ShippingMasterForm extends StatefulWidget {
  String flag; //按钮跳转判断

  ShippingMasterForm({super.key, required this.flag});

  @override
  State<ShippingMasterForm> createState() => _ShippingMasterFormState();
}

class _ShippingMasterFormState extends State<ShippingMasterForm> {
  @override
  Widget build(BuildContext context) {
    //仓库数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;
    //获取当前登录用户会社ID
    int companyId = 0;
    if (roleId != 1) {
      companyId =
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    }
    return BlocProvider<ShippingMasterBloc>(
      create: (context) {
        return ShippingMasterBloc(
          ShippingMasterModel(
              context: context,
              companyId: companyId,
              roleId: roleId,
              flag_num: widget.flag,
              flag_data: data),
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
              ShippingMasterTitle(
                flag: 'change',
              ),
              // 表单内容
              ShippingMasterFormContent(
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
class ShippingMasterFormContent extends StatefulWidget {
  String flag; //按钮跳转判断

  ShippingMasterFormContent({super.key, required this.flag});

  @override
  State<ShippingMasterFormContent> createState() =>
      _ShippingMasterFormContentState();
}

class _ShippingMasterFormContentState extends State<ShippingMasterFormContent> {
  @override
  Widget build(BuildContext context) {
    //商品数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    //控制页面刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;
    return BlocBuilder<ShippingMasterBloc, ShippingMasterModel>(
      builder: (context, state) {
        if (currentFlag) {
          //明细按钮输入框不可输入
          if (widget.flag == 0) {
            context
                .read<ShippingMasterBloc>()
                .add(ShowSelectValueEvent(data, "2"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          } else {
            //登录和修正按钮，输入框可以输入
            context
                .read<ShippingMasterBloc>()
                .add(ShowSelectValueEvent(data, "1"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          }
        }

        // 初始化基本情報入力表单
        List<Widget> _initFormBasic() {
          return [
            // 荷主ID
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
                        WMSLocalizations.i18n(context)!.shipping_master_form_1,
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
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('id', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 荷主名称
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
                                .shipping_master_form_2,
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
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('name', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // カナ名称
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
                                .shipping_master_form_3,
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
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('name_kana', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 略称
            Visibility(
              child: FractionallySizedBox(
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
                                  .shipping_master_form_4,
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
                              .read<ShippingMasterBloc>()
                              .add(SetMessageValueEvent('name_short', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 郵便番号
            Visibility(
              child: FractionallySizedBox(
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
                                  .shipping_master_form_5,
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
                          context.read<ShippingMasterBloc>().add(
                              SetMessageValueEvent(
                                  'postal_cd', value['postal_code']));
                          if (value['code'] == '0') {
                            //设定都道府县和市町村
                            context.read<ShippingMasterBloc>().add(
                                SetMessageValueEvent(
                                    'addr_1', value['data']['city']));
                            context.read<ShippingMasterBloc>().add(
                                SetMessageValueEvent(
                                    'addr_2', value['data']['region']));
                            context.read<ShippingMasterBloc>().add(
                                SetMessageValueEvent(
                                    'addr_3', value['data']['addr']));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 都道府県
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
                                .shipping_master_form_6,
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
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('addr_1', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 市区町村
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
                                .shipping_master_form_7,
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
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('addr_2', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 住所
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
                                .shipping_master_form_8,
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
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('addr_3', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 電話番号
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .shipping_master_form_9,
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
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('tel', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            // FAX番号
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
                        WMSLocalizations.i18n(context)!.shipping_master_form_10,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['fax'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('fax', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 代表者名
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
                                .shipping_master_form_11,
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
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('owner_name', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 担当者名
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
                                .shipping_master_form_12,
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
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('contact', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 担当者電話番号
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
                                .shipping_master_form_13,
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
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('contact_tel', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 担当者FAX番号
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
                        WMSLocalizations.i18n(context)!.shipping_master_form_14,
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
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('contact_fax', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 担当者EMAIL
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
                                .shipping_master_form_15,
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
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('contact_email', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 適用開始日
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
                                .shipping_master_form_16,
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
                      text: state.formInfo['start_date'].toString(),
                      readOnly: state.stateFlg == '2',
                      dateCallBack: (value) {
                        // 设定值
                        context
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('start_date', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 適用終了日
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
                                .shipping_master_form_17,
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
                      text: state.formInfo['end_date'].toString(),
                      readOnly: state.stateFlg == '2',
                      dateCallBack: (value) {
                        // 设定值
                        context
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('end_date', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 占位
            if (state.roleId != 1) FractionallySizedBox(widthFactor: 0.3),
            // 会社名称
            state.roleId == 1
                ? FractionallySizedBox(
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
                          state.stateFlg != '2'
                              ? WMSDropdownWidget(
                                  saveInput: true,
                                  inputInitialValue:
                                      state.formInfo['company_name'] == null
                                          ? ''
                                          : state.formInfo['company_name']
                                              .toString(),
                                  dropdownKey: 'name',
                                  dropdownTitle: 'name',
                                  dataList1: state.salesCompanyInfoList,
                                  inputRadius: 4,
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
                                    if (value is! String) {
                                      context.read<ShippingMasterBloc>().add(
                                          SetNowCompanyIDEvent(int.parse(
                                              value['id'].toString())));
                                      context.read<ShippingMasterBloc>().add(
                                          SetMessageValueEvent(
                                              'company_name', value['name']));
                                    } else {
                                      context.read<ShippingMasterBloc>().add(
                                          SetMessageValueEvent(
                                              'company_name', null));
                                      if (value.trim() != '' &&
                                          // ignore: unnecessary_null_comparison
                                          value != null) {
                                        WMSCommonBlocUtils.errorTextToast(
                                            WMSLocalizations.i18n(context)!
                                                .organization_master_tip_5);
                                      }
                                    }
                                  },
                                )
                              : WMSInputboxWidget(
                                  readOnly: true,
                                  text: state.formInfo['company_name'] == null
                                      ? ''
                                      : state.formInfo['company_name']
                                          .toString(),
                                ),
                        ],
                      ),
                    ),
                  )
                : Container(),

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
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .supplier_basic_internal_remarks_1,
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
                      height: 136,
                      maxLines: 5,
                      text: state.formInfo['company_note1'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('company_note1', value));
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
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .supplier_basic_internal_remarks_2,
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
                      height: 136,
                      maxLines: 5,
                      text: state.formInfo['company_note2'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<ShippingMasterBloc>()
                            .add(SetMessageValueEvent('company_note2', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            //占位
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
                        child: ShippingMasterFormTab(),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: ShippingMasterFormButton(state: state),
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

// 荷主マスタ管理-表单Tab
// ignore: must_be_immutable
class ShippingMasterFormTab extends StatefulWidget {
  ShippingMasterFormTab({super.key});

  @override
  State<ShippingMasterFormTab> createState() => _ShippingMasterFormTabState();
}

class _ShippingMasterFormTabState extends State<ShippingMasterFormTab> {
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

// 荷主マスタ管理-表单按钮
// ignore: must_be_immutable
class ShippingMasterFormButton extends StatefulWidget {
  ShippingMasterModel state;
  ShippingMasterFormButton({super.key, required this.state});

  @override
  State<ShippingMasterFormButton> createState() =>
      _ShippingMasterFormButtonState();
}

class _ShippingMasterFormButtonState extends State<ShippingMasterFormButton> {
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
                  context.read<ShippingMasterBloc>().add(ClearFormEvent());
                } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE &&
                    widget.state.stateFlg == '1') {
                  //新增/修改数据
                  context
                      .read<ShippingMasterBloc>()
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
        'title': context.read<ShippingMasterBloc>().state.formInfo['id'] ==
                    null ||
                context.read<ShippingMasterBloc>().state.formInfo['id'] == '' ||
                context.read<ShippingMasterBloc>().state.stateFlg == '2'
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
