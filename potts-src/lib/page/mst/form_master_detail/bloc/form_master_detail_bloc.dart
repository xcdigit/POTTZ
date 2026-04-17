import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/common_utils.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../model/form_detail.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'form_master_detail_model.dart';

/**
 * 内容：帳票マスタ明细-BLOC
 * 作者：赵士淞
 * 时间：2023/12/25
 */
// 事件
abstract class FormMasterDetailEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends FormMasterDetailEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定账票明细值事件
class SetFormDetailValueEvent extends FormMasterDetailEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定账票明细值事件
  SetFormDetailValueEvent(this.key, this.value);
}

// 清除账票明细定制事件
class CleanFormDetailCustomizeEvent extends FormMasterDetailEvent {
  // 清除账票明细定制事件
  CleanFormDetailCustomizeEvent();
}

// 保存账票明细定制事件
class SaveFormDetailCustomizeEvent extends FormMasterDetailEvent {
  // 保存账票明细定制事件
  SaveFormDetailCustomizeEvent();
}

// 查询账票明细定制事件
class QueryFormDetailCustomizeEvent extends FormMasterDetailEvent {
  // 账票定制ID
  int formDetailCustomizeId;
  // 查询账票明细定制事件
  QueryFormDetailCustomizeEvent(this.formDetailCustomizeId);
}

// 删除账票明细定制事件
class DeleteFormDetailCustomizeEvent extends FormMasterDetailEvent {
  // 账票明细定制ID
  int formDetailCustomizeId;
  // 删除账票明细定制事件
  DeleteFormDetailCustomizeEvent(this.formDetailCustomizeId);
}
// 自定义事件 - 终

class FormMasterDetailBloc extends WmsTableBloc<FormMasterDetailModel> {
  // 刷新补丁
  @override
  FormMasterDetailModel clone(FormMasterDetailModel src) {
    return FormMasterDetailModel.clone(src);
  }

