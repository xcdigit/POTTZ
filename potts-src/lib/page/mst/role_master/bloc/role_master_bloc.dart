import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/model/role.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'role_master_model.dart';

/**
 * 内容：ロールマスタ管理-BLOC
 * 作者：穆政道
 * 时间：2023/10/08
 */
// 事件
abstract class RoleMasterEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends RoleMasterEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定检索条件值事件
class SetSearchValueEvent extends RoleMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value);
}

// 删除检索条件值事件
class DeleteSearchValueEvent extends RoleMasterEvent {
  // index
  int index;

  // 设定值事件
  DeleteSearchValueEvent(this.index);
}

// 设定ロール情报值事件
class SetRoleValueEvent extends RoleMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetRoleValueEvent(this.key, this.value);
}

//清除表单
class ClearFormEvent extends RoleMasterEvent {
  // 清除表单
  ClearFormEvent();
}

//登录/修改表单
class UpdateFormEvent extends RoleMasterEvent {
  // 结构树
  BuildContext context;
  UpdateFormEvent(this.context);
}

//显示form数据
class ShowSelectValueEvent extends RoleMasterEvent {
  // Value
  dynamic value;
  //状态flg
  String stateflg;
  ShowSelectValueEvent(this.value, this.stateflg);
}

//检索处理
class SeletRoleEvent extends RoleMasterEvent {
  // 结构树
  BuildContext context;
  //检索处理
  SeletRoleEvent(this.context);
}

//清除检索条件
class ClearSeletRoleEvent extends RoleMasterEvent {
  //检索处理
  ClearSeletRoleEvent();
}

//消除处理
class DeleteRoleEvent extends RoleMasterEvent {
  // 结构树
  BuildContext context;
  //ロール主键
  int roleId;
  //消除处理
  DeleteRoleEvent(this.context, this.roleId);
}

//
class SearchButtonHoveredChangeEvent extends RoleMasterEvent {
  //
  bool flag;
  //
  SearchButtonHoveredChangeEvent(this.flag);
}

//
class SearchOutlinedButtonPressedEvent extends RoleMasterEvent {
  //
  SearchOutlinedButtonPressedEvent();
}

//
class SearchInkWellTapEvent extends RoleMasterEvent {
  //
  SearchInkWellTapEvent();
}

//
class SetSearchDataFlagAndSearchFlagEvent extends RoleMasterEvent {
  //
  bool searchDataFlag;
  //
  bool searchFlag;
  //
  SetSearchDataFlagAndSearchFlagEvent(this.searchDataFlag, this.searchFlag);
}

// 设置sort字段
class SetSortEvent extends RoleMasterEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终

class RoleMasterBloc extends WmsTableBloc<RoleMasterModel> {
  // 刷新补丁
  @override
  RoleMasterModel clone(RoleMasterModel src) {
    return RoleMasterModel.clone(src);
  }

  RoleMasterBloc(RoleMasterModel state) : super(state) {
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
      // 查询出荷指示
      var query = SupabaseUtils.getClient().from('mtb_role').select('*');

      query = setSelectConditions(state, query);

      List<dynamic> data = await query
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      // 循环商品数据
      for (int i = 0; i < data.length; i++) {
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }

      // 查询ロール总数
      var queryCount = SupabaseUtils.getClient().from('mtb_role').select(
            '*',
            const FetchOptions(
              count: CountOption.exact,
            ),
          );
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
      } else if ('description' == deleteColumn['key']) {
        state.searchInfo['description'] = '';
      }

      //删除显示检索条件
      state.conditionList.removeAt(event.index);

