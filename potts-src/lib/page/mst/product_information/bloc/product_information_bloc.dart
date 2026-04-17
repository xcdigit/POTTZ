import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../file/wms_common_file.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../home/bloc/home_menu_bloc.dart';
import 'product_information_model.dart';

/**
 * 内容：商品情报-BLOC
 * 作者：赵士淞
 * 时间：2024/10/28
 */
// 事件
abstract class ProductInformationEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends ProductInformationEvent {
  // 初始化事件
  InitEvent();
}

// 刷新数据事件
class RefreshDataEvent extends ProductInformationEvent {
  // 参数
  ProductInformationModel model;
  // 刷新数据事件
  RefreshDataEvent(this.model);
}

// 打开商品管理页面事件
class OpenProductMasterManagementPageEvent extends ProductInformationEvent {
  // 打开商品管理页面事件
  OpenProductMasterManagementPageEvent();
}

// 打开出荷指示照会页面事件
class OpenDisplayInstructionPageEvent extends ProductInformationEvent {
  // 打开出荷指示照会页面事件
  OpenDisplayInstructionPageEvent();
}

// 打开出庫照会页面事件
class OpenOutboundQueryCommodityPageEvent extends ProductInformationEvent {
  // 打开出庫照会页面事件
  OpenOutboundQueryCommodityPageEvent();
}

// 打开ピッキングリスト （シングル）页面事件
class OpenPickListCommodityPageEvent extends ProductInformationEvent {
  // 打开ピッキングリスト （シングル）页面事件
  OpenPickListCommodityPageEvent();
}

// 打开入荷予定照会页面事件
class OpenInquirySchedulePageEvent extends ProductInformationEvent {
  // 打开入荷予定照会页面事件
  OpenInquirySchedulePageEvent();
}

// 打开入荷检品页面事件
class OpenIncomingInspectionPageEvent extends ProductInformationEvent {
  // 打开入荷检品页面事件
  OpenIncomingInspectionPageEvent();
}

// 打开入庫照会页面事件
class OpenWarehouseQueryCommodityPageEvent extends ProductInformationEvent {
  // 打开入庫照会页面事件
  OpenWarehouseQueryCommodityPageEvent();
}

// 打开在库照会页面事件
class OpenInventoryInquiryPageEvent extends ProductInformationEvent {
  // 打开在库照会页面事件
  OpenInventoryInquiryPageEvent();
}

class ProductInformationBloc extends WmsTableBloc<ProductInformationModel> {
  // 刷新补丁
  @override
  ProductInformationModel clone(ProductInformationModel src) {
    return ProductInformationModel.clone(src);
  }

  ProductInformationBloc(ProductInformationModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 角色ID
      state.roleId = StoreProvider.of<WMSState>(state.rootContext)
          .state
          .loginUser!
          .role_id as int;

      // 查询商品情报
      await searchProductInformation('init_code');
      // 判断商品情报
      if (state.productInfo['id'] == null || state.productInfo['id'] == '') {
        // 查询商品情报
        await searchProductInformation('init_jan_cd');
        // 判断商品情报
        if (state.productInfo['id'] == null || state.productInfo['id'] == '') {
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .product_information_no_product_information_found);
        }
      }

      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 刷新数据事件
    on<RefreshDataEvent>((event, emit) async {
      // 更新
      emit(clone(event.model));
    });

    // 打开商品管理页面事件
    on<OpenProductMasterManagementPageEvent>((event, emit) async {
      // 跳转页面
      GoRouter.of(state.rootContext).push('/productMaster');
      // 触发菜单变更事件
      state.rootContext.read<HomeMenuBloc>().add(
            ChangeMenuEvent(
              state.rootContext.read<HomeMenuBloc>().state.menuList[5],
              state.rootContext,
            ),
          );
    });

