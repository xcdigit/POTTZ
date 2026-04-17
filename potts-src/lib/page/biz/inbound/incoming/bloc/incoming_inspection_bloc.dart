import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/utils/check_utils.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/common_utils.dart';
import '../../../../../common/utils/printer_utils.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'incoming_inspection_model.dart';

/**
 * 内容：入荷検品-BLOC
 * 作者：熊草云
 * 时间：2023/09/21
 */
// 事件
abstract class IncomingInspectionEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends IncomingInspectionEvent {
  // 初始化事件
  InitEvent();
}

// 检索 入荷予定一覧バーコード
class QueryArrivalNumberEvent extends IncomingInspectionEvent {
  String arrivalId;
  QueryArrivalNumberEvent(this.arrivalId);
// 初始化事件
}

// 检索 入荷予定明細のバーコード
class QueryArrivalDetailEvent extends IncomingInspectionEvent {
  BuildContext context;
  String arrivalNo;
  QueryArrivalDetailEvent(this.context, this.arrivalNo);
// 初始化事件
}

class UpdataGoodsEvent extends IncomingInspectionEvent {
  UpdataGoodsEvent();
}

// SetGoodsNullEvent
class SetGoodsNullEvent extends IncomingInspectionEvent {
  SetGoodsNullEvent();
}

class SetGoodsDetailNullEvent extends IncomingInspectionEvent {
  SetGoodsDetailNullEvent();
}

//设置检品数
class UpdataChecknumEvent extends IncomingInspectionEvent {
  String check_num;
  UpdataChecknumEvent(this.check_num);
}

// 设置出荷id
class SetReCeiveIdEvent extends IncomingInspectionEvent {
  int receiveId;
  SetReCeiveIdEvent(this.receiveId);
}

// 赵士淞 - 始
// 打印事件
class PrinterEvent extends IncomingInspectionEvent {
  // 打印事件
  PrinterEvent();
}
// 赵士淞 - 终

// 自定义事件 - 终
class IncomingInspectionBloc extends WmsTableBloc<IncomingInspectionModel> {
  // 刷新补丁
  @override
  IncomingInspectionModel clone(IncomingInspectionModel src) {
    return IncomingInspectionModel.clone(src);
  }

  bool _flag = false;
  IncomingInspectionBloc(IncomingInspectionModel state) : super(state) {
    on<SetGoodsNullEvent>((event, emit) async {
      state.qrCode1 = '';
      state.qrCode2 = '';
      state.receive = {};
      state.receiveDetailList = [];
      state.receiveDetail = {};
      state.number = 0;
      state.receive_no = '';
      state.receive_name = '';
      state.detail_code = '';
      state.detail_name = '';
      state.detail_product_num = '';
      state.detail_check_num = '';
      state.detail_image = '';
      if (_flag) {
        BotToast.closeAllLoading();
      }
      _flag = false;
      // 刷新补丁
      emit(clone(state));
    });
    on<SetGoodsDetailNullEvent>((event, emit) async {
      state.qrCode2 = '';
      state.receiveDetail = {};
      state.detail_code = '';
      state.detail_name = '';
      state.detail_product_num = '';
      state.detail_check_num = '';
      state.detail_image = '';
      // 刷新补丁
      emit(clone(state));
    });

    on<QueryArrivalNumberEvent>((event, emit) async {
      // ignore: unnecessary_null_comparison
      if (event.arrivalId == '' || event.arrivalId == null) {
        add(SetGoodsNullEvent());
        return;
      } else if (CheckUtils.check_Half_Alphanumeric_Symbol(event.arrivalId)) {
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.context)!
                .incoming_inspection_expected_barcode +
            WMSLocalizations.i18n(state.context)!
                .check_half_width_alphanumeric_with_symbol);
        return;
      }
      BotToast.showLoading();
      List<dynamic> data = await SupabaseUtils.getClient()
          .from('dtb_receive')
          .select('*')
          .eq('receive_no', event.arrivalId)
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id as int)
          .eq('del_kbn', Config.DELETE_NO)
          .is_('importerror_flg', null);
      //补丁：importerror_flg是EMPTY的情况
      if (data.length == 0) {
        data = await SupabaseUtils.getClient()
            .from('dtb_receive')
            .select('*')
            .eq('receive_no', event.arrivalId)
            .eq(
                'company_id',
                StoreProvider.of<WMSState>(state.context)
                    .state
                    .loginUser
                    ?.company_id as int)
            .eq('del_kbn', Config.DELETE_NO)
            .eq('importerror_flg', '');
      }

