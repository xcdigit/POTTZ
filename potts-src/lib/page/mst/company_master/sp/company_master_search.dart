import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/company_master_bloc.dart';
import '../bloc/company_master_model.dart';

/**
 * 内容：会社情報マスタ管理-主页
 * 作者：王光顺
 * 时间：2023/09/05
 */
class CompanyMasterSearch extends StatefulWidget {
  const CompanyMasterSearch({super.key});

  @override
  State<CompanyMasterSearch> createState() => _CompanyMasterSearchState();
}

class _CompanyMasterSearchState extends State<CompanyMasterSearch> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyMasterBloc, CompanyMasterModel>(
      builder: (context, state) {
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 48,
                child: MouseRegion(
                  onEnter: (_) {
                    //
                    context
                        .read<CompanyMasterBloc>()
                        .add(SearchButtonHoveredChangeEvent(true));
                  },
                  onExit: (_) {
                    //
                    context
                        .read<CompanyMasterBloc>()
                        .add(SearchButtonHoveredChangeEvent(false));
                  },
                  child: OutlinedButton.icon(
                    onPressed: () {
                      //
                      context
                          .read<CompanyMasterBloc>()
                          .add(SearchOutlinedButtonPressedEvent());
                    },
                    icon: ColorFiltered(
                      colorFilter: state.searchFlag
                          ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                          : state.searchButtonHovered
                              ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                              : ColorFilter.mode(Color.fromRGBO(0, 122, 255, 1),
                                  BlendMode.srcIn),
                      child:
                          Image.asset(WMSICons.WAREHOUSE_MENU_ICON, height: 18),
                    ),
                    label: Text(
                      WMSLocalizations.i18n(context)!.delivery_note_1,
                      style: TextStyle(
                          color: state.searchFlag
                              ? Colors.white
                              : state.searchButtonHovered
                                  ? Colors.white
                                  : Color.fromRGBO(0, 122, 255, 1),
                          fontSize: 14),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: state.searchFlag
                          ? Color.fromRGBO(0, 122, 255, 1)
                          : state.searchButtonHovered
                              ? Color.fromRGBO(0, 122, 255, .6)
                              : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              //检索结果展示
              visible: state.searchDataFlag,
              child: Container(
                width: double.infinity,
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
                child: Wrap(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                        child: Text(
                          WMSLocalizations.i18n(context)!.delivery_note_11,
                          style:
                              TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                        ),
                      ),
                    ),
                    for (int i = 0; i < state.conditionList.length; i++)
                      buildCondition(i, false, state)
                  ],
                ),
              ),
            ),
            Visibility(
              //检索区域
              visible: state.searchFlag,
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
                          child: Wrap(
                            children: [
                              FractionallySizedBox(
                                widthFactor: 1,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                                  child: Text(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_11,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 122, 255, 1)),
                                  ),
                                ),
                              ),
                              for (int i = 0;
                                  i < state.conditionList.length;
                                  i++)
                                buildCondition(i, true, state)
                            ],
                          ),
                        ),
                        // 检索条件主体内容
                        FractionallySizedBox(
                          widthFactor: 1,
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
                                        .company_information_1,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSInputboxWidget(
                                  text: state.searchInfo['id'].toString(),
                                  inputBoxCallBack: (value) {
                                    // 设定会社ID
                                    context
                                        .read<CompanyMasterBloc>()
                                        .add(SetSearchValueEvent('id', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 1,
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
                                        .company_information_2,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSInputboxWidget(
                                  text: state.searchInfo['name'].toString(),
                                  inputBoxCallBack: (value) {
                                    // 设定会社名称
                                    context.read<CompanyMasterBloc>().add(
                                        SetSearchValueEvent('name', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 1,
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
                                        .company_information_3,
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
                                      state.searchInfo['name_short'].toString(),
                                  inputBoxCallBack: (value) {
                                    // 设定略称
                                    context.read<CompanyMasterBloc>().add(
                                        SetSearchValueEvent(
                                            'name_short', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                            height: 80,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 24,
                                  child: Text(
                                    WMSLocalizations.i18n(context)!
                                        .company_information_4,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSInputboxWidget(
                                  text: state.searchInfo['corporate_cd']
                                      .toString(),
                                  inputBoxCallBack: (value) {
                                    // 设定法人番号
                                    context.read<CompanyMasterBloc>().add(
                                        SetSearchValueEvent(
                                            'corporate_cd', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        //解除全部
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BuildButtom(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_25,
                                    1,
                                    state,
                                    1),
                              ],
                            ),
                          ),
                        ),
                        //检索按钮
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BuildButtom(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_24,
                                    0,
                                    state,
                                    0)
                              ],
                            ),
                          ),
                        ),
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
                          //
                          context
                              .read<CompanyMasterBloc>()
                              .add(SearchInkWellTapEvent());
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
  Container BuildButtom(
      String text, int number, CompanyMasterModel state, int differ) {
    return Container(
      color: Colors.white,
      height: 48,
      width: 224,
      child: OutlinedButton(
        onPressed: () async {
          if (number == 0) {
            //检索按钮
            //检索事件执行
            bool res = context
                .read<CompanyMasterBloc>()
                .selectCompanyEventBeforeCheck(context, state);
            if (res) {
              //缩小检索框，显示检索条件
              if (state.searchInfo['id'] != '' ||
                  state.searchInfo['name'] != '' ||
                  state.searchInfo['name_short'] != '' ||
                  state.searchInfo['corporate_cd'] != '') {
                //
                context
                    .read<CompanyMasterBloc>()
                    .add(SetSearchDataFlagAndSearchFlagEvent(true, false));
              } else {
                //
                context
                    .read<CompanyMasterBloc>()
                    .add(SetSearchDataFlagAndSearchFlagEvent(true, false));
              }
            }
          } else {
            //解除检索条件
            context.read<CompanyMasterBloc>().add(ClearSeletCompanyEvent());
          }
        },
        child: Text(
          text,
          style: TextStyle(
            color: differ == 1 ? Color.fromRGBO(44, 167, 176, 1) : Colors.white,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: differ == 1
              ? MaterialStateProperty.all(Colors.white)
              : MaterialStateProperty.all(Color.fromRGBO(44, 167, 176, 1)),
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
  Container buildCondition(int index, bool flg, CompanyMasterModel state) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, right: 10),
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.black12,
          width: 1.0,
        ),
      ),
      child: Wrap(
        children: [
          Text(
            _getSearchName(state.conditionList[index]),
            style: TextStyle(color: Colors.black12),
          ),
          SizedBox(width: 10),
          InkWell(
            onTap: () {
              context
                  .read<CompanyMasterBloc>()
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
    if ('id' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.company_information_1 +
          "：" +
          condition['value'];
    } else if ('name' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.company_information_2 +
          "：" +
          condition['value'];
    } else if ('name_short' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.company_information_3 +
          "：" +
          condition['value'];
    } else if ('corporate_cd' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.company_information_4 +
          "：" +
          condition['value'];
    }
    return searchName;
  }
}
