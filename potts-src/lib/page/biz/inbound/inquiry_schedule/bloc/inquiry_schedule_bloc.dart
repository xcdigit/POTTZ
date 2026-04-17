import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/utils/check_utils.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'inquiry_schedule_model.dart';

/**
 * 内容：入何予定照会-BLOC
 * 作者：赵士淞
 * 时间：2023/09/21
 */
// 事件
abstract class InquiryScheduleEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends InquiryScheduleEvent {
  // 初始化事件
  InitEvent();
}

// 表格Tab切换事件
class TableTabSwitchEvent extends InquiryScheduleEvent {
  // 表格Tab下标
  int tableTabIndex;
  // 表格Tab切换事件
  TableTabSwitchEvent(this.tableTabIndex);
}

// 搜索输入框变更事件
class SearchInputChangeEvent extends InquiryScheduleEvent {
  // 输入框内容
  String inputContent;
  // 搜索输入框变更事件
  SearchInputChangeEvent(this.inputContent);
}

// 搜索按钮事件
class SearchButtonEvent extends InquiryScheduleEvent {
  // 搜索按钮事件
  SearchButtonEvent();
}

// 重置按钮事件
class ResetButtonEvent extends InquiryScheduleEvent {
  // 重置按钮事件
  ResetButtonEvent();
}

// 保存检索按钮标记事件
class SaveQueryButtonFlag extends InquiryScheduleEvent {
  // 值
  bool value;
  // 保存检索按钮标记事件
  SaveQueryButtonFlag(this.value);
}

// 保存查询：入荷予定番号事件
class SaveSearchReceiveNoEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存查询：入荷予定番号事件
  SaveSearchReceiveNoEvent(this.value);
}

// 保存查询：入荷予定起始日事件
class SaveSearchRcvSchDateStartEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存查询：入荷予定起始日事件
  SaveSearchRcvSchDateStartEvent(this.value);
}

// 保存查询：入荷予定终了日事件
class SaveSearchRcvSchDateEndEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存查询：入荷予定终了日事件
  SaveSearchRcvSchDateEndEvent(this.value);
}

// 保存查询：仕入先注文番号事件
class SaveSearchOrderNoEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存查询：仕入先注文番号事件
  SaveSearchOrderNoEvent(this.value);
}

// 保存查询：仕入先事件
class SaveSearchNameEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存查询：仕入先事件
  SaveSearchNameEvent(this.value);
}

// 保存查询：商品名事件
class SaveSearchProductNameEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存查询：商品名事件
  SaveSearchProductNameEvent(this.value);
}

// 保存查询：連携状態事件
class SaveSearchCsvKbnEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存查询：連携状態事件
  SaveSearchCsvKbnEvent(this.value);
}

// 保存查询：取込状態事件
class SaveSearchImporterrorFlgEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存查询：取込状態事件
  SaveSearchImporterrorFlgEvent(this.value);
}

// 保存检索：入荷予定番号事件
class SaveQueryReceiveNoEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存检索：入荷予定番号事件
  SaveQueryReceiveNoEvent(this.value);
}

// 保存检索：入荷予定起始日事件
class SaveQueryRcvSchDateStartEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存检索：入荷予定起始日事件
  SaveQueryRcvSchDateStartEvent(this.value);
}

// 保存检索：入荷予定终了日事件
class SaveQueryRcvSchDateEndEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存检索：入荷予定终了日事件
  SaveQueryRcvSchDateEndEvent(this.value);
}

// 保存检索：仕入先注文番号事件
class SaveQueryOrderNoEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存检索：仕入先注文番号事件
  SaveQueryOrderNoEvent(this.value);
}

// 保存检索：仕入先事件
class SaveQueryNameEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存检索：仕入先事件
  SaveQueryNameEvent(this.value);
}

// 保存检索：商品名事件
class SaveQueryProductNameEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存检索：商品名事件
  SaveQueryProductNameEvent(this.value);
}

// 保存检索：連携状態事件
class SaveQueryCsvKbnEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存检索：連携状態事件
  SaveQueryCsvKbnEvent(this.value);
}

