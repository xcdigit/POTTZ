// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../redux/current_flag_reducer.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/instruction_input_bloc.dart';
import '../bloc/instruction_input_model.dart';

/**
 * 内容：出荷指示入力明细详细-sp
 * 作者：luxy
 * 时间：2023/11/01
 */

class InstructionInputDetails extends StatefulWidget {
  int shipId;
  int flag;
  InstructionInputDetails(
      {super.key, required this.shipId, required this.flag});

  @override
  State<InstructionInputDetails> createState() =>
      _InstructionInputDetailsState();
}

class _InstructionInputDetailsState extends State<InstructionInputDetails> {
  @override
  Widget build(BuildContext context) {
    //出荷指示明细数据取出
    Map<String, dynamic> detailsData =
        StoreProvider.of<WMSState>(context).state.currentParam;
    //是否刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;
    return BlocProvider<InstructionInputBloc>(
      create: (context) {
        return InstructionInputBloc(
          InstructionInputModel(
            rootContext: context,
            shipId: widget.shipId,
          ),
        );
      },
      child: BlocBuilder<InstructionInputBloc, InstructionInputModel>(
        builder: (context, state) {
          state.shipCustomize = detailsData;
          if (currentFlag) {
            if (detailsData.isNotEmpty) {
              bool tempBool = context
                  .read<InstructionInputBloc>()
                  .queryShipDetailEvent(detailsData['id']);
              if (tempBool) {
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentFlagAction(false));
              }
            }
          }
          return Material(
            color: Colors.white,
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: _showDetailContent(context, state),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: InstructionInputDetailsButton(
                      state: state, flag: widget.flag),
                ),
                //占位
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // 明细详情
  _showDetailContent(BuildContext context, InstructionInputModel state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 商品名
        _detailsTitle(
            WMSLocalizations.i18n(context)!.instruction_input_table_title_4,
            true),
        WMSDropdownWidget(
          dataList1: state.productList,
          inputInitialValue:
              state.shipDetailCustomize['product_name'].toString(),
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
              // 设定出荷指示明细集合事件
              context.read<InstructionInputBloc>().add(SetShipDetailMapEvent({
                    'product_id': value,
                    'product_code': value,
                    'product_name': value,
                    'product_size': value,
                    'product_image1': value,
                    'product_image2': value,
                    'product_company_note1': value,
                    'product_company_note2': value,
                    'product_notice_note1': value,
                    'product_notice_note2': value,
                  }));
            } else if (value is String) {
              // 设定出荷指示明细值事件
              context
                  .read<InstructionInputBloc>()
                  .add(SetShipDetailValueEvent('product_name', value));
            } else {
              // 设定出荷指示明细集合事件
              context.read<InstructionInputBloc>().add(SetShipDetailMapEvent({
                    'product_id': value['id'],
                    'product_code': value['code'],
                    'product_name': value['name'],
                    'product_size': value['size'],
                    'product_image1': value['image1'],
                    'product_image2': value['image2'],
                    'product_company_note1': value['company_note1'],
                    'product_company_note2': value['company_note2'],
                    'product_notice_note1': value['notice_note1'],
                    'product_notice_note2': value['notice_note2'],
                  }));
            }
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
        ),
        // 出荷指示数
        _detailsTitle(
            WMSLocalizations.i18n(context)!.instruction_input_form_detail_13,
            true),
        WMSInputboxWidget(
          text: state.shipDetailCustomize['ship_num'].toString(),
          inputBoxCallBack: (value) {
            // 设定出荷指示明细值事件
            context
                .read<InstructionInputBloc>()
                .add(SetShipDetailValueEvent('ship_num', value));
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
        ),
        // 単価
        _detailsTitle(
            WMSLocalizations.i18n(context)!.instruction_input_table_title_9,
            true),
        WMSInputboxWidget(
          text: state.shipDetailCustomize['product_price'].toString(),
          inputBoxCallBack: (value) {
            // 设定出荷指示明细值事件
            context
                .read<InstructionInputBloc>()
                .add(SetShipDetailValueEvent('product_price', value));
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
        ),
        // 商品コード
        _detailsTitle(
            WMSLocalizations.i18n(context)!.instruction_input_table_title_3,
            false),
        WMSInputboxWidget(
          text: state.shipDetailCustomize['product_code'].toString(),
          readOnly: true,
          inputBoxCallBack: (value) {
            // 设定出荷指示明细值事件
            context
                .read<InstructionInputBloc>()
                .add(SetShipDetailValueEvent('product_code', value));
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
        ),
        // 規格
        _detailsTitle(
            WMSLocalizations.i18n(context)!.instruction_input_table_title_5,
            false),
        WMSInputboxWidget(
          text: state.shipDetailCustomize['product_size'].toString(),
          readOnly: true,
          inputBoxCallBack: (value) {
            // 设定出荷指示明细值事件
            context
                .read<InstructionInputBloc>()
                .add(SetShipDetailValueEvent('product_size', value));
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
        ),
        // 得意先明細備考
        _detailsTitle(
            WMSLocalizations.i18n(context)!.instruction_input_form_detail_9,
            false),
        WMSInputboxWidget(
          height: 136,
          maxLines: 5,
          text: state.shipDetailCustomize['note1'].toString(),
          inputBoxCallBack: (value) {
            // 设定出荷指示明细值事件
            context
                .read<InstructionInputBloc>()
                .add(SetShipDetailValueEvent('note1', value));
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
        ),
        // 社内明細備考
        _detailsTitle(
            WMSLocalizations.i18n(context)!.instruction_input_form_detail_12,
            false),
        WMSInputboxWidget(
          height: 136,
          maxLines: 5,
          text: state.shipDetailCustomize['note2'].toString(),
          inputBoxCallBack: (value) {
            // 设定出荷指示明细值事件
            context
                .read<InstructionInputBloc>()
                .add(SetShipDetailValueEvent('note2', value));
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
        ),
        // 商品注意備考1
        _detailsTitle(
            WMSLocalizations.i18n(context)!.instruction_input_form_detail_19,
            false),
        WMSInputboxWidget(
          height: 136,
          maxLines: 5,
          text: state.shipDetailCustomize['product_notice_note1'].toString(),
          readOnly: true,
          inputBoxCallBack: (value) {
            // 设定出荷指示明细值事件
            context
                .read<InstructionInputBloc>()
                .add(SetShipDetailValueEvent('product_notice_note1', value));
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
        ),
        // 商品注意備考2
        _detailsTitle(
            WMSLocalizations.i18n(context)!.instruction_input_form_detail_20,
            false),
        WMSInputboxWidget(
          height: 136,
          maxLines: 5,
          text: state.shipDetailCustomize['product_notice_note2'].toString(),
          readOnly: true,
          inputBoxCallBack: (value) {
            // 设定出荷指示明细值事件
            context
                .read<InstructionInputBloc>()
                .add(SetShipDetailValueEvent('product_notice_note2', value));
          },
        ),
        // 商品写真1
        _detailsTitle(
            WMSLocalizations.i18n(context)!.instruction_input_form_detail_5,
            false),
        Visibility(
          visible: state.shipDetailCustomize['product_image1'] == null ||
              state.shipDetailCustomize['product_image1'] == '',
          child: Image.asset(
            WMSICons.NO_IMAGE,
            width: 136,
            height: 136,
          ),
        ),
        Visibility(
          visible: state.shipDetailCustomize['product_image1'] != null &&
              state.shipDetailCustomize['product_image1'] != '',
          child: Image.network(
            state.shipDetailCustomize['product_image1'].toString(),
            width: 136,
            height: 136,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
        ),
        // 商品写真2
        _detailsTitle(
            WMSLocalizations.i18n(context)!.instruction_input_form_detail_6,
            false),
        Visibility(
          visible: state.shipDetailCustomize['product_image2'] == null ||
              state.shipDetailCustomize['product_image2'] == '',
          child: Image.asset(
            WMSICons.NO_IMAGE,
            width: 136,
            height: 136,
          ),
        ),
        Visibility(
          visible: state.shipDetailCustomize['product_image2'] != null &&
              state.shipDetailCustomize['product_image2'] != '',
          child: Image.network(
            state.shipDetailCustomize['product_image2'].toString(),
            width: 136,
            height: 136,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
        ),
        // 商品社内備考1
        _detailsTitle(
            WMSLocalizations.i18n(context)!.instruction_input_form_detail_17,
            false),
        WMSInputboxWidget(
          height: 136,
          maxLines: 5,
          text: state.shipDetailCustomize['product_company_note1'].toString(),
          readOnly: true,
          inputBoxCallBack: (value) {
            // 设定出荷指示明细值事件
            context
                .read<InstructionInputBloc>()
                .add(SetShipDetailValueEvent('product_company_note1', value));
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
        ),
        // 商品社内備考2
        _detailsTitle(
            WMSLocalizations.i18n(context)!.instruction_input_form_detail_18,
            false),
        WMSInputboxWidget(
          height: 136,
          maxLines: 5,
          text: state.shipDetailCustomize['product_company_note2'].toString(),
          readOnly: true,
          inputBoxCallBack: (value) {
            // 设定出荷指示明细值事件
            context
                .read<InstructionInputBloc>()
                .add(SetShipDetailValueEvent('product_company_note2', value));
          },
        ),
      ],
    );
  }

  // 明细标题
  _detailsTitle(String title, bool required) {
    return Container(
      height: 24,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color.fromRGBO(6, 14, 15, 1),
            ),
          ),
          Visibility(
            visible: required,
            child: Text(
              "*",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color.fromRGBO(255, 0, 0, 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 出荷指示入力-表格按钮
class InstructionInputDetailsButton extends StatefulWidget {
  // 出荷指示入力-参数
  final InstructionInputModel state;
  final int flag;
  InstructionInputDetailsButton(
      {super.key, required this.state, required this.flag});

  @override
  State<InstructionInputDetailsButton> createState() =>
      _InstructionInputDetailsButtonState();
}

class _InstructionInputDetailsButtonState
    extends State<InstructionInputDetailsButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(buttonItemList, InstructionInputModel state) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        Container(
          height: 40,
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color.fromRGBO(44, 167, 176, 1),
              ),
              minimumSize: MaterialStatePropertyAll(
                Size(88, 40),
              ),
            ),
            onPressed: () {
              // 判断循环下标
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                //修正场合
                if (widget.flag != Config.NUMBER_ZERO &&
                    state.shipCustomize['ship_kbn'] != '0' &&
                    state.shipCustomize['ship_kbn'] != '1') {
                  WMSCommonBlocUtils.tipTextToast(
                      WMSLocalizations.i18n(state.rootContext)!
                          .display_instruction_tip4);
                } else {
                  // 保存出荷指示明细表单事件
                  context.read<InstructionInputBloc>().add(
                      SaveShipDetailFormEvent(
                          context, state.shipDetailCustomize));
                }
              } else {}
            },
            child: Text(
              buttonItemList[i]['title'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: buttonItemList[i]['index'] == Config.NUMBER_ZERO
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(44, 167, 176, 1),
                height: 1.28,
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
    InstructionInputModel state = widget.state;
    // 按钮单个列表
    List _buttonItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': widget.flag == Config.NUMBER_ZERO
            ? WMSLocalizations.i18n(context)!.instruction_input_tab_button_add
            : WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_update,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _initButtonList(_buttonItemList, state),
    );
  }
}
