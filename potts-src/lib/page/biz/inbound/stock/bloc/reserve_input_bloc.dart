import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/model/receive_detail.dart';
import 'package:wms/page/biz/inbound/stock/bloc/reserve_input_model.dart';

import '../../../../../bloc/wms_common_bloc.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/common_utils.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../model/receive.dart';

import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';

/**
 * 内容：入荷予定入力-BLOC
 * 作者：王光顺
 * 时间：2023/09/12
 * 作者：luxy
 * 时间：2023/10/17
 */
// 事件
abstract class ReserveInputEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends ReserveInputEvent {
  // 初始化事件
  InitEvent();
}

// 导入CSV文件事件
class ImportCSVFileEvent extends ReserveInputEvent {
  // 结构树
  BuildContext context;
  // 内容
  List<List<Map<String, dynamic>>> content;
  // 导入CSV文件事件
  ImportCSVFileEvent(this.context, this.content);
}

// 自定义事件 - 始
// 设定弹窗值事件
class SetReceiveValueEvent extends ReserveInputEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetReceiveValueEvent(this.key, this.value);
}

// 设定基本情报值事件
class SetReserveValueEvent extends ReserveInputEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetReserveValueEvent(this.key, this.value);
}

// 赵士淞 - 始
// 设定基本情报集合事件
class SetReserveMapEvent extends ReserveInputEvent {
  // 值集合
  Map<String, dynamic> valueMap;
  // 设定集合事件
  SetReserveMapEvent(this.valueMap);
}
// 赵士淞 - 终

// 保存入荷予定表单事件
class SaveReceiveFormEvent extends ReserveInputEvent {
  // 结构树
  BuildContext context;
  // 入荷予定-结构
  Map<String, dynamic> receiveStructure = {};
  // 保存入荷予定表单事件
  SaveReceiveFormEvent(this.context, this.receiveStructure);
}

// 判断入荷予定表单是否存在内容
class QueryReceiveDetailEvent extends ReserveInputEvent {
  // 入荷予ID
  int receiveId;
  // 判断入荷予定表单是否存在内容
  QueryReceiveDetailEvent(this.receiveId);
}

// 保存弹窗入荷予定明细商品信息赋值
class SaveOtherProductEvent extends ReserveInputEvent {
  Map<String, dynamic> productData = {};
  // 保存弹窗入荷予定明细商品信息赋值
  SaveOtherProductEvent(this.productData);
}

// 保存弹窗入荷予定明细弹框事件
class SaveReceiveDetailFormEvent extends ReserveInputEvent {
  BuildContext context;
  Map<String, dynamic> data;
  // 保存入荷予定明细弹框事件
  SaveReceiveDetailFormEvent(this.context, this.data);
}

// 保存弹窗入荷予定明细表单事件
class registrationReceiveDetailFormEvent extends ReserveInputEvent {
  BuildContext context;
  Map<String, dynamic> data;
  int receiveId;
  // 保存入荷予定明细表单事件
  registrationReceiveDetailFormEvent(this.context, this.data, this.receiveId);
}

// 入荷予定明细表弹窗删除方法
class delectEvent extends ReserveInputEvent {
  // 结构树
  BuildContext context;
  String value;
  //  入荷予定明细表弹窗删除方法
  delectEvent(this.context, this.value);
}

// 处理入荷予定明细表行NO
class handleReceiveLineNoEvent extends ReserveInputEvent {
  Map<String, dynamic> data = {};
  // 处理入荷予定明细表行NO
  handleReceiveLineNoEvent(this.data);
}

// 处理商品写真路径
class handleProductImageEvent extends ReserveInputEvent {
  Map<String, dynamic> data = {};
  // 处理商品写真路径
  handleProductImageEvent(this.data);
}

// 当前下标变更事件
class CurrentIndexChangeEvent extends ReserveInputEvent {
  // 内容
  int value;
  // 当前下标变更事件
  CurrentIndexChangeEvent(this.value);
}
// 自定义事件 - 终

class ReserveInputBloc extends WmsTableBloc<ReserveInputModel> {
  // 刷新补丁
  @override
  ReserveInputModel clone(ReserveInputModel src) {
    return ReserveInputModel.clone(
      src,
    );
  }

  // 查询入荷予定明细事件
  bool QueryReceiveDetailEvent(int receiveId) {
    // 判断入荷予定列表
    if (state.customerList['id'] == null || state.customerList['id'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.reserve_input_19);

      return false;
    } else {
      return true;
    }
  }