  FormMasterDetailBloc(FormMasterDetailModel state) : super(state) {
    // 查询分页数据事件
    on<PageQueryEvent>((event, emit) async {
      // 判断加载标记
      if (state.loadingFlag) {
        // 打开加载状态
        BotToast.showLoading();
      } else {
        // 页数
        state.pageNum = 0;
        // 加载标记
        state.loadingFlag = true;
      }

      // 查询账票管理明细
      List<dynamic> data1 = await SupabaseUtils.getClient()
          .from('mtb_form_detail')
          .select('*')
          .eq('form_id', state.formId)
          .order('location', ascending: true)
          .order('sequence_number', ascending: true)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      // 循环账票数据
      for (int i = 0; i < data1.length; i++) {
        // 数据详情
        dynamic dataItem = data1[i];

        // 表格列表
        List<Map<String, dynamic>> tableList = [];

        // 判断位置
        if (dataItem['location'] != null && dataItem['location'] != '') {
          // 循环位置列表
          for (int i = 0; i < state.locationList.length; i++) {
            // 位置临时
            Map<String, dynamic> locationTemp = state.locationList[i];
            // 判断值
            if (locationTemp['index'] == dataItem['location']) {
              // 位置文本
              dataItem['location_title'] = locationTemp['title'];
            }
          }
          // 表格列表
          tableList = getTableList(
              state.formCustomize['form_kbn'], dataItem['location']);
        }
        // 判断分类
        if (dataItem['assort'] != null && dataItem['assort'] != '') {
          // 循环分类列表
          for (int i = 0; i < state.assortList.length; i++) {
            // 分类临时
            Map<String, dynamic> assortTemp = state.assortList[i];
            // 判断值
            if (assortTemp['index'] == dataItem['assort']) {
              // 分类文本
              dataItem['assort_title'] = assortTemp['title'];
            }
          }
        }
        // 判断フィールド名を表示
        if (dataItem['show_field_name'] != null &&
            dataItem['show_field_name'] != '') {
          // 循环显示列表
          for (int i = 0; i < state.showList.length; i++) {
            // 显示临时
            Map<String, dynamic> showTemp = state.showList[i];
            // 判断值
            if (showTemp['index'] == dataItem['show_field_name']) {
              // フィールド名を表示文本
              dataItem['show_field_name_title'] = showTemp['title'];
            }
          }
        }

        // コンテンツテーブル文本
        String contentTableText = '';
        // 判断コンテンツテーブル
        if (dataItem['content_table'] != null &&
            dataItem['content_table'] != '') {
          // 循环表格列表
          for (int i = 0; i < tableList.length; i++) {
            // 表格临时
            Map<String, dynamic> tableTemp = tableList[i];
            // 判断值
            if (tableTemp['index'] == dataItem['content_table']) {
              // コンテンツテーブル文本
              contentTableText = tableTemp['title'];
            }
          }
        }
        // コンテンツフィールド文本
        String contentFieldsText = '';
        // 判断コンテンツフィールド
        if (dataItem['content_fields'] != null &&
            dataItem['content_fields'] != '' &&
            dataItem['content_table'] != null &&
            dataItem['content_table'] != '') {
          // 字段列表
          List<Map<String, dynamic>> fieldsList = getContentFieldsList(
              state.formCustomize['form_kbn'], dataItem['content_table']);
          // 循环字段列表
          for (int i = 0; i < fieldsList.length; i++) {
            // 字段临时
            Map<String, dynamic> fieldsTemp = fieldsList[i];
            // 判断值
            if (fieldsTemp['index'] == dataItem['content_fields']) {
              // コンテンツフィールド文本
              contentFieldsText = fieldsTemp['title'];
            }
          }
        }
        // 計算表1文本
        String calculationTable1Text = '';
        // 判断計算表1
        if (dataItem['calculation_table1'] != null &&
            dataItem['calculation_table1'] != '') {
          // 循环表格列表
          for (int i = 0; i < tableList.length; i++) {
            // 表格临时
            Map<String, dynamic> tableTemp = tableList[i];
            // 判断值
            if (tableTemp['index'] == dataItem['calculation_table1']) {
              // 計算表1文本
              calculationTable1Text = tableTemp['title'];
            }
          }
        }
        // 計算フィールド1文本
        String calculationFields1Text = '';
        // 判断計算フィールド1
        if (dataItem['calculation_fields1'] != null &&
            dataItem['calculation_fields1'] != '' &&
            dataItem['calculation_table1'] != null &&
            dataItem['calculation_table1'] != '') {
          // 字段列表
          List<Map<String, dynamic>> fieldsList = getContentFieldsList(
              state.formCustomize['form_kbn'], dataItem['calculation_table1']);
          // 循环字段列表
          for (int i = 0; i < fieldsList.length; i++) {
            // 字段临时
            Map<String, dynamic> fieldsTemp = fieldsList[i];
            // 判断值
            if (fieldsTemp['index'] == dataItem['calculation_fields1']) {
              // 計算フィールド1文本
              calculationFields1Text = fieldsTemp['title'];
            }
          }
        }
        // 計算表2文本
        String calculationTable2Text = '';
        // 判断計算表2
        if (dataItem['calculation_table2'] != null &&
            dataItem['calculation_table2'] != '') {
          // 循环表格列表
          for (int i = 0; i < tableList.length; i++) {
            // 表格临时
            Map<String, dynamic> tableTemp = tableList[i];
            // 判断值
            if (tableTemp['index'] == dataItem['calculation_table2']) {
              // 計算表2文本
              calculationTable2Text = tableTemp['title'];
            }
          }
        }
        // 計算フィールド2文本
        String calculationFields2Text = '';
        // 判断計算フィールド2
        if (dataItem['calculation_fields2'] != null &&
            dataItem['calculation_fields2'] != '' &&
            dataItem['calculation_table2'] != null &&
            dataItem['calculation_table2'] != '') {
          // 字段列表
          List<Map<String, dynamic>> fieldsList = getContentFieldsList(
              state.formCustomize['form_kbn'], dataItem['calculation_table2']);
          // 循环字段列表
          for (int i = 0; i < fieldsList.length; i++) {
            // 字段临时
            Map<String, dynamic> fieldsTemp = fieldsList[i];
            // 判断值
            if (fieldsTemp['index'] == dataItem['calculation_fields2']) {
              // 計算フィールド2文本
              calculationFields2Text = fieldsTemp['title'];
            }
          }
        }
        // 接頭辞テキスト
        String prefixText =
            dataItem['prefix_text'] != null && dataItem['prefix_text'] != ''
                ? dataItem['prefix_text']
                : '';
        // 接尾辞テキスト
        String suffixText =
            dataItem['suffix_text'] != null && dataItem['suffix_text'] != ''
                ? dataItem['suffix_text']
                : '';
        // 計算モード
        String calculationMode = dataItem['calculation_mode'] != null &&
                dataItem['calculation_mode'] != ''
            ? dataItem['calculation_mode'] == Config.NUMBER_ONE.toString()
                ? '+'
                : dataItem['calculation_mode'] == Config.NUMBER_TWO.toString()
                    ? '-'
                    : dataItem['calculation_mode'] ==
                            Config.NUMBER_THREE.toString()
                        ? '×'
                        : dataItem['calculation_mode'] ==
                                Config.NUMBER_FOUR.toString()
                            ? '÷'
                            : ''
            : '';

        // 公示
        String formFormula = '';
        // 判断分类
        if (dataItem['assort'] == Config.NUMBER_ONE.toString() ||
            dataItem['assort'] == Config.NUMBER_TWO.toString()) {
          // 判断接頭辞テキスト和接尾辞テキスト
          if (prefixText != '' || suffixText != '') {
            // 公示
            formFormula = '=' +
                prefixText +
                '(:' +
                contentTableText +
                '[' +
                contentFieldsText +
                '])' +
                suffixText;
          } else {
            // 公示
            formFormula =
                '=' + contentTableText + '[' + contentFieldsText + ']';
          }
        } else if (dataItem['assort'] == Config.NUMBER_THREE.toString()) {
          // 判断接頭辞テキスト和接尾辞テキスト
          if (prefixText != '' || suffixText != '') {
            // 公示
            formFormula = '=' +
                prefixText +
                '(:' +
                calculationTable1Text +
                '[' +
                calculationFields1Text +
                '] ' +
                calculationMode +
                ' :' +
                calculationTable2Text +
                '[' +
                calculationFields2Text +
                '])' +
                suffixText;
          } else {
            // 公示
            formFormula = '=' +
                ':' +
                calculationTable1Text +
                '[' +
                calculationFields1Text +
                '] ' +
                calculationMode +
                ' :' +
                calculationTable2Text +
                '[' +
                calculationFields2Text +
                ']';
          }
        }
        // 公示文本
        dataItem['form_formula'] = formFormula;

        // 列表数据增加
        state.records.add(WmsRecordModel(i, dataItem));
      }

      // 查询账票管理明细
      List<dynamic> data2 = await SupabaseUtils.getClient()
          .from('mtb_form_detail')
          .select('*')
          .eq('form_id', state.formId);
      // 总页数
      state.total = data2.length;

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 自定义事件 - 始
      // 查询账票管理
      List<dynamic> data = await SupabaseUtils.getClient()
          .from('mtb_form')
          .select('*')
          .eq('id', state.formId);
      // 判断账票管理数量
      if (data.length > 0) {
        // 账票-定制
        state.formCustomize = data[0];
      }

      // 位置列表
      state.locationList = getLocationList(state.formCustomize['form_kbn']);
      // 分类列表
      state.assortList = [
        {
          'index': Config.NUMBER_ONE.toString(),
          'title': WMSLocalizations.i18n(state.rootContext)!.form_assort_text,
        },
        {
          'index': Config.NUMBER_TWO.toString(),
          'title':
              WMSLocalizations.i18n(state.rootContext)!.form_assort_bar_code,
        },
        {
          'index': Config.NUMBER_THREE.toString(),
          'title': WMSLocalizations.i18n(state.rootContext)!
              .form_assort_calculation_text,
        },
      ];
      // 计算模式列表
      state.calculationModeList = [
        {
          'index': Config.NUMBER_ONE.toString(),
          'title': WMSLocalizations.i18n(state.rootContext)!
              .form_mode_calculation_addition,
        },
        {
          'index': Config.NUMBER_TWO.toString(),
          'title': WMSLocalizations.i18n(state.rootContext)!
              .form_mode_calculation_subtraction,
        },
        {
          'index': Config.NUMBER_THREE.toString(),
          'title': WMSLocalizations.i18n(state.rootContext)!
              .form_mode_calculation_multiplication,
        },
        {
          'index': Config.NUMBER_FOUR.toString(),
          'title': WMSLocalizations.i18n(state.rootContext)!
              .form_mode_calculation_division,
        },
      ];
      // 显示列表
      state.showList = [
        {
          'index': Config.NUMBER_ONE.toString(),
          'title': WMSLocalizations.i18n(state.rootContext)!.form_show_true,
        },
        {
          'index': Config.NUMBER_TWO.toString(),
          'title': WMSLocalizations.i18n(state.rootContext)!.form_show_false,
        },
      ];
      // 自定义事件 - 终

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 自定义事件 - 始
    // 设定账票明细值事件
    on<SetFormDetailValueEvent>((event, emit) async {
      // 账票明细-临时
      Map<String, dynamic> formDetailTemp = Map<String, dynamic>();
      formDetailTemp.addAll(state.formDetailCustomize);
      // 判断key
      if (formDetailTemp[event.key] != null) {
        // 账票明细-临时
        formDetailTemp[event.key] = event.value;
      } else {
        // 账票明细-临时
        formDetailTemp.addAll({event.key: event.value});
      }
      // 账票明细-定制
      state.formDetailCustomize = formDetailTemp;

      // 判断key
      if (event.key == 'location') {
        // 循环位置列表
        for (int i = 0; i < state.locationList.length; i++) {
          // 位置临时
          Map<String, dynamic> locationTemp = state.locationList[i];
          // 判断值
          if (locationTemp['index'] == event.value) {
            // 位置文本
            state.formDetailCustomize['location_title'] = locationTemp['title'];

            // 表列表
            state.tableList =
                getTableList(state.formCustomize['form_kbn'], event.value);

            // 内容表
            state.formDetailCustomize['content_table'] = '';
            // 内容表标题
            state.formDetailCustomize['content_table_title'] = '';
            // 内容字段
            state.formDetailCustomize['content_fields'] = '';
            // 内容字段标题
            state.formDetailCustomize['content_fields_title'] = '';
            // 计算表1
            state.formDetailCustomize['calculation_table1'] = '';
            // 计算表1标题
            state.formDetailCustomize['calculation_table1_title'] = '';
            // 计算字段1
            state.formDetailCustomize['calculation_fields1'] = '';
            // 计算字段1标题
            state.formDetailCustomize['calculation_fields1_title'] = '';
            // 计算表2
            state.formDetailCustomize['calculation_table2'] = '';
            // 计算表2标题
            state.formDetailCustomize['calculation_table2_title'] = '';
            // 计算字段2
            state.formDetailCustomize['calculation_fields2'] = '';
            // 计算字段2标题
            state.formDetailCustomize['calculation_fields2_title'] = '';
            // 计算模式
            state.formDetailCustomize['calculation_mode'] = '';
            // 计算模式标题
            state.formDetailCustomize['calculation_mode_title'] = '';
            // 显示字段名称
            state.formDetailCustomize['show_field_name'] = '';
            // 显示字段名称
            state.formDetailCustomize['show_field_name_title'] = '';
            // 字号
            state.formDetailCustomize['word_size'] = '';
          }
        }
      } else if (event.key == 'assort') {
        // 循环分类列表
        for (int i = 0; i < state.assortList.length; i++) {
          // 分类临时
          Map<String, dynamic> assortTemp = state.assortList[i];
          // 判断值
          if (assortTemp['index'] == event.value) {
            // 分类文本
            state.formDetailCustomize['assort_title'] = assortTemp['title'];

            // 内容表
            state.formDetailCustomize['content_table'] = '';
            // 内容表标题
            state.formDetailCustomize['content_table_title'] = '';
            // 内容字段
            state.formDetailCustomize['content_fields'] = '';
            // 内容字段标题
            state.formDetailCustomize['content_fields_title'] = '';
            // 计算表1
            state.formDetailCustomize['calculation_table1'] = '';
            // 计算表1标题
            state.formDetailCustomize['calculation_table1_title'] = '';
            // 计算字段1
            state.formDetailCustomize['calculation_fields1'] = '';
            // 计算字段1标题
            state.formDetailCustomize['calculation_fields1_title'] = '';
            // 计算表2
            state.formDetailCustomize['calculation_table2'] = '';
            // 计算表2标题
            state.formDetailCustomize['calculation_table2_title'] = '';
            // 计算字段2
            state.formDetailCustomize['calculation_fields2'] = '';
            // 计算字段2标题
            state.formDetailCustomize['calculation_fields2_title'] = '';
            // 计算模式
            state.formDetailCustomize['calculation_mode'] = '';
            // 计算模式标题
            state.formDetailCustomize['calculation_mode_title'] = '';
            // 显示字段名称
            state.formDetailCustomize['show_field_name'] = '';
            // 显示字段名称
            state.formDetailCustomize['show_field_name_title'] = '';
            // 字号
            state.formDetailCustomize['word_size'] = '';
          }
        }
      } else if (event.key == 'content_table') {
        // 循环表列表
        for (int i = 0; i < state.tableList.length; i++) {
          // 表临时
          Map<String, dynamic> tableTemp = state.tableList[i];
          // 判断值
          if (tableTemp['index'] == event.value) {
            // 表文本
            state.formDetailCustomize['content_table_title'] =
                tableTemp['title'];

            // 内容字段列表
            state.contentFieldsList = getContentFieldsList(
                state.formCustomize['form_kbn'], event.value);
            // 内容字段
            state.formDetailCustomize['content_fields'] = '';
            // 内容字段标题
            state.formDetailCustomize['content_fields_title'] = '';
          }
        }
      } else if (event.key == 'content_fields') {
        // 循环内容字段列表
        for (int i = 0; i < state.contentFieldsList.length; i++) {
          // 内容字段临时
          Map<String, dynamic> contentFieldsTemp = state.contentFieldsList[i];
          // 判断值
          if (contentFieldsTemp['index'] == event.value) {
            // 内容字段文本
            state.formDetailCustomize['content_fields_title'] =
                contentFieldsTemp['title'];
          }
        }
      } else if (event.key == 'calculation_table1') {
        // 循环表列表
        for (int i = 0; i < state.tableList.length; i++) {
          // 表临时
          Map<String, dynamic> tableTemp = state.tableList[i];
          // 判断值
          if (tableTemp['index'] == event.value) {
            // 表文本
            state.formDetailCustomize['calculation_table1_title'] =
                tableTemp['title'];

            // 计算字段1列表
            state.calculationFields1List = getContentFieldsList(
                state.formCustomize['form_kbn'], event.value);
            // 计算字段1
            state.formDetailCustomize['calculation_fields1'] = '';
            // 计算字段1标题
            state.formDetailCustomize['calculation_fields1_title'] = '';
          }
        }
      } else if (event.key == 'calculation_fields1') {
        // 循环计算字段1列表
        for (int i = 0; i < state.calculationFields1List.length; i++) {
          // 计算字段1临时
          Map<String, dynamic> calculationFields1Temp =
              state.calculationFields1List[i];
          // 判断值
          if (calculationFields1Temp['index'] == event.value) {
            // 计算字段1文本
            state.formDetailCustomize['calculation_fields1_title'] =
                calculationFields1Temp['title'];
          }
        }
      } else if (event.key == 'calculation_table2') {
        // 循环表列表
        for (int i = 0; i < state.tableList.length; i++) {
          // 表临时
          Map<String, dynamic> tableTemp = state.tableList[i];
          // 判断值
          if (tableTemp['index'] == event.value) {
            // 表文本
            state.formDetailCustomize['calculation_table2_title'] =
                tableTemp['title'];

            // 计算字段2列表
            state.calculationFields2List = getContentFieldsList(
                state.formCustomize['form_kbn'], event.value);
            // 计算字段2
            state.formDetailCustomize['calculation_fields2'] = '';
            // 计算字段2标题
            state.formDetailCustomize['calculation_fields2_title'] = '';
          }
        }
      } else if (event.key == 'calculation_fields2') {
        // 循环计算字段2列表
        for (int i = 0; i < state.calculationFields2List.length; i++) {
          // 计算字段2临时
          Map<String, dynamic> calculationFields2Temp =
              state.calculationFields2List[i];
          // 判断值
          if (calculationFields2Temp['index'] == event.value) {
            // 计算字段2文本
            state.formDetailCustomize['calculation_fields2_title'] =
                calculationFields2Temp['title'];
          }
        }
      } else if (event.key == 'calculation_mode') {
        // 循环计算模式列表
        for (int i = 0; i < state.calculationModeList.length; i++) {
          // 计算模式临时
          Map<String, dynamic> calculationModeTemp =
              state.calculationModeList[i];
          // 判断值
          if (calculationModeTemp['index'] == event.value) {
            // 计算模式文本
            state.formDetailCustomize['calculation_mode_title'] =
                calculationModeTemp['title'];
          }
        }
      } else if (event.key == 'show_field_name') {
        // 循环显示列表
        for (int i = 0; i < state.showList.length; i++) {
          // 显示临时
          Map<String, dynamic> showTemp = state.showList[i];
          // 判断值
          if (showTemp['index'] == event.value) {
            // 计算模式文本
            state.formDetailCustomize['show_field_name_title'] =
                showTemp['title'];
          }
        }
      }

      // 更新
      emit(clone(state));
    });

    // 清除账票明细定制事件
    on<CleanFormDetailCustomizeEvent>((event, emit) async {
      // 账票明细-定制
      state.formDetailCustomize = {
        'id': '',
        'location': '',
        'location_title': '',
        'sequence_number': '',
        'assort': '',
        'assort_title': '',
        'content_table': '',
        'content_table_title': '',
        'content_fields': '',
        'content_fields_title': '',
        'calculation_table1': '',
        'calculation_table1_title': '',
        'calculation_fields1': '',
        'calculation_fields1_title': '',
        'calculation_table2': '',
        'calculation_table2_title': '',
        'calculation_fields2': '',
        'calculation_fields2_title': '',
        'calculation_mode': '',
        'calculation_mode_title': '',
        'show_field_name': '',
        'show_field_name_title': '',
        'word_size': '',
        'prefix_text': '',
        'suffix_text': '',
      };

      // 更新
      emit(clone(state));
    });

    // 保存账票明细定制事件
    on<SaveFormDetailCustomizeEvent>((event, emit) async {
      // 保存账票明细定制验证
      Map<String, dynamic> formDetailStructure =
          saveFormDetailCustomizeCheck(state.formDetailCustomize);
      // 判断验证结果
      if (formDetailStructure.length == 0) {
        return;
      }

      // 打开加载状态
      BotToast.showLoading();

      // 账票明细数据
      List<Map<String, dynamic>> formDetailData;
      // 账票明细
      FormDetail formDetail = FormDetail.fromJson(formDetailStructure);

      // 判断账票明细ID
      if (formDetail.id == null) {
        // 创建账票明细定制处理
        formDetail = await createFormDetailCustomizeHandle(formDetail);
        // 判断处理结果
        if (formDetail.create_id == null || formDetail.create_id == '') {
          return;
        }

        try {
          // 新增账票明细
          formDetailData = await SupabaseUtils.getClient()
              .from('mtb_form_detail')
              .insert([formDetail.toJson()]).select('*');
          // 判断账票明细数据
          if (formDetailData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(state.rootContext)!.form_detail_title +
                    WMSLocalizations.i18n(state.rootContext)!.create_success);

            // 账票明细-定制
            state.formDetailCustomize = {
              'id': '',
              'location': '',
              'location_title': '',
              'sequence_number': '',
              'assort': '',
              'assort_title': '',
              'content_table': '',
              'content_table_title': '',
              'content_fields': '',
              'content_fields_title': '',
              'calculation_table1': '',
              'calculation_table1_title': '',
              'calculation_fields1': '',
              'calculation_fields1_title': '',
              'calculation_table2': '',
              'calculation_table2_title': '',
              'calculation_fields2': '',
              'calculation_fields2_title': '',
              'calculation_mode': '',
              'calculation_mode_title': '',
              'show_field_name': '',
              'show_field_name_title': '',
              'word_size': '',
              'prefix_text': '',
              'suffix_text': '',
            };

            // 插入操作履历
            CommonUtils().createLogInfo(
                '帳票マスタ明细（ID：' +
                    formDetail.id.toString() +
                    '）' +
                    Config.OPERATION_TEXT1 +
                    Config.OPERATION_BUTTON_TEXT1 +
                    Config.OPERATION_TEXT2,
                "SaveFormDetailCustomizeEvent()",
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser!
                    .company_id,
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser!
                    .id);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!.form_detail_title +
                    WMSLocalizations.i18n(state.rootContext)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.form_detail_title +
                  WMSLocalizations.i18n(state.rootContext)!.create_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else {
        // 更新账票明细定制处理
        formDetail = updateFormDetailCustomizeHandle(formDetail);
        // 判断处理结果
        if (formDetail.update_id == null || formDetail.update_id == '') {
          return;
        }

        try {
          // 修改账票明细
          formDetailData = await SupabaseUtils.getClient()
              .from('mtb_form_detail')
              .update(formDetail.toJson())
              .eq('id', formDetail.id)
              .select('*');
          // 判断账票明细数据
          if (formDetailData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(state.rootContext)!.form_detail_title +
                    WMSLocalizations.i18n(state.rootContext)!.update_success);

            // 账票明细-定制
            state.formDetailCustomize = {
              'id': '',
              'location': '',
              'location_title': '',
              'sequence_number': '',
              'assort': '',
              'assort_title': '',
              'content_table': '',
              'content_table_title': '',
              'content_fields': '',
              'content_fields_title': '',
              'calculation_table1': '',
              'calculation_table1_title': '',
              'calculation_fields1': '',
              'calculation_fields1_title': '',
              'calculation_table2': '',
              'calculation_table2_title': '',
              'calculation_fields2': '',
              'calculation_fields2_title': '',
              'calculation_mode': '',
              'calculation_mode_title': '',
              'show_field_name': '',
              'show_field_name_title': '',
              'word_size': '',
              'prefix_text': '',
              'suffix_text': '',
            };

            // 插入操作履历
            CommonUtils().createLogInfo(
                '帳票マスタ明细（ID：' +
                    formDetail.id.toString() +
                    '）' +
                    Config.OPERATION_TEXT1 +
                    Config.OPERATION_BUTTON_TEXT1 +
                    Config.OPERATION_TEXT2,
                "SaveFormDetailCustomizeEvent()",
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser!
                    .company_id,
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser!
                    .id);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!.form_detail_title +
                    WMSLocalizations.i18n(state.rootContext)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.form_detail_title +
                  WMSLocalizations.i18n(state.rootContext)!.update_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      }

      // 返回上一页
      GoRouter.of(state.rootContext).pop('refresh return');

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 查询账票明细定制事件
    on<QueryFormDetailCustomizeEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询账票明细管理
      List<dynamic> data = await SupabaseUtils.getClient()
          .from('mtb_form_detail')
          .select('*')
          .eq('id', event.formDetailCustomizeId);
      // 判断账票数量
      if (data.length != 0) {
        // 账票明细-定制
        state.formDetailCustomize = data[0];
        // 判断位置
        if (state.formDetailCustomize['location'] != null &&
            state.formDetailCustomize['location'] != '') {
          // 循环位置列表
          for (int i = 0; i < state.locationList.length; i++) {
            // 位置临时
            Map<String, dynamic> locationTemp = state.locationList[i];
            // 判断值
            if (locationTemp['index'] ==
                state.formDetailCustomize['location']) {
              // 位置文本
              state.formDetailCustomize['location_title'] =
                  locationTemp['title'];
            }
          }
        }
        // 判断分类
        if (state.formDetailCustomize['assort'] != null &&
            state.formDetailCustomize['assort'] != '') {
          // 循环分类列表
          for (int i = 0; i < state.assortList.length; i++) {
            // 分类临时
            Map<String, dynamic> assortTemp = state.assortList[i];
            // 判断值
            if (assortTemp['index'] == state.formDetailCustomize['assort']) {
              // 分类文本
              state.formDetailCustomize['assort_title'] = assortTemp['title'];
            }
          }
        }
        // 表格列表
        state.tableList = getTableList(state.formCustomize['form_kbn'],
            state.formDetailCustomize['location']);
        // 判断コンテンツテーブル
        if (state.formDetailCustomize['content_table'] != null &&
            state.formDetailCustomize['content_table'] != '') {
          // 循环表格列表
          for (int i = 0; i < state.tableList.length; i++) {
            // 表格临时
            Map<String, dynamic> tableTemp = state.tableList[i];
            // 判断值
            if (tableTemp['index'] ==
                state.formDetailCustomize['content_table']) {
              // コンテンツテーブル文本
              state.formDetailCustomize['content_table_title'] =
                  tableTemp['title'];
            }
          }
        }
        // 判断コンテンツフィールド
        if (state.formDetailCustomize['content_fields'] != null &&
            state.formDetailCustomize['content_fields'] != '' &&
            state.formDetailCustomize['content_table'] != null &&
            state.formDetailCustomize['content_table'] != '') {
          // 字段列表
          state.contentFieldsList = getContentFieldsList(
              state.formCustomize['form_kbn'],
              state.formDetailCustomize['content_table']);
          // 循环字段列表
          for (int i = 0; i < state.contentFieldsList.length; i++) {
            // 字段临时
            Map<String, dynamic> fieldsTemp = state.contentFieldsList[i];
            // 判断值
            if (fieldsTemp['index'] ==
                state.formDetailCustomize['content_fields']) {
              // コンテンツフィールド文本
              state.formDetailCustomize['content_fields_title'] =
                  fieldsTemp['title'];
            }
          }
        }
        // 判断計算表1
        if (state.formDetailCustomize['calculation_table1'] != null &&
            state.formDetailCustomize['calculation_table1'] != '') {
          // 循环表格列表
          for (int i = 0; i < state.tableList.length; i++) {
            // 表格临时
            Map<String, dynamic> tableTemp = state.tableList[i];
            // 判断值
            if (tableTemp['index'] ==
                state.formDetailCustomize['calculation_table1']) {
              // 計算表1文本
              state.formDetailCustomize['calculation_table1_title'] =
                  tableTemp['title'];
            }
          }
        }
        // 判断計算フィールド1
        if (state.formDetailCustomize['calculation_fields1'] != null &&
            state.formDetailCustomize['calculation_fields1'] != '' &&
            state.formDetailCustomize['calculation_table1'] != null &&
            state.formDetailCustomize['calculation_table1'] != '') {
          // 字段列表
          state.calculationFields1List = getContentFieldsList(
              state.formCustomize['form_kbn'],
              state.formDetailCustomize['calculation_table1']);
          // 循环字段列表
          for (int i = 0; i < state.calculationFields1List.length; i++) {
            // 字段临时
            Map<String, dynamic> fieldsTemp = state.calculationFields1List[i];
            // 判断值
            if (fieldsTemp['index'] ==
                state.formDetailCustomize['calculation_fields1']) {
              // 計算フィールド1文本
              state.formDetailCustomize['calculation_fields1_title'] =
                  fieldsTemp['title'];
            }
          }
        }
        // 判断計算表2
        if (state.formDetailCustomize['calculation_table2'] != null &&
            state.formDetailCustomize['calculation_table2'] != '') {
          // 循环表格列表
          for (int i = 0; i < state.tableList.length; i++) {
            // 表格临时
            Map<String, dynamic> tableTemp = state.tableList[i];
            // 判断值
            if (tableTemp['index'] ==
                state.formDetailCustomize['calculation_table2']) {
              // 計算表2文本
              state.formDetailCustomize['calculation_table2_title'] =
                  tableTemp['title'];
            }
          }
        }
        // 判断計算フィールド2
        if (state.formDetailCustomize['calculation_fields2'] != null &&
            state.formDetailCustomize['calculation_fields2'] != '' &&
            state.formDetailCustomize['calculation_table2'] != null &&
            state.formDetailCustomize['calculation_table2'] != '') {
          // 字段列表
          state.calculationFields1List = getContentFieldsList(
              state.formCustomize['form_kbn'],
              state.formDetailCustomize['calculation_table2']);
          // 循环字段列表
          for (int i = 0; i < state.calculationFields1List.length; i++) {
            // 字段临时
            Map<String, dynamic> fieldsTemp = state.calculationFields1List[i];
            // 判断值
            if (fieldsTemp['index'] ==
                state.formDetailCustomize['calculation_fields2']) {
              // 計算フィールド2文本
              state.formDetailCustomize['calculation_fields2_title'] =
                  fieldsTemp['title'];
            }
          }
        }
        // 判断計算モード
        if (state.formDetailCustomize['calculation_mode'] != null &&
            state.formDetailCustomize['calculation_mode'] != '') {
          // 循环計算モード列表
          for (int i = 0; i < state.calculationModeList.length; i++) {
            // 計算モード临时
            Map<String, dynamic> calculationModeTemp =
                state.calculationModeList[i];
            // 判断值
            if (calculationModeTemp['index'] ==
                state.formDetailCustomize['calculation_mode']) {
              // 計算モード文本
              state.formDetailCustomize['calculation_mode_title'] =
                  calculationModeTemp['title'];
            }
          }
        }
        // 判断フィールド名を表示
        if (state.formDetailCustomize['show_field_name'] != null &&
            state.formDetailCustomize['show_field_name'] != '') {
          // 循环显示列表
          for (int i = 0; i < state.showList.length; i++) {
            // 显示临时
            Map<String, dynamic> showTemp = state.showList[i];
            // 判断值
            if (showTemp['index'] ==
                state.formDetailCustomize['show_field_name']) {
              // フィールド名を表示文本
              state.formDetailCustomize['show_field_name_title'] =
                  showTemp['title'];
            }
          }
        }
      } else {
        // 账票明细-定制
        state.formDetailCustomize = {
          'id': '',
          'location': '',
          'location_title': '',
          'sequence_number': '',
          'assort': '',
          'assort_title': '',
          'content_table': '',
          'content_table_title': '',
          'content_fields': '',
          'content_fields_title': '',
          'calculation_table1': '',
          'calculation_table1_title': '',
          'calculation_fields1': '',
          'calculation_fields1_title': '',
          'calculation_table2': '',
          'calculation_table2_title': '',
          'calculation_fields2': '',
          'calculation_fields2_title': '',
          'calculation_mode': '',
          'calculation_mode_title': '',
          'show_field_name': '',
          'show_field_name_title': '',
          'word_size': '',
          'prefix_text': '',
          'suffix_text': '',
        };
      }

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 删除账票明细定制事件
    on<DeleteFormDetailCustomizeEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      try {
        // 删除账票明细定制
        List<Map<String, dynamic>> data = await SupabaseUtils.getClient()
            .from('mtb_form_detail')
            .delete()
            .eq('id', event.formDetailCustomizeId)
            .select('*');
        // 判断账票明细定制数据
        if (data.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(state.rootContext)!.form_detail_title +
                  WMSLocalizations.i18n(state.rootContext)!.delete_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.form_detail_title +
                  WMSLocalizations.i18n(state.rootContext)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!.form_detail_title +
                WMSLocalizations.i18n(state.rootContext)!.delete_error);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });
    // 自定义事件 - 终

    add(InitEvent());
  }

  // 获取位置列表
  List<Map<String, dynamic>> getLocationList(String formKbn) {
    // 位置列表
    List<Map<String, dynamic>> locationList = [];
    // 判断区分
    if (formKbn == Config.NUMBER_ONE.toString()) {
      // 位置列表
      locationList = [
        // 1行目の左部分
        {
          'index': Config.NUMBER_ONE.toString(),
          'title':
              WMSLocalizations.i18n(state.rootContext)!.form_location_one_left,
        },
        // 1行目の右部分
        {
          'index': Config.NUMBER_TWO.toString(),
          'title':
              WMSLocalizations.i18n(state.rootContext)!.form_location_one_right,
        },
        // 2行目の左部分
        {
          'index': Config.NUMBER_THREE.toString(),
          'title':
              WMSLocalizations.i18n(state.rootContext)!.form_location_two_left,
        },
        // 2行目の右部分
        {
          'index': Config.NUMBER_FOUR.toString(),
          'title':
              WMSLocalizations.i18n(state.rootContext)!.form_location_two_right,
        },
        // テーブル
        {
          'index': Config.NUMBER_FIVE.toString(),
          'title':
              WMSLocalizations.i18n(state.rootContext)!.form_location_table,
        },
      ];
    } else if (formKbn == Config.NUMBER_TWO.toString()) {
      // 位置列表
      locationList = [
        // 1行目の左部分
        {
          'index': Config.NUMBER_ONE.toString(),
          'title':
              WMSLocalizations.i18n(state.rootContext)!.form_location_one_left,
        },
        // 1行目の右部分
        {
          'index': Config.NUMBER_TWO.toString(),
          'title':
              WMSLocalizations.i18n(state.rootContext)!.form_location_one_right,
        },
        // テーブル
        {
          'index': Config.NUMBER_THREE.toString(),
          'title':
              WMSLocalizations.i18n(state.rootContext)!.form_location_table,
        },
      ];
    } else if (formKbn == Config.NUMBER_THREE.toString()) {
      // 位置列表
      locationList = [
        // 1行目の左部分
        {
          'index': Config.NUMBER_ONE.toString(),
          'title':
              WMSLocalizations.i18n(state.rootContext)!.form_location_one_left,
        },
        // 1行目の右部分
        {
          'index': Config.NUMBER_TWO.toString(),
          'title':
              WMSLocalizations.i18n(state.rootContext)!.form_location_one_right,
        },
        // テーブル
        {
          'index': Config.NUMBER_THREE.toString(),
          'title':
              WMSLocalizations.i18n(state.rootContext)!.form_location_table,
        },
      ];
    } else {
      // 位置列表
      locationList = [];
    }
    // 返回
    return locationList;
  }

  // 获取表列表
  List<Map<String, dynamic>> getTableList(String formKbn, String location) {
    // 表列表
    List<Map<String, dynamic>> tableList = [];
    // 判断区分
    if (formKbn == Config.NUMBER_ONE.toString()) {
      // 判断位置
      if (location == Config.NUMBER_ONE.toString() ||
          location == Config.NUMBER_TWO.toString() ||
          location == Config.NUMBER_THREE.toString() ||
          location == Config.NUMBER_FOUR.toString()) {
        // 表列表
        tableList = [
          // 会社
          {
            'index': Config.NUMBER_ONE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .account_profile_company,
          },
          // 出荷指示
          {
            'index': Config.NUMBER_TWO.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .instruction_input_table_title_10,
          },
        ];
      } else if (location == Config.NUMBER_FIVE.toString()) {
        // 表列表
        tableList = [
          // 出荷指示明細
          {
            'index': Config.NUMBER_THREE.toString(),
            'title':
                WMSLocalizations.i18n(state.rootContext)!.menu_content_60_3_5,
          },
        ];
      } else {
        // 表列表
        tableList = [];
      }
    } else if (formKbn == Config.NUMBER_TWO.toString()) {
      // 判断位置
      if (location == Config.NUMBER_ONE.toString() ||
          location == Config.NUMBER_TWO.toString()) {
        // 表列表
        tableList = [
          // 会社
          {
            'index': Config.NUMBER_ONE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .account_profile_company,
          },
          // 出荷指示
          {
            'index': Config.NUMBER_TWO.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .instruction_input_table_title_10,
          },
        ];
      } else if (location == Config.NUMBER_THREE.toString()) {
        // 表列表
        tableList = [
          // 出荷指示明細
          {
            'index': Config.NUMBER_THREE.toString(),
            'title':
                WMSLocalizations.i18n(state.rootContext)!.menu_content_60_3_5,
          },
        ];
      } else {
        // 表列表
        tableList = [];
      }
    } else if (formKbn == Config.NUMBER_THREE.toString()) {
      // 判断位置
      if (location == Config.NUMBER_ONE.toString() ||
          location == Config.NUMBER_TWO.toString()) {
        // 表列表
        tableList = [
          // 会社
          {
            'index': Config.NUMBER_ONE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .account_profile_company,
          },
          // 入荷予定
          {
            'index': Config.NUMBER_TWO.toString(),
            'title':
                WMSLocalizations.i18n(state.rootContext)!.home_main_page_text6,
          },
        ];
      } else if (location == Config.NUMBER_THREE.toString()) {
        // 表列表
        tableList = [
          // 入荷予定明細
          {
            'index': Config.NUMBER_THREE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .inquiry_schedule_print_table_detail,
          },
        ];
      } else {
        // 表列表
        tableList = [];
      }
    } else {
      // 表列表
      tableList = [];
    }
    // 返回
    return tableList;
  }

  // 获取内容字段列表
  List<Map<String, dynamic>> getContentFieldsList(
      String formKbn, String contentTable) {
    // 内容字段列表
    List<Map<String, dynamic>> contentFieldsList = [];
    // 判断区分
    if (formKbn == Config.NUMBER_ONE.toString()) {
      // 判断内容表
      if (contentTable == Config.NUMBER_ONE.toString()) {
        // 内容字段列表
        contentFieldsList = [
          // 会社名
          {
            'index': Config.NUMBER_ONE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .organization_master_form_5,
          },
          // 郵便番号
          {
            'index': Config.NUMBER_TWO.toString(),
            'title':
                WMSLocalizations.i18n(state.rootContext)!.company_information_6,
          },
          // 都道府県
          {
            'index': Config.NUMBER_THREE.toString(),
            'title':
                WMSLocalizations.i18n(state.rootContext)!.company_information_7,
          },
          // 市区町村
          {
            'index': Config.NUMBER_FOUR.toString(),
            'title':
                WMSLocalizations.i18n(state.rootContext)!.company_information_8,
          },
          // 住所
          {
            'index': Config.NUMBER_FIVE.toString(),
            'title':
                WMSLocalizations.i18n(state.rootContext)!.company_information_9,
          },
        ];
      } else if (contentTable == Config.NUMBER_TWO.toString()) {
        // 内容字段列表
        contentFieldsList = [
          // 納入先名
          {
            'index': Config.NUMBER_ONE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .instruction_input_form_basic_8,
          },
          // 納入先郵便番号
          {
            'index': Config.NUMBER_TWO.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .instruction_input_form_before_13,
          },
          // 納入先都道府県
          {
            'index': Config.NUMBER_THREE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .instruction_input_form_before_14,
          },
          // 納入先市区町村
          {
            'index': Config.NUMBER_FOUR.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .instruction_input_form_before_15,
          },
          // 納入先住所詳細
          {
            'index': Config.NUMBER_FIVE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .instruction_input_form_before_16,
          },
          // 出荷指示番号
          {
            'index': Config.NUMBER_SIX.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!.delivery_note_14,
          },
          // 出荷指示日
          {
            'index': Config.NUMBER_SEVEN.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .instruction_input_form_basic_3,
          },
        ];
      } else if (contentTable == Config.NUMBER_THREE.toString()) {
        // 内容字段列表
        contentFieldsList = [
          // 商品コード
          {
            'index': Config.NUMBER_ONE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .delivery_note_shipment_details_2,
          },
          // 商品名
          {
            'index': Config.NUMBER_TWO.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .delivery_note_shipment_details_3,
          },
          // 数量
          {
            'index': Config.NUMBER_THREE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!.delivery_note_44,
          },
          // 単価
          {
            'index': Config.NUMBER_FOUR.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .delivery_note_shipment_details_4,
          },
        ];
      } else {
        // 内容字段列表
        contentFieldsList = [];
      }
    } else if (formKbn == Config.NUMBER_TWO.toString()) {
      // 判断内容表
      if (contentTable == Config.NUMBER_ONE.toString()) {
        // 内容字段列表
        contentFieldsList = [
          // 会社名
          {
            'index': Config.NUMBER_ONE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .organization_master_form_5,
          },
          // 郵便番号
          {
            'index': Config.NUMBER_TWO.toString(),
            'title':
                WMSLocalizations.i18n(state.rootContext)!.company_information_6,
          },
          // 都道府県
          {
            'index': Config.NUMBER_THREE.toString(),
            'title':
                WMSLocalizations.i18n(state.rootContext)!.company_information_7,
          },
          // 市区町村
          {
            'index': Config.NUMBER_FOUR.toString(),
            'title':
                WMSLocalizations.i18n(state.rootContext)!.company_information_8,
          },
          // 住所
          {
            'index': Config.NUMBER_FIVE.toString(),
            'title':
                WMSLocalizations.i18n(state.rootContext)!.company_information_9,
          },
        ];
      } else if (contentTable == Config.NUMBER_TWO.toString()) {
        // 内容字段列表
        contentFieldsList = [
          // オーダー番号
          {
            'index': Config.NUMBER_ONE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .user_license_management_detail_table_2,
          },
          // 納入日
          {
            'index': Config.NUMBER_TWO.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .instruction_input_form_basic_5,
          },
          // 得意先名
          {
            'index': Config.NUMBER_THREE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .instruction_input_form_basic_4,
          },
          // 納入先名
          {
            'index': Config.NUMBER_FOUR.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .instruction_input_form_basic_8,
          },
          // 出荷指示番号
          {
            'index': Config.NUMBER_FIVE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!.delivery_note_14,
          },
          // 出荷指示日
          {
            'index': Config.NUMBER_SIX.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .instruction_input_form_basic_3,
          },
        ];
      } else if (contentTable == Config.NUMBER_THREE.toString()) {
        // 内容字段列表
        contentFieldsList = [
          // ピッキング明細行No
          {
            'index': Config.NUMBER_ONE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!.pink_list_63,
          },
          // 出库仓库
          {
            'index': Config.NUMBER_TWO.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .delivery_note_shipment_details_1,
          },
          // ロケーションコード
          {
            'index': Config.NUMBER_THREE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .exit_input_table_title_3,
          },
          // 商品コード
          {
            'index': Config.NUMBER_FOUR.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .delivery_note_shipment_details_2,
          },
          // 商品名
          {
            'index': Config.NUMBER_FIVE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .delivery_note_shipment_details_3,
          },
          // 出庫数
          {
            'index': Config.NUMBER_SIX.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .shipment_inspection_number,
          },
        ];
      } else {
        // 内容字段列表
        contentFieldsList = [];
      }
    } else if (formKbn == Config.NUMBER_THREE.toString()) {
      // 判断内容表
      if (contentTable == Config.NUMBER_ONE.toString()) {
        // 内容字段列表
        contentFieldsList = [
          // 会社名
          {
            'index': Config.NUMBER_ONE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .organization_master_form_5,
          },
          // 郵便番号
          {
            'index': Config.NUMBER_TWO.toString(),
            'title':
                WMSLocalizations.i18n(state.rootContext)!.company_information_6,
          },
          // 都道府県
          {
            'index': Config.NUMBER_THREE.toString(),
            'title':
                WMSLocalizations.i18n(state.rootContext)!.company_information_7,
          },
          // 市区町村
          {
            'index': Config.NUMBER_FOUR.toString(),
            'title':
                WMSLocalizations.i18n(state.rootContext)!.company_information_8,
          },
          // 住所
          {
            'index': Config.NUMBER_FIVE.toString(),
            'title':
                WMSLocalizations.i18n(state.rootContext)!.company_information_9,
          },
        ];
      } else if (contentTable == Config.NUMBER_TWO.toString()) {
        // 内容字段列表
        contentFieldsList = [
          // オーダー番号
          {
            'index': Config.NUMBER_ONE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .inquiry_schedule_print_head_1,
          },
          // 仕入先名称
          {
            'index': Config.NUMBER_TWO.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .inquiry_schedule_print_head_2,
          },
          // 入荷予定番号
          {
            'index': Config.NUMBER_THREE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .inquiry_schedule_print_head_3,
          },
          // 入荷予定日
          {
            'index': Config.NUMBER_FOUR.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .inquiry_schedule_print_head_4,
          },
        ];
      } else if (contentTable == Config.NUMBER_THREE.toString()) {
        // 内容字段列表
        contentFieldsList = [
          // 入荷予定明細行No
          {
            'index': Config.NUMBER_ONE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .inquiry_schedule_print_table_1,
          },
          // 商品名
          {
            'index': Config.NUMBER_TWO.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .inquiry_schedule_print_table_2,
          },
          // 入荷予定数
          {
            'index': Config.NUMBER_THREE.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .inquiry_schedule_print_table_3,
          },
          // 単価
          {
            'index': Config.NUMBER_FOUR.toString(),
            'title': WMSLocalizations.i18n(state.rootContext)!
                .inquiry_schedule_print_table_4,
          },
        ];
      } else {
        // 内容字段列表
        contentFieldsList = [];
      }
    } else {
      // 内容字段列表
      contentFieldsList = [];
    }
    // 返回
    return contentFieldsList;
  }

  // 保存账票明细定制验证
  Map<String, dynamic> saveFormDetailCustomizeCheck(
      Map<String, dynamic> formDetailStructure) {
    // 判断是否为空
    if (formDetailStructure['location'] == null ||
        formDetailStructure['location'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.form_location +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (formDetailStructure['sequence_number'] == null ||
        formDetailStructure['sequence_number'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.form_sequence_number +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (formDetailStructure['assort'] == null ||
        formDetailStructure['assort'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.form_assort +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    }

    // 判断分类
    if (formDetailStructure['assort'] == Config.NUMBER_ONE.toString() ||
        formDetailStructure['assort'] == Config.NUMBER_TWO.toString()) {
      // 判断是否为空
      if (formDetailStructure['content_table'] == null ||
          formDetailStructure['content_table'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!.content_table +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (formDetailStructure['content_fields'] == null ||
          formDetailStructure['content_fields'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!.content_fields +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      }
    } else if (formDetailStructure['assort'] ==
        Config.NUMBER_THREE.toString()) {
      // 判断是否为空
      if (formDetailStructure['calculation_table1'] == null ||
          formDetailStructure['calculation_table1'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!.calculation_table1 +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (formDetailStructure['calculation_fields1'] == null ||
          formDetailStructure['calculation_fields1'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!.calculation_fields1 +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (formDetailStructure['calculation_table2'] == null ||
          formDetailStructure['calculation_table2'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!.calculation_table2 +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (formDetailStructure['calculation_fields2'] == null ||
          formDetailStructure['calculation_fields2'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!.calculation_fields2 +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (formDetailStructure['calculation_mode'] == null ||
          formDetailStructure['calculation_mode'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!.calculation_mode +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      }
    }

    // 判断位置
    if (formDetailStructure['location'] == Config.NUMBER_ONE.toString() ||
        formDetailStructure['location'] == Config.NUMBER_TWO.toString()) {
      // 判断是否为空
      if (formDetailStructure['show_field_name'] == null ||
          formDetailStructure['show_field_name'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!.form_show_field_name +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (formDetailStructure['word_size'] == null ||
          formDetailStructure['word_size'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!.form_word_size +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      }
    }

    // 处理账票-结构
    if (formDetailStructure['id'] == null || formDetailStructure['id'] == '') {
      formDetailStructure.remove('id');
    } else {
      formDetailStructure['id'] =
          int.parse(formDetailStructure['id'].toString());
    }
    if (formDetailStructure['sequence_number'] == null ||
        formDetailStructure['sequence_number'] == '') {
      formDetailStructure.remove('sequence_number');
    } else {
      formDetailStructure['sequence_number'] =
          int.parse(formDetailStructure['sequence_number'].toString());
    }
    if (formDetailStructure['word_size'] == null ||
        formDetailStructure['word_size'] == '') {
      formDetailStructure.remove('word_size');
    } else {
      formDetailStructure['word_size'] =
          int.parse(formDetailStructure['word_size'].toString());
    }

    // 返回
    return formDetailStructure;
  }

  // 创建账票明细定制处理
  FormDetail createFormDetailCustomizeHandle(FormDetail formDetail) {
    // 账票明细
    formDetail.form_id = state.formId;
    formDetail.company_id = StoreProvider.of<WMSState>(state.rootContext)
        .state
        .loginUser
        ?.company_id;
    formDetail.create_time = DateTime.now().toString();
    formDetail.create_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
    formDetail.update_time = DateTime.now().toString();
    formDetail.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    // 返回
    return formDetail;
  }

  // 更新账票明细定制处理
  FormDetail updateFormDetailCustomizeHandle(FormDetail formDetail) {
    // 账票明细
    formDetail.update_time = DateTime.now().toString();
    formDetail.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    // 返回
    return formDetail;
  }
}
