import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/utils/common_utils.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/check_utils.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../model/product_location.dart';
import '../../../../../model/store.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'inventory_inquiry_model.dart';

/**
 * 内容：在庫照会-BLOC
 * 作者：赵士淞
 * 时间：2023/10/08
 */
// 事件
abstract class InventoryInquiryEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends InventoryInquiryEvent {
  // 初始化事件
  InitEvent();
}

// 保存检索按钮标记事件
class SaveQueryButtonFlag extends InventoryInquiryEvent {
  // 值
  bool value;
  // 保存检索按钮标记事件
  SaveQueryButtonFlag(this.value);
}

// 保存查询：商品コード事件
class SaveSearchProductCodeEvent extends InventoryInquiryEvent {
  // 值
  String value;
  // 保存查询：商品コード事件
  SaveSearchProductCodeEvent(this.value);
}

// 保存查询：商品名事件
class SaveSearchProductNameEvent extends InventoryInquiryEvent {
  // 值
  String value;
  // 保存查询：商品名事件
  SaveSearchProductNameEvent(this.value);
}

// 保存查询：ロケーションコード事件
class SaveSearchLocationLocCdEvent extends InventoryInquiryEvent {
  // 值
  String value;
  // 保存查询：ロケーションコード事件
  SaveSearchLocationLocCdEvent(this.value);
}

// 保存查询：年月事件
class SaveSearchYearMonthEvent extends InventoryInquiryEvent {
  // 值
  String value;
  // 保存查询：年月事件
  SaveSearchYearMonthEvent(this.value);
}

// 保存检索：商品コード事件
class SaveQueryProductCodeEvent extends InventoryInquiryEvent {
  // 值
  String value;
  // 保存检索：商品コード事件
  SaveQueryProductCodeEvent(this.value);
}

// 保存检索：商品名事件
class SaveQueryProductNameEvent extends InventoryInquiryEvent {
  // 值
  String value;
  // 保存检索：商品名事件
  SaveQueryProductNameEvent(this.value);
}

// 保存检索：ロケーションコード事件
class SaveQueryLocationLocCdEvent extends InventoryInquiryEvent {
  // 值
  String value;
  // 保存检索：ロケーションコード事件
  SaveQueryLocationLocCdEvent(this.value);
}

// 保存检索：年月事件
class SaveQueryYearMonthEvent extends InventoryInquiryEvent {
  // 值
  String value;
  // 保存检索：年月事件
  SaveQueryYearMonthEvent(this.value);
}

// 搜索按钮事件
class SearchButtonEvent extends InventoryInquiryEvent {
  // 搜索按钮事件
  SearchButtonEvent();
}

// 重置按钮事件
class ResetButtonEvent extends InventoryInquiryEvent {
  // 重置按钮事件
  ResetButtonEvent();
}

// 表格Tab切换事件
class TableTabSwitchEvent extends InventoryInquiryEvent {
  // 表格Tab下标
  int tableTabIndex;
  // 表格Tab切换事件
  TableTabSwitchEvent(this.tableTabIndex);
}

// 导入CSV文件事件
class ImportCSVFileEvent extends InventoryInquiryEvent {
  // 内容
  List<List<Map<String, dynamic>>> content;
  // 导入CSV文件事件
  ImportCSVFileEvent(this.content);
}

// 导出CSV文件事件
class ExportCSVFileEvent extends InventoryInquiryEvent {
  // 导出CSV文件事件
  ExportCSVFileEvent();
}

// 设置sort字段
class SetSortEvent extends InventoryInquiryEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

class InventoryInquiryBloc extends WmsTableBloc<InventoryInquiryModel> {
  // 刷新补丁
  @override
  InventoryInquiryModel clone(InventoryInquiryModel src) {
    return InventoryInquiryModel.clone(src);
  }

