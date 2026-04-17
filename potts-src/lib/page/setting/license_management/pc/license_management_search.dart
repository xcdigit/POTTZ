import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../widget/wms_date_widget.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/license_management_bloc.dart';
import '../bloc/license_management_model.dart';

/**
 * 内容：ライセンス管理-检索条件
 * 作者：王光顺
 * 时间：2023/12/05
 */
class LicenseManagementSearch extends StatefulWidget {
  const LicenseManagementSearch({super.key});

  @override
  State<LicenseManagementSearch> createState() =>
      _LicenseManagementSearchState();
}

class _LicenseManagementSearchState extends State<LicenseManagementSearch> {
  // 检索按钮追踪
  bool _search = false;
  bool _searchData = false;
  bool buttonHovered = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LicenseManagementBloc, LicenseManagementModel>(
      builder: (context, state) {
        return Column(
          children: [
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
              visible: _searchData && state.conditionList.length > 0,
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
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_11,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 122, 255, 1)),
                              ),
                              SizedBox(width: 10),
                              for (int i = 0;
                                  i < state.conditionList.length;
                                  i++)
                                buildCondition(i, true, state)
                            ],
                          ),
                        ),
                        // 检索条件主体内容
                        // ロール
                        FractionallySizedBox(
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
                                        .account_profile_roll,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSDropdownWidget(
                                  saveInput: true,
                                  inputInitialValue:
                                      state.searchInfo['role'] == null
                                          ? ''
                                          : state.searchInfo['role'].toString(),
                                  dropdownKey: 'name',
                                  dropdownTitle: 'name',
                                  dataList1: state.salesRoleInfoList,
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
                                      context.read<LicenseManagementBloc>().add(
                                          SetNowRoleDEvent(int.parse(
                                              value['id'].toString())));
                                      context.read<LicenseManagementBloc>().add(
                                          SetSearchValueEvent(
                                              'role', value['name']));
                                    } else {
                                      context
                                          .read<LicenseManagementBloc>()
                                          .add(SetSearchValueEvent('role', ''));
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        // ライセンスの種類
                        FractionallySizedBox(
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
                                        .account_license_type,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSInputboxWidget(
                                  text: state.searchInfo['type'].toString(),
                                  inputBoxCallBack: (value) {
                                    context.read<LicenseManagementBloc>().add(
                                        SetSearchValueEvent('type', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 開始日
                        FractionallySizedBox(
                          widthFactor: 0.4,
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
                                        .menu_content_4_10_3,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSDateWidget(
                                  text:
                                      state.searchInfo['start_date'].toString(),
                                  dateCallBack: (value) {
                                    // 设定值

                                    context.read<LicenseManagementBloc>().add(
                                        SetSearchValueEvent(
                                            'start_date', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 終了日
                        FractionallySizedBox(
                          widthFactor: 0.4,
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
                                        .menu_content_4_10_4,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSDateWidget(
                                  text: state.searchInfo['end_date'].toString(),
                                  dateCallBack: (value) {
                                    // 设定值

                                    context.read<LicenseManagementBloc>().add(
                                        SetSearchValueEvent('end_date', value));
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
                            border:
                                Border.all(color: Colors.black12, width: 0.5),
                          ),
                          child:
                              Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  // 底部检索和解除按钮
  Container BuildButtom(String text, int number, LicenseManagementModel state) {
    return Container(
      color: Colors.white,
      height: 48,
      width: 224,
      child: OutlinedButton(
        onPressed: () {
          if (number == 0) {
            //检索按钮
            //检索事件执行
            bool res = context
                .read<LicenseManagementBloc>()
                .selectMessageEventBeforeCheck(context, state);
            if (res) {
              //缩小检索框，显示检索条件
              if (state.searchInfo['role'] != '' ||
                  state.searchInfo['type'] != '' ||
                  state.searchInfo['start_date'] != '' ||
                  state.searchInfo['end_date'] != '') {
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
            context
                .read<LicenseManagementBloc>()
                .add(ClearSelectMessageEvent());
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
            const BorderSide(
              width: 1,
              color: Color.fromRGBO(44, 167, 176, 1),
            ),
          ),
        ),
      ),
    );
  }

  // 检索条件内部数据
  Container buildCondition(int index, bool flg, LicenseManagementModel state) {
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
                  .read<LicenseManagementBloc>()
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
    if ('role' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.account_profile_roll +
          "：" +
          condition['value'];
    } else if ('type' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.account_license_type +
          "：" +
          condition['value'];
    } else if ('start_date' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.menu_content_4_10_3 +
          "：" +
          condition['value'];
    } else if ('end_date' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.menu_content_4_10_4 +
          "：" +
          condition['value'];
    }
    return searchName;
  }
}
