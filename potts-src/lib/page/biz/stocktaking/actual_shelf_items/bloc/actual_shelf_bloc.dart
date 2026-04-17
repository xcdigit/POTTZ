import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../file/wms_common_file.dart';
import 'actual_shelf_model.dart';

/**
 * 内容：実棚明細入力
 * 作者：王光顺
 * 时间：2023/10/07
 */
// 事件
abstract class ActualShelfEvent {}

// 初始化事件
class InitEvent extends ActualShelfEvent {
  // 初始化事件
  InitEvent();
}

// location输入事件
class InputLocationEvent extends ActualShelfEvent {
  BuildContext context;
  int a1;
  int a2;
  InputLocationEvent(this.context, this.a1, this.a2);
}

// 设置检索条件
class SetSearchEvent extends ActualShelfEvent {
  // 初始化事件
  String key;
  String searchData;
  SetSearchEvent(this.key, this.searchData);
}

// 查询事件
class QueryEvent extends ActualShelfEvent {
  // 查询用户事件
  QueryEvent();
}

// 计算差值事件
class InputRealEvent extends ActualShelfEvent {
  dynamic value;
  InputRealEvent(this.value);
}

//理由输入事件
class InputReasonEvent extends ActualShelfEvent {
  BuildContext context;
  int realNum;
  String inputreason;
  InputReasonEvent(this.context, this.realNum, this.inputreason);
}

// 设定商品情报值事件
class SetProductValueEvent extends ActualShelfEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetProductValueEvent(this.key, this.value);
}

// 设置input输入值
class ShelfSetInputEvent extends ActualShelfEvent {
  String key;
  dynamic value;
  ShelfSetInputEvent(this.key, this.value);
}

class ActualShelfBloc extends Bloc<ActualShelfEvent, ActualShelfModel> {
  // 刷新补丁
  ActualShelfModel clone(ActualShelfModel src) {
    return ActualShelfModel.clone(src);
  }

