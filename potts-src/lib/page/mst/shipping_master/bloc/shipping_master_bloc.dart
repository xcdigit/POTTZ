import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/utils/check_utils.dart';

import 'package:wms/model/owner.dart';
import 'package:wms/page/mst/shipping_master/bloc/shipping_master_model.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../redux/wms_state.dart';

import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';

/**
 * 内容：荷主マスタ-BLOC
 * 作者：王光顺
 * 时间：2023/11/29
 */

// 事件
abstract class ShippingMasterEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends ShippingMasterEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定表单情报值事件
class SetMessageValueEvent extends ShippingMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetMessageValueEvent(this.key, this.value);
}

//清除表单
class ClearFormEvent extends ShippingMasterEvent {
  // 清除表单
  ClearFormEvent();
}

//登录/修改表单
class UpdateFormEvent extends ShippingMasterEvent {
  // 结构树
  BuildContext context;
  UpdateFormEvent(this.context);
}

// 设定检索条件值事件
class SetSearchValueEvent extends ShippingMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value);
}

// 删除检索条件值事件
class DeleteSearchValueEvent extends ShippingMasterEvent {
  int index;
  //设定值事件
  DeleteSearchValueEvent(this.index);
}

//form表单回显
class ShowSelectValueEvent extends ShippingMasterEvent {
  // Value
  dynamic value;
  //状态flg
  String stateflg;
  ShowSelectValueEvent(this.value, this.stateflg);
}

//清除检索条件
class ClearSelectMessageEvent extends ShippingMasterEvent {
  ClearSelectMessageEvent();
}

//检索处理
class SelectMessageEvent extends ShippingMasterEvent {
  // 结构树
  BuildContext context;
  //检索处理
  SelectMessageEvent(this.context);
}

//删除数据
class DeleteMessageDataEvent extends ShippingMasterEvent {
  // 结构树
  BuildContext context;
  int Id;
  DeleteMessageDataEvent(this.context, this.Id);
}

// 设置当前会社ID
class SetNowCompanyIDEvent extends ShippingMasterEvent {
  int nowCompanyId;
  SetNowCompanyIDEvent(this.nowCompanyId);
}

//
class SearchButtonHoveredChangeEvent extends ShippingMasterEvent {
  //
  bool flag;
  //
  SearchButtonHoveredChangeEvent(this.flag);
}

//
class SearchOutlinedButtonPressedEvent extends ShippingMasterEvent {
  //
  SearchOutlinedButtonPressedEvent();
}

//
class SearchInkWellTapEvent extends ShippingMasterEvent {
  //
  SearchInkWellTapEvent();
}

//
class SetSearchDataFlagAndSearchFlagEvent extends ShippingMasterEvent {
  //
  bool searchDataFlag;
  //
  bool searchFlag;
  //
  SetSearchDataFlagAndSearchFlagEvent(this.searchDataFlag, this.searchFlag);
}

// 设置sort字段
class SetSortEvent extends ShippingMasterEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终

class ShippingMasterBloc extends WmsTableBloc<ShippingMasterModel> {
  // 刷新补丁
  @override
  ShippingMasterModel clone(ShippingMasterModel src) {
    return ShippingMasterModel.clone(src);
  }