      // 1-1检索结果为空，提示【请输入正确的バーコード】;
      if (data.length == 0) {
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.context)!.incoming_inspection_1);
        add(SetGoodsNullEvent());
      } else if (data[0]['receive_kbn'] != Config.RECEIVE_KBN_WAIT_INSPECT) {
        // 1-2如果检索结果的【入荷状態】！=【1:检品待ち】
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.context)!.incoming_inspection_2);
        add(SetGoodsNullEvent());
      } else {
        state.qrCode1 = event.arrivalId;
        state.receive = data[0];
        state.receive_no = data[0]['receive_no'];
        state.receive_name = data[0]['name'];
        List<dynamic> dataDetail = await SupabaseUtils.getClient()
            .from('dtb_receive_detail')
            .select('*')
            .eq('receive_id', data[0]['id'])
            .eq('del_kbn', Config.DELETE_NO);
        if (dataDetail.length == 0) {
          add(SetGoodsNullEvent());
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(state.context)!.incoming_inspection_tip_4);
          BotToast.closeAllLoading();
          return;
        }
        state.receiveDetailList = dataDetail;
        state.receive['datalength'] = dataDetail.length;
        //设定页面显示比例数字
        List<dynamic> dataDetailNum = await SupabaseUtils.getClient()
            .from('dtb_receive_detail')
            .select('*')
            .eq('receive_id', state.receiveDetailList[0]['receive_id'])
            .eq('check_kbn', Config.DELETE_NO)
            .eq('del_kbn', Config.DELETE_NO);
        state.number = state.receive['datalength'] - dataDetailNum.length;
      }
      // 刷新补丁
      emit(clone(state));
      BotToast.closeAllLoading();
    });

    on<QueryArrivalDetailEvent>((event, emit) async {
      if (CheckUtils.check_Half_Alphanumeric_Symbol(event.arrivalNo)) {
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
                .incoming_inspection_receipt_barcode +
            WMSLocalizations.i18n(event.context)!
                .check_half_width_alphanumeric_with_symbol);
        return;
      }
      BotToast.showLoading();
      List<dynamic> detailData = await SupabaseUtils.getClient().rpc(
          'func_query_table_dtb_receive_detail_incoming_inspection',
          params: {
            "p_detailno": event.arrivalNo,
            'p_receive_id': state.receive['id'],
          }).select();
      if (detailData.length == 0) {
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.incoming_inspection_1);
        add(SetGoodsDetailNullEvent());
      } else {
        try {
          // ignore: unnecessary_null_comparison
          if (detailData[0]['image1'] != null &&
              detailData[0]['image1'] != '') {
            detailData[0]['image1'] =
                await WMSCommonFile().previewImageFile(detailData[0]['image1']);
          }
        } catch (e) {
          detailData[0]['image1'] = '';
        }
        state.qrCode2 = event.arrivalNo;
        state.receiveDetail = detailData[0];
        state.detail_code = detailData[0]['code'];
        state.detail_name = detailData[0]['name'];
        state.detail_product_num = detailData[0]['product_num'].toString();
        state.detail_check_num = detailData[0]['check_num'] == null
            ? detailData[0]['product_num'].toString()
            : detailData[0]['check_num'].toString();
        state.detail_image = detailData[0]['image1'];
      }

      emit(clone(state));
      BotToast.closeAllLoading();
    });

    ///
    on<UpdataGoodsEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      await SupabaseUtils.getClient()
          .from('dtb_receive_detail')
          .update({
            'check_num': state.receiveDetail['check_num'] == null
                ? state.receiveDetail['product_num']
                : state.receiveDetail['check_num'],
            'check_kbn': '1'
          })
          .eq("receive_line_no", state.receiveDetail['receive_line_no'])
          .eq('id', state.receiveDetail['id']);

      List<dynamic> dataDetail = await SupabaseUtils.getClient()
          .from('dtb_receive_detail')
          .select('*')
          .eq('receive_id', state.receiveDetailList[0]['receive_id'])
          .eq('check_kbn', Config.DELETE_NO)
          .eq('del_kbn', Config.DELETE_NO);
      //设定页面显示比例数字
      state.number = state.receive['datalength'] - dataDetail.length;
      if (dataDetail.length == 0) {
        // 4-1 更新表【dtb_receive(入荷予定)】 字段【入荷状態】=【2:入庫待ち】
        await SupabaseUtils.getClient()
            .from('dtb_receive')
            .update({'receive_kbn': Config.RECEIVE_KBN_WAIT_INBOUND}).eq(
                'id', state.receive['id']);
        //插入操作履历 sys_log表
        CommonUtils().createLogInfo(
            '入荷検品（NO：' +
                state.receive['receive_no'].toString() +
                '）' +
                Config.OPERATION_TEXT1 +
                Config.OPERATION_BUTTON_TEXT3 +
                Config.OPERATION_TEXT2,
            "UpdataGoodsEvent()",
            StoreProvider.of<WMSState>(state.context)
                .state
                .loginUser!
                .company_id,
            StoreProvider.of<WMSState>(state.context).state.loginUser!.id);
      }

      add(SetGoodsDetailNullEvent());
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<UpdataChecknumEvent>((event, emit) async {
      state.detail_check_num = event.check_num;
      emit(clone(state));
    });
    on<InitEvent>((event, emit) async {
      BotToast.showLoading();
      _flag = true;
      add(SetGoodsNullEvent());
    });

    // 赵士淞 - 始
    // 打印事件
    on<PrinterEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询商品
      List<dynamic> productData = await SupabaseUtils.getClient()
          .from('mtb_product')
          .select('*')
          .eq('id', state.receiveDetail['product_id']);
      // 判断商品数量
      if (productData.length != 0) {
        // 打印数据
        Map<String, dynamic> printData = {
          'code': state.qrCode2,
          'name': productData[0]['name_short'],
          'number': state.detail_check_num,
          'type': productData[0]['packing_type'],
          'no': productData[0]['code'],
          'company_name': state.receive_name,
        };
        // 商品ラベル打印
        PrinterUtils.productInfoPrint(3, printData);
      } else {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.context)!.miss_param_unable_print);
      }

      // 关闭加载
      BotToast.closeAllLoading();
    });
    // 赵士淞 - 终

    if (state.receiveNo == null) {
      add(InitEvent());
    } else {
      add(QueryArrivalNumberEvent(state.receiveNo!));
    }
  }
}