  ActualShelfBloc(ActualShelfModel state) : super(state) {
    // 查询事件
    on<QueryEvent>((event, emit) async {
      if (state.actualState == 2) {
        //修改按钮过来需要检索表
        List<dynamic> Data = await SupabaseUtils.getClient()
            .from('dtb_inventory_detail')
            .select('*')
            .eq('end_kbn', '1')
            .eq('del_kbn', '2')
            .eq('id', state.MactualId); //state.actualId

        if (Data.length != 0) {
          for (int i = 0; i < Data.length; i++) {
            state.actualInformation.addAll(Data[i]);
          }

          state.inputLocation = state.actualInformation['location_id'] ?? 0;
          state.inputProduct = state.actualInformation['product_id'] ?? 0;
          ;
          state.inputreason =
              (state.actualInformation['diff_reason'] ?? 0).toString();
          state.realNum = state.actualInformation['real_num'] ?? 0;
          ;
          state.difference = (state.actualInformation['real_num'] ?? 0) -
              (state.actualInformation['logic_num'] ?? 0);

          List<dynamic> productDate = await SupabaseUtils.getClient()
              .from('mtb_product')
              .select('*')
              .eq('id', state.actualInformation['product_id']);

          for (int i = 0; i < productDate.length; i++) {
            state.actualProduct.addAll(productDate[i]);
          }
          if (state.actualProduct['image1'] != null)
            state.image1Network = await WMSCommonFile()
                .previewImageFile(state.actualProduct['image1']);
        }
      }

      // 刷新补丁
      emit(clone(state));
    });

    //输入理由事件
    on<InputReasonEvent>((event, emit) async {
      if (state.difference != 0) {
        await SupabaseUtils.getClient().from('dtb_inventory_detail').update({
          'real_num': event.realNum,
          'diff_reason': event.inputreason,
          'diff_kbn': '1',
          'end_kbn': '1'
        }).eq('id', state.MactualId);
      } else {
        await SupabaseUtils.getClient().from('dtb_inventory_detail').update({
          'real_num': event.realNum,
          'diff_reason': event.inputreason,
          'diff_kbn': '2',
          'end_kbn': '1'
        }).eq('id', state.MactualId);
      }
      state.inputreason = event.inputreason;

      if (state.actualState != 2) {
        //登录状态 要清空页面
        state.actualInformation = {};
        state.actualProduct = {};
        state.difference = 0;
        state.inputLocation = -1;
        state.inputProduct = -1;
        state.image1Network = '';
        state.delKfn = 1;
        state.inputreason = '';
        state.realNum = 0;
        state.loc_cd = '';
        state.pro_code = '';
      }

      add(InitEvent());
    });
    //设置input值
    on<ShelfSetInputEvent>(
      (event, emit) async {
        //非修改状态进入到实棚明细入力
        if (state.actualState != 2) {
          // 打开加载状态
          BotToast.showLoading();

          if (event.key == 'location') {
            state.loc_cd = event.value;
          }
          if (event.key == 'product') {
            state.pro_code = event.value;
          }

          if (state.loc_cd != '' && state.pro_code != '') {
            try {
              //根据页面输入的 ロケーションのバーコード 查询 location 表 这条数据是否存在
              List<dynamic> location_Data = await SupabaseUtils.getClient()
                  .from('mtb_location')
                  .select('*')
                  .eq('del_kbn', '2')
                  .eq('loc_cd', state.loc_cd);
              //根据页面输入的 商品ラベルのバーコード 查询 product 表 这条数据是否存在
              List<dynamic> product_Data = await SupabaseUtils.getClient()
                  .from('mtb_product')
                  .select('*')
                  .eq('del_kbn', '2')
                  .eq('code', state.pro_code);
              //都存在
              if (location_Data.length > 0 && product_Data.length > 0) {
                for (var i = 0; i < location_Data.length; i++) {
                  state.locationData = location_Data[i];
                }
                for (var i = 0; i < product_Data.length; i++) {
                  state.productData = product_Data[i];
                }
                //根据传入的ロケーションのバーコード 和 商品ラベルのバーコード 查询棚卸明細数据是否存在
                List<dynamic> inventoryData = await SupabaseUtils.getClient()
                    .from('dtb_inventory_detail')
                    .select('*')
                    .eq('inventory_id', state.actualId)
                    .eq('location_id', state.locationData['id'])
                    .eq('product_id', state.productData['id'])
                    .eq('del_kbn', '2');
                //明细存在
                if (inventoryData.length > 0) {
                  for (var i = 0; i < inventoryData.length; i++) {
                    state.actualInformation = inventoryData[i];
                  }
                  state.actualInformation.addAll({'loc_cd': state.loc_cd});
                  state.actualInformation.addAll({'code': state.pro_code});

                  //棚卸明細id
                  state.MactualId = state.actualInformation['id'] ?? 0;
                  //差異理由
                  state.inputreason =
                      state.actualInformation['diff_reason'] ?? ''.toString();
                  //差异数量
                  state.difference =
                      (state.actualInformation['real_num'] ?? 0) -
                          (state.actualInformation['logic_num'] ?? 0);

                  //実際の数量
                  state.realNum = state.actualInformation['real_num'] ?? 0;
                  state.actualProduct.addAll(state.productData);
                  // 获取图片
                  if (state.actualProduct['image1'] != null) {
                    state.image1Network = await WMSCommonFile()
                        .previewImageFile(state.actualProduct['image1']);
                    state.delKfn = 0;
                  }
                } else {
                  WMSCommonBlocUtils.errorTextToast(
                      WMSLocalizations.i18n(state.rootBuildContext)!
                          .Actual_Shelf_22);
                }
              } else {
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.rootBuildContext)!
                        .Actual_Shelf_16);
              }
            } catch (e) {
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.rootBuildContext)!
                      .Actual_Shelf_16);
              // 关闭加载
              BotToast.closeAllLoading();
            }
          } else {
            Map<String, dynamic> act = Map<String, dynamic>();
            act.addAll(state.actualInformation);
            act.addAll({'logic_num': 0});
            act.addAll({'loc_cd': state.loc_cd});
            act.addAll({'code': state.pro_code});
            state.actualInformation = act;
            state.actualProduct = {};
            state.difference = 0;
            state.realNum = 0;
            state.image1Network = '';
            state.delKfn = 1;
            state.inputreason = '';
          }