// 保存检索：取込状態事件
class SaveQueryImporterrorFlgEvent extends InquiryScheduleEvent {
  // 值
  String value;
  // 保存检索：取込状態事件
  SaveQueryImporterrorFlgEvent(this.value);
}

// 删除入荷指示事件
class DeleteReceiveEvent extends InquiryScheduleEvent {
  // 入荷指示ID
  int receiveId;
  // 删除入荷指示事件
  DeleteReceiveEvent(this.receiveId);
}

// 设置sort字段
class SetSortEvent extends InquiryScheduleEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

class InquiryScheduleBloc extends WmsTableBloc<InquiryScheduleModel> {
  // 刷新补丁
  @override
  InquiryScheduleModel clone(InquiryScheduleModel src) {
    return InquiryScheduleModel.clone(src);
  }

  InquiryScheduleBloc(InquiryScheduleModel state) : super(state) {
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

      // 判断表格：Tab下标
      if (state.tableTabIndex == Config.NUMBER_ZERO) {
        // 检索：入荷状態
        state.queryReceiveKbn = '';
      } else if (state.tableTabIndex == Config.NUMBER_ONE) {
        // 检索：入荷状態
        state.queryReceiveKbn = Config.NUMBER_ONE.toString();
      } else if (state.tableTabIndex == Config.NUMBER_TWO) {
        // 检索：入荷状態
        state.queryReceiveKbn = Config.NUMBER_TWO.toString();
      } else if (state.tableTabIndex == Config.NUMBER_THREE) {
        // 检索：入荷状態
        state.queryReceiveKbn = Config.NUMBER_THREE.toString();
      } else if (state.tableTabIndex == Config.NUMBER_FOUR) {
        // 检索：入荷状態
        state.queryReceiveKbn = Config.NUMBER_FOUR.toString();
      } else if (state.tableTabIndex == Config.NUMBER_FIVE) {
        // 检索：入荷状態
        state.queryReceiveKbn = Config.NUMBER_FIVE.toString();
      } else {
        // 检索：入荷状態
        state.queryReceiveKbn = '';
      }

      // 查询入荷予定照会
      List<dynamic> data = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_table_dtb_receive', params: {
            'p_receive_no':
                state.queryReceiveNo != '' ? state.queryReceiveNo : null,
            'p_rcv_sch_date_start': state.queryRcvSchDateStart != ''
                ? state.queryRcvSchDateStart
                : null,
            'p_rcv_sch_date_end': state.queryRcvSchDateEnd != ''
                ? state.queryRcvSchDateEnd
                : null,
            'p_order_no': state.queryOrderNo != '' ? state.queryOrderNo : null,
            'p_name': state.queryName != '' ? state.queryName : null,
            'p_product_name':
                state.queryProductName != '' ? state.queryProductName : null,
            'p_csv_kbn': state.queryCsvKbn != '' ? state.queryCsvKbn : null,
            'p_receive_kbn':
                state.queryReceiveKbn != '' ? state.queryReceiveKbn : null,
            'p_importerror_flg': state.queryImporterrorFlg != ''
                ? state.queryImporterrorFlg
                : null,
            'p_del_kbn': Config.DELETE_NO,
            'p_input_content':
                state.queryInputContent != '' ? state.queryInputContent : null,
            'p_company_id': StoreProvider.of<WMSState>(state.rootContext)
                .state
                .loginUser
                ?.company_id,
          })
          .select('*')
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();

      // 循环入荷予定照会数据
      for (int i = 0; i < data.length; i++) {
        // 查询分页结果处理
        data[i] = pageQueryResultProcessing(data[i]);

        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }

      // 总页数
      state.total = await pageTotalNumber(state, state.queryReceiveKbn);

      // 表格：一覧数量
      state.tableZeroNumber = await pageTotalNumber(state, '');
      // 表格：检品待ち数量
      state.tableOneNumber =
          await pageTotalNumber(state, Config.NUMBER_ONE.toString());
      // 表格：入庫待ち数量
      state.tableTwoNumber =
          await pageTotalNumber(state, Config.NUMBER_TWO.toString());
      // 表格：入庫中数量
      state.tableThreeNumber =
          await pageTotalNumber(state, Config.NUMBER_THREE.toString());
      // 表格：入荷確定待ち数量
      state.tableFourNumber =
          await pageTotalNumber(state, Config.NUMBER_FOUR.toString());
      // 表格：入荷済み数量
      state.tableFiveNumber =
          await pageTotalNumber(state, Config.NUMBER_FIVE.toString());

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询供应商
      List<dynamic> supplierData = await SupabaseUtils.getClient()
          .from('mtb_supplier')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.company_id);
      // 供应商列表
      state.supplierList = supplierData;

      // 查询商品事件
      List<dynamic> productData = await SupabaseUtils.getClient()
          .from('mtb_product')
          .select('*')
          .eq('del_kbn', Config.DELETE_NO)
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.company_id);
      // 商品列表
      state.productList = productData;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 表格Tab切换事件
    on<TableTabSwitchEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 表格：Tab下标
      state.tableTabIndex = event.tableTabIndex;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 搜索输入框变更事件
    on<SearchInputChangeEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：输入框内容
      state.queryInputContent = event.inputContent;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 搜索按钮事件
    on<SearchButtonEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索按钮标记
      state.queryButtonFlag = false;
      // 检索：入荷予定番号
      state.queryReceiveNo = state.searchReceiveNo;
      // 检索：入荷予定起始日
      state.queryRcvSchDateStart = state.searchRcvSchDateStart;
      // 检索：入荷予定终了日
      state.queryRcvSchDateEnd = state.searchRcvSchDateEnd;
      // 检索：仕入先注文番号
      state.queryOrderNo = state.searchOrderNo;
      // 检索：仕入先
      state.queryName = state.searchName;
      // 检索：商品名
      state.queryProductName = state.searchProductName;
      // 检索：連携状態
      state.queryCsvKbn = state.searchCsvKbn;
      // 检索：取込状態
      state.queryImporterrorFlg = state.searchImporterrorFlg;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 重置按钮事件
    on<ResetButtonEvent>((event, emit) async {
      // 查询：入荷予定番号
      state.searchReceiveNo = '';
      // 查询：入荷予定起始日
      state.searchRcvSchDateStart = '';
      // 查询：入荷予定终了日
      state.searchRcvSchDateEnd = '';
      // 查询：仕入先注文番号
      state.searchOrderNo = '';
      // 查询：仕入先
      state.searchName = '';
      // 查询：商品名
      state.searchProductName = '';
      // 查询：連携状態
      state.searchCsvKbn = '';
      // 查询：取込状態
      state.searchImporterrorFlg = '';

      // 更新
      emit(clone(state));
    });

    // 保存检索按钮标记事件
    on<SaveQueryButtonFlag>((event, emit) async {
      // 检索按钮标记
      state.queryButtonFlag = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存查询：入荷予定番号事件
    on<SaveSearchReceiveNoEvent>((event, emit) async {
      // 查询：入荷予定番号
      state.searchReceiveNo = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存查询：入荷予定起始日事件
    on<SaveSearchRcvSchDateStartEvent>((event, emit) async {
      // 查询：入荷予定起始日
      state.searchRcvSchDateStart = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存查询：入荷予定终了日事件
    on<SaveSearchRcvSchDateEndEvent>((event, emit) async {
      // 查询：入荷予定终了日
      state.searchRcvSchDateEnd = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存查询：仕入先注文番号事件
    on<SaveSearchOrderNoEvent>((event, emit) async {
      // 查询：仕入先注文番号
      state.searchOrderNo = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存查询：仕入先事件
    on<SaveSearchNameEvent>((event, emit) async {
      // 查询：仕入先
      state.searchName = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存查询：商品名事件
    on<SaveSearchProductNameEvent>((event, emit) async {
      // 查询：商品名
      state.searchProductName = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存查询：連携状態事件
    on<SaveSearchCsvKbnEvent>((event, emit) async {
      // 查询：連携状態
      state.searchCsvKbn = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存查询：取込状態事件
    on<SaveSearchImporterrorFlgEvent>((event, emit) async {
      // 查询：取込状態
      state.searchImporterrorFlg = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存检索：入荷予定番号事件
    on<SaveQueryReceiveNoEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：入荷予定番号
      state.queryReceiveNo = event.value;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 保存检索：入荷予定起始日事件
    on<SaveQueryRcvSchDateStartEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：入荷予定起始日
      state.queryRcvSchDateStart = event.value;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 保存检索：入荷予定终了日事件
    on<SaveQueryRcvSchDateEndEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：入荷予定终了日
      state.queryRcvSchDateEnd = event.value;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 保存检索：仕入先注文番号事件
    on<SaveQueryOrderNoEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：仕入先注文番号
      state.queryOrderNo = event.value;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 保存检索：仕入先事件
    on<SaveQueryNameEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：仕入先
      state.queryName = event.value;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 保存检索：商品名事件
    on<SaveQueryProductNameEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：商品名
      state.queryProductName = event.value;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 保存检索：連携状態事件
    on<SaveQueryCsvKbnEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：連携状態
      state.queryCsvKbn = event.value;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 保存检索：取込状態事件
    on<SaveQueryImporterrorFlgEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：取込状態
      state.queryImporterrorFlg = event.value;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 删除入荷指示事件
    on<DeleteReceiveEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      try {
        // 修改入荷指示
        List<Map<String, dynamic>> receiveData = await SupabaseUtils.getClient()
            .from('dtb_receive')
            .update({'del_kbn': Config.DELETE_YES})
            .eq('id', event.receiveId)
            .select('*');
        // 判断入荷指示数据
        if (receiveData.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(state.rootContext)!.home_main_page_text6 +
                  WMSLocalizations.i18n(state.rootContext)!.delete_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.home_main_page_text6 +
                  WMSLocalizations.i18n(state.rootContext)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!.home_main_page_text6 +
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

    // 设置sort字段
    on<SetSortEvent>((event, emit) async {
      state.sortCol = event.sortCol;
      state.ascendingFlg = event.asc;
      emit(clone(state));
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    add(InitEvent());
  }

  // 查询分页结果处理
  dynamic pageQueryResultProcessing(dynamic data) {
    // 判断入荷状態
    if (data['receive_kbn'] == Config.NUMBER_ONE.toString()) {
      // 入荷状態名称
      data['receive_kbn_name'] =
          WMSLocalizations.i18n(state.rootContext)!.receive_kbn_text_1;
    } else if (data['receive_kbn'] == Config.NUMBER_TWO.toString()) {
      // 入荷状態名称
      data['receive_kbn_name'] =
          WMSLocalizations.i18n(state.rootContext)!.receive_kbn_text_2;
    } else if (data['receive_kbn'] == Config.NUMBER_THREE.toString()) {
      // 入荷状態名称
      data['receive_kbn_name'] =
          WMSLocalizations.i18n(state.rootContext)!.receive_kbn_text_3;
    } else if (data['receive_kbn'] == Config.NUMBER_FOUR.toString()) {
      // 入荷状態名称
      data['receive_kbn_name'] =
          WMSLocalizations.i18n(state.rootContext)!.receive_kbn_text_4;
    } else if (data['receive_kbn'] == Config.NUMBER_FIVE.toString()) {
      // 入荷状態名称
      data['receive_kbn_name'] =
          WMSLocalizations.i18n(state.rootContext)!.receive_kbn_text_5;
    } else {
      // 入荷状態名称
      data['receive_kbn_name'] = '';
    }

    // 判断取込状態
    if (data['importerror_flg'] == Config.NUMBER_ONE.toString()) {
      // 取込状態名称
      data['importerror_flg_name'] =
          WMSLocalizations.i18n(state.rootContext)!.importerror_flg_text_1;
    } else if (data['importerror_flg'] == Config.NUMBER_TWO.toString()) {
      // 取込状態名称
      data['importerror_flg_name'] =
          WMSLocalizations.i18n(state.rootContext)!.importerror_flg_text_2;
    } else if (data['importerror_flg'] == Config.NUMBER_THREE.toString()) {
      // 取込状態名称
      data['importerror_flg_name'] =
          WMSLocalizations.i18n(state.rootContext)!.importerror_flg_text_3;
    } else if (data['importerror_flg'] == Config.NUMBER_FOUR.toString()) {
      // 取込状態名称
      data['importerror_flg_name'] =
          WMSLocalizations.i18n(state.rootContext)!.importerror_flg_text_4;
    } else {
      // 取込状態名称
      data['importerror_flg_name'] = '';
    }

    // 返回
    return data;
  }

  // 查询总数量
  Future<int> pageTotalNumber(
      InquiryScheduleModel state, String receiveKbn) async {
    // 查询入荷予定照会总数
    List<dynamic> count = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_query_total_dtb_receive', params: {
      'p_receive_no': state.queryReceiveNo != '' ? state.queryReceiveNo : null,
      'p_rcv_sch_date_start':
          state.queryRcvSchDateStart != '' ? state.queryRcvSchDateStart : null,
      'p_rcv_sch_date_end':
          state.queryRcvSchDateEnd != '' ? state.queryRcvSchDateEnd : null,
      'p_order_no': state.queryOrderNo != '' ? state.queryOrderNo : null,
      'p_name': state.queryName != '' ? state.queryName : null,
      'p_product_name':
          state.queryProductName != '' ? state.queryProductName : null,
      'p_csv_kbn': state.queryCsvKbn != '' ? state.queryCsvKbn : null,
      'p_receive_kbn': receiveKbn != '' ? receiveKbn : null,
      'p_importerror_flg':
          state.queryImporterrorFlg != '' ? state.queryImporterrorFlg : null,
      'p_del_kbn': Config.DELETE_NO,
      'p_input_content':
          state.queryInputContent != '' ? state.queryInputContent : null,
      'p_company_id': StoreProvider.of<WMSState>(state.rootContext)
          .state
          .loginUser
          ?.company_id,
    });
    // 返回
    return count[0]['total'];
  }

  // 检查可操作状态
  Future<bool> checkOperationalStatus(
      int receiveId, String editOrDelete) async {
    // 查询入荷指示
    List<dynamic> receiveList = await SupabaseUtils.getClient()
        .from('dtb_receive')
        .select('*')
        .eq('id', receiveId);
    // 判断入荷指示数量和入荷状态
    if (receiveList.length == 0 || receiveList[0]['receive_kbn'] != '1') {
      // 判断修改删除标记
      if (editOrDelete == '1') {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!.this_status_cannot_edit);
      } else if (editOrDelete == '2') {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                .this_status_cannot_delete);
      }
      return false;
    } else {
      return true;
    }
  }

  //查询当前数据是否已经被消除
  Future<bool> queryReceiveEvent(int receiveId) async {
    // 查询入荷指示
    List<dynamic> receiveList = await SupabaseUtils.getClient()
        .from('dtb_receive')
        .select('*')
        .eq('id', receiveId)
        .eq('del_kbn', '2');
    if (receiveList.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  //检索前check处理
  bool selectBeforeCheck(BuildContext context, String shipNo, String orderNo) {
    //检索条件check
    // 入荷予定番号 半角英数記号
    if (shipNo != '') {
      if (CheckUtils.check_Half_Alphanumeric_Symbol(shipNo)) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.menu_content_2_5_6 +
                WMSLocalizations.i18n(context)!
                    .input_letter_and_number_and_symbol_check);
        return false;
      }
    }
    // 仕入先注文番号 半角英数
    if (orderNo != '') {
      if (CheckUtils.check_Half_Alphanumeric(orderNo)) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.menu_content_2_5_7 +
                WMSLocalizations.i18n(context)!.input_letter_and_number_check);
        return false;
      }
    }

    return true;
  }
}
