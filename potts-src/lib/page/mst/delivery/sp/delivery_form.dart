import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/mst/delivery/bloc/delivery_bloc.dart';
import 'package:wms/page/mst/delivery/bloc/delivery_model.dart';
import 'package:wms/redux/current_flag_reducer.dart';
import 'package:wms/redux/wms_state.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../widget/wms_postal_code_widget.dart';

/**
 * 内容：納入先マスタ-表单
 * 作者：张博睿
 * 时间：2023/09/06
 */

// 当前下标
int currentIndex = Config.NUMBER_ZERO;

// ignore: must_be_immutable
class DeliveryForm extends StatefulWidget {
  int deliveryId; //id
  int flag; //按钮跳转判断
  DeliveryForm({super.key, required this.deliveryId, required this.flag});

  @override
  State<DeliveryForm> createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  @override
  Widget build(BuildContext context) {
    //获取当前登录用户身份
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;
    //获取当前登录用户会社ID
    int companyId = 0;
    if (StoreProvider.of<WMSState>(context).state.loginUser!.company_id !=
        null) {
      companyId = StoreProvider.of<WMSState>(context)
          .state
          .loginUser!
          .company_id as int;
    }
    //商品数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    //控制页面刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;

    return BlocProvider<DeliveryBloc>(
      create: (context) {
        return DeliveryBloc(
          DeliveryModel(context: context, companyId: companyId, roleId: roleId),
        );
      },
      child: BlocBuilder<DeliveryBloc, DeliveryModel>(
        builder: (context, state) {
          if (currentFlag) {
            //明细按钮输入框不可输入
            if (widget.flag == 0) {
              context.read<DeliveryBloc>().add(ShowSelectValueEvent(data, "2"));
              //控制刷新
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshCurrentFlagAction(false));
            } else {
              //登录和修正按钮，输入框可以输入
              context.read<DeliveryBloc>().add(ShowSelectValueEvent(data, "1"));
              //控制刷新
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshCurrentFlagAction(false));
            }
          }
          // 初始化基本情報入力表单
          List<Widget> _initFormBasic() {
            return [
              //纳入先id
              FractionallySizedBox(
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
                          WMSLocalizations.i18n(context)!.delivery_form_id,
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
              //納入先名称
              FractionallySizedBox(
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
                                  .delivery_form_name,
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
                              .read<DeliveryBloc>()
                              .add(SetDeliveryValueEvent('name', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //カナ名称
              FractionallySizedBox(
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
                                  .delivery_form_canaName,
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
                              .read<DeliveryBloc>()
                              .add(SetDeliveryValueEvent('name_kana', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //略称
              FractionallySizedBox(
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
                                  .delivery_form_abbreviation,
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
                              .read<DeliveryBloc>()
                              .add(SetDeliveryValueEvent('name_short', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //郵便番号
              FractionallySizedBox(
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
                                  .delivery_form_zipCode,
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
                          context.read<DeliveryBloc>().add(
                              SetDeliveryValueEvent(
                                  'postal_cd', value['postal_code']));
                          if (value['code'] == '0') {
                            //设定都道府县和市町村
                            context.read<DeliveryBloc>().add(
                                SetDeliveryValueEvent(
                                    'addr_1', value['data']['city']));
                            context.read<DeliveryBloc>().add(
                                SetDeliveryValueEvent(
                                    'addr_2', value['data']['region']));
                            context.read<DeliveryBloc>().add(
                                SetDeliveryValueEvent(
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
                                  .delivery_form_prefecture,
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
                              .read<DeliveryBloc>()
                              .add(SetDeliveryValueEvent('addr_1', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //市区町村
              FractionallySizedBox(
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
                                  .delivery_form_municipal,
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
                              .read<DeliveryBloc>()
                              .add(SetDeliveryValueEvent('addr_2', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //住所
              FractionallySizedBox(
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
                                  .delivery_form_address,
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
                              .read<DeliveryBloc>()
                              .add(SetDeliveryValueEvent('addr_3', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //電話番号
              FractionallySizedBox(
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
                              WMSLocalizations.i18n(context)!.delivery_form_tel,
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
                        text: state.formInfo['tel'].toString(),
                        readOnly: state.stateFlg == '2',
                        numberIME: true,
                        inputBoxCallBack: (value) {
                          // 设定值
                          context
                              .read<DeliveryBloc>()
                              .add(SetDeliveryValueEvent('tel', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //FAX番号
              FractionallySizedBox(
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
                              WMSLocalizations.i18n(context)!.delivery_form_fax,
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
                              .read<DeliveryBloc>()
                              .add(SetDeliveryValueEvent('fax', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //担当者名
              FractionallySizedBox(
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
                                  .delivery_form_chargePerson,
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
                        text: state.formInfo['person'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定值
                          context
                              .read<DeliveryBloc>()
                              .add(SetDeliveryValueEvent('person', value));
                        },
                      ),
                      // WMSDropdownWidget(
                      //   dropdownTitle: '荷姿',
                      //   key: _dropdownWidgetKey2,
                      //   inputWidth: double.infinity,
                      //   inputBackgroundColor: Colors.white,
                      //   inputBorderColor: Color.fromRGBO(224, 224, 224, 1),
                      //   inputRadius: 4,
                      //   inputSuffixIcon: Icon(Icons.keyboard_arrow_down),
                      // ),
                    ],
                  ),
                ),
              ),
              //会社名
              state.roleId == 1
                  ? FractionallySizedBox(
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
                                          .delivery_form_company,
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
                                          state.formInfo['company_name'],
                                      inputRadius: 4,
                                      inputSuffixIcon: Container(
                                        width: 24,
                                        height: 24,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 16, 0),
                                        child: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                        ),
                                      ),
                                      inputFontSize: 14,
                                      dropdownRadius: 4,
                                      dropdownTitle: 'name',
                                      selectedCallBack: (value) {
                                        // 设定值
                                        context.read<DeliveryBloc>().add(
                                            SetDeliveryValueEvent(
                                                'company_id', value['id']));
                                        // 设定值
                                        context.read<DeliveryBloc>().add(
                                            SetDeliveryValueEvent(
                                                'company_name', value['name']));
                                      },
                                    )
                                  : WMSInputboxWidget(
                                      text: state.formInfo['company_name']
                                          .toString(),
                                      readOnly: state.stateFlg == '2',
                                      inputBoxCallBack: (value) {
                                        // 设定值
                                        context.read<DeliveryBloc>().add(
                                            SetDeliveryValueEvent(
                                                'company', value));
                                      },
                                    ),
                            ],
                          )),
                    )
                  : FractionallySizedBox(),
              // FractionallySizedBox(
              //   widthFactor: 1,
              //   child: Container(
              //     margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              //   ),
              // ),
              //社内備考1
              FractionallySizedBox(
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
                          WMSLocalizations.i18n(context)!
                              .delivery_form_company_notes1,
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
                          context.read<DeliveryBloc>().add(
                              SetDeliveryValueEvent('company_note1', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //社内備考2
              FractionallySizedBox(
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
                          WMSLocalizations.i18n(context)!
                              .delivery_form_company_notes2,
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
                          context.read<DeliveryBloc>().add(
                              SetDeliveryValueEvent('company_note2', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //表单按钮
              Visibility(
                visible: widget.flag == 1,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: DeliveryFormButton(
                      state: state,
                      deliveryId: widget.deliveryId,
                    ),
                  ),
                ),
              ),
              // FractionallySizedBox(
              //   widthFactor: 1,
              //   child: Container(
              //     margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              //   ),
              // ),
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
                          child: DeliveryFormTab(),
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
      ),
    );
  }
}

// 出荷指示入力-表单Tab
// ignore: must_be_immutable
class DeliveryFormTab extends StatefulWidget {
  DeliveryFormTab({super.key});

  @override
  State<DeliveryFormTab> createState() => _DeliveryFormTabState();
}

class _DeliveryFormTabState extends State<DeliveryFormTab> {
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
                fontSize: 14,
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

// 出荷指示入力-表单按钮
// ignore: must_be_immutable
class DeliveryFormButton extends StatefulWidget {
  DeliveryModel state;
  int deliveryId;
  DeliveryFormButton(
      {super.key, required this.state, required this.deliveryId});

  @override
  State<DeliveryFormButton> createState() => _DeliveryFormButtonState();
}

class _DeliveryFormButtonState extends State<DeliveryFormButton> {
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
                if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                  //清除表单数据
                  context.read<DeliveryBloc>().add(ClearFormEvent());
                } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE &&
                    widget.state.stateFlg == '1') {
                  //新增/修改数据
                  context.read<DeliveryBloc>().add(UpdateFormEvent(context));
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
      // {
      //   'index': Config.NUMBER_ZERO,
      //   'title': WMSLocalizations.i18n(context)!.exit_input_form_button_clear,
      // },
      {
        'index': Config.NUMBER_ONE,
        'title': widget.deliveryId == 0
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