    // 打开出荷指示照会页面事件
    on<OpenDisplayInstructionPageEvent>((event, emit) async {
      // 跳转页面
      GoRouter.of(state.rootContext).push('/' + Config.PAGE_FLAG_3_5);
      // 触发菜单变更事件
      state.rootContext.read<HomeMenuBloc>().add(
            ChangeMenuEvent(
              state.rootContext.read<HomeMenuBloc>().state.menuList[2],
              state.rootContext,
            ),
          );
    });

    // 打开出庫照会页面事件
    on<OpenOutboundQueryCommodityPageEvent>((event, emit) async {
      // 跳转页面
      GoRouter.of(state.rootContext).push('/' + Config.PAGE_FLAG_3_16);
      // 触发菜单变更事件
      state.rootContext.read<HomeMenuBloc>().add(
            ChangeMenuEvent(
              state.rootContext.read<HomeMenuBloc>().state.menuList[2],
              state.rootContext,
            ),
          );
    });

    // 打开ピッキングリスト （シングル）页面事件
    on<OpenPickListCommodityPageEvent>((event, emit) async {
      // 跳转页面
      GoRouter.of(state.rootContext).push('/' + Config.PAGE_FLAG_3_8);
      // 触发菜单变更事件
      state.rootContext.read<HomeMenuBloc>().add(
            ChangeMenuEvent(
              state.rootContext.read<HomeMenuBloc>().state.menuList[2],
              state.rootContext,
            ),
          );
    });

    // 打开入荷予定照会页面事件
    on<OpenInquirySchedulePageEvent>((event, emit) async {
      // 跳转页面
      GoRouter.of(state.rootContext).push('/' + Config.PAGE_FLAG_2_5);
      // 触发菜单变更事件
      state.rootContext.read<HomeMenuBloc>().add(
            ChangeMenuEvent(
              state.rootContext.read<HomeMenuBloc>().state.menuList[1],
              state.rootContext,
            ),
          );
    });

    // 打开入荷检品页面事件
    on<OpenIncomingInspectionPageEvent>((event, emit) async {
      // 跳转页面
      GoRouter.of(state.rootContext).push('/' + Config.PAGE_FLAG_2_4);
      // 触发菜单变更事件
      state.rootContext.read<HomeMenuBloc>().add(
            ChangeMenuEvent(
              state.rootContext.read<HomeMenuBloc>().state.menuList[1],
              state.rootContext,
            ),
          );
    });

    // 打开入庫照会页面事件
    on<OpenWarehouseQueryCommodityPageEvent>((event, emit) async {
      // 跳转页面
      GoRouter.of(state.rootContext).push('/' + Config.PAGE_FLAG_2_7);
      // 触发菜单变更事件
      state.rootContext.read<HomeMenuBloc>().add(
            ChangeMenuEvent(
              state.rootContext.read<HomeMenuBloc>().state.menuList[1],
              state.rootContext,
            ),
          );
    });

    // 打开在库照会页面事件
    on<OpenInventoryInquiryPageEvent>((event, emit) async {
      // 跳转页面
      GoRouter.of(state.rootContext).push('/' + Config.PAGE_FLAG_4_1);
      // 触发菜单变更事件
      state.rootContext.read<HomeMenuBloc>().add(
            ChangeMenuEvent(
              state.rootContext.read<HomeMenuBloc>().state.menuList[3],
              state.rootContext,
            ),
          );
    });