      // 更新
      emit(clone(state));
    });

    // 设定ロール情报值事件
    on<SetRoleValueEvent>((event, emit) async {
      // ロール情报-临时
      Map<String, dynamic> formTemp = Map<String, dynamic>();
      formTemp.addAll(state.formInfo);
      // 判断key
      if (formTemp[event.key] != null) {
        // ロール情报-临时
        formTemp[event.key] = event.value;
      } else {
        // ロール情报-临时
        formTemp.addAll({event.key: event.value});
      }
      // ロール情报-定制
      state.formInfo = formTemp;

      // 更新
      emit(clone(state));
    });

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
      Map<String, dynamic> formInfo = changeRoleMap(state.formInfo);
      // 商品master数据
      List<Map<String, dynamic>> formData;
      Role role = Role.fromJson(formInfo);
      //判断登录场合
      if (role.id == null) {
        //填入必须字段
        role.create_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        role.create_time = DateTime.now().toString();
        role.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        role.update_time = DateTime.now().toString();
        try {
          BotToast.showLoading();
          // 新增角色
          formData = await SupabaseUtils.getClient()
              .from('mtb_role')
              .insert([role.toJson()]).select('*');
          // 判断角色数据
          if (formData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.role_basic +
                    WMSLocalizations.i18n(event.context)!.create_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.role_basic +
                    WMSLocalizations.i18n(event.context)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.role_basic +
                  WMSLocalizations.i18n(event.context)!.create_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else {
        //修正的场合
        //更新者更新时间
        role.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        role.update_time = DateTime.now().toString();
        try {
          BotToast.showLoading();
          // 修改商品情报
          formData = await SupabaseUtils.getClient()
              .from('mtb_role')
              .update(role.toJson())
              .eq('id', role.id)
              .select('*');
          // 判断角色数据
          if (formData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.role_basic +
                    WMSLocalizations.i18n(event.context)!.update_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.role_basic +
                    WMSLocalizations.i18n(event.context)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.role_basic +
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

    // 检索处理
    on<SeletRoleEvent>((event, emit) async {
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
      if (state.searchInfo['description'] != '' &&
          state.searchInfo['description'] != null) {
        state.conditionList.add(
            {'key': 'description', 'value': state.searchInfo['description']});
      }
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    //清除检索条件
    on<ClearSeletRoleEvent>((event, emit) {
      // 打开加载状态
      BotToast.showLoading();
      //初期化检索条件
      initSearch(state);
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 删除角色事件
    on<DeleteRoleEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      try {
        //角色使用check
        //ytb_use_type(ライセンス・課金管理)
        final ytbUseTypeCount = await SupabaseUtils.getClient()
            .from('ytb_use_type')
            .select(
              '*',
              const FetchOptions(
                count: CountOption.exact,
              ),
            )
            .eq('role_id', event.roleId);
        if (ytbUseTypeCount.count != 0) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.role_check_exists_1);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        //mtb_authority(権限マスタ)
        final mtbAuthorityCount = await SupabaseUtils.getClient()
            .from('mtb_authority')
            .select(
              '*',
              const FetchOptions(
                count: CountOption.exact,
              ),
            )
            .eq('role_id', event.roleId);
        if (mtbAuthorityCount.count != 0) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.role_check_exists_2);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        //mtb_user(ユーザーマスタ)
        final mtbUserCount = await SupabaseUtils.getClient()
            .from('mtb_user')
            .select(
              '*',
              const FetchOptions(
                count: CountOption.exact,
              ),
            )
            .eq('role_id', event.roleId);
        if (mtbUserCount.count != 0) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.role_check_exists_3);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }

        // check通过 删除数据
        List<Map<String, dynamic>> roleData = await SupabaseUtils.getClient()
            .from('mtb_role')
            .delete()
            .eq('id', event.roleId)
            .select('*');
        // 判断删除是否成功
        if (roleData.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(event.context)!.role_basic +
                  WMSLocalizations.i18n(event.context)!.delete_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.role_basic +
                  WMSLocalizations.i18n(event.context)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(event.context)!.role_basic +
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

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 自定义事件 - 始
      //初期化表单
      initForm(state);

      //初期化检索条件
      initSearch(state);
      // 加载标记
      state.loadingFlag = false;
      // 自定义事件 - 终

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
  bool selectRoleEventBeforeCheck(BuildContext context, RoleMasterModel state) {
    //检索条件check
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      // 验证是否全数字
      if (CheckUtils.check_Half_Number_In_10(state.searchInfo['id'])) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.role_overview_id +
                WMSLocalizations.i18n(context)!.input_int_in_10_check);
        return false;
      }
    }
    add(SeletRoleEvent(context));
    return true;
  }

  //check必须输入项目
  bool checkMustInputColumn(
      Map<String, dynamic> formInfo, BuildContext context) {
    if (formInfo['name'] == null || formInfo['name'] == '') {
      //ロール名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.role_basic_name +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    }

    return true;
  }

  //model用map做成
  Map<String, dynamic> changeRoleMap(Map<String, dynamic> formInfo) {
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
  void initForm(RoleMasterModel state) {
    // ロール情报初期化
    state.formInfo = {'id': '', 'name': '', 'description': ''};
    //状态初期化
    state.stateFlg = '1';
  }

  //初期化检索条件
  void initSearch(RoleMasterModel state) {
    state.searchInfo = {'id': '', 'name': '', 'description': ''};
    state.conditionList = [];
  }

  PostgrestFilterBuilder setSelectConditions(
      RoleMasterModel state, PostgrestFilterBuilder query) {
    var result = query;
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      query = query.eq('id', int.parse(state.searchInfo['id'].toString()));
    }
    if (state.searchInfo['name'] != '' && state.searchInfo['name'] != null) {
      String nameTemp = '%' + state.searchInfo['name'] + '%';
      query = query.like('name', nameTemp.toString());
    }
    if (state.searchInfo['description'] != '' &&
        state.searchInfo['description'] != null) {
      String nameShotTemp = '%' + state.searchInfo['description'] + '%';
      query = query.like('description', nameShotTemp.toString());
    }
    return result;
  }
  //自定义方法 - 终
}
