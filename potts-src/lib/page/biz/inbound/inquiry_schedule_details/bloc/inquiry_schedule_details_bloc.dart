import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'inquiry_schedule_details_model.dart';

/**
 * 内容：入荷指示照会-BLOC
 * 作者：赵士淞
 * 时间：2023/09/27
 */
// 事件
abstract class InquiryScheduleDetailsEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends InquiryScheduleDetailsEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定入荷指示值事件
class SetReceiveValueEvent extends InquiryScheduleDetailsEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetReceiveValueEvent(this.key, this.value);
}

// 设定入荷指示集合事件
class SetReceiveMapEvent extends InquiryScheduleDetailsEvent {
  // 值集合
  Map<String, dynamic> valueMap;
  // 设定集合事件
  SetReceiveMapEvent(this.valueMap);
}

// 删除入荷指示事件
class DeleteReceiveEvent extends InquiryScheduleDetailsEvent {
  // 删除入荷指示事件
  DeleteReceiveEvent();
}

// 删除入荷指示明细事件
class DeleteReceiveDetailEvent extends InquiryScheduleDetailsEvent {
  // 入荷指示明细ID
  int receiveDetailId;
  // 删除入荷指示明细事件
  DeleteReceiveDetailEvent(this.receiveDetailId);
}

// 查询入荷指示明细事件
class QueryReceiveDetailEvent extends InquiryScheduleDetailsEvent {
  // 入荷指示明细ID
  int receiveDetailId;
  // 查询入荷指示明细事件
  QueryReceiveDetailEvent(this.receiveDetailId);
}

// 设定入荷指示明细值事件
class SetReceiveDetailValueEvent extends InquiryScheduleDetailsEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetReceiveDetailValueEvent(this.key, this.value);
}

// 设定入荷指示明细集合事件
class SetReceiveDetailMapEvent extends InquiryScheduleDetailsEvent {
  // 值集合
  Map<String, dynamic> valueMap;
  // 设定集合事件
  SetReceiveDetailMapEvent(this.valueMap);
}
// 自定义事件 - 终