  InventoryInquiryBloc(InventoryInquiryModel state) : super(state) {
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

      // 当前日期时间
      DateTime now = DateTime.now();
      // 当前年份
      int year = now.year;
      // 当前月份
      int month = now.month;
      // 当前年月
      String yearMonth = year.toString() +
          (month < 10 ? '0' + month.toString() : month.toString());

      // 查询在庫照会
      List<dynamic> data = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_table_dtb_store', params: {
            'p_product_code':
                state.queryProductCode != '' ? state.queryProductCode : null,
            'p_product_name':
                state.queryProductName != '' ? state.queryProductName : null,
            'p_location_loc_cd': state.queryLocationLocCd != ''
                ? state.queryLocationLocCd
                : null,
            'p_company_id': StoreProvider.of<WMSState>(state.rootContext)
                .state
                .loginUser
                ?.company_id,
            'p_year_month': state.queryYearMonth != ''
                ? state.queryYearMonth.replaceAll('/', '')
                : yearMonth,
          })
          .select('*')
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      // 循环在庫照会数据
      for (int i = 0; i < data.length; i++) {
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }

      // 查询在库总数
      List<dynamic> count = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_total_dtb_store', params: {
        'p_product_code':
            state.queryProductCode != '' ? state.queryProductCode : null,
        'p_product_name':
            state.queryProductName != '' ? state.queryProductName : null,
        'p_location_loc_cd':
            state.queryLocationLocCd != '' ? state.queryLocationLocCd : null,
        'p_company_id': StoreProvider.of<WMSState>(state.rootContext)
            .state
            .loginUser
            ?.company_id,
        'p_year_month': state.queryYearMonth != ''
            ? state.queryYearMonth.replaceAll('/', '')
            : yearMonth,
      }).select('*');
      // 总页数
      state.total = count[0]['total'];

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      //获取当前登录用户会社ID
      int companyId = StoreProvider.of<WMSState>(state.rootContext)
          .state
          .loginUser!
          .company_id!;

      // 查询位置
      List<dynamic> locationData = await SupabaseUtils.getClient()
          .from('mtb_location')
          .select('*')
          .eq('company_id', companyId)
          .eq('del_kbn', Config.DELETE_NO);
      // 位置列表
      state.locationList = locationData;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 保存检索按钮标记事件
    on<SaveQueryButtonFlag>((event, emit) async {
      // 检索按钮标记
      state.queryButtonFlag = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存查询：商品コード事件
    on<SaveSearchProductCodeEvent>((event, emit) async {
      // 查询：商品コード
      state.searchProductCode = event.value;

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

    // 保存查询：ロケーションコード事件
    on<SaveSearchLocationLocCdEvent>((event, emit) async {
      // 查询：ロケーションコード
      state.searchLocationLocCd = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存查询：年月事件
    on<SaveSearchYearMonthEvent>((event, emit) async {
      // 查询：年月
      state.searchYearMonth = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存检索：商品コード事件
    on<SaveQueryProductCodeEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：商品コード
      state.queryProductCode = event.value;

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

    // 保存检索：ロケーションコード事件
    on<SaveQueryLocationLocCdEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：ロケーションコード
      state.queryLocationLocCd = event.value;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 保存检索：年月事件
    on<SaveQueryYearMonthEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：年月
      state.queryYearMonth = event.value;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 搜索按钮事件
    on<SearchButtonEvent>((event, emit) async {
      //
      if (state.searchProductCode != '' &&
          CheckUtils.check_Half_Alphanumeric_6_50(state.searchProductCode)) {
        //商品コード
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!.delivery_note_23 +
                WMSLocalizations.i18n(state.rootContext)!
                    .input_must_six_number_check);
        return;
      }

      // 打开加载状态
      BotToast.showLoading();

      // 检索按钮标记
      state.queryButtonFlag = false;
      // 检索：商品コード
      state.queryProductCode = state.searchProductCode;
      // 检索：商品名
      state.queryProductName = state.searchProductName;
      // 检索：ロケーションコード
      state.queryLocationLocCd = state.searchLocationLocCd;
      // 检索：年月
      state.queryYearMonth = state.searchYearMonth;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 重置按钮事件
    on<ResetButtonEvent>((event, emit) async {
      // 查询：商品コード
      state.searchProductCode = '';
      // 查询：商品名
      state.searchProductName = '';
      // 查询：ロケーションコード
      state.searchLocationLocCd = '';
      // 查询：年月
      state.searchYearMonth = '';
      // 更新
      emit(clone(state));
    });

    // 表格Tab切换事件
    on<TableTabSwitchEvent>((event, emit) async {
      // 表格：Tab下标
      state.tableTabIndex = event.tableTabIndex;

      // 更新
      emit(clone(state));
    });

    // 导入CSV文件事件
    on<ImportCSVFileEvent>((event, emit) async {
      // 判断内容长度
      if (event.content.length == 0) {
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }

      // 判断内容长度
      if (event.content.length > 0 && event.content.length < 3) {
        // 在库列表
        List<Map<String, dynamic>> storeList = [];
        // 商品在库位置列表
        List<Map<String, dynamic>> productLocationList = [];

        // 判断内容长度
        if (event.content.length == 2) {
          // 在库列表
          storeList = event.content[0];
          // 商品在库位置列表
          productLocationList = event.content[1];
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                  WMSLocalizations.i18n(state.rootContext)!.import_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }

        // 循环在库列表
        for (int i = 0; i < storeList.length; i++) {
          // 在库数量
          int storeStock = int.parse(storeList[i]['stock']);
          // 商品在库位置数量
          int productLocationStock = 0;

          // 循环商品在库位置列表
          for (int j = 0; j < productLocationList.length; j++) {
            // 判断在库列表与商品在库位置列表是否匹配
            if (productLocationList[j]['stock_id'] == storeList[i]['id']) {
              // 商品在库位置数量
              productLocationStock +=
                  int.parse(productLocationList[j]['stock']);
            }
            // 判断循环是否结束且在库数量与商品在库位置数量是否相等
            if (j == productLocationList.length - 1 &&
                storeStock != productLocationStock) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                      WMSLocalizations.i18n(state.rootContext)!.import_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          }
        }

        // 循环在库列表
        for (int i = 0; i < storeList.length; i++) {
          // 在库-结构
          Map<String, dynamic> storeStructure =
              saveStoreFormCheck(storeList[i]);
          // 判断验证结果
          if (storeStructure.length == 0) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                    WMSLocalizations.i18n(state.rootContext)!.import_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }

          // 在库-更新
          storeList[i] = storeStructure;
        }

        // 循环商品在库位置列表
        for (int i = 0; i < productLocationList.length; i++) {
          // 商品在库位置-结构
          Map<String, dynamic> productLocationStructure =
              saveProductLocationFormCheck(productLocationList[i]);
          // 判断验证结果
          if (productLocationStructure.length == 0) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                    WMSLocalizations.i18n(state.rootContext)!.import_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }

          // 查询位置
          List<dynamic> locationData = await SupabaseUtils.getClient()
              .from('mtb_location')
              .select('*')
              .eq('id', productLocationStructure['location_id']);
          // 判断位置数据
          if (locationData.length == 0) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                    WMSLocalizations.i18n(state.rootContext)!.import_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }

          // 查询商品
          List<dynamic> productData = await SupabaseUtils.getClient()
              .from('mtb_product')
              .select('*')
              .eq('id', productLocationStructure['product_id']);
          // 判断商品数据
          if (productData.length == 0) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                    WMSLocalizations.i18n(state.rootContext)!.import_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }

          // 商品在库位置-更新
          productLocationList[i] = productLocationStructure;
        }

        // 循环商品在库位置列表
        for (int i = 0; i < productLocationList.length; i++) {
          // 在库ID
          int storeId = 0;

          // 当前商品在库位置
          Map<String, dynamic> currentProductLocation = productLocationList[i];
          // 当前在库
          Map<String, dynamic> currentStore = {};
          // 循环在库列表
          for (int j = 0; j < storeList.length; j++) {
            // 判断是否一致
            if (currentProductLocation['stock_id'] == storeList[j]['id']) {
              // 当前在库
              currentStore = storeList[j];
              break;
            }
          }

          // 查询商品在库位置
          List<dynamic> productLocationTemp = await SupabaseUtils.getClient()
              .from('dtb_product_location')
              .select('*')
              .eq('location_id', currentProductLocation['location_id'])
              .eq('product_id', currentProductLocation['product_id']);
          // 判断商品在库位置数量
          if (productLocationTemp.length == 0) {
            // 在库
            Store store = Store.fromJson(currentStore);
            store.id = null;
            // 创建在库表单处理
            store = createStoreFormHandle(store);

            try {
              // 在库数据
              List<Map<String, dynamic>> storeData =
                  await SupabaseUtils.getClient()
                      .from('dtb_store')
                      .insert([store.toJson()]).select('*');
              // 判断在库数据
              if (storeData.length == 0) {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                        WMSLocalizations.i18n(state.rootContext)!.import_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }
              // 在库ID
              storeId = storeData[0]['id'];
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                      WMSLocalizations.i18n(state.rootContext)!.import_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }

            // 商品在库位置
            ProductLocation productLocation =
                ProductLocation.fromJson(currentProductLocation);
            productLocation.id = null;
            productLocation.stock_id = storeId;
            // 创建商品在库位置表单处理
            productLocation = createProductLocationFormHandle(productLocation);

            try {
              // 商品在库位置数据
              List<Map<String, dynamic>> productLocationData =
                  await SupabaseUtils.getClient()
                      .from('dtb_product_location')
                      .insert([productLocation.toJson()]).select('*');
              // 判断商品在库位置数据
              if (productLocationData.length == 0) {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                        WMSLocalizations.i18n(state.rootContext)!.import_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                      WMSLocalizations.i18n(state.rootContext)!.import_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          } else {
            // 商品在库位置
            ProductLocation productLocation =
                ProductLocation.fromJson(productLocationTemp[0]);
            // 更新商品在库位置表单处理
            productLocation = updateProductLocationFormHandle(
                productLocation, currentProductLocation);

            try {
              // 商品在库位置数据
              List<Map<String, dynamic>> productLocationData =
                  await SupabaseUtils.getClient()
                      .from('dtb_product_location')
                      .update(productLocation.toJson())
                      .eq('id', productLocation.id)
                      .select('*');
              // 判断商品在库位置数据
              if (productLocationData.length == 0) {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                        WMSLocalizations.i18n(state.rootContext)!.import_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }
              // 在库ID
              storeId = productLocationData[0]['stock_id'];
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                      WMSLocalizations.i18n(state.rootContext)!.import_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }

            // 查询在库
            List<dynamic> storeTemp = await SupabaseUtils.getClient()
                .from('dtb_store')
                .select('*')
                .eq('id', storeId);
            // 判断在库数量
            if (storeTemp.length != 0) {
              // 在库
              Store store = Store.fromJson(storeTemp[0]);
              // 更新在库表单处理
              store = updateStoreFormHandle(store, currentStore);

              try {
                // 在库数据
                List<Map<String, dynamic>> storeData =
                    await SupabaseUtils.getClient()
                        .from('dtb_store')
                        .update(store.toJson())
                        .eq('id', store.id)
                        .select('*');
                // 判断在库数据
                if (storeData.length == 0) {
                  // 失败提示
                  WMSCommonBlocUtils.errorTextToast(
                      WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                          WMSLocalizations.i18n(state.rootContext)!
                              .import_error);
                  // 关闭加载
                  BotToast.closeAllLoading();
                  return;
                }
              } catch (e) {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                        WMSLocalizations.i18n(state.rootContext)!.import_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }
            } else {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                      WMSLocalizations.i18n(state.rootContext)!.import_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          }
        }

        // 成功提示
        WMSCommonBlocUtils.successTextToast(
            WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                WMSLocalizations.i18n(state.rootContext)!.import_success);
        //插入操作履历 sys_log表
        CommonUtils().createLogInfo(
            '在庫データCSV' +
                Config.OPERATION_TEXT1 +
                Config.OPERATION_BUTTON_TEXT9 +
                Config.OPERATION_TEXT2,
            "ImportCSVFileEvent()",
            StoreProvider.of<WMSState>(state.rootContext)
                .state
                .loginUser!
                .company_id,
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser!.id);
      }

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 导出CSV文件事件
    on<ExportCSVFileEvent>((event, emit) async {
      // 内容列表
      List<Map<String, dynamic>> contentList = [];
      // 表格选中列表
      List<WmsRecordModel> wmsRecordModelList = state.checkedRecords();
      // 循环表格选中列表
      for (int i = 0; i < wmsRecordModelList.length; i++) {
        // 内容列表
        contentList.add(wmsRecordModelList[i].data);
      }
      // 判断内容列表长度
      if (contentList.length != 0) {
        // 导入CSV文件
        WMSCommonFile().exportCSVFile([
          'id',
          'product_code',
          'product_name',
          'stock',
          'lock_stock',
          'before_stock',
          'in_stock',
          'out_stock',
          'adjust_stock',
          'inventory_stock',
          'move_in_stock',
          'move_out_stock'
        ], contentList, '在庫照会');
      } else {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                .Inventory_Confirmed_tip_1);
      }
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

  // 保存在库表单验证
  Map<String, dynamic> saveStoreFormCheck(Map<String, dynamic> storeStructure) {
    // 判断是否为空
    if (storeStructure['product_id'] == null ||
        storeStructure['product_id'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .outbound_adjust_table_title_3 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (storeStructure['year_month'] == null ||
        storeStructure['year_month'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.menu_content_4_10_11 +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (storeStructure['stock'] == null ||
        storeStructure['stock'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .goods_transfer_entry_stock_count +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    }

    // 处理商品在库位置-结构
    if (storeStructure['id'] == null || storeStructure['id'] == '') {
      storeStructure.remove('id');
    } else {
      storeStructure['id'] = int.parse(storeStructure['id'].toString());
    }
    if (storeStructure['product_id'] == null ||
        storeStructure['product_id'] == '') {
      storeStructure.remove('product_id');
    } else {
      storeStructure['product_id'] =
          int.parse(storeStructure['product_id'].toString());
    }
    if (storeStructure['stock'] == null || storeStructure['stock'] == '') {
      storeStructure.remove('stock');
    } else {
      storeStructure['stock'] = int.parse(storeStructure['stock'].toString());
    }
    if (storeStructure['lock_stock'] == null ||
        storeStructure['lock_stock'] == '') {
      storeStructure.remove('lock_stock');
    } else {
      storeStructure['lock_stock'] =
          int.parse(storeStructure['lock_stock'].toString());
    }
    if (storeStructure['before_stock'] == null ||
        storeStructure['before_stock'] == '') {
      storeStructure.remove('before_stock');
    } else {
      storeStructure['before_stock'] =
          int.parse(storeStructure['before_stock'].toString());
    }
    if (storeStructure['in_stock'] == null ||
        storeStructure['in_stock'] == '') {
      storeStructure.remove('in_stock');
    } else {
      storeStructure['in_stock'] =
          int.parse(storeStructure['in_stock'].toString());
    }
    if (storeStructure['out_stock'] == null ||
        storeStructure['out_stock'] == '') {
      storeStructure.remove('out_stock');
    } else {
      storeStructure['out_stock'] =
          int.parse(storeStructure['out_stock'].toString());
    }
    if (storeStructure['adjust_stock'] == null ||
        storeStructure['adjust_stock'] == '') {
      storeStructure.remove('adjust_stock');
    } else {
      storeStructure['adjust_stock'] =
          int.parse(storeStructure['adjust_stock'].toString());
    }
    if (storeStructure['inventory_stock'] == null ||
        storeStructure['inventory_stock'] == '') {
      storeStructure.remove('inventory_stock');
    } else {
      storeStructure['inventory_stock'] =
          int.parse(storeStructure['inventory_stock'].toString());
    }
    if (storeStructure['move_in_stock'] == null ||
        storeStructure['move_in_stock'] == '') {
      storeStructure.remove('move_in_stock');
    } else {
      storeStructure['move_in_stock'] =
          int.parse(storeStructure['move_in_stock'].toString());
    }
    if (storeStructure['move_out_stock'] == null ||
        storeStructure['move_out_stock'] == '') {
      storeStructure.remove('move_out_stock');
    } else {
      storeStructure['move_out_stock'] =
          int.parse(storeStructure['move_out_stock'].toString());
    }
    if (storeStructure['return_stock'] == null ||
        storeStructure['return_stock'] == '') {
      storeStructure.remove('return_stock');
    } else {
      storeStructure['return_stock'] =
          int.parse(storeStructure['return_stock'].toString());
    }
    if (storeStructure['company_id'] == null ||
        storeStructure['company_id'] == '') {
      storeStructure.remove('company_id');
    } else {
      storeStructure['company_id'] =
          int.parse(storeStructure['company_id'].toString());
    }
    if (storeStructure['create_id'] == null ||
        storeStructure['create_id'] == '') {
      storeStructure.remove('create_id');
    } else {
      storeStructure['create_id'] =
          int.parse(storeStructure['create_id'].toString());
    }
    if (storeStructure['update_id'] == null ||
        storeStructure['update_id'] == '') {
      storeStructure.remove('update_id');
    } else {
      storeStructure['update_id'] =
          int.parse(storeStructure['update_id'].toString());
    }

    // 返回
    return storeStructure;
  }

  // 创建在库表单处理
  Store createStoreFormHandle(Store store) {
    // 在库
    store.company_id = StoreProvider.of<WMSState>(state.rootContext)
        .state
        .loginUser
        ?.company_id;
    store.create_time = DateTime.now().toString();
    store.create_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
    store.update_time = DateTime.now().toString();
    store.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    // 返回
    return store;
  }

  // 更新在库表单处理
  Store updateStoreFormHandle(
      Store store, Map<String, dynamic> storeStructure) {
    // 在库
    if (storeStructure['year_month'] != null &&
        storeStructure['year_month'] != '') {
      store.year_month = storeStructure['year_month'];
    }
    if (storeStructure['stock'] != null && storeStructure['stock'] != '') {
      store.stock =
          store.stock! + int.parse(storeStructure['stock'].toString());
    }
    if (storeStructure['lock_stock'] != null &&
        storeStructure['lock_stock'] != '') {
      store.lock_stock = store.lock_stock! +
          int.parse(storeStructure['lock_stock'].toString());
    }
    if (storeStructure['before_stock'] != null &&
        storeStructure['before_stock'] != '') {
      store.before_stock = store.before_stock! +
          int.parse(storeStructure['before_stock'].toString());
    }
    if (storeStructure['in_stock'] != null &&
        storeStructure['in_stock'] != '') {
      store.in_stock =
          store.in_stock! + int.parse(storeStructure['in_stock'].toString());
    }
    if (storeStructure['out_stock'] != null &&
        storeStructure['out_stock'] != '') {
      store.out_stock =
          store.out_stock! + int.parse(storeStructure['out_stock'].toString());
    }
    if (storeStructure['adjust_stock'] != null &&
        storeStructure['adjust_stock'] != '') {
      store.adjust_stock = store.adjust_stock! +
          int.parse(storeStructure['adjust_stock'].toString());
    }
    if (storeStructure['inventory_stock'] != null &&
        storeStructure['inventory_stock'] != '') {
      store.inventory_stock = store.inventory_stock! +
          int.parse(storeStructure['inventory_stock'].toString());
    }
    if (storeStructure['move_in_stock'] != null &&
        storeStructure['move_in_stock'] != '') {
      store.move_in_stock = store.move_in_stock! +
          int.parse(storeStructure['move_in_stock'].toString());
    }
    if (storeStructure['move_out_stock'] != null &&
        storeStructure['move_out_stock'] != '') {
      store.move_out_stock = store.move_out_stock! +
          int.parse(storeStructure['move_out_stock'].toString());
    }
    if (storeStructure['return_stock'] != null &&
        storeStructure['return_stock'] != '') {
      store.return_stock = store.return_stock! +
          int.parse(storeStructure['return_stock'].toString());
    }
    store.update_time = DateTime.now().toString();
    store.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    // 返回
    return store;
  }

  // 保存商品在库位置表单验证
  Map<String, dynamic> saveProductLocationFormCheck(
      Map<String, dynamic> productLocationStructure) {
    // 判断是否为空
    if (productLocationStructure['location_id'] == null ||
        productLocationStructure['location_id'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.Stock_present_4 +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (productLocationStructure['stock_id'] == null ||
        productLocationStructure['stock_id'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.inventory_inquiry_stock_id +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (productLocationStructure['product_id'] == null ||
        productLocationStructure['product_id'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.exit_input_form_title_7 +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (productLocationStructure['stock'] == null ||
        productLocationStructure['stock'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .goods_transfer_entry_stock_count +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (productLocationStructure['lock_stock'] == null ||
        productLocationStructure['lock_stock'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .outbound_adjust_table_btn_2 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    }

    // 处理商品在库位置-结构
    if (productLocationStructure['id'] == null ||
        productLocationStructure['id'] == '') {
      productLocationStructure.remove('id');
    } else {
      productLocationStructure['id'] =
          int.parse(productLocationStructure['id'].toString());
    }
    if (productLocationStructure['location_id'] == null ||
        productLocationStructure['location_id'] == '') {
      productLocationStructure.remove('location_id');
    } else {
      productLocationStructure['location_id'] =
          int.parse(productLocationStructure['location_id'].toString());
    }
    if (productLocationStructure['stock_id'] == null ||
        productLocationStructure['stock_id'] == '') {
      productLocationStructure.remove('stock_id');
    } else {
      productLocationStructure['stock_id'] =
          int.parse(productLocationStructure['stock_id'].toString());
    }
    if (productLocationStructure['product_id'] == null ||
        productLocationStructure['product_id'] == '') {
      productLocationStructure.remove('product_id');
    } else {
      productLocationStructure['product_id'] =
          int.parse(productLocationStructure['product_id'].toString());
    }
    if (productLocationStructure['stock'] == null ||
        productLocationStructure['stock'] == '') {
      productLocationStructure.remove('stock');
    } else {
      productLocationStructure['stock'] =
          int.parse(productLocationStructure['stock'].toString());
    }
    if (productLocationStructure['lock_stock'] == null ||
        productLocationStructure['lock_stock'] == '') {
      productLocationStructure.remove('lock_stock');
    } else {
      productLocationStructure['lock_stock'] =
          int.parse(productLocationStructure['lock_stock'].toString());
    }
    if (productLocationStructure['create_id'] == null ||
        productLocationStructure['create_id'] == '') {
      productLocationStructure.remove('create_id');
    } else {
      productLocationStructure['create_id'] =
          int.parse(productLocationStructure['create_id'].toString());
    }
    if (productLocationStructure['update_id'] == null ||
        productLocationStructure['update_id'] == '') {
      productLocationStructure.remove('update_id');
    } else {
      productLocationStructure['update_id'] =
          int.parse(productLocationStructure['update_id'].toString());
    }

    // 返回
    return productLocationStructure;
  }

  // 创建商品在库位置表单处理
  ProductLocation createProductLocationFormHandle(
      ProductLocation productLocation) {
    // 商品在库位置
    productLocation.create_time = DateTime.now().toString();
    productLocation.create_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
    productLocation.update_time = DateTime.now().toString();
    productLocation.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    // 返回
    return productLocation;
  }

  // 更新商品在库位置表单处理
  ProductLocation updateProductLocationFormHandle(
      ProductLocation productLocation,
      Map<String, dynamic> productLocationStructure) {
    // 商品在库位置
    if (productLocationStructure['stock'] != null &&
        productLocationStructure['stock'] != '') {
      productLocation.stock = productLocation.stock! +
          int.parse(productLocationStructure['stock'].toString());
    }
    if (productLocationStructure['lock_stock'] != null &&
        productLocationStructure['lock_stock'] != '') {
      productLocation.lock_stock = productLocation.lock_stock! +
          int.parse(productLocationStructure['lock_stock'].toString());
    }
    if (productLocationStructure['limit_date'] != null &&
        productLocationStructure['limit_date'] != '') {
      productLocation.limit_date = productLocationStructure['limit_date'];
    }
    if (productLocationStructure['lot_no'] != null &&
        productLocationStructure['lot_no'] != '') {
      productLocation.lot_no = productLocationStructure['lot_no'];
    }
    if (productLocationStructure['serial_no'] != null &&
        productLocationStructure['serial_no'] != '') {
      productLocation.serial_no = productLocationStructure['serial_no'];
    }
    if (productLocationStructure['note'] != null &&
        productLocationStructure['note'] != '') {
      productLocation.note = productLocationStructure['note'];
    }
    productLocation.update_time = DateTime.now().toString();
    productLocation.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    // 返回
    return productLocation;
  }
}