          emit(clone(state));
          // 关闭加载
          BotToast.closeAllLoading();
        }
      },
    );
    on<InputLocationEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      List<dynamic> Date = [];
      add(InitEvent());
      if (event.a2 != '' && event.a1 != '') {
        Date = await SupabaseUtils.getClient()
            .from('dtb_inventory_detail')
            .select('*')
            .eq('location_id', event.a1)
            .eq('product_id', event.a2);
        if (Date.length == 0) {
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.Actual_Shelf_16);
          //错误则重置数据 防止脏数据
          state.actualInformation = {};
          state.actualProduct = {};
          state.difference = 0;
          state.inputLocation = -1;
          state.inputProduct = -1;
          state.image1Network = '';
          state.delKfn = 1;
          state.inputreason = '';

          // 刷新补丁
          emit(clone(state));
        } else {
          for (int i = 0; i < Date.length; i++) {
            state.actualInformation.addAll(Date[i]);
          }

          state.MactualId = state.actualInformation['id'] ?? 0;
          state.inputLocation = event.a1;
          state.inputProduct = event.a2;
          state.inputreason =
              state.actualInformation['diff_reason'] ?? ''.toString();
          state.difference = (state.actualInformation['real_num'] ?? 0) -
              (state.actualInformation['logic_num'] ?? 0);

          state.realNum = state.actualInformation['real_num'] ?? 0;

          List<dynamic> productDate = await SupabaseUtils.getClient()
              .from('mtb_product')
              .select('*')
              .eq('id', state.actualInformation['product_id']);

          for (int i = 0; i < productDate.length; i++) {
            state.actualProduct.addAll(productDate[i]);
          }

          if (state.actualProduct['image1'] != null)
            state.image1Network = await WMSCommonFile()
                .previewImageFile(state.actualProduct['image1']);
          state.delKfn = 0;
          // 刷新补丁
          emit(clone(state));
        }
      }

      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<InputRealEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      if (event.value != 0) {
        state.realNum = int.parse(event.value);
        if (state.actualInformation.length != 0) {
          int num = state.actualInformation['logic_num'] != ''
              ? state.actualInformation['logic_num']
              : 0;
          state.difference = state.realNum - num;
        } else {
          state.difference = 0;
        }
      } else {
        state.realNum = 0;
      }
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      List<dynamic> inventoryData = await SupabaseUtils.getClient()
          .from('dtb_inventory_detail')
          .select('*')
          .eq('inventory_id', state.actualId)
          .eq('del_kbn', '2');

      int logicNum = 0;
      int HlogicNum = 0;
      //统计进度
      for (int i = 0; i < inventoryData.length; i++) {
        //总数
        HlogicNum += inventoryData[i]['logic_num'] == null
            ? 0
            : int.parse(inventoryData[i]['logic_num'].toString());
        //完了チェック 1：on 盘点完成的数据
        if (inventoryData[i]['end_kbn'] == '1') {
          logicNum += inventoryData[i]['logic_num'] == null
              ? 0
              : int.parse(inventoryData[i]['logic_num'].toString());
        }
      }
      state.logicNum = logicNum;
      state.HlogicNum = HlogicNum;
      if (logicNum != 0 && HlogicNum != 0)
        state.progress = logicNum / HlogicNum;
      else
        state.progress = 0;

      if (state.actualState == 2) {
        //加载商品信息，如果是修正状态跳转
        List<dynamic> Date = await SupabaseUtils.getClient()
            .from('dtb_inventory_detail')
            .select('*')
            .eq('location_id', state.inputLocation)
            .eq('product_id', state.inputProduct)
            .eq('del_kbn', '2');

        for (int i = 0; i < Date.length; i++) {
          state.actualInformation.addAll(Date[i]);
        }
        state.MactualId = state.actualInformation['id'] ?? 0;
        state.inputLocation = state.inputLocation;
        state.inputProduct = state.inputProduct;
        state.inputreason =
            (state.actualInformation['diff_reason'] ?? "").toString();
        state.difference = (state.actualInformation['real_num'] ?? 0) -
            (state.actualInformation['logic_num'] ?? 0);
        state.realNum = state.actualInformation['real_num'] ?? 0;

        //获取位置表ロケーションマスタ（mtb_location）的 loc_cd值
        if (state.actualInformation['location_id'] != null) {
          List<dynamic> locationData = await SupabaseUtils.getClient()
              .from('mtb_location')
              .select('*')
              .eq('id', state.actualInformation['location_id']);
          for (var i = 0; i < locationData.length; i++) {
            state.actualInformation
                .addAll({"loc_cd": locationData[i]['loc_cd']});
          }
        }
        //获取商品（mtb_product）的Jan_cd值 和 商品图片
        if (state.actualInformation['product_id'] != null) {
          List<dynamic> productDate = await SupabaseUtils.getClient()
              .from('mtb_product')
              .select('*')
              .eq('id', state.actualInformation['product_id']);

          for (int i = 0; i < productDate.length; i++) {
            state.actualProduct.addAll(productDate[i]);
            state.actualInformation.addAll({"code": productDate[i]['code']});
          }

          if (state.actualProduct['image1'] != null &&
              state.actualProduct['image1'] != '') {
            // 出荷指示明细-定制
            try {
              state.actualProduct['image1'] = await WMSCommonFile()
                  .previewImageFile(state.actualProduct['image1']);
            } catch (e) {
              // 在这里处理异常
              state.actualProduct['image1'] = '';
            }
          }
          if (state.actualProduct['image1'] != null &&
              state.actualProduct['image1'] != '') {
            // 出荷指示明细-定制
            try {
              state.actualProduct['image1'] = await WMSCommonFile()
                  .previewImageFile(state.actualProduct['image1']);
            } catch (e) {
              // 在这里处理异常
              state.actualProduct['image1'] = '';
            }
          }

          state.delKfn = 0;
        }
      }
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    add(QueryEvent());
    add(InitEvent());
  }
}