class InquiryScheduleDetailsBloc
    extends WmsTableBloc<InquiryScheduleDetailsModel> {
  // 刷新补丁
  @override
  InquiryScheduleDetailsModel clone(InquiryScheduleDetailsModel src) {
    return InquiryScheduleDetailsModel.clone(src);
  }

  // 查询入荷指示明细事件
  Future<bool> queryReceiveDetailEvent(
      int receiveDetailId, BuildContext context) async {
    // 判断入荷指示-定制ID
    if (state.receiveCustomize['id'] == null ||
        state.receiveCustomize['id'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.home_main_page_text6 +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return false;
    } else {
      // 查询入荷指示明细内容事件
      bool flag = await queryReceiveDetailContentEvent(receiveDetailId);
      // 判断标记
      if (!flag) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                .data_changed_operate_again);
        // 跳转页面
        GoRouter.of(context).pop();
      }
      return flag;
    }
  }

  // 查询入荷指示明细内容事件
  Future<bool> queryReceiveDetailContentEvent(int receiveDetailId) async {
    // 打开加载状态
    BotToast.showLoading();

    // 查询入荷指示明细
    List<dynamic> receiveDetailData = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_query_item_dtb_receive_detail', params: {
      'p_id': receiveDetailId,
      'p_del_kbn': Config.DELETE_NO,
      'p_rev_ship_kbn': Config.NUMBER_ONE.toString()
    }).select('*');
    // 判断入荷指示明细数量
    if (receiveDetailData.length != 0) {
      // 入荷指示明细-定制
      state.receiveDetailCustomize = receiveDetailData[0];
      // 判断商品写真1
      if (receiveDetailData[0]['product_image1'] != null &&
          receiveDetailData[0]['product_image1'] != '') {
        // 入荷指示明细-定制
        state.receiveDetailCustomize['product_image1'] = await WMSCommonFile()
            .previewImageFile(receiveDetailData[0]['product_image1']);
      }
      // 判断商品写真2
      if (receiveDetailData[0]['product_image2'] != null &&
          receiveDetailData[0]['product_image2'] != '') {
        // 入荷指示明细-定制
        state.receiveDetailCustomize['product_image2'] = await WMSCommonFile()
            .previewImageFile(receiveDetailData[0]['product_image2']);
      }
      // 关闭加载
      BotToast.closeAllLoading();
      return true;
    } else {
      // 关闭加载
      BotToast.closeAllLoading();
      return false;
    }
  }

  InquiryScheduleDetailsBloc(InquiryScheduleDetailsModel state) : super(state) {
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

      // 查询入荷指示明细
      List<dynamic> data = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_table_dtb_receive_detail', params: {
            'receive_id': state.receiveId,
            'del_kbn': Config.DELETE_NO
          })
          .select('*')
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        // 结果处理
        data[i] = resultProcessing(data[i]);

        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }

      // 查询入荷指示明细总数
      List<dynamic> count = await SupabaseUtils.getClient().rpc(
          'func_zhaoss_query_total_dtb_receive_detail',
          params: {'receive_id': state.receiveId, 'del_kbn': Config.DELETE_NO});
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

      // 自定义事件 - 始
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

      // 查询入荷指示
      List<dynamic> receiveData = await SupabaseUtils.getClient()
          .from('dtb_receive')
          .select('*')
          .eq('del_kbn', Config.DELETE_NO)
          .eq('id', state.receiveId);
      // 判断入荷指示数量
      if (receiveData.length != 0) {
        // 入荷指示-定制
        state.receiveCustomize = receiveData[0];
      } else {
        // 入荷指示-定制
        state.receiveCustomize = {
          'id': '',
          'receive_no': '',
          'rcv_sch_date': '',
          'order_no': '',
          'supplier_id': '',
          'name': '',
          'name_kana': '',
          'postal_cd': '',
          'addr_1': '',
          'addr_2': '',
          'addr_3': '',
          'addr_tel': '',
          'customer_fax': '',
          'importerror_flg': '',
          'note1': '',
          'note2': ''
        };
      }
      // 结果处理
      state.receiveCustomize = resultProcessing(state.receiveCustomize);
      // 自定义事件 - 终

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 自定义事件 - 始
    // 设定入荷指示值事件
    on<SetReceiveValueEvent>((event, emit) async {
      // 入荷指示-临时
      Map<String, dynamic> receiveTemp = Map<String, dynamic>();
      receiveTemp.addAll(state.receiveCustomize);
      // 判断key
      if (receiveTemp[event.key] != null) {
        // 入荷指示-临时
        receiveTemp[event.key] = event.value;
      } else {
        // 入荷指示-临时
        receiveTemp.addAll({event.key: event.value});
      }
      // 入荷指示-定制
      state.receiveCustomize = receiveTemp;

      // 更新
      emit(clone(state));
    });

    // 设定入荷指示集合事件
    on<SetReceiveMapEvent>((event, emit) async {
      // 入荷指示-临时
      Map<String, dynamic> receiveTemp = Map<String, dynamic>();
      receiveTemp.addAll(state.receiveCustomize);
      // 循环值集合
      event.valueMap.forEach((key, value) {
        // 判断key
        if (receiveTemp[key] != null) {
          // 入荷指示-临时
          receiveTemp[key] = value;
        } else {
          // 入荷指示-临时
          receiveTemp.addAll({key: value});
        }
      });
      // 入荷指示-定制
      state.receiveCustomize = receiveTemp;

      // 更新
      emit(clone(state));
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
            .eq('id', state.receiveId)
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

      // 关闭加载
      BotToast.closeAllLoading();

      // 返回上一页
      GoRouter.of(state.rootContext).pop('delete return');
    });

    // 删除入荷指示明细事件
    on<DeleteReceiveDetailEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      try {
        // 修改入荷指示明细
        List<Map<String, dynamic>> receiveDetailData =
            await SupabaseUtils.getClient()
                .from('dtb_receive_detail')
                .update({'del_kbn': Config.DELETE_YES})
                .eq('id', event.receiveDetailId)
                .select('*');
        // 判断入荷指示明细数据
        if (receiveDetailData.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(state.rootContext)!.menu_content_2_5_11 +
                  WMSLocalizations.i18n(state.rootContext)!.delete_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.menu_content_2_5_11 +
                  WMSLocalizations.i18n(state.rootContext)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!.menu_content_2_5_11 +
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

    // 查询入荷指示明细事件
    on<QueryReceiveDetailEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询入荷指示明细
      List<dynamic> receiveDetailData = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_item_dtb_receive_detail', params: {
        'p_id': event.receiveDetailId,
        'p_del_kbn': Config.DELETE_NO,
        'p_rev_ship_kbn': Config.NUMBER_ONE.toString()
      }).select('*');
      // 判断入荷指示明细数量
      if (receiveDetailData.length != 0) {
        // 入荷指示明细-定制
        state.receiveDetailCustomize = receiveDetailData[0];
        // 判断商品写真1
        if (receiveDetailData[0]['product_image1'] != null &&
            receiveDetailData[0]['product_image1'] != '') {
          // 入荷指示明细-定制
          state.receiveDetailCustomize['product_image1'] = await WMSCommonFile()
              .previewImageFile(receiveDetailData[0]['product_image1']);
        }
        // 判断商品写真2
        if (receiveDetailData[0]['product_image2'] != null &&
            receiveDetailData[0]['product_image2'] != '') {
          // 入荷指示明细-定制
          state.receiveDetailCustomize['product_image2'] = await WMSCommonFile()
              .previewImageFile(receiveDetailData[0]['product_image2']);
        }
      } else {
        // 入荷指示明细-定制
        state.receiveDetailCustomize = {
          'id': '',
          'receive_line_no': '',
          'product_id': '',
          'product_code': '',
          'product_name': '',
          'product_price': '',
          'product_num': '',
          'prodect_size': '',
          'product_location_id': '',
          'limit_date': '',
          'lot_no': '',
          'serial_no': '',
          'note1': '',
          'note2': '',
          'product_image1': '',
          'product_image2': '',
          'company_note1': '',
          'company_note2': '',
          'notice_note1': '',
          'notice_note2': ''
        };
      }

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设定入荷指示明细值事件
    on<SetReceiveDetailValueEvent>((event, emit) async {
      // 入荷指示明细-临时
      Map<String, dynamic> receiveDetailTemp = Map<String, dynamic>();
      receiveDetailTemp.addAll(state.receiveDetailCustomize);
      // 判断key
      if (receiveDetailTemp[event.key] != null) {
        // 入荷指示-临时
        receiveDetailTemp[event.key] = event.value;
      } else {
        // 入荷指示-临时
        receiveDetailTemp.addAll({event.key: event.value});
      }
      // 入荷指示明细-定制
      state.receiveDetailCustomize = receiveDetailTemp;

      // 更新
      emit(clone(state));
    });

    // 设定入荷指示明细集合事件
    on<SetReceiveDetailMapEvent>((event, emit) async {
      // 入荷指示明细-临时
      Map<String, dynamic> receiveDetailTemp = Map<String, dynamic>();
      receiveDetailTemp.addAll(state.receiveCustomize);
      // 循环值集合
      event.valueMap.forEach((key, value) {
        // 判断key
        if (receiveDetailTemp[key] != null) {
          // 入荷指示明细-临时
          receiveDetailTemp[key] = value;
        } else {
          // 入荷指示明细-临时
          receiveDetailTemp.addAll({key: value});
        }
      });
      // 入荷指示明细-定制
      state.receiveDetailCustomize = receiveDetailTemp;

      // 更新
      emit(clone(state));
    });
    // 自定义事件 - 终

    add(InitEvent());
  }

  // 结果处理
  dynamic resultProcessing(dynamic data) {
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

  // 检查可操作状态
  Future<bool> checkOperationalStatus(String editOrDelete) async {
    // 查询入荷指示
    List<dynamic> receiveList = await SupabaseUtils.getClient()
        .from('dtb_receive')
        .select('*')
        .eq('id', state.receiveId);
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
}