  ShippingMasterBloc(ShippingMasterModel state) : super(state) {
    //设置会社id
    on<SetNowCompanyIDEvent>((event, emit) async {
      state.nowCompanyId = event.nowCompanyId == 0 ? null : event.nowCompanyId;
      emit(clone(state));
    });

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 自定义事件 - 始
      // 加载标记
      state.loadingFlag = false;

      //初期化表单
      initForm(state);

      List companyList =
          await SupabaseUtils.getClient().from('mtb_company').select('*');
      state.salesCompanyInfoList = companyList;

      // SP端跳转页面
      if (state.flag_num == '2') {
        add(ShowSelectValueEvent(state.flag_data, "2"));
      } else if (state.flag_num == '0' || state.flag_num == '1') {
        add(ShowSelectValueEvent(state.flag_data, "1"));
      }
      // 查询分页数据事件
      add(PageQueryEvent());
    });
    //查询分页数据事件
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
      //会社管理员
      if (state.roleId != 1) {
        // 查询指示
        var query = SupabaseUtils.getClient()
            .from('mtb_owner')
            .select('*')
            .eq('del_kbn', '2');

        query = setSelectConditions(state, query, true);

        List<dynamic> data = await query
            .order(state.sortCol, ascending: state.ascendingFlg)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1);
        // 列表数据清空
        state.records.clear();
        // 循环商品数据
        for (int i = 0; i < data.length; i++) {
          state.records.add(WmsRecordModel(i, data[i]));
        }

        // 查询总数
        var queryCount = SupabaseUtils.getClient()
            .from('mtb_owner')
            .select(
              '*',
              const FetchOptions(
                count: CountOption.exact,
              ),
            )
            .eq('del_kbn', '2');
        ;
        //设置检索条件
        queryCount = setSelectConditions(state, queryCount, true);
        final countResult = await queryCount;
        // 总页数
        state.total = countResult.count;
      } else {
        // 查询指示
        var query = SupabaseUtils.getClient()
            .from('mtb_owner')
            .select('*')
            .eq('del_kbn', '2');

        query = setSelectConditions(state, query, false);

        List<dynamic> data = await query
            .order(state.sortCol, ascending: state.ascendingFlg)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1);

        // 列表数据清空
        state.records.clear();
        //查询会社信息
        List<dynamic> mtbCompanyList =
            await SupabaseUtils.getClient().from('mtb_company').select('*');
        // 循环数据 查询会社信息
        for (int i = 0; i < data.length; i++) {
          dynamic mtbCompany = mtbCompanyList.firstWhere(
              (mtbCompany) => mtbCompany['id'] == data[i]['company_id'],
              orElse: () => null);
          if (mtbCompany != null) {
            data[i]['company_name'] = mtbCompany['name'];
          }
        }

        // 查询总数
        var queryCount = SupabaseUtils.getClient()
            .from('mtb_owner')
            .select(
              '*',
              const FetchOptions(
                count: CountOption.exact,
              ),
            )
            .eq('del_kbn', '2');

        //设置检索条件
        queryCount = setSelectConditions(state, queryCount, false);
        final countResult = await queryCount;
        // 总页数
        state.total = countResult.count;
        // 单独对会社的检索数据筛选，避免写多表查询sql
        for (int i = 0; i < data.length; i++) {
          if (data[i]['company_name']
                  .toString()
                  .contains(state.searchInfo['company_name'].toString()) ||
              (state.searchInfo['company_name'].toString() == '') ||
              (state.searchInfo['company_name'] == null)) {
            state.records.add(WmsRecordModel(i, data[i]));
          } else {
            state.total -= 1; //如果数据不符合就不加入表中，总数减一
          }
        }
      }

      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设定表单情报值事件
    on<SetMessageValueEvent>(
      (event, emit) {
        // 表单情报-临时
        Map<String, dynamic> formTemp = Map<String, dynamic>();
        formTemp.addAll(state.formInfo);
        // 判断key
        if (formTemp[event.key] != null) {
          // 表单情报-临时
          formTemp[event.key] = event.value;
        } else {
          // 表单情报-临时
          formTemp.addAll({event.key: event.value});
        }
        // 表单情报-定制
        state.formInfo = formTemp;

        // 更新
        emit(clone(state));
      },
    );
    on<ShowSelectValueEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();
        //初期化表单
        initForm(state);
        //设定数据
        state.formInfo = event.value;
        state.stateFlg = event.stateflg;
        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      },
    );
    //表单清除
    on<ClearFormEvent>(
      (event, emit) {
        //初期化表单
        initForm(state);
        // 更新
        emit(clone(state));
      },
    );
    // 设定检索条件值事件
    on<SetSearchValueEvent>((event, emit) async {
      // 检索情报-临时
      Map<String, dynamic> searchTemp = Map<String, dynamic>();
      searchTemp.addAll(state.searchInfo);
      // 判断key
      if (searchTemp[event.key] != null) {
        // 检索情报-临时
        searchTemp[event.key] = event.value;
      } else {
        // 检索情报-临时
        searchTemp.addAll({event.key: event.value});
      }
      // 检索情报-定制
      state.searchInfo = searchTemp;
      state.searchKbn = event.value;
      // 更新
      emit(clone(state));
    });
    // 检索处理
    on<SelectMessageEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //设定显示检索条件
      state.conditionList = [];
      if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
        state.conditionList.add({'key': 'id', 'value': state.searchInfo['id']});
      }
      if (state.searchInfo['name'] != '' && state.searchInfo['name'] != null) {
        state.conditionList
            .add({'key': 'name', 'value': state.searchInfo['name']});
      }
      if (state.searchInfo['owner_name'] != '' &&
          state.searchInfo['owner_name'] != null) {
        state.conditionList.add(
            {'key': 'owner_name', 'value': state.searchInfo['owner_name']});
      }
      if (state.searchInfo['contact'] != '' &&
          state.searchInfo['contact'] != null) {
        state.conditionList
            .add({'key': 'contact', 'value': state.searchInfo['contact']});
      }
      if (state.searchInfo['company_name'] != '' &&
          state.searchInfo['company_name'] != null) {
        state.conditionList.add(
            {'key': 'company_name', 'value': state.searchInfo['company_name']});
      }
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });
    //清除检索条件
    on<ClearSelectMessageEvent>(
      (event, emit) {
        // 打开加载状态
        BotToast.showLoading();
        //初期化检索条件
        initSearch(state);
        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      },
    );

    // 删除检索条件值事件
    on<DeleteSearchValueEvent>((event, emit) {
      //判断删除检索条件
      dynamic deleteColumn = state.conditionList[event.index];

      if (deleteColumn['key'] == null || deleteColumn['value'] == null) {
        return;
      }
      //清空检索条件
      if ('id' == deleteColumn['key']) {
        state.searchInfo['id'] = '';
      } else if ('name' == deleteColumn['key']) {
        state.searchInfo['name'] = '';
      } else if ('owner_name' == deleteColumn['key']) {
        state.searchInfo['owner_name'] = '';
      } else if ('contact' == deleteColumn['key']) {
        state.searchInfo['contact'] = '';
      } else if ('company_name' == deleteColumn['key']) {
        state.searchInfo['company_name'] = '';
      }
      //删除显示检索条件
      state.conditionList.removeAt(event.index);

      // 更新
      emit(clone(state));
    });

    //采用逻辑删除客户数据
    on<DeleteMessageDataEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();

        try {
          // 修改
          await SupabaseUtils.getClient()
              .from('mtb_owner')
              .update({'del_kbn': Config.DELETE_YES}).eq('id', event.Id);

          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_3 +
                  WMSLocalizations.i18n(event.context)!.delete_success);
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_3 +
                  WMSLocalizations.i18n(event.context)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }

        // 加载标记
        state.loadingFlag = false;
        // 查询分页数据事件
        add(PageQueryEvent());
      },
    );

    //登录/修改表单
    on<UpdateFormEvent>(
      (event, emit) async {
        //check必须输入项目
        bool checkResult = checkMustInputColumn(state.formInfo, event.context);

        // 判断验证结果
        if (!checkResult) {
          return;
        }
        //model用map做成
        Map<String, dynamic> formInfo = changeMessageMap(state.formInfo);
        // 商品master数据
        List<Map<String, dynamic>> formData;

        //会社管理员身份进行登录/修改
        if (state.roleId != 1) {
          formInfo['id'] = (formInfo['id'] == '' || formInfo['id'] == null)
              ? null
              : int.parse(formInfo['id'].toString());

          Owner message = Owner.fromJson(formInfo);

          if (message.id == null) {
            // 登录的场合
            BotToast.showLoading();
            if (state.formInfo['id'] != null && state.formInfo['id'] != '') {
              state.formInfo['id'] = '';
              // 更新
              emit(clone(state));
              return;
            }
            //填入必须字段
            message.company_id = state.companyId;
            message.create_id =
                StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
            message.create_time = DateTime.now().toString();
            message.update_id =
                StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
            message.update_time = DateTime.now().toString();
            message.del_kbn = '2';

            try {
              // 新增
              formData = await SupabaseUtils.getClient()
                  .from('mtb_owner')
                  .insert([message.toJson()]).select('*');
              // 判断商品数据
              if (formData.length != 0) {
                // 成功提示
                WMSCommonBlocUtils.successTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_3 +
                        WMSLocalizations.i18n(event.context)!.create_success);
              } else {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_3 +
                        WMSLocalizations.i18n(event.context)!.create_error);

                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_3 +
                      WMSLocalizations.i18n(event.context)!.create_error);

              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          } else {
            //修正的场合
            //更新者更新时间
            // check id
            BotToast.showLoading();

            message.update_id =
                StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
            message.update_time = DateTime.now().toString();
            try {
              // 修改情报
              formData = await SupabaseUtils.getClient()
                  .from('mtb_owner')
                  .update(message.toJson())
                  .eq('id', message.id)
                  .select('*');

              if (formData.length != 0) {
                // 成功提示
                WMSCommonBlocUtils.successTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_3 +
                        WMSLocalizations.i18n(event.context)!.update_success);
              } else {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_3 +
                        WMSLocalizations.i18n(event.context)!.update_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_3 +
                      WMSLocalizations.i18n(event.context)!.update_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          }
        } else {
          BotToast.showLoading();
          //admin管理员身份进行登录/修改
          Owner message = Owner.fromJson(formInfo);
          if (message.id == null) {
            if (state.formInfo['id'] != null && state.formInfo['id'] != '') {
              state.formInfo['id'] = '';
              // 更新
              emit(clone(state));
              return;
            }
            //填入必须字段
            message.company_id = state.nowCompanyId == null
                ? state.formInfo['company_id']
                : state.nowCompanyId;
            //更新者更新时间
            message.create_id =
                StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
            message.create_time = DateTime.now().toString();
            message.update_id =
                StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
            message.update_time = DateTime.now().toString();
            message.del_kbn = '2';
            try {
              // 新增
              formData = await SupabaseUtils.getClient()
                  .from('mtb_owner')
                  .insert([message.toJson()]).select('*');
              // 判断数据
              if (formData.length != 0) {
                // 成功提示
                WMSCommonBlocUtils.successTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_3 +
                        WMSLocalizations.i18n(event.context)!.create_success);
              } else {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_3 +
                        WMSLocalizations.i18n(event.context)!.create_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_3 +
                      WMSLocalizations.i18n(event.context)!.create_error);

              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          } else {
            //修正的场合
            // check id
            BotToast.showLoading();
            if (state.formInfo['id'] != null && state.formInfo['id'] != '') {
              state.formInfo['id'] = '';
              // 更新
              emit(clone(state));
            }
            message.company_id = state.nowCompanyId == null
                ? state.formInfo['company_id']
                : state.nowCompanyId;
            //更新者更新时间
            message.update_id =
                StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
            message.update_time = DateTime.now().toString();
            try {
              // 修改商品情报
              formData = await SupabaseUtils.getClient()
                  .from('mtb_owner')
                  .update(message.toJson())
                  .eq('id', message.id)
                  .select('*');

              if (formData.length != 0) {
                // 成功提示
                WMSCommonBlocUtils.successTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_3 +
                        WMSLocalizations.i18n(event.context)!.update_success);
              } else {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_3 +
                        WMSLocalizations.i18n(event.context)!.update_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_3 +
                      WMSLocalizations.i18n(event.context)!.update_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          }
        }
        // 返回上一页
        GoRouter.of(event.context).pop('refresh return');

        // 加载标记
        state.loadingFlag = false;
        // 查询分页数据事件
        add(PageQueryEvent());
      },
    );

    //
    on<SearchButtonHoveredChangeEvent>((event, emit) async {
      //
      state.searchButtonHovered = event.flag;
      // 更新
      emit(clone(state));
    });

    //
    on<SearchOutlinedButtonPressedEvent>((event, emit) async {
      state.searchFlag = !state.searchFlag;
      if (state.searchFlag) {
        state.searchDataFlag = false;
      } else if (state.conditionList.length > 0) {
        state.searchDataFlag = true;
      } else {
        state.searchDataFlag = false;
      }
      // 更新
      emit(clone(state));
    });

    //
    on<SearchInkWellTapEvent>((event, emit) async {
      state.searchFlag = !state.searchFlag;
      if (state.conditionList.length > 0) {
        state.searchDataFlag = true;
      } else {
        state.searchDataFlag = false;
      }
      // 更新
      emit(clone(state));
    });

    //
    on<SetSearchDataFlagAndSearchFlagEvent>((event, emit) async {
      state.searchDataFlag = event.searchDataFlag;
      state.searchFlag = event.searchFlag;
      // 更新
      emit(clone(state));
    });

    // 设置sort字段
    on<SetSortEvent>((event, emit) async {
      state.sortCol = event.sortCol;
      state.ascendingFlg = event.asc;
      emit(clone(state));
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 初始化判断
    add(InitEvent());
  }

  //检索前check处理
  bool selectMessageEventBeforeCheck(
      BuildContext context, ShippingMasterModel state) {
    //检索条件check
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      // 验证是否全数字
      if (CheckUtils.check_Half_Number_In_10(state.searchInfo['id'])) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.shipping_master_form_1 +
                WMSLocalizations.i18n(context)!.input_int_in_10_check);
        return false;
      }
    }
    add(SelectMessageEvent(context));
    return true;
  }

  //check必须输入项目
  bool checkMustInputColumn(
      Map<String, dynamic> formInfo, BuildContext context) {
    if (formInfo['name'] == null || formInfo['name'] == '') {
      // 荷主名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_2 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['name_kana'] == null || formInfo['name_kana'] == '') {
      // 荷主_カナ名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_3 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Kana(formInfo['name_kana'])) {
      // 荷主_カナ入力check
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_3 +
              WMSLocalizations.i18n(context)!.check_kana);
      return false;
    } else if (formInfo['name_short'] == null || formInfo['name_short'] == '') {
      // 略称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_4 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['postal_cd'] == null || formInfo['postal_cd'] == '') {
      // 郵便番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_5 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Postal(formInfo['postal_cd'])) {
      //郵便番号 3位半角数字-4位半角数字
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_5 +
              WMSLocalizations.i18n(context)!.check_postal);
      return false;
    } else if (formInfo['addr_1'] == null || formInfo['addr_1'] == '') {
      // 都道府県
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_6 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['addr_2'] == null || formInfo['addr_2'] == '') {
      // 市区町村
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_7 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['addr_3'] == null || formInfo['addr_3'] == '') {
      // 住所
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_8 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['tel'] == null || formInfo['tel'] == '') {
      // 電話番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_9 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_Hyphen(formInfo['tel'])) {
      //電話番号 半角数字，ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .shipping_master_form_9 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['fax'] != null &&
        formInfo['fax'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(formInfo['fax'])) {
      //Fax 半角数字和ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .shipping_master_form_10 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['owner_name'] == null || formInfo['owner_name'] == '') {
      // 代表者名
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_11 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['contact'] == null || formInfo['contact'] == '') {
      // 担当者名
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_12 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['contact_tel'] == null ||
        formInfo['contact_tel'] == '') {
      // 担当者電話番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_13 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_Hyphen(formInfo['contact_tel'])) {
      //担当者電話番号 半角数字，ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .shipping_master_form_13 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['contact_fax'] != null &&
        formInfo['contact_fax'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(formInfo['contact_fax'])) {
      //担当者Fax 半角数字和ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .shipping_master_form_14 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['contact_email'] == null ||
        formInfo['contact_email'] == '') {
      // 担当者EMAIL
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_15 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Email(formInfo['contact_email'])) {
      //担当者名 -email check
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_15 +
              WMSLocalizations.i18n(context)!.check_email);
      return false;
    } else if (formInfo['start_date'] == null || formInfo['start_date'] == '') {
      // 適用開始日
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_16 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['end_date'] == null || formInfo['end_date'] == '') {
      // 適用終了日
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipping_master_form_17 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
      // } else if (formInfo['company_note1'] == null ||
      //     formInfo['company_note1'] == '') {
      //   // 社内備考1
      //   WMSCommonBlocUtils.tipTextToast(
      //       WMSLocalizations.i18n(context)!.supplier_basic_internal_remarks_1 +
      //           WMSLocalizations.i18n(context)!.can_not_null_text);
      //   return false;
      // } else if (formInfo['company_note2'] == null ||
      //     formInfo['company_note2'] == '') {
      //   // 社内備考2
      //   WMSCommonBlocUtils.tipTextToast(
      //       WMSLocalizations.i18n(context)!.supplier_basic_internal_remarks_2 +
      //           WMSLocalizations.i18n(context)!.can_not_null_text);
      //   return false;
    } else if (formInfo['company_name'] == null ||
        formInfo['company_name'] == '') {
      // 会社名称
      if (state.roleId == 1) {
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(context)!.company_information_2 +
                WMSLocalizations.i18n(context)!.can_not_null_text);
        return false;
      }
    }
    //適用開始日
    String date1 = formInfo['start_date'].toString().replaceAll("/", "-");
    //適用終了日
    String date2 = formInfo['end_date'].toString().replaceAll("/", "-");
    //日期转换
    DateTime startDate = DateTime.parse(date1);
    DateTime endDate = DateTime.parse(date2);
    // 比较两个日期
    if (startDate.isAfter(endDate)) {
      //適用終了日不能大于適用開始日
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.operator_text_5);
      return false;
    }
    return true;
  }

  //model用map做成
  Map<String, dynamic> changeMessageMap(Map<String, dynamic> formInfo) {
    Map<String, dynamic> result = formInfo;
    // 处理-结构
    if (result['id'] == null || result['id'] == '') {
      result.remove('id');
    } else {
      result['id'] = int.parse(result['id'].toString());
    }
    return result;
  }

  //初期化表单
  void initForm(ShippingMasterModel state) {
    // 会社情报初期化
    state.formInfo = {
      'id': '',
      'name': '',
      'name_kana': '',
      'name_short': '',
      'postal_cd': '',
      'addr_1': '',
      'addr_2': '',
      'addr_3': '',
      'tel': '',
      'fax': '',
      'owner_name': '',
      'contact': '',
      'contact_tel': '',
      'contact_fax': '',
      'contact_email': '',
      'start_date': '',
      'end_date': '',
      'company_name': '',
      'company_note1': '',
      'company_note2': '',
    };
    //状态初期化
    state.stateFlg = '1';
  }

  //初期化检索条件
  void initSearch(ShippingMasterModel state) {
    state.searchInfo = {
      'id': '',
      'name': '',
      'owner_name': '',
      'contact': '',
      'company_name': ''
    };
    state.searchKbn = '';
    state.conditionList = [];
  }

  //设定检索条件
  PostgrestFilterBuilder setSelectConditions(
      ShippingMasterModel state, PostgrestFilterBuilder query, bool flag) {
    if (flag) {
      query = query.eq('company_id', state.companyId);
    }

    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      query = query.eq('id', int.parse(state.searchInfo['id'].toString()));
    }
    if (state.searchInfo['name'] != '' && state.searchInfo['name'] != null) {
      String nameShotTemp = '%' + state.searchInfo['name'] + '%';
      query = query.like('name', nameShotTemp.toString());
    }
    if (state.searchInfo['owner_name'] != '' &&
        state.searchInfo['owner_name'] != null) {
      String nameShotTemp = '%' + state.searchInfo['owner_name'] + '%';
      query = query.like('owner_name', nameShotTemp.toString());
    }
    if (state.searchInfo['contact'] != '' &&
        state.searchInfo['contact'] != null) {
      String nameShotTemp = '%' + state.searchInfo['contact'] + '%';
      query = query.like('contact', nameShotTemp.toString());
    }
    var result = query;
    return result;
  }
}