  ReserveInputBloc(ReserveInputModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      if (state.receiveId > 0) {
        state.isOk = true; //标记页面是跳转过来的，按钮文字更新为修改
        // 查询入荷予定明细
        List<dynamic> DetailData = await SupabaseUtils.getClient()
            .from('dtb_receive')
            .select('*')
            .eq('del_kbn', '2')
            .eq('company_id', state.companyId)
            .eq('id', state.receiveId);

        state.customerList = DetailData[0];

        //sp-新增情况下显示最新“入荷予定明细行No”
        if (!kIsWeb) {
          if (state.customer.length == 0) {
            // 获取入荷予定明细最大行No ---------start
            Map<String, dynamic> receiveTemp = Map<String, dynamic>();
            receiveTemp.addAll(state.customer);
            List<dynamic> data = await SupabaseUtils.getClient()
                .from('dtb_receive_detail')
                .select('*')
                .eq('receive_id', state.receiveId)
                .eq('del_kbn', Config.DELETE_NO)
                .order('id');
            String lineNo = '001';
            if (data.length > 0) {
              lineNo = data[0]['receive_line_no'];
              lineNo = lineNo.substring(lineNo.length - 3);
              int no = int.parse(lineNo) + 1;
              lineNo = no.toString();
              switch (lineNo.length) {
                case 1:
                  lineNo = '00' + lineNo;
                  break;
                case 2:
                  lineNo = '0' + lineNo;
                  break;
                case 3:
                  lineNo = lineNo;
                  break;
                default:
              }
            }

            //入荷予定入力明細行No赋值
            receiveTemp['receive_line_no'] =
                state.customerList['receive_no'] + lineNo;
            state.customer = receiveTemp;
            //获取入荷予定明细最大行No    ---------end
          }
        }

        //sp-入荷予定明细有内容的情况，商品写真路径更改
        if (state.customer['image1'] != '' &&
            state.customer['image1'] != null &&
            !state.customer['image1'].toString().contains('https')) {
          state.customer['image1'] =
              await WMSCommonFile().previewImageFile(state.customer['image1']);
        }
        if (state.customer['image2'] != '' &&
            state.customer['image2'] != null &&
            !state.customer['image2'].toString().contains('https')) {
          state.customer['image2'] =
              await WMSCommonFile().previewImageFile(state.customer['image2']);
        }
      }

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

      // 赵士淞 - 始
      // 查询仕入先
      List<dynamic> supplierData = await SupabaseUtils.getClient()
          .from('mtb_supplier')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.company_id)
          .eq('del_kbn', Config.DELETE_NO);
      // 仕入先列表
      state.supplierList = supplierData;
      // 赵士淞 - 终

      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 查询分页数据事件
    on<PageQueryEvent>((event, emit) async {
      // 查询入荷予定明细
      if (state.receiveId > 0) {
        List<dynamic> data = await SupabaseUtils.getClient()
            .rpc('func_query_table_reserve_dtb_ship_detail',
                params: {'ship_id': state.receiveId})
            .select('*')
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1);

        //查总数用
        List<dynamic> count = await SupabaseUtils.getClient().rpc(
            'func_query_total_reserve_dtb_ship_detail',
            params: {'ship_id': state.receiveId}).select('*');

        state.num = count[0]['total'];

        // 列表数据清空
        state.records.clear();
        // 循环入荷予定数据
        for (int i = 0; i < data.length; i++) {
          // 列表数据增加
          if (data[i]['del_kbn'] == '2')
            state.records.add(WmsRecordModel(i, data[i]));
        }
        state.dataLength = data.length;

        // 总页数
        state.total = data.length;
      }

      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 导入CSV文件事件
    on<ImportCSVFileEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      int userId = StoreProvider.of<WMSState>(state.rootContext)
          .state
          .loginUser
          ?.id as int;

      // 判断内容长度
      if (event.content.length > 0 && event.content.length < 3) {
        // 入荷予定列表
        List<Map<String, dynamic>> receiveList = [];
        // 入荷予定明细列表
        List<Map<String, dynamic>> receiveDetailList = [];

        // 判断内容长度
        if (event.content.length == 1) {
          // 入荷予定列表
          receiveList = event.content[0];
        } else if (event.content.length == 2) {
          // 入荷予定列表
          receiveList = event.content[0];
          // 入荷予定明细列表
          receiveDetailList = event.content[1];
        }

        // 循环入荷予定列表
        for (int i = 0; i < receiveList.length; i++) {
          // 入荷予定ID
          int receiveId = 0;
          // 入荷予定番号
          String receiveNo = '';
          // 当前入荷予定ID
          int currentReceiveId = 0;

          // 当前入荷予定
          Map<String, dynamic> currentReceive = receiveList[i];
          // 判断当前入荷予定ID
          if (currentReceive['id'] != null && currentReceive['id'] != '') {
            // 当前入荷予定ID
            currentReceiveId = int.parse(currentReceive['id'].toString());
            // 当前入荷予定ID
            currentReceive['id'] = '';
          }

          // 保存入荷予定表单验证
          Map<String, dynamic> receiveStructure =
              saveReceiveFormCheck(currentReceive);
          // 判断验证结果
          if (receiveStructure.length == 0) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                    WMSLocalizations.i18n(state.rootContext)!.import_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }

          // 入荷予定
          Receive receive = Receive.fromJson(receiveStructure);

          // 创建入荷予定表单处理
          receive = await createReceiveFormHandle(receive, event.context);

          // 判断处理结果
          if (receive.create_id == null || receive.create_id == '') {
            // 赵士淞 - 始
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                    WMSLocalizations.i18n(state.rootContext)!.import_error);
            // 关闭加载
            BotToast.closeAllLoading();
            // 赵士淞 - 终
            return;
          }
          try {
            // 新增入荷予定
            List<Map<String, dynamic>> receiveData =
                await SupabaseUtils.getClient()
                    .from('dtb_receive')
                    .insert([receive.toJson()]).select('*');
            // 判断入荷予定数据
            if (receiveData.length == 0) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.file_type_csv +
                      WMSLocalizations.i18n(event.context)!.import_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            } else {
              //csv导入成功
              //插入操作履历 sys_log表
              CommonUtils().createLogInfo(
                  '入荷予定入力CSV' +
                      Config.OPERATION_TEXT1 +
                      Config.OPERATION_BUTTON_TEXT9 +
                      Config.OPERATION_TEXT2,
                  "ImportCSVFileEvent()",
                  StoreProvider.of<WMSState>(event.context)
                      .state
                      .loginUser!
                      .company_id,
                  StoreProvider.of<WMSState>(event.context)
                      .state
                      .loginUser!
                      .id);
            }
            // 入荷予定ID
            receiveId = receiveData[0]['id'];
            // 入荷予定番号
            receiveNo = receiveData[0]['receive_no'];
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.file_type_csv +
                    WMSLocalizations.i18n(event.context)!.import_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }

          // 循环入荷予定明细列表
          for (int j = 0; j < receiveDetailList.length; j++) {
            // 判断当前入荷予定ID
            if (receiveDetailList[j]['receive_id'] != null &&
                receiveDetailList[j]['receive_id'] != '' &&
                int.parse(receiveDetailList[j]['receive_id'].toString()) ==
                    currentReceiveId) {
              // 当前入荷予定明细
              Map<String, dynamic> currentReceiveDetail = receiveDetailList[j];
              currentReceiveDetail['id'] = '';
              // 保存入荷予定明细表单验证
              Map<String, dynamic> receiveDetailStructure =
                  saveReceiveDetailFormCheck(currentReceiveDetail);
              // 判断验证结果
              if (receiveDetailStructure.length == 0) {
                // 赵士淞 - 始
                // 入荷予定导入异常字段更新
                await SupabaseUtils.getClient()
                    .from('dtb_receive')
                    .update({'importerror_flg': 5}).eq('id', receiveId);
                // 赵士淞 - 终
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                        WMSLocalizations.i18n(state.rootContext)!.import_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }

              //判断商品id是否存在
              bool judgeProductIdFlag =
                  await judgeProductId(currentReceiveDetail);
              // 判断验证结果
              if (judgeProductIdFlag) {
                //商品id不存在，更新importerror_flg字段为“1”
                // 更新入荷予定
                await SupabaseUtils.getClient()
                    .from('dtb_receive')
                    .update({
                      'importerror_flg': Config.NUMBER_ONE.toString(),
                      'update_time': DateTime.now().toString(),
                      'update_id': StoreProvider.of<WMSState>(state.rootContext)
                          .state
                          .loginUser
                          ?.id
                    })
                    .eq('id', receiveId)
                    .select('*');
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.rootContext)!
                        .importerror_flg_text_1);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }

              ReceiveDetail receiveDetail = ReceiveDetail.empty();

