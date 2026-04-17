import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/page/mst/warehouse_master/bloc/warehouse_master_model.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../model/warehouse.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../setting/menu_master/bloc/menu_master_bloc.dart';

/**
 * 内容：倉庫マスタ管理-BLOC
 * 作者：王光顺
 * 时间：2023/10/10
 */
// 事件
abstract class WarehouseMasterEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends WarehouseMasterEvent {
  // 初始化事件
  InitEvent();
}

// 导入CSV文件事件
class ImportCSVFileEvent extends WarehouseMasterEvent {
  // 结构树
  BuildContext context;
  // 内容
  List<List<Map<String, dynamic>>> content;
  // 导入CSV文件事件
  ImportCSVFileEvent(this.context, this.content);
}

// 自定义事件 - 始
// 设定出荷指示值事件
class SetShipValueEvent extends WarehouseMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetShipValueEvent(this.key, this.value);
}

// 保存表单事件
class SaveShipFormEvent extends WarehouseMasterEvent {
  // 结构树
  BuildContext context;
  // 结构
  Map<String, dynamic> shipStructure = {};
  // 保存表单事件
  SaveShipFormEvent(this.context, this.shipStructure);
}

// 检索事件
class QueryDetailEvent extends WarehouseMasterEvent {
  // 查询明细事件
  List<dynamic> list;

  QueryDetailEvent(this.list);
}

// 基本情报明细事件
class QueryShipEvent extends WarehouseMasterEvent {
  // 查询明细事件
  QueryShipEvent();
}

// 设定明细值事件
class SetShipDetailValueEvent extends WarehouseMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetShipDetailValueEvent(this.key, this.value);
}

// 设定菜单情报值事件
class SetMenuValueEvent extends WarehouseMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetMenuValueEvent(this.key, this.value);
}

// 赵士淞 - 始
// 设定菜单情报集合事件
class SetMenuMapEvent extends WarehouseMasterEvent {
  // 值集合
  Map<String, dynamic> valueMap;
  // 设定菜单情报集合事件
  SetMenuMapEvent(this.valueMap);
}
// 赵士淞 - 终

//消除处理
class DeleteMenuEvent extends MenuMasterEvent {
  // 结构树
  BuildContext context;
  //菜单主键
  int menuId;
  //消除处理
  DeleteMenuEvent(this.context, this.menuId);
}

//显示form数据
class ShowSelectValueEvent extends MenuMasterEvent {
  // Value
  dynamic value;
  //状态flg
  String stateflg;
  ShowSelectValueEvent(this.value, this.stateflg);
}

//清除表单
class ClearFormEvent extends MenuMasterEvent {
  // 清除表单
  ClearFormEvent();
}

//登录/修改表单
class UpdateFormEvent extends MenuMasterEvent {
  // 结构树
  BuildContext context;
  UpdateFormEvent(this.context);
}

//设定检索条件值事件
class SetSearchValueEvent extends MenuMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value);
}

// 赵士淞 - 始
// 设定检索条件集合事件
class SetSearchMapEvent extends MenuMasterEvent {
  // 值集合
  Map<String, dynamic> valueMap;
  // 设定检索条件集合事件
  SetSearchMapEvent(this.valueMap);
}
// 赵士淞 - 终

//清除检索条件
class ClearSeletMenuEvent extends MenuMasterEvent {
  //检索处理
  ClearSeletMenuEvent();
}

// 删除检索条件值事件
class DeleteSearchValueEvent extends MenuMasterEvent {
  // index
  int index;

  // 设定值事件
  DeleteSearchValueEvent(this.index);
}

//
class SearchButtonHoveredChangeEvent extends MenuMasterEvent {
  //
  bool flag;
  //
  SearchButtonHoveredChangeEvent(this.flag);
}

//
class SearchOutlinedButtonPressedEvent extends MenuMasterEvent {
  //
  SearchOutlinedButtonPressedEvent();
}

//
class SearchInkWellTapEvent extends MenuMasterEvent {
  //
  SearchInkWellTapEvent();
}