    add(InitEvent());
  }

  // 设定商品情报值
  Future<bool> setProductInfoValue(
      String key, dynamic value, ProductInformationModel state) async {
    // 页数
    state.pageNum = 0;
    // 列表数据清空
    state.records.clear();
    // 总数
    state.total = 0;
    // 初期化商品情报
    initBasic(state);
    // 初始化在制品情报
    initDesign(state);
    // 初始化图标情报
    initTrend(state);

    // 商品情报-临时
    Map<String, dynamic> productInfoTemp = Map<String, dynamic>();
    productInfoTemp.addAll(state.productInfo);
    // 判断key
    if (productInfoTemp[key] != null) {
      // 商品情报-临时
      productInfoTemp[key] = value;
    } else {
      // 商品情报-临时
      productInfoTemp.addAll({key: value});
    }
    // 商品情报-定制
    state.productInfo = productInfoTemp;

    // 查询商品情报
    return await searchProductInformation(key);
  }

  // 初期化商品情报
  void initBasic(ProductInformationModel state) {
    // 商品情报
    state.productInfo = {
      'id': '',
      'code': '',
      'name': '',
      'name_short': '',
      'jan_cd': '',
      'category_l': '',
      'category_m': '',
      'category_s': '',
      'size': '',
      'packing_type': '',
      'packing_num': '',
      'image1': '',
      'image2': '',
      'company_note1': '',
      'company_note2': '',
      'notice_note1': '',
      'notice_note2': '',
      'company_id': '',
      'company_name': ''
    };
    // 写真1展示路径
    state.image1Network = '';
  }

  // 初始化在制品情报
  void initDesign(ProductInformationModel state) {
    // 出荷指示済数
    state.shipmentNumber = 0;
    // 未出荷数
    state.unshippedNumber = 0;
    // 本日出荷指示数
    state.shipmentNumberToday = 0;
    // 本日未出荷数
    state.unshippedNumberToday = 0;
    // 未出庫数
    state.unoutboundNumber = 0;
    // 未ピッキング数
    state.unpickingNumber = 0;
    // 入荷予定数
    state.expectedNumber = 0;
    // 未入荷数
    state.unexpectedNumber = 0;
    // 本日入荷予定数
    state.expectedNumberToday = 0;
    // 本日未入荷数
    state.unexpectedNumberToday = 0;
    // 未検品数
    state.uncheckedNumber = 0;
    // 未入庫数
    state.unlistedNumber = 0;
  }

  // 初始化图标情报
  void initTrend(ProductInformationModel state) {
    // 出荷先（上位５社）
    state.shipmentTopFive = [];
    // 入荷元（上位５社）
    state.entranceTopFive = [];
    // 出荷数（月単位）
    state.shipmentMonth = [];
    // 入荷数（月単位）
    state.entranceMonth = [];
  }

  // 查询商品情报
  Future<bool> searchProductInformation(String flag) async {
    // 标记
    bool mark = true;
    // 打开加载状态
    BotToast.showLoading();

    // 查询商品マスタ
    var query = SupabaseUtils.getClient().from('mtb_product').select('*');
    // 判断标记
    if (flag == 'init_code') {
      query = query.eq('code', state.productCodeOrJanCd);
    } else if (flag == 'init_jan_cd') {
      query = query.eq('jan_cd', state.productCodeOrJanCd);
    } else if (flag == 'code') {
      query = query.eq('code', state.productInfo['code']);
    } else if (flag == 'jan_cd') {
      query = query.eq('jan_cd', state.productInfo['jan_cd']);
    }
    // 登录角色不是超级管理员
    if (Config.ROLE_ID_1 != state.roleId) {
      query = query.eq(
          'company_id',
          StoreProvider.of<WMSState>(state.rootContext)
              .state
              .loginUser!
              .company_id as int);
    }
    List<dynamic> data = await query.order('id', ascending: false);

    // 判断商品マスタ数量
    if (data.length == 0) {
      // 标记
      mark = false;
    } else if (data.length > 1) {
      // 消息提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.rootContext)!
              .product_information_multiple_product_information_found);
    } else {
      // 商品情报
      state.productInfo = data[0];

      if (state.productInfo['image1'] != null &&
          state.productInfo['image1'] != "") {
        // 写真1展示路径
        state.image1Network =
            await WMSCommonFile().previewImageFile(state.productInfo['image1']);
      }

      // 获取在制品数据
      await getDesignData(state);

      // 获取在库数据
      await getInventoryData(state);

      // 获取图表数据
      await getTrendData(state);

      // 刷新数据事件
      add(RefreshDataEvent(state));
    }

    // 关闭加载
    BotToast.closeAllLoading();
    // 返回
    return mark;
  }

  // 获取在制品数据
  Future<void> getDesignData(ProductInformationModel state) async {
    // 出荷指示済数
    List<dynamic> data1 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_ship_count_information_1', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    state.shipmentNumber = data1[0]['statistics'];
    // 未出荷数
    List<dynamic> data2 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_ship_count_information_2', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    state.unshippedNumber = data2[0]['statistics'];
    // 本日出荷指示数
    List<dynamic> data3 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_ship_count_information_3', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    state.shipmentNumberToday = data3[0]['statistics'];
    // 本日未出荷数
    List<dynamic> data4 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_ship_count_information_4', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    state.unshippedNumberToday = data4[0]['statistics'];
    // 未出庫数
    List<dynamic> data5 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_ship_count_information_5', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    state.unoutboundNumber = data5[0]['statistics'];
    // 未ピッキング数
    List<dynamic> data6 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_ship_count_information_6', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    state.unpickingNumber = data6[0]['statistics'];
    // 入荷予定数
    List<dynamic> data7 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_receive_count_information_1', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    state.expectedNumber = data7[0]['statistics'];
    // 未入荷数
    List<dynamic> data8 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_receive_count_information_2', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    state.unexpectedNumber = data8[0]['statistics'];
    // 本日入荷予定数
    List<dynamic> data9 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_receive_count_information_3', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    state.expectedNumberToday = data9[0]['statistics'];
    // 本日未入荷数
    List<dynamic> data10 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_receive_count_information_4', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    state.unexpectedNumberToday = data10[0]['statistics'];
    // 未検品数
    List<dynamic> data11 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_receive_count_information_5', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    state.uncheckedNumber = data11[0]['statistics'];
    // 未入庫数
    List<dynamic> data12 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_receive_count_information_6', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    state.unlistedNumber = data12[0]['statistics'];
  }

  // 获取在库数据
  Future<void> getInventoryData(ProductInformationModel state) async {
    // 查询商品在庫位置
    List<dynamic> data = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_query_item_dtb_product_location', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    // 列表数据清空
    state.records.clear();
    // 循环在庫照会数据
    for (int i = 0; i < data.length; i++) {
      // 列表数据增加
      state.records.add(WmsRecordModel(i, data[i]));
    }
    // 总页数
    state.total = data.length;
  }

  // 获取图表数据
  Future<void> getTrendData(ProductInformationModel state) async {
    // 出荷先（上位５社）
    List<dynamic> data1 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_ship_pie_chart', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    state.shipmentTopFive = data1;

    // 入荷元（上位５社）
    List<dynamic> data2 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_receive_pie_chart', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    state.entranceTopFive = data2;

    // 出荷数（月単位）
    List<dynamic> data3 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_ship_bar_chart', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    List<dynamic> tempShipmentMonth = [];
    for (int i = 1; i <= 12; i++) {
      for (int j = 0; j < data3.length; j++) {
        if (i == int.parse(data3[j]['month'])) {
          tempShipmentMonth.add(data3[j]);
          break;
        }
        if (j == data3.length - 1) {
          tempShipmentMonth.add({'month': i, 'statistics': 0});
        }
      }
    }
    state.shipmentMonth = tempShipmentMonth;

    // 入荷数（月単位）
    List<dynamic> data4 = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_receive_bar_chart', params: {
      'product_id': state.productInfo['id'],
    }).select('*');
    List<dynamic> tempEntranceMonth = [];
    for (int i = 1; i <= 12; i++) {
      for (int j = 0; j < data4.length; j++) {
        if (i == int.parse(data4[j]['month'])) {
          tempEntranceMonth.add(data4[j]);
          break;
        }
        if (j == data4.length - 1) {
          tempEntranceMonth.add({'month': i, 'statistics': 0});
        }
      }
    }
    state.entranceMonth = tempEntranceMonth;
  }
}
