import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/biz/store/outbound_adjust/bloc/outbound_adjust_bloc.dart';
import 'package:wms/page/biz/store/outbound_adjust/bloc/outbound_adjust_model.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/utils/check_utils.dart';

/**
 * 内容：在库调整入力 -搜索
 * 作者：cuihr
 * 时间：2023/08/28
 */
// 全局主键-下拉共通
GlobalKey<WMSDropdownWidgetState> _dropdownWidgetKey = new GlobalKey();

// 检索条件
List<String> conditionLabelList = [];
// 下拉框value值列表
List<String> conditionValueList = [];
bool flag = false;

class OutboundAdjustQuery extends StatefulWidget {
  // 检索按钮
  final ValueChanged<bool> onValueChanged;
  final ValueChanged<bool> onbottomChanged;
  final Function(List<String>) onBoxChanged;
  final Function(List<String>) onSearchLabel;
  final Function(List<String>) onSearchValue;
  const OutboundAdjustQuery(
      {super.key,
      required this.onValueChanged,
      required this.onbottomChanged,
      required this.onBoxChanged,
      required this.onSearchLabel,
      required this.onSearchValue});

  @override
  State<OutboundAdjustQuery> createState() => _OutboundAdjustQueryState();
}

class _OutboundAdjustQueryState extends State<OutboundAdjustQuery> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OutboundAdjustBloc, OutboundAdjustModel>(
        builder: (context, state) {
      return Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.only(left: 32, right: 32),
            decoration: BoxDecoration(
              color: Color.fromRGBO(245, 245, 245, 1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color.fromRGBO(245, 245, 245, 1),
                width: 1.0,
              ),
            ),
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                children: _initSearch(state),
              ),
            ),
          ),
          // 删除检索窗口按钮
          Positioned(
            top: 0,
            right: 0,
            child: Transform.translate(
              offset: Offset(-10, 20),
              child: InkWell(
                onTap: () {
                  setState(() {
                    flag = false;
                    widget.onValueChanged(flag);
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
      );
    });
  }

  // 初始化检索条件
  List<Widget> _initSearch(OutboundAdjustModel state) {
    return [
      //检索条件
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          height: 64,
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: Color.fromRGBO(224, 224, 224, 1), width: 1.0)),
          child: Row(
            children: [
              Text(
                WMSLocalizations.i18n(context)!.delivery_note_11,
                style: TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
              ),
              SizedBox(width: 10),
              Visibility(
                visible: state.data1 != '',
                child: buildCondition(
                    WMSLocalizations.i18n(context)!.outbound_adjust_query_id,
                    state.data1),
              ),
              Visibility(
                visible: state.data2 != '',
                child: buildCondition(
                    WMSLocalizations.i18n(context)!.outbound_adjust_query_name,
                    state.data2),
              ),
              Visibility(
                visible: state.location.id != null,
                child: buildCondition(
                    WMSLocalizations.i18n(context)!
                        .outbound_adjust_query_location,
                    state.location.loc_cd.toString()),
              ),
            ],
          ),
        ),
      ),
      //商品id
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText(
                  WMSLocalizations.i18n(context)!.outbound_adjust_query_id),
              WMSInputboxWidget(
                text: state.data1,
                inputBoxCallBack: (value) {
                  context
                      .read<OutboundAdjustBloc>()
                      .add(SetProductCodeEvent(value));
                },
              ),
            ],
          ),
        ),
      ),
      //商品名
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 16, 0, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText(
                  WMSLocalizations.i18n(context)!.outbound_adjust_query_name),
              WMSInputboxWidget(
                text: state.data2,
                inputBoxCallBack: (value) {
                  context
                      .read<OutboundAdjustBloc>()
                      .add(SetProductNameEvent(value));
                },
              ),
            ],
          ),
        ),
      ),
      //商品位置
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText(WMSLocalizations.i18n(context)!
                  .outbound_adjust_query_location),
              WMSDropdownWidget(
                dropdownTitle: 'loc_cd',
                inputInitialValue: state.location.loc_cd.toString(),
                dataList1: state.locationList,
                key: _dropdownWidgetKey,
                inputRadius: 4,
                inputSuffixIcon: Container(
                  width: 24,
                  height: 24,
                  margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                  ),
                ),
                inputBackgroundColor: Color.fromRGBO(255, 255, 255, 1),
                selectedCallBack: (value) {
                  if (value != '') {
                    context
                        .read<OutboundAdjustBloc>()
                        .add(SetAdjustInquiryEvent(
                          "id",
                          value['id'].toString(),
                        ));
                    context
                        .read<OutboundAdjustBloc>()
                        .add(SetAdjustInquiryEvent(
                          "loc_cd",
                          value['loc_cd'].toString(),
                        ));
                  } else {
                    context
                        .read<OutboundAdjustBloc>()
                        .add(SetAdjustInquiryEvent("loc_cd", ''));
                  }
                },
              ),
            ],
          ),
        ),
      ),
      // 底部检索和解除按钮
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.only(top: 50, bottom: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButtom(
                  WMSLocalizations.i18n(context)!.outbound_adjust_query_btn_1,
                  0),
              SizedBox(width: 32),
              buildButtom(
                  WMSLocalizations.i18n(context)!.outbound_adjust_query_btn_2,
                  1),
            ],
          ),
        ),
      ),
    ];
  }

  //检索条件内部数据
  BlocBuilder<OutboundAdjustBloc, OutboundAdjustModel> buildCondition(
      String queryLabel, String queryValue) {
    return BlocBuilder<OutboundAdjustBloc, OutboundAdjustModel>(
        builder: (bloc, state) {
      return Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.only(left: 10, right: 10),
        height: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: Colors.black12,
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  child: Text(
                    queryLabel + ':' + queryValue,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(156, 156, 156, 1),
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    setState(
                      () {
                        if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .outbound_adjust_query_id) {
                          context
                              .read<OutboundAdjustBloc>()
                              .add(SetProductCodeEvent(''));
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .outbound_adjust_query_name) {
                          context
                              .read<OutboundAdjustBloc>()
                              .add(SetProductNameEvent(''));
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .outbound_adjust_query_location) {
                          bloc
                              .read<OutboundAdjustBloc>()
                              .add(SetAdjustInquiryEvent("id", ''));
                          bloc
                              .read<OutboundAdjustBloc>()
                              .add(SetAdjustInquiryEvent("loc_cd", ''));
                        }
                      },
                    );
                  },
                  child: Icon(
                    Icons.close,
                    color: Color.fromRGBO(156, 156, 156, 1),
                    size: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  //输入框上方的文本
  buildText(String _text) {
    return Container(
      height: 24,
      child: Text(
        _text,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color.fromRGBO(6, 14, 15, 1),
        ),
      ),
    );
  }

  // 底部检索和解除按钮
  BlocBuilder<OutboundAdjustBloc, OutboundAdjustModel> buildButtom(
      String text, int number) {
    return BlocBuilder<OutboundAdjustBloc, OutboundAdjustModel>(
        builder: (bloc, state) {
      return StatefulBuilder(builder: (context, setState) {
        return MouseRegion(
          child: Container(
            color: Colors.white,
            height: 48,
            width: 220,
            child: OutlinedButton(
              onPressed: () {
                //检索按钮
                if (number == 0) {
                  if (state.data1 != '' &&
                      CheckUtils.check_Half_Alphanumeric_6_50(state.data1)) {
                    WMSCommonBlocUtils.tipTextToast(
                        WMSLocalizations.i18n(context)!
                                .outbound_adjust_query_id +
                            WMSLocalizations.i18n(context)!
                                .input_must_six_number_check);
                    return;
                  }
                  setState(() {
                    flag = false;
                  });
                } else {
                  // 检索条件 商品ID
                  context
                      .read<OutboundAdjustBloc>()
                      .add(SetProductCodeEvent(''));
                  // 检索条件 商品名
                  context
                      .read<OutboundAdjustBloc>()
                      .add(SetProductNameEvent(''));
                  // 检索条件 ロケーション
                  bloc
                      .read<OutboundAdjustBloc>()
                      .add(SetAdjustInquiryEvent("id", ''));
                  bloc
                      .read<OutboundAdjustBloc>()
                      .add(SetAdjustInquiryEvent("loc_cd", ''));
                  conditionLabelList.clear();
                  conditionValueList.clear();
                  flag = false;
                }
                // 检索条件label集合
                widget.onSearchLabel(conditionLabelList);
                // 检索条件value集合
                widget.onSearchValue(conditionValueList);
                widget.onValueChanged(flag);
              },
              child: Text(text,
                  style: TextStyle(color: Color.fromRGBO(44, 167, 176, 1))),
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
          ),
        );
      });
    });
  }
}
