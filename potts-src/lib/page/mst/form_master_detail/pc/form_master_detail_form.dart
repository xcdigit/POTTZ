import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/form_master_detail_bloc.dart';
import '../bloc/form_master_detail_model.dart';
import 'form_master_detail_title.dart';

/**
 * 内容：帳票マスタ明细-表单
 * 作者：赵士淞
 * 时间：2023/12/25
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前悬停下标
int currentHoverIndex = Config.NUMBER_NEGATIVE;
// 当前内容
Widget currentContent = Wrap();

// ignore: must_be_immutable
class FormMasterDetailForm extends StatefulWidget {
  // 账票ID
  int formId;

  FormMasterDetailForm({super.key, required this.formId});

  @override
  State<FormMasterDetailForm> createState() => _FormMasterDetailFormState();
}

class _FormMasterDetailFormState extends State<FormMasterDetailForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FormMasterDetailBloc>(
      create: (context) {
        return FormMasterDetailBloc(
          FormMasterDetailModel(rootContext: context, formId: widget.formId),
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
              FormMasterDetailTitle(),
              // 表单内容
              FormMasterDetailFormContent(
                formId: widget.formId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class FormMasterDetailFormContent extends StatefulWidget {
  // 账票ID
  int formId;

  FormMasterDetailFormContent({super.key, required this.formId});

  @override
  State<FormMasterDetailFormContent> createState() =>
      _FormMasterDetailFormContentState();
}

class _FormMasterDetailFormContentState
    extends State<FormMasterDetailFormContent> {
  // 初始化基本情報表单
  Widget _initFormBasic(FormMasterDetailModel state) {
    return BlocBuilder<FormMasterDetailBloc, FormMasterDetailModel>(
      builder: (context, state) {
        return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            // 位置
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
                        WMSLocalizations.i18n(context)!.form_location,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSDropdownWidget(
                      dataList1: state.locationList,
                      inputInitialValue:
                          state.formDetailCustomize['location_title'],
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
                      dropdownKey: 'index',
                      dropdownTitle: 'title',
                      selectedCallBack: (value) {
                        // 设定账票明细值事件
                        context.read<FormMasterDetailBloc>().add(
                            SetFormDetailValueEvent(
                                'location', value['index']));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 順序番号
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
                        WMSLocalizations.i18n(context)!.form_sequence_number,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formDetailCustomize['sequence_number']
                          .toString(),
                      inputBoxCallBack: (value) {
                        // 设定账票明细值事件
                        context.read<FormMasterDetailBloc>().add(
                            SetFormDetailValueEvent('sequence_number', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 分類
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
                        WMSLocalizations.i18n(context)!.form_assort,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSDropdownWidget(
                      dataList1: state.assortList,
                      inputInitialValue:
                          state.formDetailCustomize['assort_title'],
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
                      dropdownKey: 'index',
                      dropdownTitle: 'title',
                      selectedCallBack: (value) {
                        // 设定账票明细值事件
                        context.read<FormMasterDetailBloc>().add(
                            SetFormDetailValueEvent('assort', value['index']));
                      },
                    ),
                  ],
                ),
              ),
            ),
            //
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Container(),
            ),
            // コンテンツテーブル
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Visibility(
                visible: state.formDetailCustomize['assort'] ==
                        Config.NUMBER_ONE.toString() ||
                    state.formDetailCustomize['assort'] ==
                        Config.NUMBER_TWO.toString(),
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.content_table,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSDropdownWidget(
                        dataList1: state.tableList,
                        inputInitialValue:
                            state.formDetailCustomize['content_table_title'],
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
                        dropdownKey: 'index',
                        dropdownTitle: 'title',
                        selectedCallBack: (value) {
                          // 设定账票明细值事件
                          context.read<FormMasterDetailBloc>().add(
                              SetFormDetailValueEvent(
                                  'content_table', value['index']));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // コンテンツフィールド
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Visibility(
                visible: (state.formDetailCustomize['assort'] ==
                        Config.NUMBER_ONE.toString() ||
                    state.formDetailCustomize['assort'] ==
                        Config.NUMBER_TWO.toString()),
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.content_fields,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSDropdownWidget(
                        dataList1: state.contentFieldsList,
                        inputInitialValue:
                            state.formDetailCustomize['content_fields_title'],
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
                        dropdownKey: 'index',
                        dropdownTitle: 'title',
                        selectedCallBack: (value) {
                          // 设定账票明细值事件
                          context.read<FormMasterDetailBloc>().add(
                              SetFormDetailValueEvent(
                                  'content_fields', value['index']));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 計算表1
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Visibility(
                visible: state.formDetailCustomize['assort'] ==
                    Config.NUMBER_THREE.toString(),
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.calculation_table1,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSDropdownWidget(
                        dataList1: state.tableList,
                        inputInitialValue: state
                            .formDetailCustomize['calculation_table1_title'],
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
                        dropdownKey: 'index',
                        dropdownTitle: 'title',
                        selectedCallBack: (value) {
                          // 设定账票明细值事件
                          context.read<FormMasterDetailBloc>().add(
                              SetFormDetailValueEvent(
                                  'calculation_table1', value['index']));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 計算フィールド1
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Visibility(
                visible: state.formDetailCustomize['assort'] ==
                    Config.NUMBER_THREE.toString(),
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.calculation_fields1,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSDropdownWidget(
                        dataList1: state.calculationFields1List,
                        inputInitialValue: state
                            .formDetailCustomize['calculation_fields1_title'],
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
                        dropdownKey: 'index',
                        dropdownTitle: 'title',
                        selectedCallBack: (value) {
                          // 设定账票明细值事件
                          context.read<FormMasterDetailBloc>().add(
                              SetFormDetailValueEvent(
                                  'calculation_fields1', value['index']));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 計算表2
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Visibility(
                visible: state.formDetailCustomize['assort'] ==
                    Config.NUMBER_THREE.toString(),
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.calculation_table2,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSDropdownWidget(
                        dataList1: state.tableList,
                        inputInitialValue: state
                            .formDetailCustomize['calculation_table2_title'],
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
                        dropdownKey: 'index',
                        dropdownTitle: 'title',
                        selectedCallBack: (value) {
                          // 设定账票明细值事件
                          context.read<FormMasterDetailBloc>().add(
                              SetFormDetailValueEvent(
                                  'calculation_table2', value['index']));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 計算フィールド2
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Visibility(
                visible: state.formDetailCustomize['assort'] ==
                    Config.NUMBER_THREE.toString(),
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.calculation_fields2,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSDropdownWidget(
                        dataList1: state.calculationFields2List,
                        inputInitialValue: state
                            .formDetailCustomize['calculation_fields2_title'],
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
                        dropdownKey: 'index',
                        dropdownTitle: 'title',
                        selectedCallBack: (value) {
                          // 设定账票明细值事件
                          context.read<FormMasterDetailBloc>().add(
                              SetFormDetailValueEvent(
                                  'calculation_fields2', value['index']));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 計算モード
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Visibility(
                visible: state.formDetailCustomize['assort'] ==
                    Config.NUMBER_THREE.toString(),
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.calculation_mode,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSDropdownWidget(
                        dataList1: state.calculationModeList,
                        inputInitialValue:
                            state.formDetailCustomize['calculation_mode_title'],
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
                        dropdownKey: 'index',
                        dropdownTitle: 'title',
                        selectedCallBack: (value) {
                          // 设定账票明细值事件
                          context.read<FormMasterDetailBloc>().add(
                              SetFormDetailValueEvent(
                                  'calculation_mode', value['index']));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Container(),
            ),
            // フィールド名を表示
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Visibility(
                visible: state.formDetailCustomize['location'] ==
                        Config.NUMBER_ONE.toString() ||
                    state.formDetailCustomize['location'] ==
                        Config.NUMBER_TWO.toString(),
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.form_show_field_name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSDropdownWidget(
                        dataList1: state.showList,
                        inputInitialValue:
                            state.formDetailCustomize['show_field_name_title'],
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
                        dropdownKey: 'index',
                        dropdownTitle: 'title',
                        selectedCallBack: (value) {
                          // 设定账票明细值事件
                          context.read<FormMasterDetailBloc>().add(
                              SetFormDetailValueEvent(
                                  'show_field_name', value['index']));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // サイズ
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Visibility(
                visible: state.formDetailCustomize['location'] ==
                        Config.NUMBER_ONE.toString() ||
                    state.formDetailCustomize['location'] ==
                        Config.NUMBER_TWO.toString(),
                child: Container(
                  height: 72,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.form_word_size,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSInputboxWidget(
                        text: state.formDetailCustomize['word_size'].toString(),
                        inputBoxCallBack: (value) {
                          // 设定账票明细值事件
                          context
                              .read<FormMasterDetailBloc>()
                              .add(SetFormDetailValueEvent('word_size', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 接頭辞テキスト
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
                        WMSLocalizations.i18n(context)!.form_prefix_text,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formDetailCustomize['prefix_text'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定账票明细值事件
                        context
                            .read<FormMasterDetailBloc>()
                            .add(SetFormDetailValueEvent('prefix_text', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 接尾辞テキスト
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
                        WMSLocalizations.i18n(context)!.form_suffix_text,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formDetailCustomize['suffix_text'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定账票明细值事件
                        context
                            .read<FormMasterDetailBloc>()
                            .add(SetFormDetailValueEvent('suffix_text', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    return BlocBuilder<FormMasterDetailBloc, FormMasterDetailModel>(
      builder: (context, state) {
        // 判断参数状态
        if (StoreProvider.of<WMSState>(context).state.currentFlag) {
          // 判断新增还是修改
          if (data['id'] != null && data['id'] != '') {
            // 查询账票定制事件
            context
                .read<FormMasterDetailBloc>()
                .add(QueryFormDetailCustomizeEvent(data['id']));
          }
          // 控制刷新
          StoreProvider.of<WMSState>(context)
              .dispatch(RefreshCurrentFlagAction(false));
        }

        // 判断当前下标
        if (currentIndex == Config.NUMBER_ZERO) {
          // 当前内容
          currentContent = _initFormBasic(state);
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
                        child: FormMasterDetailFormTab(
                          initFormBasic: _initFormBasic,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: FormMasterDetailFormButton(),
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
                  child: currentContent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 帳票マスタ明细-表单Tab
typedef TabContextBuilder = Widget Function(FormMasterDetailModel state);

// ignore: must_be_immutable
class FormMasterDetailFormTab extends StatefulWidget {
  // 初始化基本情報表单
  TabContextBuilder initFormBasic;

  FormMasterDetailFormTab({
    super.key,
    required this.initFormBasic,
  });

  @override
  State<FormMasterDetailFormTab> createState() =>
      _FormMasterDetailFormTabState();
}

class _FormMasterDetailFormTabState extends State<FormMasterDetailFormTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, FormMasterDetailModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 判断当前下标
    if (currentIndex == Config.NUMBER_ZERO) {
      // 当前内容
      currentContent = widget.initFormBasic(state);
    } else {
      // 当前内容
      currentContent = Wrap();
    }
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        MouseRegion(
          onEnter: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              currentHoverIndex = tabItemList[i]['index'];
            });
          },
          onExit: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              currentHoverIndex = Config.NUMBER_NEGATIVE;
            });
          },
          child: GestureDetector(
            onPanDown: (details) {
              // 状态变更
              setState(() {
                // 当前下标
                currentIndex = tabItemList[i]['index'];
              });
            },
            child: Container(
              height: 46,
              padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              decoration: BoxDecoration(
                color: currentIndex == tabItemList[i]['index']
                    ? Color.fromRGBO(44, 167, 176, 1)
                    : currentHoverIndex == tabItemList[i]['index']
                        ? Color.fromRGBO(44, 167, 176, 0.6)
                        : Color.fromRGBO(245, 245, 245, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              constraints: BoxConstraints(
                minWidth: 160,
              ),
              child: Text(
                tabItemList[i]['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: currentIndex == tabItemList[i]['index']
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : currentHoverIndex == tabItemList[i]['index']
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
            ),
          ),
        ),
      );
    }
    // Tab列表
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

    return BlocBuilder<FormMasterDetailBloc, FormMasterDetailModel>(
      builder: (context, state) {
        return Row(
          children: _initTabList(_tabItemList, state),
        );
      },
    );
  }
}

// 帳票マスタ明细-表单按钮
class FormMasterDetailFormButton extends StatefulWidget {
  const FormMasterDetailFormButton({super.key});

  @override
  State<FormMasterDetailFormButton> createState() =>
      _FormMasterDetailFormButtonState();
}

class _FormMasterDetailFormButtonState
    extends State<FormMasterDetailFormButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        Container(
          height: 37,
          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color.fromRGBO(44, 167, 176, 1),
              ),
              minimumSize: MaterialStatePropertyAll(
                Size(80, 37),
              ),
            ),
            onPressed: () {
              // 判断循环下标
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                // 清除账票明细定制事件
                context
                    .read<FormMasterDetailBloc>()
                    .add(CleanFormDetailCustomizeEvent());
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 保存账票明细定制事件
                context
                    .read<FormMasterDetailBloc>()
                    .add(SaveFormDetailCustomizeEvent());
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
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_button_add,
      },
    ];

    return Row(
      children: _initButtonList(_buttonItemList),
    );
  }
}