              try {
                // 入荷予定明细
                receiveDetail = ReceiveDetail.fromJson(receiveDetailStructure);
                // 创建入荷予定明细表单处理
                receiveDetail = await createreceiveDetailFormHandle(
                    receiveDetail, receiveId, receiveNo);
                // 判断处理结果
                if (receiveDetail.create_id == null ||
                    receiveDetail.create_id == '') {
                  // 赵士淞 - 始
                  // 入荷予定导入异常字段更新
                  await SupabaseUtils.getClient()
                      .from('dtb_receive')
                      .update({'importerror_flg': 5}).eq('id', receiveId);
                  // 赵士淞 - 终
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
                //导入子表时出现错误，更新importerror_flg字段为“4”
                // 更新入荷予定
                await SupabaseUtils.getClient()
                    .from('dtb_receive')
                    .update({
                      'importerror_flg': Config.NUMBER_FOUR.toString(),
                      'update_time': DateTime.now().toString(),
                      'update_id': userId
                    })
                    .eq('id', receiveId)
                    .select('*');
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.rootContext)!
                        .importerror_flg_text_4);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }

              try {
                // 新增入荷予定明细
                List<Map<String, dynamic>> receiveDetailData =
                    await SupabaseUtils.getClient()
                        .from('dtb_receive_detail')
                        .insert([receiveDetail.toJson()]).select('*');
                // 判断入荷予定明细数据
                if (receiveDetailData.length == 0) {
                  // 赵士淞 - 始
                  // 入荷予定导入异常字段更新
                  await SupabaseUtils.getClient()
                      .from('dtb_receive')
                      .update({'importerror_flg': 4}).eq('id', receiveId);
                  // 赵士淞 - 终
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
                // 赵士淞 - 始
                // 入荷予定导入异常字段更新
                await SupabaseUtils.getClient()
                    .from('dtb_receive')
                    .update({'importerror_flg': 4}).eq('id', receiveId);
                // 赵士淞 - 终
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
        }

        // 成功提示
        WMSCommonBlocUtils.successTextToast(
            WMSLocalizations.i18n(event.context)!.file_type_csv +
                WMSLocalizations.i18n(event.context)!.import_success);
      }

      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 设定基本情报事件
    on<SetReserveValueEvent>((event, emit) async {
      // 基本情报-临时
      Map<String, dynamic> receiveTemp = Map<String, dynamic>();
      receiveTemp.addAll(state.customerList);
      // 判断key
      if (receiveTemp[event.key] != null) {
        // 基本情报-临时
        receiveTemp[event.key] = event.value;
      } else {
        // 基本情报-临时
        receiveTemp.addAll({event.key: event.value});
      }
      // 基本情报-定制
      state.customerList = receiveTemp;
      // 更新
      emit(clone(state));
    });

    // 赵士淞 - 始
    // 设定基本情报集合事件
    on<SetReserveMapEvent>((event, emit) async {
      // 基本情报-临时
      Map<String, dynamic> receiveTemp = Map<String, dynamic>();
      receiveTemp.addAll(state.customerList);
      // 循环值集合
      event.valueMap.forEach((key, value) {
        // 判断key
        if (receiveTemp[key] != null) {
          // 基本情报-临时
          receiveTemp[key] = value;
        } else {
          // 基本情报-临时
          receiveTemp.addAll({key: value});
        }
      });
      // 基本情报-定制
      state.customerList = receiveTemp;

      // 更新
      emit(clone(state));
    });
    // 赵士淞 - 终

    // 设定弹窗值事件
    on<SetReceiveValueEvent>((event, emit) async {
      // 入荷予定-临时
      Map<String, dynamic> receiveTemp = Map<String, dynamic>();
      receiveTemp.addAll(state.customer);
      // 判断key
      if (receiveTemp[event.key] != null) {
        // 入荷予定-临时
        receiveTemp[event.key] = event.value;
      } else {
        // 入荷予定-临时
        receiveTemp.addAll({event.key: event.value});
      }
      // 入荷予定-定制
      state.customer = receiveTemp;
      // 更新
      emit(clone(state));
    });

    // 保存入荷予定表单事件
    on<SaveReceiveFormEvent>((event, emit) async {
      // 保存入荷予定表单验证
      Map<String, dynamic> receiveStructure =
          saveReceiveFormCheck(state.customerList);
      // 判断验证结果
      if (receiveStructure.length == 0) {
        return;
      }
      // 打开加载状态
      BotToast.showLoading();

      // 入荷予定数据
      List<Map<String, dynamic>> receiveData = [];
      // 入荷予定
      Receive receive = Receive.fromJson(state.customerList);

      // 判断ID
      if (receive.receive_no == null) {
        // 创建入荷予定表单处理
        receive = await createReceiveFormHandle(receive, event.context);
        // 判断处理结果
        if (receive.create_id == null || receive.create_id == '') {
          return;
        }
        try {
          // 新增入荷予定
          receiveData = await SupabaseUtils.getClient()
              .from('dtb_receive')
              .insert([receive.toJson()]).select('*');

          // 判断入荷予定数据
          if (receiveData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.home_main_page_text6 +
                    WMSLocalizations.i18n(event.context)!.create_success);
            //显示修改按钮
            state.isOk = true;

            //插入操作履历 sys_log表
            CommonUtils().createLogInfo(
                '入荷予定入力（NO：' +
                    receive.receive_no.toString() +
                    '）' +
                    Config.OPERATION_TEXT1 +
                    Config.OPERATION_BUTTON_TEXT1 +
                    Config.OPERATION_TEXT2,
                "SaveReceiveFormEvent()",
                StoreProvider.of<WMSState>(event.context)
                    .state
                    .loginUser!
                    .company_id,
                StoreProvider.of<WMSState>(event.context).state.loginUser!.id);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.home_main_page_text6 +
                    WMSLocalizations.i18n(event.context)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.home_main_page_text6 +
                  WMSLocalizations.i18n(event.context)!.create_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else {
        // 更新入荷予定表单处理
        receive = updateReceiveFormHandle(receive, event.context);
        // 判断处理结果
        if (receive.update_id == null || receive.update_id == '') {
          return;
        }
        try {
          // 修改入荷予定
          receiveData = await SupabaseUtils.getClient()
              .from('dtb_receive')
              .update(receive.toJson())
              .eq('receive_no', state.customerList['receive_no'].toString())
              .select('*');
          // 判断入荷予定数据

          if (receiveData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.home_main_page_text6 +
                    WMSLocalizations.i18n(event.context)!.update_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.home_main_page_text6 +
                    WMSLocalizations.i18n(event.context)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.home_main_page_text6 +
                  WMSLocalizations.i18n(event.context)!.update_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      }
      // 入荷予定-定制
      state.customerList = receiveData[0];
      // 入荷予定-定制ID
      state.receiveId = state.customerList['id']!;
      add(PageQueryEvent());
    });

    //保存弹窗入荷予定明细商品信息赋值
    on<SaveOtherProductEvent>((event, emit) async {
      Map<String, dynamic> productData = event.productData;
      //清空显示
      if (event.productData.isEmpty) {
        //商品名
        state.customer['name'] = '';
        //商品id
        state.customer['product_id'] = '';
        //商品コード
        state.customer['code'] = '';
        //商品規格
        state.customer['size'] = '';
        //商品_写真１
        state.customer['image1'] = '';
        //商品_写真2
        state.customer['image2'] = '';
        //商品_社内備考１
        state.customer['company_note1'] = '';
        //商品_社内備考2
        state.customer['company_note2'] = '';
        //商品_注意備考１
        state.customer['notice_note1'] = '';
        //商品_注意備考2
        state.customer['notice_note2'] = '';
      } else {
        //赋值
        //商品名-显示
        state.customer['name'] = productData['name'];
        //商品id
        state.customer['product_id'] = productData['id'];
        //商品コード
        state.customer['code'] = productData['code'];
        //商品規格
        state.customer['size'] = productData['size'];
        //商品_写真１
        if (productData['image1'] != "" && productData['image1'] != null) {
          state.customer['image1'] =
              await WMSCommonFile().previewImageFile(productData['image1']);
        }
        //商品_写真2
        if (productData['image2'] != "" && productData['image2'] != null) {
          state.customer['image2'] =
              await WMSCommonFile().previewImageFile(productData['image2']);
        }
        //商品_社内備考１
        state.customer['company_note1'] = productData['company_note1'];
        //商品_社内備考2
        state.customer['company_note2'] = productData['company_note2'];
        //商品_注意備考１
        state.customer['notice_note1'] = productData['notice_note1'];
        //商品_注意備考2
        state.customer['notice_note2'] = productData['notice_note2'];
      }

      // 刷新补丁
      emit(clone(state));
    });

    //弹窗数据插入
    on<registrationReceiveDetailFormEvent>((event, emit) async {
      // 保存入荷予定明细表单验证
      Map<String, dynamic> receiveDetailStructure =
          saveReceiveDetailFormCheck(state.customer);
      // 判断验证结果
      if (receiveDetailStructure.length == 0) {
        return;
      }
      // 打开加载状态
      BotToast.showLoading();
      try {
        // 入荷予定明细数据
        List<Map<String, dynamic>> receiveDetailData = [];
        //类型转换
        state.customer['product_num'] =
            int.parse(state.customer['product_num'].toString());
        state.customer['product_price'] =
            double.parse(state.customer['product_price'].toString());
        ReceiveDetail receiveDetail = ReceiveDetail.fromJson(state.customer);
        // 创建入荷予定明细表单处理
        receiveDetail = await createreceiveDetailFormHandle(
            receiveDetail, event.receiveId, state.customerList['receive_no']);
        //插入入荷予定明细数据
        receiveDetailData = await SupabaseUtils.getClient()
            .from('dtb_receive_detail')
            .insert([receiveDetail.toJson()]).select('*');
        // 判断入荷予定数据
        if (receiveDetailData.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(state.rootContext)!.home_main_page_text6 +
                  WMSLocalizations.i18n(state.rootContext)!.delivery_note_8 +
                  WMSLocalizations.i18n(state.rootContext)!.create_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.home_main_page_text6 +
                  WMSLocalizations.i18n(state.rootContext)!.delivery_note_8 +
                  WMSLocalizations.i18n(state.rootContext)!.create_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!.home_main_page_text6 +
                WMSLocalizations.i18n(state.rootContext)!.delivery_note_8 +
                WMSLocalizations.i18n(state.rootContext)!.create_error);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }
      // 关闭弹窗
      Navigator.pop(event.context);
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    //更新弹窗入荷予定明细弹框事件
    on<SaveReceiveDetailFormEvent>((event, emit) async {
      int userId = StoreProvider.of<WMSState>(state.rootContext)
          .state
          .loginUser
          ?.id as int;
      // 打开加载状态
      BotToast.showLoading();
      try {
        //查询入荷予定明细数据
        List<dynamic> data = await SupabaseUtils.getClient()
            .from('dtb_receive_detail')
            .select('*')
            .eq('receive_id', state.receiveId)
            .eq('id', event.data['id'])
            .eq('del_kbn', Config.DELETE_NO);
        // 入荷予定明细数据
        List<Map<String, dynamic>> receiveDetailData = [];
        //类型转换
        state.customer['product_num'] =
            int.parse(state.customer['product_num'].toString());
        state.customer['product_price'] =
            double.parse(state.customer['product_price'].toString());
        int productId = 0;
        if (state.customer['product_id'] != null &&
            state.customer['product_id'] != "") {
          productId = state.customer['product_id'];
        } else {
          productId = data[0]['product_id'];
        }
        receiveDetailData = await SupabaseUtils.getClient()
            .from('dtb_receive_detail')
            .update({
              'product_id': productId,
              'product_price': state.customer['product_price'],
              'product_num': state.customer['product_num'],
              'note1': state.customer['note1'],
              'note2': state.customer['note2'],
              'update_id': userId,
              'update_time': DateTime.now().toString(),
            })
            .eq('id', event.data['id'])
            .select('*');
        // 判断入荷予定数据
        if (receiveDetailData.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(state.rootContext)!.home_main_page_text6 +
                  WMSLocalizations.i18n(state.rootContext)!.delivery_note_8 +
                  WMSLocalizations.i18n(state.rootContext)!.update_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.home_main_page_text6 +
                  WMSLocalizations.i18n(state.rootContext)!.delivery_note_8 +
                  WMSLocalizations.i18n(state.rootContext)!.update_error);
          return;
        }
      } catch (e) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!.home_main_page_text6 +
                WMSLocalizations.i18n(state.rootContext)!.delivery_note_8 +
                WMSLocalizations.i18n(state.rootContext)!.update_error);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }
      // 关闭弹窗
      Navigator.pop(event.context);
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 入荷予定明细表弹窗删除方法
    on<delectEvent>((event, emit) async {
      // 入荷予定数据
      List<Map<String, dynamic>> receiveData = [];

      // 打开加载状态
      BotToast.showLoading();

      try {
        receiveData = await SupabaseUtils.getClient()
            .from('dtb_receive_detail')
            .update({'del_kbn': '1'})
            .eq('receive_line_no', event.value)
            .select('*');
        // 判断入荷予定数据
        if (receiveData != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_2_9 +
                  WMSLocalizations.i18n(event.context)!.delete_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_2_9 +
                  WMSLocalizations.i18n(event.context)!.delete_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(event.context)!.menu_content_2_9 +
                WMSLocalizations.i18n(event.context)!.delete_error);

        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }
      // 查询分页数据事件
      add(PageQueryEvent());
    });
    // 处理入荷予定明细表行NO
    on<handleReceiveLineNoEvent>((event, emit) async {
      //明细内容赋值
      state.customer = event.data;
      //新增情况下显示最新“入荷予定明细行No”
      if (state.customer.length == 0) {
        // 获取入荷予定明细最大行No ---------start
        Map<String, dynamic> receiveTemp = Map<String, dynamic>();
        receiveTemp.addAll(state.customer);
        List<dynamic> data = await SupabaseUtils.getClient()
            .from('dtb_receive_detail')
            .select('*')
            .eq('receive_id', state.receiveId)
            .order('id');
        String lineNo = '001';
        if (data.length > 0) {
          lineNo = data[0]['receive_line_no'];
          lineNo = lineNo.substring(lineNo.length - 3);
          int no = int.parse(lineNo) + 1;
          lineNo = no.toString();
          switch (lineNo.length) {
            case 1:
              lineNo = '00' + lineNo;
              break;
            case 2:
              lineNo = '0' + lineNo;
              break;
            case 3:
              lineNo = lineNo;
              break;
            default:
          }
        }
        //入荷予定入力明細行No赋值
        receiveTemp['receive_line_no'] =
            state.customerList['receive_no'] + lineNo;
        state.customer = receiveTemp;
        //获取入荷予定明细最大行No    ---------end
      }
      // 刷新补丁
      emit(clone(state));
    });

    // 处理商品写真路径
    on<handleProductImageEvent>((event, emit) async {
      //明细内容赋值
      state.customer = event.data;
      //入荷予定明细有内容的情况，商品写真路径更改
      if (state.customer['image1'] != '' &&
          state.customer['image1'] != null &&
          !state.customer['image1'].toString().contains('https')) {
        state.customer['image1'] =
            await WMSCommonFile().previewImageFile(state.customer['image1']);
      }
      if (state.customer['image2'] != '' &&
          state.customer['image2'] != null &&
          !state.customer['image2'].toString().contains('https')) {
        state.customer['image2'] =
            await WMSCommonFile().previewImageFile(state.customer['image2']);
      }
      // 刷新补丁
      emit(clone(state));
    });

    // 当前下标变更事件
    on<CurrentIndexChangeEvent>((event, emit) async {
      // 当前下标
      state.currentIndex = event.value;
      // 更新
      emit(clone(state));
    });

    add(InitEvent());
  }

  // 保存入荷予定表单验证
  Map<String, dynamic> saveReceiveFormCheck(
      Map<String, dynamic> receiveStructure) {
    // 判断是否为空
    if (receiveStructure['rcv_sch_date'] == null ||
        receiveStructure['rcv_sch_date'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.home_main_page_table_text1 +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (receiveStructure['order_no'] == null ||
        receiveStructure['order_no'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.menu_content_2_5_7 +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (CheckUtils.check_Half_Alphanumeric_Symbol(
        receiveStructure['order_no'])) {
      // 仕入先注文番号 半角英数字记号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.menu_content_2_5_7 +
              WMSLocalizations.i18n(state.rootContext)!
                  .check_half_width_alphanumeric_with_symbol);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (receiveStructure['name'] == null ||
        receiveStructure['name'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.reserve_input_6 +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (receiveStructure['name_kana'] == null ||
        receiveStructure['name_kana'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.supplier_kana +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (CheckUtils.check_Kana(receiveStructure['name_kana'])) {
      // カナ名称 カナ
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.supplier_kana +
              WMSLocalizations.i18n(state.rootContext)!.check_kana);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (receiveStructure['postal_cd'] == null ||
        receiveStructure['postal_cd'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.supplier_basic_zip_code +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (CheckUtils.check_Postal(receiveStructure['postal_cd'])) {
      // 郵便番号 3位半角数字-4位半角数字
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.supplier_basic_zip_code +
              WMSLocalizations.i18n(state.rootContext)!.check_postal);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (receiveStructure['addr_1'] == null ||
        receiveStructure['addr_1'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.supplier_basic_province +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (receiveStructure['addr_2'] == null ||
        receiveStructure['addr_2'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.supplier_basic_villages +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (receiveStructure['addr_3'] == null ||
        receiveStructure['addr_3'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.supplier_basic_address +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (receiveStructure['addr_tel'] == null ||
        receiveStructure['addr_tel'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .supplier_basic_contact_telephone_number +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (CheckUtils.check_Half_Number_Hyphen(
        receiveStructure['addr_tel'])) {
      // 電話番号 半角数字，ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .supplier_basic_contact_telephone_number +
          WMSLocalizations.i18n(state.rootContext)!
              .check_half_width_numbers_with_hyphen);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (receiveStructure['customer_fax'] != null &&
        receiveStructure['customer_fax'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(receiveStructure['customer_fax'])) {
      // FAX番号 半角数字，ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .supplier_basic_contact_fax_number +
          WMSLocalizations.i18n(state.rootContext)!
              .check_half_width_numbers_with_hyphen);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    }

    // 处理入荷予定-结构
    try {
      if (receiveStructure['id'] == null || receiveStructure['id'] == '') {
        receiveStructure.remove('id');
      } else {
        receiveStructure['id'] = int.parse(receiveStructure['id'].toString());
      }
      if (receiveStructure['supplier_id'] == null ||
          receiveStructure['supplier_id'] == '') {
        receiveStructure.remove('supplier_id');
      } else {
        receiveStructure['supplier_id'] =
            int.parse(receiveStructure['supplier_id'].toString());
      }
      if (receiveStructure['company_id'] == null ||
          receiveStructure['company_id'] == '') {
        receiveStructure.remove('company_id');
      } else {
        receiveStructure['company_id'] =
            int.parse(receiveStructure['company_id'].toString());
      }
      // 返回
      return receiveStructure;
    } catch (e) {
      return {};
    }
  }

  // 更新入荷予定表单处理
  Receive updateReceiveFormHandle(Receive receive, BuildContext context) {
    // 入荷予定
    receive.update_time = DateTime.now().toString();
    receive.update_id = StoreProvider.of<WMSState>(context).state.loginUser?.id;

    // 返回
    return receive;
  }

  // 创建入荷予定表单处理
  Future<Receive> createReceiveFormHandle(
      Receive receive, BuildContext context) async {
    try {
      // 获取自动采番连番
      receive.receive_no = await WMSCommonBloc.selectNumber(
          StoreProvider.of<WMSState>(context).state.loginUser?.company_id,
          Config.WMS_CHANNEL_A);
      // 更新自动采番连番
      WMSCommonBloc.updateNumberSeqNo(
          StoreProvider.of<WMSState>(context).state.loginUser?.company_id,
          Config.WMS_CHANNEL_A,
          receive.receive_no!);
    } catch (e) {
      // 失败提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(context)!.confirmation_data_table_title_3 +
              WMSLocalizations.i18n(context)!.create_error);
      // 关闭加载
      BotToast.closeAllLoading();
      return Receive.empty();
    }

    // 入荷予定
    receive.receive_kbn = Config.RECEIVE_KBN_WAIT_INSPECT;
    receive.csv_kbn = Config.CSV_KBN_2;
    receive.company_id =
        StoreProvider.of<WMSState>(context).state.loginUser?.company_id;
    receive.del_kbn = Config.DELETE_NO;
    receive.create_time = DateTime.now().toString();
    receive.create_id = StoreProvider.of<WMSState>(context).state.loginUser?.id;
    receive.update_time = DateTime.now().toString();
    receive.update_id = StoreProvider.of<WMSState>(context).state.loginUser?.id;

    // 返回
    return receive;
  }

  // 保存入荷予定明细表单验证
  Future<bool> judgeProductId(
      Map<String, dynamic> receiveDetailStructure) async {
    //根据商品id，查询商品信息
    List<dynamic> productData = await SupabaseUtils.getClient()
        .from('mtb_product')
        .select('*')
        .eq('id', receiveDetailStructure['product_id'])
        .eq(
            'company_id',
            StoreProvider.of<WMSState>(state.rootContext)
                .state
                .loginUser
                ?.company_id)
        .eq('del_kbn', Config.DELETE_NO);
    if (productData.length == 0) {
      // 关闭加载
      BotToast.closeAllLoading();
      return true;
    } else {
      return false;
    }
  }

  // 保存入荷予定明细表单验证
  Map<String, dynamic> saveReceiveDetailFormCheck(
      Map<String, dynamic> receiveDetailStructure) {
    // 判断是否为空
    if (receiveDetailStructure['product_id'] == null ||
        receiveDetailStructure['product_id'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_table_title_4 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (receiveDetailStructure['product_num'] == null ||
        receiveDetailStructure['product_num'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.reserve_input_13 +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (CheckUtils.check_Half_Number_In_10(
        receiveDetailStructure['product_num'])) {
      // 単価 半角数字
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.reserve_input_13 +
              WMSLocalizations.i18n(state.rootContext)!
                  .check_half_width_numbers_in_10);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (receiveDetailStructure['product_price'] == null ||
        receiveDetailStructure['product_price'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_table_title_9 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (CheckUtils.check_Half_Number(
        receiveDetailStructure['product_price'])) {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_table_title_9 +
          WMSLocalizations.i18n(state.rootContext)!.check_half_width_numbers);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    }

    // 处理入荷予定明细-结构
    if (receiveDetailStructure['id'] == null ||
        receiveDetailStructure['id'] == '') {
      receiveDetailStructure.remove('id');
    } else {
      receiveDetailStructure['id'] =
          int.parse(receiveDetailStructure['id'].toString());
    }
    if (receiveDetailStructure['receive_id'] == null ||
        receiveDetailStructure['receive_id'] == '') {
      receiveDetailStructure.remove('receive_id');
    } else {
      receiveDetailStructure['receive_id'] =
          int.parse(receiveDetailStructure['receive_id'].toString());
    }
    if (receiveDetailStructure['product_id'] == null ||
        receiveDetailStructure['product_id'] == '') {
      receiveDetailStructure.remove('product_id');
    } else {
      receiveDetailStructure['product_id'] =
          int.parse(receiveDetailStructure['product_id'].toString());
    }
    if (receiveDetailStructure['product_num'] == null ||
        receiveDetailStructure['product_num'] == '') {
      receiveDetailStructure.remove('product_num');
    } else {
      receiveDetailStructure['product_num'] =
          int.parse(receiveDetailStructure['product_num'].toString());
    }
    if (receiveDetailStructure['product_price'] == null ||
        receiveDetailStructure['product_price'] == '') {
      receiveDetailStructure.remove('product_price');
    } else {
      receiveDetailStructure['product_price'] =
          double.parse(receiveDetailStructure['product_price'].toString());
    }
    if (receiveDetailStructure['store_num'] == null ||
        receiveDetailStructure['store_num'] == '') {
      receiveDetailStructure.remove('store_num');
    } else {
      receiveDetailStructure['store_num'] =
          int.parse(receiveDetailStructure['store_num'].toString());
    }
    if (receiveDetailStructure['check_num'] == null ||
        receiveDetailStructure['check_num'] == '') {
      receiveDetailStructure.remove('check_num');
    } else {
      receiveDetailStructure['check_num'] =
          int.parse(receiveDetailStructure['check_num'].toString());
    }

    // 返回
    return receiveDetailStructure;
  }

  // 创建入荷予定明细表单处理
  Future<ReceiveDetail> createreceiveDetailFormHandle(
      ReceiveDetail receiveDetail, int receiveId, String receiveNo) async {
    // 番号
    String lineNo = '001';
    // 查询入荷予定明细
    List<dynamic> receiveDetailData = await SupabaseUtils.getClient()
        .from('dtb_receive_detail')
        .select('*')
        .eq('receive_id', receiveId)
        .order('id', ascending: false);
    // 判断入荷予定明细长度
    if (receiveDetailData.length != 0) {
      // 上一个入荷予定明细番号
      dynamic lastReceiveLineNo = receiveDetailData[0]['receive_line_no'];
      // 判断上一个入荷予定明细番号
      if (lastReceiveLineNo != null && lastReceiveLineNo != '') {
        // 上一个番号
        int lastLineNo = int.parse(lastReceiveLineNo.substring(
            lastReceiveLineNo.length - 3, lastReceiveLineNo.length));
        // 当前番号
        int nowLineNo = lastLineNo + 1;
        // 判断当前番号
        if (nowLineNo < 10) {
          // 番号
          lineNo = '00' + nowLineNo.toString();
        } else if (lastLineNo < 100) {
          // 番号
          lineNo = '0' + nowLineNo.toString();
        } else {
          // 番号
          lineNo = nowLineNo.toString();
        }
      }
    }
    // 入荷予定明细
    receiveDetail.receive_id = receiveId;
    receiveDetail.receive_line_no = receiveNo + lineNo;
    receiveDetail.store_kbn = Config.STORE_KBN_2;
    receiveDetail.check_kbn = Config.CHECK_KBN_2;
    receiveDetail.confirm_kbn = Config.CONFIRM_KBN_2;
    receiveDetail.del_kbn = Config.DELETE_NO;
    receiveDetail.create_time = DateTime.now().toString();
    receiveDetail.create_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
    receiveDetail.update_time = DateTime.now().toString();
    receiveDetail.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    // 返回
    return receiveDetail;
  }

  // 更新入荷予定明细表单处理
  ReceiveDetail updatereceiveDetailFormHandle(ReceiveDetail receiveDetail) {
    // 入荷予定明细
    receiveDetail.update_time = DateTime.now().toString();
    receiveDetail.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    // 返回
    return receiveDetail;
  }
}