//
class SetSearchDataFlagAndSearchFlagEvent extends MenuMasterEvent {
  //
  bool searchDataFlag;
  //
  bool searchFlag;
  //
  SetSearchDataFlagAndSearchFlagEvent(this.searchDataFlag, this.searchFlag);
}

// 设置sort字段
class SetSortEvent extends WarehouseMasterEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终

class WarehouseMasterBloc extends WmsTableBloc<WarehouseMasterModel> {
  // 刷新补丁
  @override
  WarehouseMasterModel clone(WarehouseMasterModel src) {
    return WarehouseMasterModel.clone(
      src,
    );
  }

  WarehouseMasterBloc(WarehouseMasterModel state) : super(state) {
    // 检索处理
    on<SeletMenuEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //设定显示检索条件
      state.conditionList = [];
      if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
        state.conditionList.add({'key': 'id', 'value': state.searchInfo['id']});
      }
      // 赵士淞 - 始
      if (state.searchInfo['company_id'] != '' &&
          state.searchInfo['company_id'] != null &&
          state.searchInfo['company_name'] != '' &&
          state.searchInfo['company_name'] != null) {
        state.conditionList.add(
            {'key': 'company_name', 'value': state.searchInfo['company_name']});
      }
      // 赵士淞 - 终
      if (state.searchInfo['code'] != '' && state.searchInfo['code'] != null) {
        state.conditionList
            .add({'key': 'code', 'value': state.searchInfo['code']});
      }
      if (state.searchInfo['name'] != '' && state.searchInfo['name'] != null) {
        state.conditionList
            .add({'key': 'name', 'value': state.searchInfo['name']});
      }
      if (state.searchInfo['kbn'] != '' && state.searchInfo['kbn'] != null) {
        state.conditionList
            .add({'key': 'kbn', 'value': state.searchInfo['kbn']});
      }
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    //清除检索条件
    on<ClearSeletMenuEvent>((event, emit) {
      // 打开加载状态
      BotToast.showLoading();
      //初期化检索条件
      initSearch(state);
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

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
        // 赵士淞 - 始
      } else if ('company_name' == deleteColumn['key']) {
        state.searchInfo['company_id'] = '';
        state.searchInfo['company_name'] = '';
        // 赵士淞 - 终
      } else if ('code' == deleteColumn['key']) {
        state.searchInfo['code'] = '';
      } else if ('name' == deleteColumn['key']) {
        state.searchInfo['name'] = '';
      } else if ('kbn' == deleteColumn['key']) {
        state.searchInfo['kbn'] = '';
      }

      //删除显示检索条件
      state.conditionList.removeAt(event.index);

      // 更新
      emit(clone(state));
    });

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

      // 更新
      emit(clone(state));
    });

    // 赵士淞 - 始
    // 设定检索条件集合事件
    on<SetSearchMapEvent>((event, emit) async {
      // 检索情报-临时
      Map<String, dynamic> searchTemp = Map<String, dynamic>();
      searchTemp.addAll(state.searchInfo);
      // 循环值集合
      event.valueMap.forEach((key, value) {
        // 判断key
        if (searchTemp[key] != null) {
          // 检索情报-临时
          searchTemp[key] = value;
        } else {
          // 检索情报-临时
          searchTemp.addAll({key: value});
        }
      });
      // 检索情报-定制
      state.searchInfo = searchTemp;

      // 更新
      emit(clone(state));
    });
    // 赵士淞 - 终

    //表单清除
    on<ClearFormEvent>(
      (event, emit) {
        //初期化表单
        initForm(state);
        // 更新
        emit(clone(state));
      },
    );

    //登录/修改表单
    on<UpdateFormEvent>((event, emit) async {
      //check必须输入项目
      bool checkResult = checkMustInputColumn(state.formInfo, event.context);
      // 判断验证结果
      if (!checkResult) {
        return;
      }
      //model用map做成
      Map<String, dynamic> formInfo = changeMap(state.formInfo);
      // 仓库master数据
      List<Map<String, dynamic>> formData;
      Warehouse ware = Warehouse.fromJson(formInfo);
      //判断登录场合
      if (ware.id == null) {
        //填入必须字段
        // 赵士淞 - 始
        // 判断登录用户角色
        if (StoreProvider.of<WMSState>(event.context)
                .state
                .loginUser
                ?.role_id !=
            1) {
          // 会社ID
          ware.company_id = StoreProvider.of<WMSState>(event.context)
              .state
              .loginUser
              ?.company_id;
        }
        // 赵士淞 - 终
        ware.create_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        ware.create_time = DateTime.now().toString();
        ware.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        ware.update_time = DateTime.now().toString();
        try {
          BotToast.showLoading();
          // 新增菜单
          formData = await SupabaseUtils.getClient()
              .from('mtb_warehouse')
              .insert([ware.toJson()]).select('*');
          // 判断菜单数据
          if (formData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_19 +
                    WMSLocalizations.i18n(event.context)!.create_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_19 +
                    WMSLocalizations.i18n(event.context)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_19 +
                  WMSLocalizations.i18n(event.context)!.create_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else {
        //修正的场合
        //更新者更新时间
        ware.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        ware.update_time = DateTime.now().toString();
        try {
          // 开启加载
          BotToast.showLoading();
          // 修改菜单情报
          formData = await SupabaseUtils.getClient()
              .from('mtb_warehouse')
              .update(ware.toJson())
              .eq('id', ware.id)
              .select('*');
          // 判断菜单数据
          if (formData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_19 +
                    WMSLocalizations.i18n(event.context)!.update_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_19 +
                    WMSLocalizations.i18n(event.context)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_19 +
                  WMSLocalizations.i18n(event.context)!.update_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      }
      // 返回上一页
      GoRouter.of(event.context).pop('refresh return');

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

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
      // 查询
      var query = SupabaseUtils.getClient().from('mtb_warehouse').select('*');
      //设置检索条件
      query = setSelectConditions(state, query);

      List<dynamic> data;
      if (state.onlyMyselfData) {
        data = await query
            .eq(
                'company_id',
                StoreProvider.of<WMSState>(state.context)
                    .state
                    .loginUser
                    ?.company_id)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1)
            .order(state.sortCol, ascending: state.ascendingFlg);
      } else {
        data = await query
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1)
            .order(state.sortCol, ascending: state.ascendingFlg);
      }
      // 列表数据清空
      state.records.clear();
      // 循环菜单数据
      for (int i = 0; i < data.length; i++) {
        // 赵士淞 - 始
        // 临时数据
        dynamic tempData = data[i];
        // 循环会社列表
        for (var i = 0; i < state.companyList.length; i++) {
          // 判断是否同一会社
          if (state.companyList[i]['id'] == tempData['company_id']) {
            // 会社名
            tempData['company_name'] = state.companyList[i]['name'];
            // 中止循环
            break;
          }
        }

        state.records.add(WmsRecordModel(i, tempData));
        // 赵士淞 - 终
      }

      // 查询总数
      var queryCount;
      if (state.onlyMyselfData) {
        queryCount = SupabaseUtils.getClient()
            .from('mtb_warehouse')
            .select(
              '*',
              const FetchOptions(
                count: CountOption.exact,
              ),
            )
            .eq(
                'company_id',
                StoreProvider.of<WMSState>(state.context)
                    .state
                    .loginUser
                    ?.company_id);
      } else {
        queryCount = SupabaseUtils.getClient().from('mtb_warehouse').select(
              '*',
              const FetchOptions(
                count: CountOption.exact,
              ),
            );
      }
      //设置检索条件
      queryCount = setSelectConditions(state, queryCount);
      final countResult = await queryCount;
      // 总页数
      state.total = countResult.count;

      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    //显示form数据
    on<ShowSelectValueEvent>((event, emit) async {
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
    });

    // 删除菜单事件
    on<DeleteMenuEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      try {
        //菜单使用check
        //mtb_authority(権限マスタ)
        final mtbAuthorityCount = await SupabaseUtils.getClient()
            .from('mtb_authority')
            .select(
              '*',
              const FetchOptions(
                count: CountOption.exact,
              ),
            )
            .eq('menu_id', event.menuId);
        if (mtbAuthorityCount.count != 0) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_check_exists +
                  WMSLocalizations.i18n(event.context)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }

        // check通过 删除数据
        List<Map<String, dynamic>> menuData = await SupabaseUtils.getClient()
            .from('mtb_menu')
            .delete()
            .eq('id', event.menuId)
            .select('*');
        // 判断删除是否成功
        if (menuData.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(event.context)!.menu_master +
                  WMSLocalizations.i18n(event.context)!.delete_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_master +
                  WMSLocalizations.i18n(event.context)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(event.context)!.menu_master +
                WMSLocalizations.i18n(event.context)!.delete_error);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 设定情报值事件
    on<SetMenuValueEvent>((event, emit) async {
      // 情报-临时
      Map<String, dynamic> formTemp = Map<String, dynamic>();
      formTemp.addAll(state.formInfo);
      // 判断key
      if (formTemp[event.key] != null) {
        formTemp[event.key] = event.value;
      } else {
        formTemp.addAll({event.key: event.value});
      }

      state.formInfo = formTemp;

      // 更新
      emit(clone(state));
    });

    // 赵士淞 - 始
    // 设定菜单情报集合事件
    on<SetMenuMapEvent>((event, emit) async {
      // 情报-临时
      Map<String, dynamic> formTemp = Map<String, dynamic>();
      formTemp.addAll(state.formInfo);
      // 循环值集合
      event.valueMap.forEach((key, value) {
        // 判断key
        if (formTemp[key] != null) {
          // 情报-临时
          formTemp[key] = value;
        } else {
          // 情报-临时
          formTemp.addAll({key: value});
        }
      });
      // 菜单情报
      state.formInfo = formTemp;

      // 更新
      emit(clone(state));
    });
    // 赵士淞 - 终

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 自定义事件 - 始
      // 判断登录用户角色
      if (StoreProvider.of<WMSState>(state.context).state.loginUser?.role_id !=
          1) {
        // 仅自己数据
        state.onlyMyselfData = true;
      } else {
        // 仅自己数据
        state.onlyMyselfData = false;
      }

      //初期化表单
      initForm(state);

      //初期化检索条件
      initSearch(state);

      // 赵士淞 - 始
      // 会社数据
      List<dynamic> companyData = await SupabaseUtils.getClient()
          .from('mtb_company')
          .select('*')
          .in_('status', ['1', '2']);
      // 会社列表
      state.companyList = companyData;
      // 赵士淞 - 终
      // 自定义事件 - 终
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

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

    add(InitEvent());
  }

  //自定义方法 - 始
  //检索前check处理
  bool seletMenuEventBeforeCheck(
      BuildContext context, WarehouseMasterModel state) {
    //检索条件check
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      // 验证是否全数字
      if (CheckUtils.check_Half_Number_In_10(state.searchInfo['id'])) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.warehouse_master_1 +
                WMSLocalizations.i18n(context)!.input_int_in_10_check);
        return false;
      }
    }

    add(SeletMenuEvent(context));
    return true;
  }

  //check必须输入项目
  bool checkMustInputColumn(
      Map<String, dynamic> formInfo, BuildContext context) {
    // 赵士淞 - 始
    // 判断登录用户角色
    if (StoreProvider.of<WMSState>(context).state.loginUser?.role_id == 1) {
      if (formInfo['company_id'] == null || formInfo['company_id'] == '') {
        // 会社名
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(context)!.delivery_form_company +
                WMSLocalizations.i18n(context)!.can_not_null_text);
        return false;
      }
    }
    // 仓库CD 半角英数
    if (formInfo['code'] != null &&
        formInfo['code'] != '' &&
        CheckUtils.check_Half_Alphanumeric(formInfo['code'])) {
      // 会社名
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.warehouse_master_2 +
              WMSLocalizations.i18n(context)!.check_half_width_alphanumeric);
      return false;
    }
    // 赵士淞 - 终
    if (formInfo['name'] == null || formInfo['name'] == '') {
      //名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.warehouse_master_3 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    }
    // 赵士淞 - 测试修复 2023/11/16 - 始
    if (formInfo['name_short'] == null || formInfo['name_short'] == '') {
      //名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_form_abbreviation +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else {
      //英文、数字输入check
      if (CheckUtils.check_Half_Alphanumeric(formInfo['name_short'])) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.delivery_form_abbreviation +
                WMSLocalizations.i18n(context)!.check_half_width_alphanumeric);
        return false;
      }
    }

    if (formInfo['postal_cd'] != null &&
        formInfo['postal_cd'] != '' &&
        CheckUtils.check_Postal(formInfo['postal_cd'])) {
      //郵便番号 3位半角数字-4位半角数字
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_6 +
              WMSLocalizations.i18n(context)!.check_postal);
      return false;
    }

    if (formInfo['tel'] != null &&
        formInfo['tel'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(formInfo['tel'])) {
      //電話番号 半角数字，ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .company_information_10 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    }

    if (formInfo['fax'] != null &&
        formInfo['fax'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(formInfo['fax'])) {
      //fax 半角数字，ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .company_information_11 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    }

    // 赵士淞 - 测试修复 2023/11/16 - 终

    return true;
  }

  //model用map做成
  Map<String, dynamic> changeMap(Map<String, dynamic> formInfo) {
    Map<String, dynamic> result = formInfo;
    // 处理-结构
    if (result['id'] == null || result['id'] == '') {
      result.remove('id');
    } else {
      result['id'] = int.parse(result['id'].toString());
    }
    if (result['company_id'] == null || result['company_id'] == '') {
      result.remove('company_id');
    } else {
      result['company_id'] = int.parse(result['company_id'].toString());
    }

    return result;
  }

  //初期化表单
  void initForm(WarehouseMasterModel state) {
    // メニュー情报初期化
    state.formInfo = {
      'id': '',
      // 赵士淞 - 始
      'company_id': '',
      'company_name': '',
      // 赵士淞 - 终
      'code': '',
      'name': '',
      'name_short': '',
      'kbn': '',
      'area': '',
      'postal_cd': '',
      'addr_1': '',
      'addr_2': '',
      'addr_3': '',
      'tel': '',
      'fax': '',
      'note1': '',
      'note2': ''
    };
    //状态初期化
    state.stateFlg = '1';
  }

  //初期化检索条件
  void initSearch(WarehouseMasterModel state) {
    state.searchInfo = {
      'id': '',
      // 赵士淞 - 始
      'company_id': '',
      'company_name': '',
      // 赵士淞 - 终
      'code': '',
      'name': '',
      'kbn': ''
    };
    state.conditionList = [];
  }

  //设定检索条件
  PostgrestFilterBuilder setSelectConditions(
      WarehouseMasterModel state, PostgrestFilterBuilder query) {
    var result = query;
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      query = query.eq('id', int.parse(state.searchInfo['id'].toString()));
    }
    // 赵士淞 - 始
    if (state.searchInfo['company_id'] != '' &&
        state.searchInfo['company_id'] != null &&
        state.searchInfo['company_name'] != '' &&
        state.searchInfo['company_name'] != null) {
      query = query.eq(
          'company_id', int.parse(state.searchInfo['company_id'].toString()));
    }
    // 赵士淞 - 终
    if (state.searchInfo['code'] != '' && state.searchInfo['code'] != null) {
      query = query.eq('code', (state.searchInfo['code'].toString()));
    }
    if (state.searchInfo['name'] != '' && state.searchInfo['name'] != null) {
      String nameTemp = '%' + state.searchInfo['name'] + '%';
      query = query.like('name', nameTemp.toString());
    }
    if (state.searchInfo['kbn'] != '' && state.searchInfo['kbn'] != null) {
      query = query.eq('kbn', (state.searchInfo['kbn'].toString()));
    }
    return result;
  }

  //自定义方法 - 终
}
