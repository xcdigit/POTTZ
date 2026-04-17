import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/app/application_cceptance/bloc/application_cceptance_bloc.dart';
import 'package:wms/page/app/application_cceptance/bloc/application_cceptance_model.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

/**
 * 内容：申込受付 -检索条件
 * 作者：cuihr
 * 时间：2023/12/18
 */
class ApplicationCceptanceQuery extends StatefulWidget {
  const ApplicationCceptanceQuery({super.key});

  @override
  State<ApplicationCceptanceQuery> createState() =>
      _ApplicationCceptanceQueryState();
}

class _ApplicationCceptanceQueryState extends State<ApplicationCceptanceQuery> {
  // 检索按钮追踪
  bool _search = false;
  bool _searchData = false;
  bool buttonHovered = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationCceptanceBloc, ApplicationCceptanceModel>(
        builder: (context, state) {
      return Column(
        children: [
          // Padding(padding: EdgeInsets.only(top: 30)),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 48,
              child: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    buttonHovered = true; // 鼠标进入，按钮悬停状态为 true
                  });
                },
                onExit: (_) {
                  setState(() {
                    buttonHovered = false; // 鼠标离开，按钮悬停状态为 false
                  });
                },
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(
                      () {
                        _search = !_search;
                        if (_search) {
                          _searchData = false;
                        } else if (state.conditionList.length > 0) {
                          _searchData = true;
                        } else {
                          _searchData = false;
                        }
                      },
                    );
                  },
                  icon: ColorFiltered(
                    colorFilter: _search
                        ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                        : buttonHovered
                            ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                            : ColorFilter.mode(Color.fromRGBO(0, 122, 255, 1),
                                BlendMode.srcIn),
                    child:
                        Image.asset(WMSICons.WAREHOUSE_MENU_ICON, height: 24),
                  ),
                  label: Text(
                    WMSLocalizations.i18n(context)!.delivery_note_1,
                    style: TextStyle(
                        color: _search
                            ? Colors.white
                            : buttonHovered
                                ? Colors.white
                                : Color.fromRGBO(0, 122, 255, 1),
                        fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _search
                        ? Color.fromRGBO(0, 122, 255, 1)
                        : buttonHovered
                            ? Color.fromRGBO(0, 122, 255, .6)
                            : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            //检索结果展示
            visible: _searchData,
            child: Container(
              height: 50,
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black12,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    WMSLocalizations.i18n(context)!.delivery_note_11,
                    style: TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                  ),
                  SizedBox(width: 10),
                  for (int i = 0; i < state.conditionList.length; i++)
                    buildCondition(i, false, state)
                ],
              ),
            ),
          ),
          Visibility(
            //检索区域
            visible: _search,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(left: 32, right: 32, bottom: 30),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color.fromRGBO(245, 245, 245, 89),
                      width: 1.0,
                    ),
                  ),
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      // 检索条件小框
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 30, bottom: 30),
                        padding: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black12,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!.delivery_note_11,
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 122, 255, 1)),
                            ),
                            SizedBox(width: 10),
                            for (int i = 0; i < state.conditionList.length; i++)
                              buildCondition(i, true, state)
                          ],
                        ),
                      ),
                      // 检索条件主体内容
                      FractionallySizedBox(
                        //1、Email
                        widthFactor: 0.4,
                        child: Container(
                          height: 80,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .app_cceptance_user_email,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                  ),
                                ),
                              ),
                              WMSInputboxWidget(
                                text: state.searchInfo['user_email'].toString(),
                                inputBoxCallBack: (value) {
                                  context.read<ApplicationCceptanceBloc>().add(
                                      SetSearchValueEvent(
                                          'user_email', value, ''));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        //2、ユーザー名称
                        widthFactor: 0.4,
                        child: Container(
                          height: 80,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .app_cceptance_user_name,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                  ),
                                ),
                              ),
                              WMSInputboxWidget(
                                text: state.searchInfo['user_name'].toString(),
                                inputBoxCallBack: (value) {
                                  context.read<ApplicationCceptanceBloc>().add(
                                      SetSearchValueEvent(
                                          'user_name', value, ''));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        //3、電話番号
                        widthFactor: 0.4,
                        child: Container(
                          height: 80,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .app_cceptance_user_phone,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                  ),
                                ),
                              ),
                              WMSInputboxWidget(
                                numberIME: true,
                                text: state.searchInfo['user_phone'].toString(),
                                inputBoxCallBack: (value) {
                                  context.read<ApplicationCceptanceBloc>().add(
                                      SetSearchValueEvent(
                                          'user_phone', value, ''));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        //4、会社名名称
                        widthFactor: 0.4,
                        child: Container(
                          height: 80,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .app_cceptance_company_name,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                  ),
                                ),
                              ),
                              WMSInputboxWidget(
                                text:
                                    state.searchInfo['company_name'].toString(),
                                inputBoxCallBack: (value) {
                                  context.read<ApplicationCceptanceBloc>().add(
                                      SetSearchValueEvent(
                                          'company_name', value, ''));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      FractionallySizedBox(
                        //7、支払状態
                        widthFactor: 0.4,
                        child: Container(
                          height: 80,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .app_cceptance_pay_status,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                  ),
                                ),
                              ),
                              WMSDropdownWidget(
                                dataList1: state.payStatusList,
                                inputInitialValue: state
                                    .searchInfo['pay_status_name']
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
                                    context
                                        .read<ApplicationCceptanceBloc>()
                                        .add(SetSearchValueEvent(
                                            'pay_status', '', ''));
                                  } else {
                                    context
                                        .read<ApplicationCceptanceBloc>()
                                        .add(SetSearchValueEvent('pay_status',
                                            value['id'], value['name']));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        //8、申込状態
                        widthFactor: 0.4,
                        child: Container(
                          height: 80,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .app_cceptance_status,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                  ),
                                ),
                              ),
                              WMSDropdownWidget(
                                dataList1: state.applicationStatusList,
                                inputInitialValue: state
                                    .searchInfo['application_status_name']
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
                                    context
                                        .read<ApplicationCceptanceBloc>()
                                        .add(SetSearchValueEvent(
                                            'application_status', '', ''));
                                  } else {
                                    context
                                        .read<ApplicationCceptanceBloc>()
                                        .add(SetSearchValueEvent(
                                            'application_status',
                                            value['id'],
                                            value['name']));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BuildButtom(
                                  WMSLocalizations.i18n(context)!
                                      .delivery_note_24,
                                  0,
                                  state),
                              SizedBox(width: 32),
                              BuildButtom(
                                  WMSLocalizations.i18n(context)!
                                      .delivery_note_25,
                                  1,
                                  state),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // 删除检索窗口按钮
                Positioned(
                  top: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(-10, 10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _search = !_search;
                          if (state.conditionList.length > 0) {
                            _searchData = true;
                          } else {
                            _searchData = false;
                          }
                        });
                      },
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(44, 167, 176, 1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12, width: 0.5),
                        ),
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    });
  }

  // 底部检索和解除按钮
  Widget BuildButtom(String text, int number, ApplicationCceptanceModel state) {
    return Container(
      height: 48,
      width: 220,
      color: Colors.white,
      child: OutlinedButton(
        onPressed: () {
          if (number == 0) {
            //检索按钮
            //检索事件执行
            bool res = context
                .read<ApplicationCceptanceBloc>()
                .selectCceptanceEventBeforeCheck(context, state);
            if (res) {
              //检索事件执行
              context.read<ApplicationCceptanceBloc>().add(SeletAppEvent());
              //缩小检索框，显示检索条件
              if (state.searchInfo['user_email'] != '' ||
                  state.searchInfo['user_name'] != '' ||
                  state.searchInfo['user_phone'] != '' ||
                  state.searchInfo['company_name'] != '' ||
                  state.searchInfo['company_name_short'] != '' ||
                  state.searchInfo['use_type_id'] != null ||
                  state.searchInfo['pay_status'] != '' ||
                  state.searchInfo['application_status'] != '') {
                setState(() {
                  _searchData = true;
                  _search = false;
                });
              } else {
                setState(() {
                  _searchData = false;
                  _search = false;
                });
              }
            }
          } else {
            //解除检索条件
            context.read<ApplicationCceptanceBloc>().add(ClearSeletAppEvent());
          }
        },
        child: Text(
          text,
          style: TextStyle(
            color: Color.fromRGBO(44, 167, 176, 1),
          ),
        ),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.black),
          side: MaterialStateProperty.all(
            BorderSide(
              width: 1,
              // ignore: dead_code
              color: Color.fromRGBO(44, 167, 176, 1),
            ),
          ),
        ),
      ),
    );
  }

  // 检索条件内部数据
  Container buildCondition(
      int index, bool flg, ApplicationCceptanceModel state) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.black12,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getSearchName(state.conditionList[index]),
            style: TextStyle(color: Colors.black12),
          ),
          InkWell(
            onTap: () {
              context
                  .read<ApplicationCceptanceBloc>()
                  .add(DeleteSearchValueEvent(index));
            },
            child: Text(
              flg ? 'x' : '',
              style: TextStyle(color: Colors.black12),
            ),
          ),
        ],
      ),
    );
  }

  //取得检索条件名称
  String _getSearchName(dynamic condition) {
    String searchName = "";
    if (condition['key'] == null || condition['value'] == null) {
      return searchName;
    }
    if ('user_email' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.app_cceptance_user_email +
          "：" +
          condition['value'];
    } else if ('user_name' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.message_master_5 +
          "：" +
          condition['value'];
    } else if ('user_phone' == condition['key']) {
      searchName =
          WMSLocalizations.i18n(context)!.supplier_basic_telephone_number +
              "：" +
              condition['value'];
    } else if ('company_name' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.register_company_1 +
          "：" +
          condition['value'];
    } else if ('company_name_short' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.register_company_2 +
          "：" +
          condition['value'];
    } else if ('use_type_id' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.register_table_1 +
          "：" +
          condition['value'];
    } else if ('pay_status' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.account_license_payment +
          "：" +
          condition['value'];
    } else if ('application_status' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.app_cceptance_status +
          "：" +
          condition['value'];
    }
    return searchName;
  }
}
