import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../../common/utils/supabase_untils.dart';
import 'wms_account_ticket_model.dart';

/**
 * 内容：账票组件-BLOC
 * 作者：赵士淞
 * 时间：2023/12/26
 */
// 事件
abstract class WMSAccountticketEvent {}

// 初始化事件
class InitEvent extends WMSAccountticketEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始

// 自定义事件 - 终

class WMSAccountticketBloc
    extends Bloc<WMSAccountticketEvent, WMSAccountTicketModel> {
  // 刷新补丁
  WMSAccountTicketModel clone(WMSAccountTicketModel src) {
    return WMSAccountTicketModel.clone(src);
  }

  WMSAccountticketBloc(WMSAccountTicketModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 自定义事件 - 始
      // 查询会社
      List<dynamic> companyData = await SupabaseUtils.getClient()
          .from('mtb_company')
          .select('*')
          .eq('id', state.companyId);
      // 表一数据
      state.tableOneData = companyData[0];

      // 获取表格二和三列表
      await getTableTwoAndThreeList();

      // 查询账票管理
      List<dynamic> formData = await SupabaseUtils.getClient()
          .from('mtb_form')
          .select('*')
          .eq('form_kbn', state.formKbn)
          .eq('company_id', state.companyId);
      // 账票数据
      state.formData = formData[0];

      // 查询账票明细管理
      List<dynamic> formDetailData = await SupabaseUtils.getClient()
          .from('mtb_form_detail')
          .select('*')
          .eq('form_id', state.formData['id'])
          .order('sequence_number', ascending: true);
      // 账票明细列表
      state.formDetailList = formDetailData;

      // 获取字段列表
      getFieldsList();

      // 获取可编辑区域数量
      getEditableRegionsNumber();

      // 处理内容列表
      processContentList();
      // 自定义事件 - 终

      // 更新
      emit(clone(state));
    });

    // 自定义事件 - 始

    // 自定义事件 - 终

    add(InitEvent());
  }

  // 获取表格二和三列表
  Future<void> getTableTwoAndThreeList() async {
    // 判断账票区分
    if (state.formKbn == Config.NUMBER_ONE.toString()) {
      // 出荷指示列表
      List<dynamic> shipList = [];
      // 出荷指示明细列表
      List<dynamic> shipDetailList = [];

      // 循环出荷指示ID列表
      for (int i = 0; i < state.idList.length; i++) {
        // 查询出荷指示
        List<dynamic> shipData = await SupabaseUtils.getClient()
            .from('dtb_ship')
            .select('*')
            .eq('id', state.idList[i]);
        // 出荷指示列表
        shipList.add(shipData[0]);

        // 查询出荷指示明细
        List<dynamic> shipDetailData = await SupabaseUtils.getClient().rpc(
            'func_query_warehouse_dtb_ship_settlement',
            params: {'ship_id': state.idList[i]}).select('*');
        // 判断出荷指示明细列表长度
        if (shipDetailData.length == 0) {
          // 出荷指示明细列表
          shipDetailList.add([
            {
              'code': '',
              'name': '',
              'ship_num': '',
              'product_price': '',
            }
          ]);
        } else {
          // 出荷指示明细列表
          shipDetailList.add(shipDetailData);
        }
      }

      // 表二列表
      state.tableTwoList = shipList;
      // 表三列表
      state.tableThreeList = shipDetailList;
    } else if (state.formKbn == Config.NUMBER_TWO.toString()) {
      // 出荷指示列表
      List<dynamic> shipList = [];
      // 挑货单明细列表
      List<dynamic> shipDetailList = [];

      // 循环出荷指示ID列表
      for (int i = 0; i < state.idList.length; i++) {
        // 查询出荷指示
        List<dynamic> shipData = await SupabaseUtils.getClient()
            .from('dtb_ship')
            .select('*')
            .eq('id', state.idList[i]);
        // 出荷指示列表
        shipList.add(shipData[0]);

        // 查询出荷指示明细
        List<dynamic> shipDetailData = await SupabaseUtils.getClient().rpc(
            'func_zhaoss_query_print_dtb_pick_list',
            params: {'ship_id': state.idList[i]}).select('*');
        print('111');
        print(shipDetailData);
        // 判断出荷指示明细列表长度
        if (shipDetailData.length == 0) {
          // 出荷指示明细列表
          shipDetailList.add([
            {
              'pick_line_no': '',
              'warehouse_no': '',
              'location_loc_cd': '',
              'product_code': '',
              'product_name': '',
              'lock_num': '',
            }
          ]);
        } else {
          // 出荷指示明细列表
          shipDetailList.add(shipDetailData);
        }
      }

      // 表二列表
      state.tableTwoList = shipList;
      // 表三列表
      state.tableThreeList = shipDetailList;
    } else if (state.formKbn == Config.NUMBER_THREE.toString()) {
      // 入荷预定列表
      List<dynamic> receiveList = [];
      // 入荷预定明细列表
      List<dynamic> receiveDetailList = [];

      // 循环入荷预定ID列表
      for (int i = 0; i < state.idList.length; i++) {
        // 查询入荷予定
        List<dynamic> receiveData = await SupabaseUtils.getClient()
            .from('dtb_receive')
            .select('*')
            .eq('id', state.idList[i]);
        // 入荷预定列表
        receiveList.add(receiveData[0]);

        // 查询入荷预定明细
        List<dynamic> receiveDetailData = await SupabaseUtils.getClient().rpc(
            'func_muzd_query_dtb_receive_detail_print',
            params: {'receive_id': state.idList[i]}).select('*');
        // 判断入荷预定明细列表长度
        if (receiveDetailData.length == 0) {
          // 入荷预定明细列表
          receiveDetailList.add([
            {
              'receive_line_no': '',
              'name': '',
              'product_num': '',
              'product_price': '',
            }
          ]);
        } else {
          // 入荷预定明细列表
          receiveDetailList.add(receiveDetailData);
        }
      }

      // 表二列表
      state.tableTwoList = receiveList;
      // 表三列表
      state.tableThreeList = receiveDetailList;
    } else {
      // 表二列表
      state.tableTwoList = [];
      // 表三列表
      state.tableThreeList = [];
    }
  }

  // 获取字段列表
  void getFieldsList() {
    // 判断账票区分
    if (state.formKbn == Config.NUMBER_ONE.toString()) {
      // 字段一列表
      state.fieldsOneList = [
        // 会社名
        {
          'index': Config.NUMBER_ONE.toString(),
          'key': 'name',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .organization_master_form_5,
        },
        // 郵便番号
        {
          'index': Config.NUMBER_TWO.toString(),
          'key': 'postal_cd',
          'title':
              WMSLocalizations.i18n(state.rootContext)!.company_information_6,
        },
        // 都道府県
        {
          'index': Config.NUMBER_THREE.toString(),
          'key': 'addr_1',
          'title':
              WMSLocalizations.i18n(state.rootContext)!.company_information_7,
        },
        // 市区町村
        {
          'index': Config.NUMBER_FOUR.toString(),
          'key': 'addr_2',
          'title':
              WMSLocalizations.i18n(state.rootContext)!.company_information_8,
        },
        // 住所
        {
          'index': Config.NUMBER_FIVE.toString(),
          'key': 'addr_3',
          'title':
              WMSLocalizations.i18n(state.rootContext)!.company_information_9,
        },
      ];
      // 字段二列表
      state.fieldsTwoList = [
        // 納入先名
        {
          'index': Config.NUMBER_ONE.toString(),
          'key': 'name',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_basic_8,
        },
        // 納入先郵便番号
        {
          'index': Config.NUMBER_TWO.toString(),
          'key': 'postal_cd',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_before_13,
        },
        // 納入先都道府県
        {
          'index': Config.NUMBER_THREE.toString(),
          'key': 'customer_addr_1',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_before_14,
        },
        // 納入先市区町村
        {
          'index': Config.NUMBER_FOUR.toString(),
          'key': 'customer_addr_2',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_before_15,
        },
        // 納入先住所詳細
        {
          'index': Config.NUMBER_FIVE.toString(),
          'key': 'customer_addr_3',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_before_16,
        },
        // 出荷指示番号
        {
          'index': Config.NUMBER_SIX.toString(),
          'key': 'ship_no',
          'title': WMSLocalizations.i18n(state.rootContext)!.delivery_note_14,
        },
        // 出荷指示日
        {
          'index': Config.NUMBER_SEVEN.toString(),
          'key': 'rcv_sch_date',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_basic_3,
        },
      ];
      // 字段三列表
      state.fieldsThreeList = [
        // 商品コード
        {
          'index': Config.NUMBER_ONE.toString(),
          'key': 'code',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .delivery_note_shipment_details_2,
        },
        // 商品名
        {
          'index': Config.NUMBER_TWO.toString(),
          'key': 'name',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .delivery_note_shipment_details_3,
        },
        // 数量
        {
          'index': Config.NUMBER_THREE.toString(),
          'key': 'ship_num',
          'title': WMSLocalizations.i18n(state.rootContext)!.delivery_note_44,
        },
        // 単価
        {
          'index': Config.NUMBER_FOUR.toString(),
          'key': 'product_price',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .delivery_note_shipment_details_4,
        },
      ];
    } else if (state.formKbn == Config.NUMBER_TWO.toString()) {
      // 字段一列表
      state.fieldsOneList = [
        // 会社名
        {
          'index': Config.NUMBER_ONE.toString(),
          'key': 'name',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .organization_master_form_5,
        },
        // 郵便番号
        {
          'index': Config.NUMBER_TWO.toString(),
          'key': 'postal_cd',
          'title':
              WMSLocalizations.i18n(state.rootContext)!.company_information_6,
        },
        // 都道府県
        {
          'index': Config.NUMBER_THREE.toString(),
          'key': 'addr_1',
          'title':
              WMSLocalizations.i18n(state.rootContext)!.company_information_7,
        },
        // 市区町村
        {
          'index': Config.NUMBER_FOUR.toString(),
          'key': 'addr_2',
          'title':
              WMSLocalizations.i18n(state.rootContext)!.company_information_8,
        },
        // 住所
        {
          'index': Config.NUMBER_FIVE.toString(),
          'key': 'addr_3',
          'title':
              WMSLocalizations.i18n(state.rootContext)!.company_information_9,
        },
      ];
      // 字段二列表
      state.fieldsTwoList = [
        // オーダー番号
        {
          'index': Config.NUMBER_ONE.toString(),
          'key': 'order_no',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .user_license_management_detail_table_2,
        },
        // 納入日
        {
          'index': Config.NUMBER_TWO.toString(),
          'key': 'cus_rev_date',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_basic_5,
        },
        // 得意先名
        {
          'index': Config.NUMBER_THREE.toString(),
          'key': 'customer_name',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_basic_4,
        },
        // 納入先名
        {
          'index': Config.NUMBER_FOUR.toString(),
          'key': 'name',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_basic_8,
        },
        // 出荷指示番号
        {
          'index': Config.NUMBER_FIVE.toString(),
          'key': 'ship_no',
          'title': WMSLocalizations.i18n(state.rootContext)!.delivery_note_14,
        },
        // 出荷指示日
        {
          'index': Config.NUMBER_SIX.toString(),
          'key': 'rcv_sch_date',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_basic_3,
        },
      ];
      // 字段三列表
      state.fieldsThreeList = [
// ピッキング明細行No
        {
          'index': Config.NUMBER_ONE.toString(),
          'key': 'pick_line_no',
          'title': WMSLocalizations.i18n(state.rootContext)!.pink_list_63,
        },
        // 出库仓库
        {
          'index': Config.NUMBER_TWO.toString(),
          'key': 'warehouse_no',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .delivery_note_shipment_details_1,
        },
        // ロケーションコード
        {
          'index': Config.NUMBER_THREE.toString(),
          'key': 'location_loc_cd',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .exit_input_table_title_3,
        },
        // 商品コード
        {
          'index': Config.NUMBER_FOUR.toString(),
          'key': 'product_code',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .delivery_note_shipment_details_2,
        },
        // 商品名
        {
          'index': Config.NUMBER_FIVE.toString(),
          'key': 'product_name',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .delivery_note_shipment_details_3,
        },
        // 出庫数
        {
          'index': Config.NUMBER_SIX.toString(),
          'key': 'lock_num',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .shipment_inspection_number,
        },
      ];
    } else if (state.formKbn == Config.NUMBER_THREE.toString()) {
      // 字段一列表
      state.fieldsOneList = [
        // 会社名
        {
          'index': Config.NUMBER_ONE.toString(),
          'key': 'name',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .organization_master_form_5,
        },
        // 郵便番号
        {
          'index': Config.NUMBER_TWO.toString(),
          'key': 'postal_cd',
          'title':
              WMSLocalizations.i18n(state.rootContext)!.company_information_6,
        },
        // 都道府県
        {
          'index': Config.NUMBER_THREE.toString(),
          'key': 'addr_1',
          'title':
              WMSLocalizations.i18n(state.rootContext)!.company_information_7,
        },
        // 市区町村
        {
          'index': Config.NUMBER_FOUR.toString(),
          'key': 'addr_2',
          'title':
              WMSLocalizations.i18n(state.rootContext)!.company_information_8,
        },
        // 住所
        {
          'index': Config.NUMBER_FIVE.toString(),
          'key': 'addr_3',
          'title':
              WMSLocalizations.i18n(state.rootContext)!.company_information_9,
        },
      ];
      // 字段二列表
      state.fieldsTwoList = [
        // オーダー番号
        {
          'index': Config.NUMBER_ONE.toString(),
          'key': 'order_no',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .inquiry_schedule_print_head_1,
        },
        // 仕入先名称
        {
          'index': Config.NUMBER_TWO.toString(),
          'key': 'name',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .inquiry_schedule_print_head_2,
        },
        // 入荷予定番号
        {
          'index': Config.NUMBER_THREE.toString(),
          'key': 'receive_no',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .inquiry_schedule_print_head_3,
        },
        // 入荷予定日
        {
          'index': Config.NUMBER_FOUR.toString(),
          'key': 'rcv_sch_date',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .inquiry_schedule_print_head_4,
        },
      ];
      // 字段三列表
      state.fieldsThreeList = [
        // 入荷予定明細行No
        {
          'index': Config.NUMBER_ONE.toString(),
          'key': 'receive_line_no',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .inquiry_schedule_print_table_1,
        },
        // 商品名
        {
          'index': Config.NUMBER_TWO.toString(),
          'key': 'name',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .inquiry_schedule_print_table_2,
        },
        // 入荷予定数
        {
          'index': Config.NUMBER_THREE.toString(),
          'key': 'product_num',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .inquiry_schedule_print_table_3,
        },
        // 単価
        {
          'index': Config.NUMBER_FOUR.toString(),
          'key': 'product_price',
          'title': WMSLocalizations.i18n(state.rootContext)!
              .inquiry_schedule_print_table_4,
        },
      ];
    } else {
      // 字段一列表
      state.fieldsOneList = [];
      // 字段二列表
      state.fieldsTwoList = [];
      // 字段三列表
      state.fieldsThreeList = [];
    }
  }

  // 获取可编辑区域数量
  void getEditableRegionsNumber() {
    // 判断账票区分
    if (state.formKbn == Config.NUMBER_ONE.toString()) {
      // 可编辑区域数量
      state.editableRegionsNumber = Config.NUMBER_FIVE;
    } else if (state.formKbn == Config.NUMBER_TWO.toString()) {
      // 可编辑区域数量
      state.editableRegionsNumber = Config.NUMBER_THREE;
    } else if (state.formKbn == Config.NUMBER_THREE.toString()) {
      // 可编辑区域数量
      state.editableRegionsNumber = Config.NUMBER_THREE;
    } else {
      // 可编辑区域数量
      state.editableRegionsNumber = Config.NUMBER_ZERO;
    }
  }

  // 处理内容列表
  void processContentList() {
    // 内容汇总列表
    List<List<List<dynamic>>> contentSummaryList = [];
    // 表二数据
    Map<String, dynamic> tableTwoData = {};
    // 表三列表
    List<dynamic> tableThreeList = [];

    // 循环表二列表
    for (int i = 0; i < state.tableTwoList.length; i++) {
      // 内容页面列表
      List<List<dynamic>> contentPageList = [];
      // 表二数据
      tableTwoData = state.tableTwoList[i];
      // 表三列表
      tableThreeList = state.tableThreeList[i];

      // 循环可编辑区域数量
      for (int j = 1; j <= state.editableRegionsNumber; j++) {
        // 判断是否是最后区域（表格）
        if (j != state.editableRegionsNumber) {
          // 内容页面列表
          contentPageList.add(processCoreContentList(j, tableTwoData, false));
        } else {
          // 内容列表
          List<List<Map<String, dynamic>>> contentList = [];

          // 循环表三列表
          for (int z = 0; z < tableThreeList.length; z++) {
            // 内容数据
            List<Map<String, dynamic>> contentData =
                processCoreContentList(j, tableThreeList[z], true);

            // 判断表头列表长度
            if (state.tableHeadersList.length == 0) {
              // 表头列表
              List<String> tableHeadersList = [];
              // 表头文本列表
              List<String> tableHeadersTextList = [];
              // 循环内容数据
              for (int t = 0; t < contentData.length; t++) {
                // 表头列表长度
                tableHeadersList.add(contentData[t]['key']);
                // 表头文本列表长度
                tableHeadersTextList.add(contentData[t]['title']);
              }
              // 表头列表长度
              state.tableHeadersList = tableHeadersList;
              // 表头文本列表长度
              state.tableHeadersTextList = tableHeadersTextList;

              // 列宽
              double columnWidths = 10 / state.tableHeadersList.length;
              // 列宽列表
              Map<int, pw.TableColumnWidth> columnWidthsList = {};
              // 循环表头列表
              for (int k = 0; k < state.tableHeadersList.length; k++) {
                // 列宽列表
                columnWidthsList
                    .addAll({k: pw.IntrinsicColumnWidth(flex: columnWidths)});
              }
              // 列宽列表
              state.columnWidthsList = columnWidthsList;
            }

            // 内容列表
            contentList.add(contentData);
          }

          // 内容页面列表
          contentPageList.add(contentList);
        }
      }

      // 内容汇总列表
      contentSummaryList.add(contentPageList);
    }

    // 内容汇总列表
    state.contentSummaryList = contentSummaryList;
  }

  // 处理核心内容列表
  List<Map<String, dynamic>> processCoreContentList(int locationIndex,
      Map<String, dynamic> tableData, bool lastPositionFlag) {
    // 内容数据
    List<Map<String, dynamic>> contentData = [];

    // 循环账票明细列表
    for (int x = 0; x < state.formDetailList.length; x++) {
      // 判断位置是否匹配
      if (locationIndex.toString() == state.formDetailList[x]['location']) {
        // 账票明细单个数据
        Map<String, dynamic> formDetailItemData = state.formDetailList[x];
        // 内容单个数据
        Map<String, dynamic> contentItemData = {};

        // 判断最后位置
        if (lastPositionFlag) {
          // 内容单个数据
          contentItemData.addAll({
            'assort': formDetailItemData['assort'],
            'key': 'col' + x.toString(),
          });
        } else {
          // 内容单个数据
          contentItemData.addAll({
            'assort': formDetailItemData['assort'],
            'show_field_name': formDetailItemData['show_field_name'],
            'word_size': formDetailItemData['word_size'],
          });
        }

        // 判断账票明细分类
        if (formDetailItemData['assort'] == Config.NUMBER_ONE.toString()) {
          // 当前表格数据
          dynamic currentTableData = {};
          // 当前字段列表
          List<Map<String, dynamic>> currentFieldsList = [];

          // 判断账票明细内容表格
          if (formDetailItemData['content_table'] ==
              Config.NUMBER_ONE.toString()) {
            // 当前表格数据
            currentTableData = state.tableOneData;
            // 当前字段列表
            currentFieldsList = state.fieldsOneList;
          } else if (formDetailItemData['content_table'] ==
              Config.NUMBER_TWO.toString()) {
            // 当前表格数据
            currentTableData = tableData;
            // 当前字段列表
            currentFieldsList = state.fieldsTwoList;
          } else if (formDetailItemData['content_table'] ==
              Config.NUMBER_THREE.toString()) {
            // 当前表格数据
            currentTableData = tableData;
            // 当前字段列表
            currentFieldsList = state.fieldsThreeList;
          } else {
            // 跳过当前循环
            continue;
          }

          // 标题
          dynamic title;
          // 值
          dynamic value;

          // 循环当前字段列表
          for (int y = 0; y < currentFieldsList.length; y++) {
            // 判断账票明细内容字段
            if (formDetailItemData['content_fields'] ==
                currentFieldsList[y]['index']) {
              // 标题
              title = currentFieldsList[y]['title'];
              // 值
              value = currentTableData[currentFieldsList[y]['key']];
            }
          }

          // 值（前缀文本）
          value = value != null && value != ''
              ? formDetailItemData['prefix_text'] != null &&
                      formDetailItemData['prefix_text'] != ''
                  ? formDetailItemData['prefix_text'] + ' ' + value.toString()
                  : value
              : value;
          // 值（后缀文本）
          value = value != null && value != ''
              ? formDetailItemData['suffix_text'] != null &&
                      formDetailItemData['suffix_text'] != ''
                  ? value.toString() + ' ' + formDetailItemData['suffix_text']
                  : value
              : value;

          // 内容单个数据
          contentItemData.addAll({
            'title': title,
            'value': value,
          });
        } else if (formDetailItemData['assort'] ==
            Config.NUMBER_TWO.toString()) {
          // 当前表格数据
          dynamic currentTableData = {};
          // 当前字段列表
          List<Map<String, dynamic>> currentFieldsList = [];

          // 判断账票明细内容表格
          if (formDetailItemData['content_table'] ==
              Config.NUMBER_ONE.toString()) {
            // 当前表格数据
            currentTableData = state.tableOneData;
            // 当前字段列表
            currentFieldsList = state.fieldsOneList;
          } else if (formDetailItemData['content_table'] ==
              Config.NUMBER_TWO.toString()) {
            // 当前表格数据
            currentTableData = tableData;
            // 当前字段列表
            currentFieldsList = state.fieldsTwoList;
          } else if (formDetailItemData['content_table'] ==
              Config.NUMBER_THREE.toString()) {
            // 当前表格数据
            currentTableData = tableData;
            // 当前字段列表
            currentFieldsList = state.fieldsThreeList;
          } else {
            // 跳过当前循环
            continue;
          }

          // 值
          dynamic value;

          // 循环当前字段列表
          for (int y = 0; y < currentFieldsList.length; y++) {
            // 判断账票明细内容字段
            if (formDetailItemData['content_fields'] ==
                currentFieldsList[y]['index']) {
              // 值
              value = currentTableData[currentFieldsList[y]['key']];
            }
          }

          // 值（前缀文本）
          value = value != null && value != ''
              ? formDetailItemData['prefix_text'] != null &&
                      formDetailItemData['prefix_text'] != ''
                  ? formDetailItemData['prefix_text'] + ' ' + value.toString()
                  : value
              : value;
          // 值（后缀文本）
          value = value != null && value != ''
              ? formDetailItemData['suffix_text'] != null &&
                      formDetailItemData['suffix_text'] != ''
                  ? value.toString() + ' ' + formDetailItemData['suffix_text']
                  : value
              : value;

          // 内容单个数据
          contentItemData.addAll({
            'title': WMSLocalizations.i18n(state.rootContext)!.barcode,
            'value': value,
          });
        } else if (formDetailItemData['assort'] ==
            Config.NUMBER_THREE.toString()) {
          // 当前表格1数据
          dynamic currentTable1Data = {};
          // 当前字段1列表
          List<Map<String, dynamic>> currentFields1List = [];

          // 判断账票明细计算表格1
          if (formDetailItemData['calculation_table1'] ==
              Config.NUMBER_ONE.toString()) {
            // 当前表格1数据
            currentTable1Data = state.tableOneData;
            // 当前字段1列表
            currentFields1List = state.fieldsOneList;
          } else if (formDetailItemData['calculation_table1'] ==
              Config.NUMBER_TWO.toString()) {
            // 当前表格1数据
            currentTable1Data = tableData;
            // 当前字段1列表
            currentFields1List = state.fieldsTwoList;
          } else if (formDetailItemData['calculation_table1'] ==
              Config.NUMBER_THREE.toString()) {
            // 当前表格1数据
            currentTable1Data = tableData;
            // 当前字段1列表
            currentFields1List = state.fieldsThreeList;
          } else {
            // 跳过当前循环
            continue;
          }

          // 值1
          dynamic value1;

          // 循环当前字段1列表
          for (int y = 0; y < currentFields1List.length; y++) {
            // 判断账票明细计算字段1
            if (formDetailItemData['calculation_fields1'] ==
                currentFields1List[y]['index']) {
              // 值1
              value1 = currentTable1Data[currentFields1List[y]['key']];
            }
          }

          // 当前表格2数据
          dynamic currentTable2Data = {};
          // 当前字段列表
          List<Map<String, dynamic>> currentFields2List = [];

          // 判断账票明细计算表格2
          if (formDetailItemData['calculation_table2'] ==
              Config.NUMBER_ONE.toString()) {
            // 当前表格2数据
            currentTable2Data = state.tableOneData;
            // 当前字段2列表
            currentFields2List = state.fieldsOneList;
          } else if (formDetailItemData['calculation_table2'] ==
              Config.NUMBER_TWO.toString()) {
            // 当前表格2数据
            currentTable2Data = tableData;
            // 当前字段2列表
            currentFields2List = state.fieldsTwoList;
          } else if (formDetailItemData['calculation_table2'] ==
              Config.NUMBER_THREE.toString()) {
            // 当前表格2数据
            currentTable2Data = tableData;
            // 当前字段2列表
            currentFields2List = state.fieldsThreeList;
          } else {
            // 跳过当前循环
            continue;
          }

          // 值2
          dynamic value2;

          // 循环当前字段2列表
          for (int y = 0; y < currentFields2List.length; y++) {
            // 判断账票明细计算字段2
            if (formDetailItemData['calculation_fields2'] ==
                currentFields2List[y]['index']) {
              // 值2
              value2 = currentTable2Data[currentFields2List[y]['key']];
            }
          }

          // 值
          dynamic value;

          // 值
          value = (value1 is int || value1 is double) &&
                  (value2 is int || value2 is double)
              ? formDetailItemData['calculation_mode'] ==
                      Config.NUMBER_ONE.toString()
                  ? value1 + value2
                  : formDetailItemData['calculation_mode'] ==
                          Config.NUMBER_TWO.toString()
                      ? value1 - value2
                      : formDetailItemData['calculation_mode'] ==
                              Config.NUMBER_THREE.toString()
                          ? value1 * value2
                          : formDetailItemData['calculation_mode'] ==
                                  Config.NUMBER_FOUR.toString()
                              ? value1 / value2
                              : ''
              : '';

          // 值（前缀文本）
          value = value != null && value != ''
              ? formDetailItemData['prefix_text'] != null &&
                      formDetailItemData['prefix_text'] != ''
                  ? formDetailItemData['prefix_text'] + ' ' + value.toString()
                  : value
              : value;
          // 值（后缀文本）
          value = value != null && value != ''
              ? formDetailItemData['suffix_text'] != null &&
                      formDetailItemData['suffix_text'] != ''
                  ? value.toString() + ' ' + formDetailItemData['suffix_text']
                  : value
              : value;

          // 内容单个数据
          contentItemData.addAll({
            'title': WMSLocalizations.i18n(state.rootContext)!.delivery_note_43,
            'value': value,
          });
        } else {
          // 跳过当前循环
          continue;
        }

        // 内容数据
        contentData.add(contentItemData);
      }
    }

    // 返回
    return contentData;
  }
}
