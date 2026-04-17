import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../widget/wms_date_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../../../../widget/wms_postal_code_widget.dart';
import '../bloc/information_management_bloc.dart';
import '../bloc/information_management_model.dart';

/**
 * 内容：運用基本情報管理-表单
 * 作者：王光顺
 * 时间：2023/09/06
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 全局主键-下拉共通

class InformationManagementForm extends StatefulWidget {
  const InformationManagementForm({super.key});

  @override
  State<InformationManagementForm> createState() =>
      _InformationManagementFormState();
}

class _InformationManagementFormState extends State<InformationManagementForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InformationManagementBloc, InformationManagementModel>(
        builder: (context, state) {
      // 初始化基本情報入力表单
      List<Widget> _initFormBasic() {
        return [
          // FractionallySizedBox(
          //   //1
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
          //             WMSLocalizations.i18n(context)!.company_information_1,
          //             style: TextStyle(
          //               fontWeight: FontWeight.w400,
          //               fontSize: 14,
          //               color: Color.fromRGBO(1, 4, 4, 1),
          //             ),
          //           ),
          //         ),
          //         WMSInputboxWidget(
          //           readOnly: true,
          //           text: state.customerList['id'].toString(),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          FractionallySizedBox(
            //2
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
                          WMSLocalizations.i18n(context)!.company_information_2,
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
                    text: state.customerList['name'].toString(),
                    inputBoxCallBack: (value) {
                      context
                          .read<InformationManagementBloc>()
                          .add(SetInformationValueEvent('name', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //3
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
                      WMSLocalizations.i18n(context)!.company_information_4,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    text: state.customerList['corporate_cd'].toString(),
                    inputBoxCallBack: (value) {
                      context
                          .read<InformationManagementBloc>()
                          .add(SetInformationValueEvent('corporate_cd', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //4
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
                      WMSLocalizations.i18n(context)!.company_information_5,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    text: state.customerList['qrr_cd'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定登录值事件
                      context
                          .read<InformationManagementBloc>()
                          .add(SetInformationValueEvent('qrr_cd', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //5
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
                      WMSLocalizations.i18n(context)!.company_information_6,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSPostalcodeWidget(
                    text: state.customerList['postal_cd'].toString(),
                    country: 'JP',
                    postalCodeCallBack: (value) {
                      context.read<InformationManagementBloc>().add(
                          SetInformationValueEvent(
                              'postal_cd', value['postal_code']));
                      if (value['code'] == '0') {
                        //设定都道府县和市町村
                        context.read<InformationManagementBloc>().add(
                            SetInformationValueEvent(
                                'addr_1', value['data']['city']));
                        context.read<InformationManagementBloc>().add(
                            SetInformationValueEvent(
                                'addr_2', value['data']['region']));
                        context.read<InformationManagementBloc>().add(
                            SetInformationValueEvent(
                                'addr_3', value['data']['addr']));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //6
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
                      WMSLocalizations.i18n(context)!.company_information_7,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    text: state.customerList['addr_1'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定登录值事件
                      context
                          .read<InformationManagementBloc>()
                          .add(SetInformationValueEvent('addr_1', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //7
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
                      WMSLocalizations.i18n(context)!.company_information_8,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    text: state.customerList['addr_2'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定登录值事件
                      context
                          .read<InformationManagementBloc>()
                          .add(SetInformationValueEvent('addr_2', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //8
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
                      WMSLocalizations.i18n(context)!.company_information_9,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    text: state.customerList['addr_3'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定登录值事件
                      context
                          .read<InformationManagementBloc>()
                          .add(SetInformationValueEvent('addr_3', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //9
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
                    text: state.customerList['tel'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定登录值事件
                      context
                          .read<InformationManagementBloc>()
                          .add(SetInformationValueEvent('tel', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //10
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
                    text: state.customerList['fax'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定登录值事件
                      context
                          .read<InformationManagementBloc>()
                          .add(SetInformationValueEvent('fax', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //11
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
                    text: state.customerList['url'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定登录值事件
                      context
                          .read<InformationManagementBloc>()
                          .add(SetInformationValueEvent('url', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //12
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
                      WMSLocalizations.i18n(context)!.information_management_1,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    text: state.customerList['email'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定登录值事件
                      context
                          .read<InformationManagementBloc>()
                          .add(SetInformationValueEvent('email', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //13
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
                      WMSLocalizations.i18n(context)!.information_management_2,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    text: state.customerList['business_hour'].toString(),
                    inputBoxCallBack: (value) {
                      // 设定登录值事件
                      context.read<InformationManagementBloc>().add(
                          SetInformationValueEvent('business_hour', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //14
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
                              .information_management_3,
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
                      text: state.customerList['free_time']
                          .toString()
                          .split('T')[0],
                      dateCallBack: (value) {
                        setState(() {
                          context.read<InformationManagementBloc>().add(
                              SetInformationValueEvent('free_time', value));
                        });
                      }),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            //占位
            widthFactor: 0.3,
            child: Container(
              height: 72,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
            ),
          ),
        ];
      }

      return Container(
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
                      child: ProductMasterManagementFormTab(),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ProductMasterManagementFormButton(),
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
    });
  }
}

// Tab
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

// 表单按钮
class ProductMasterManagementFormButton extends StatefulWidget {
  const ProductMasterManagementFormButton({super.key});

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
          onTap: () {
            // 判断循环下标
            if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {}
          },
          child: Container(
            margin: EdgeInsets.only(left: 20),
            height: 37,
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(44, 167, 176, 1),
                ), // 设置按钮背景颜色
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white), // 设置按钮文本颜色
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(80, 37),
                ), // 设置按钮宽度和高度
              ),
              onPressed: () {
                context
                    .read<InformationManagementBloc>()
                    .add(UpdataInformEvent(context));
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
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_button_add,
      },
    ];

    return Row(
      children: _initButtonList(_buttonItemList),
    );
  }
}
