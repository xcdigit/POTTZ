import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/mst/warehouse_master/bloc/warehouse_master_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../../../../widget/wms_postal_code_widget.dart';
import '../bloc/warehouse_master_model.dart';

/**
 * 内容：倉庫マスタ管理SP-表单
 * 作者：luxy
 * 时间：2023/11/21
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

// ignore: must_be_immutable
class WarehouseMasterForm extends StatefulWidget {
  int warehouseId; //仓库id
  int flag; //按钮跳转判断
  WarehouseMasterForm({super.key, this.warehouseId = 0, this.flag = 0});

  @override
  State<WarehouseMasterForm> createState() => _WarehouseMasterFormState();
}

class _WarehouseMasterFormState extends State<WarehouseMasterForm> {
  @override
  Widget build(BuildContext context) {
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;
    //获取当前登录用户会社ID
    int companyId = 0;
    if (roleId != 1) {
      companyId =
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    }
    //仓库数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    //控制页面刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;
    return BlocProvider<WarehouseMasterBloc>(create: (context) {
      return WarehouseMasterBloc(
        WarehouseMasterModel(
          context: context,
          companyId: companyId,
        ),
      );
    }, child: BlocBuilder<WarehouseMasterBloc, WarehouseMasterModel>(
        builder: (context, state) {
      if (currentFlag) {
        //明细按钮输入框不可输入
        if (widget.flag == 0) {
          context
              .read<WarehouseMasterBloc>()
              .add(ShowSelectValueEvent(data, "2"));
          //控制刷新
          StoreProvider.of<WMSState>(context)
              .dispatch(RefreshCurrentFlagAction(false));
        } else {
          //登录和修正按钮，输入框可以输入
          context
              .read<WarehouseMasterBloc>()
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
            //1
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
                      WMSLocalizations.i18n(context)!.warehouse_master_1,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly: true,
                    text: state.formInfo['id'].toString(),
                  ),
                ],
              ),
            ),
          ),
          // 赵士淞 - 始
          // 会社名
          Visibility(
            visible:
                StoreProvider.of<WMSState>(context).state.loginUser?.role_id ==
                    1,
            child: FractionallySizedBox(
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
                    Visibility(
                      visible: state.stateFlg != '2',
                      child: WMSDropdownWidget(
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
                            context.read<WarehouseMasterBloc>().add(
                                    SetMenuMapEvent({
                                  'company_id': value,
                                  'company_name': value
                                }));
                          } else {
                            // 设定值
                            context.read<WarehouseMasterBloc>().add(
                                    SetMenuMapEvent({
                                  'company_id': value['id'],
                                  'company_name': value['name']
                                }));
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: state.stateFlg == '2',
                      child: WMSInputboxWidget(
                        text: state.formInfo['company_name'].toString(),
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 赵士淞 - 终
          FractionallySizedBox(
            //2
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
                      WMSLocalizations.i18n(context)!.warehouse_master_2,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    text: state.formInfo['code'].toString(),
                    readOnly: state.stateFlg == '2' ? true : false,
                    inputBoxCallBack: (value) {
                      // 设定值
                      context
                          .read<WarehouseMasterBloc>()
                          .add(SetMenuValueEvent('code', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //3倉庫名称
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
                          WMSLocalizations.i18n(context)!.warehouse_master_3,
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
                    readOnly: state.stateFlg == '2' ? true : false,
                    inputBoxCallBack: (value) {
                      // 设定值
                      context
                          .read<WarehouseMasterBloc>()
                          .add(SetMenuValueEvent('name', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //4倉庫略称
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
                          WMSLocalizations.i18n(context)!.warehouse_master_7,
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
                    readOnly: state.stateFlg == '2' ? true : false,
                    inputBoxCallBack: (value) {
                      // 设定值
                      context
                          .read<WarehouseMasterBloc>()
                          .add(SetMenuValueEvent('name_short', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //5
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
                      WMSLocalizations.i18n(context)!.warehouse_master_4,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly: state.stateFlg == '2' ? true : false,
                    text: state.formInfo['kbn'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定值
                      context
                          .read<WarehouseMasterBloc>()
                          .add(SetMenuValueEvent('kbn', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //6
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
                      WMSLocalizations.i18n(context)!.warehouse_master_5,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly: state.stateFlg == '2' ? true : false,
                    text: state.formInfo['area'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定值
                      context
                          .read<WarehouseMasterBloc>()
                          .add(SetMenuValueEvent('area', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //6
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
                      WMSLocalizations.i18n(context)!.company_information_6,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSPostalcodeWidget(
                    readOnly: state.stateFlg == '2' ? true : false,
                    text: state.formInfo['postal_cd'].toString(),
                    country: 'JP',
                    postalCodeCallBack: (value) {
                      context.read<WarehouseMasterBloc>().add(
                          SetMenuValueEvent('postal_cd', value['postal_code']));

                      if (value['code'] == '0') {
                        //设定都道府县和市町村
                        context.read<WarehouseMasterBloc>().add(
                            SetMenuValueEvent('addr_1', value['data']['city']));
                        context.read<WarehouseMasterBloc>().add(
                            SetMenuValueEvent(
                                'addr_2', value['data']['region']));
                        context.read<WarehouseMasterBloc>().add(
                            SetMenuValueEvent('addr_3', value['data']['addr']));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //7
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
                      WMSLocalizations.i18n(context)!.company_information_7,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly: state.stateFlg == '2' ? true : false,
                    text: state.formInfo['addr_1'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定值
                      context
                          .read<WarehouseMasterBloc>()
                          .add(SetMenuValueEvent('addr_1', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //8
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
                      WMSLocalizations.i18n(context)!.company_information_8,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly: state.stateFlg == '2' ? true : false,
                    text: state.formInfo['addr_2'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定值
                      context
                          .read<WarehouseMasterBloc>()
                          .add(SetMenuValueEvent('addr_2', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //9
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
                      WMSLocalizations.i18n(context)!.company_information_9,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly: state.stateFlg == '2' ? true : false,
                    text: state.formInfo['addr_3'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定值
                      context
                          .read<WarehouseMasterBloc>()
                          .add(SetMenuValueEvent('addr_3', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //10
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
                      WMSLocalizations.i18n(context)!.company_information_10,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    numberIME: true,
                    readOnly: state.stateFlg == '2' ? true : false,
                    text: state.formInfo['tel'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定值
                      context
                          .read<WarehouseMasterBloc>()
                          .add(SetMenuValueEvent('tel', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //11
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
                    readOnly: state.stateFlg == '2' ? true : false,
                    text: state.formInfo['fax'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定值
                      context
                          .read<WarehouseMasterBloc>()
                          .add(SetMenuValueEvent('fax', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              height: 172,
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
                    readOnly: state.stateFlg == '2' ? true : false,
                    text: state.formInfo['note1'].toString(),
                    height: 136,
                    inputBoxCallBack: (value) {
                      // 设定值
                      context
                          .read<WarehouseMasterBloc>()
                          .add(SetMenuValueEvent('note1', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              height: 172,
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
                    readOnly: state.stateFlg == '2' ? true : false,
                    text: state.formInfo['note2'].toString(),
                    height: 136,
                    inputBoxCallBack: (value) {
                      // 设定值
                      context
                          .read<WarehouseMasterBloc>()
                          .add(SetMenuValueEvent('note2', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.flag == 1,
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ProductMasterManagementFormButton(
                  state: state,
                  warehouseId: widget.warehouseId,
                ),
              ),
            ),
          ),
        ];
      }

      return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                      child: ProductMasterManagementFormTab(),
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
    }));
  }
}

// 表单Tab
// ignore: must_be_immutable
class ProductMasterManagementFormTab extends StatefulWidget {
  ProductMasterManagementFormTab({super.key});

  @override
  State<ProductMasterManagementFormTab> createState() =>
      _ProductMasterManagementFormTabState();
}

class _ProductMasterManagementFormTabState
    extends State<ProductMasterManagementFormTab> {
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

// 表单按钮
// ignore: must_be_immutable
class ProductMasterManagementFormButton extends StatefulWidget {
  WarehouseMasterModel state;
  int warehouseId;
  ProductMasterManagementFormButton(
      {super.key, required this.state, required this.warehouseId});

  @override
  State<ProductMasterManagementFormButton> createState() =>
      _ProductMasterManagementFormButtonState();
}

class _ProductMasterManagementFormButtonState
    extends State<ProductMasterManagementFormButton> {
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
                  //新增/修改数据
                  context
                      .read<WarehouseMasterBloc>()
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
        'title': widget.warehouseId == 0
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
