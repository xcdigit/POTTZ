import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/model/authority.dart';
import 'package:wms/redux/wms_state.dart';
import 'package:wms/widget/table/bloc/wms_record_model.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';
import 'auth_master_model.dart';

/**
 * 内容：权限マスタ管理-BLOC
 * 作者：穆政道
 * 时间：2023/09/30
 */
// 事件
abstract class AuthMasterEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends AuthMasterEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定下拉框情报值事件
class SetDropdownValueEvent extends AuthMasterEvent {
  String key;
  dynamic value;
  // 设定值事件
  SetDropdownValueEvent(this.key, this.value);
}

// 设定检索条件值事件
class SetSearchValueEvent extends AuthMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // Value
  dynamic name;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value, this.name);
}

// 删除检索条件值事件
class DeleteSearchValueEvent extends AuthMasterEvent {
  // index
  int index;

  // 设定值事件
  DeleteSearchValueEvent(this.index);
}

// 设定权限情报值事件
class SetAuthValueEvent extends AuthMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetAuthValueEvent(this.key, this.value);
}

//设定按钮显示状态
class SetStateFlgValueEvent extends AuthMasterEvent {
  // flg
  String flg;
  // 设定值事件
  SetStateFlgValueEvent(this.flg);
}

//清除表单
class ClearFormEvent extends AuthMasterEvent {
  // 清除表单
  ClearFormEvent();
}

//登录/修改表单
class UpdateFormEvent extends AuthMasterEvent {
  // 结构树
  BuildContext context;
  UpdateFormEvent(this.context);
}

//显示form数据
class ShowSelectValueEvent extends AuthMasterEvent {
  // Value
  dynamic value;
  //状态flg
  String stateflg;
  ShowSelectValueEvent(this.value, this.stateflg);
}

//消除处理
class DeleteAuthEvent extends AuthMasterEvent {
  // 结构树
  BuildContext context;
  //权限主键
  int authId;
  //消除处理
  DeleteAuthEvent(this.context, this.authId);
}

//检索处理
class SeletAuthEvent extends AuthMasterEvent {
  //检索处理
  SeletAuthEvent();
}

//清除检索条件
class ClearSeletAuthEvent extends AuthMasterEvent {
  //检索处理
  ClearSeletAuthEvent();
}

// 设置sort字段
class SetSortEvent extends AuthMasterEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终

class AuthMasterBloc extends WmsTableBloc<AuthMasterModel> {
  // 刷新补丁
  @override
  AuthMasterModel clone(AuthMasterModel src) {
    return AuthMasterModel.clone(src);
  }

  AuthMasterBloc(AuthMasterModel state) : super(state) {
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
      //设置检索条件
      Map<String, dynamic> searchMap = Map();
      if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
        searchMap['id'] = int.parse(state.searchInfo['id']);
      } else {
        searchMap['id'] = null;
      }
      if (state.searchInfo['role_id'] != '' &&
          state.searchInfo['role_id'] != null) {
        searchMap['role_id'] = int.parse(state.searchInfo['role_id']);
      } else {
        searchMap['role_id'] = null;
      }
      if (state.searchInfo['menu_id'] != '' &&
          state.searchInfo['menu_id'] != null) {
        searchMap['menu_id'] = int.parse(state.searchInfo['menu_id']);
      } else {
        searchMap['menu_id'] = null;
      }
      if (state.searchInfo['auth'] != '' && state.searchInfo['auth'] != null) {
        searchMap['auth'] = state.searchInfo['auth'];
      } else {
        searchMap['auth'] = null;
      }

      // 查询权限マスタ
      List<dynamic> dataSearch = await SupabaseUtils.getClient()
          .rpc('func_query_table_mtb_authority', params: searchMap)
          .select()
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      state.records.clear();
      for (int i = 0; i < dataSearch.length; i++) {
        // 列表数据增加
        state.records.add(WmsRecordModel(i, dataSearch[i]));
      }
      //查询数据总数
      List<dynamic> count = await SupabaseUtils.getClient()
          .rpc('func_query_total_table_mtb_authority', params: searchMap)
          .select();
      // 总页数
      state.total = count[0]['total'];
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

      //设定检索roleName和menuName
      if (event.key == 'role_id') {
        // 检索情报-临时
        searchTemp['role_name'] = event.name;
      } else if (event.key == 'menu_id') {
        // 检索情报-临时
        searchTemp['menu_name'] = event.name;
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
      } else if ('role_id' == deleteColumn['key']) {
        state.searchInfo['role_id'] = '';
        state.searchInfo['role_name'] = '';
      } else if ('menu_id' == deleteColumn['key']) {
        state.searchInfo['menu_id'] = '';
        state.searchInfo['menu_name'] = '';
      } else if ('auth' == deleteColumn['key']) {
        state.searchInfo['auth'] = '';
      }

      //删除显示检索条件
      state.conditionList.removeAt(event.index);

      // 更新
      emit(clone(state));
    });

    // 设定权限情报值事件
    on<SetAuthValueEvent>((event, emit) async {
      // 权限情报-临时
      Map<String, dynamic> authTemp = Map<String, dynamic>();
      authTemp.addAll(state.formInfo);
      // 判断key
      if (authTemp[event.key] != null) {
        // 权限情报-临时
        authTemp[event.key] = event.value;
      } else {
        // 权限情报-临时
        authTemp.addAll({event.key: event.value});
      }
      // 权限情报-定制
      state.formInfo = authTemp;

      // 更新
      emit(clone(state));
    });

    // 设定按钮显示状态
    on<SetStateFlgValueEvent>((event, emit) {
      //设定flg
      state.stateFlg = event.flg;
      // 更新
      emit(clone(state));
    });

    //表单清除
    on<ClearFormEvent>(
      (event, emit) {
        //初期化表单
        initForm(state);
        //初期化ロール名称下拉框
        initRoleInfo(state);
        //初期化メニュー名称下拉框
        initMenuInfo(state);
        // 更新
        emit(clone(state));
      },
    );

    //登录/修改表单
    on<UpdateFormEvent>((event, emit) async {
      BotToast.showLoading();
      //check必须输入项目
      bool checkResult =
          await checkMustInputColumn(state.formInfo, event.context);
      // 判断验证结果
      if (!checkResult) {
        BotToast.closeAllLoading();
        return;
      }
      //model用map做成
      Map<String, dynamic> authInfo = changeAuthMap(state.formInfo);
      // 商品master数据
      List<Map<String, dynamic>> authData;
      Authority auth = Authority.fromJson(authInfo);
      //判断登录场合
      if (auth.id == null) {
        //填入必须字段
        auth.create_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        auth.create_time = DateTime.now().toString();
        auth.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        auth.update_time = DateTime.now().toString();
        try {
          // 新增商品
          authData = await SupabaseUtils.getClient()
              .from('mtb_authority')
              .insert([auth.toJson()]).select('*');
          // 判断商品数据
          if (authData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.auth_Form_4 +
                    WMSLocalizations.i18n(event.context)!.create_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.auth_Form_4 +
                    WMSLocalizations.i18n(event.context)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.auth_Form_4 +
                  WMSLocalizations.i18n(event.context)!.create_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else {
        //修正的场合
        //更新者更新时间
        auth.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        auth.update_time = DateTime.now().toString();
        try {
          // 修改商品情报
          authData = await SupabaseUtils.getClient()
              .from('mtb_authority')
              .update(auth.toJson())
              .eq('id', auth.id)
              .select('*');
          // 判断出荷指示数据
          if (authData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.auth_Form_4 +
                    WMSLocalizations.i18n(event.context)!.update_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.auth_Form_4 +
                    WMSLocalizations.i18n(event.context)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.auth_Form_4 +
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

    // 删除权限事件
    on<DeleteAuthEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      try {
        // 删除权限数据
        List<Map<String, dynamic>> authDate = await SupabaseUtils.getClient()
            .from('mtb_authority')
            .delete()
            .eq('id', event.authId)
            .select('*');
        // 判断删除结果
        if (authDate.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(event.context)!.auth_Form_4 +
                  WMSLocalizations.i18n(event.context)!.delete_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.auth_Form_4 +
                  WMSLocalizations.i18n(event.context)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(event.context)!.auth_Form_4 +
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

    // 检索处理
    on<SeletAuthEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //设定显示检索条件
      state.conditionList = [];
      if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
        state.conditionList.add({'key': 'id', 'value': state.searchInfo['id']});
      }
      if (state.searchInfo['role_id'] != '' &&
          state.searchInfo['role_id'] != null) {
        state.conditionList
            .add({'key': 'role_id', 'value': state.searchInfo['role_name']});
      }
      if (state.searchInfo['menu_id'] != '' &&
          state.searchInfo['menu_id'] != null) {
        state.conditionList
            .add({'key': 'menu_id', 'value': state.searchInfo['menu_name']});
      }
      if (state.searchInfo['auth'] != '' && state.searchInfo['auth'] != null) {
        state.conditionList
            .add({'key': 'auth', 'value': state.searchInfo['auth']});
      }
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    //清除检索条件
    on<ClearSeletAuthEvent>((event, emit) {
      // 打开加载状态
      BotToast.showLoading();
      //初期化检索条件
      initSearch(state);
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设定下拉框情报值事件
    on<SetDropdownValueEvent>((event, emit) async {
      Map<String, dynamic> formTemp = Map<String, dynamic>();
      formTemp.addAll(state.formInfo);
      if (formTemp[event.key] != null) {
        formTemp[event.key] = event.value;
      } else {
        formTemp.addAll({event.key: event.value});
      }
      state.formInfo = formTemp;
      // 更新
      emit(clone(state));
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

      //初期化ロール名称下拉框
      initRoleInfo(state);

      //初期化メニュー名称下拉框
      initMenuInfo(state);

      // 加载标记
      state.loadingFlag = false;
      // 自定义事件 - 终
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
  //自定义方法 - 始
  //check必须输入项目
  Future<bool> checkMustInputColumn(
      Map<String, dynamic> formInfo, BuildContext context) async {
    if (formInfo['role_id'] == null || formInfo['role_id'] == '') {
      //ロール
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.auth_Form_2 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['menu_id'] == null || formInfo['menu_id'] == '') {
      //メニュー
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.auth_Form_3 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['auth'] == null || formInfo['auth'] == '') {
      //権限
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.auth_Form_4 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    }

    //権限是否全大写判断
    if (!isAZ(formInfo['auth'])) {
      //権限
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.auth_Form_4 +
              WMSLocalizations.i18n(context)!.auth_Form_4_check);
      return false;
    }

    //输入组合在DB中是否存在
    Map<String, dynamic> selectMap = Map();
    selectMap['id'] = null;
    selectMap['role_id'] = state.formInfo['role_id'];
    selectMap['menu_id'] = state.formInfo['menu_id'];
    selectMap['auth'] = null;
    List<dynamic> count = await SupabaseUtils.getClient()
        .rpc('func_query_total_table_mtb_authority', params: selectMap)
        .select();

    List<dynamic> data = [];
    var id = state.formInfo['id'];
    var roleId = state.formInfo['role_id'];
    var menuId = state.formInfo['menu_id'];
    //查询输入的角色名称和菜单名称
    data = await SupabaseUtils.getClient()
        .from('mtb_authority')
        .select('*')
        .eq('role_id', roleId)
        .eq('menu_id', menuId);

    //修改角色名称和菜单名称是否存在
    if (data.length > 0) {
      if (data[0]['id'] != id) {
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(context)!.auth_Form_2_check);
        return false;
      }
      // 新增数据，判断角色名称和菜单名称是否存在
    } else if (count[0]['total'] > 0) {
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.auth_Form_2_check);
      return false;
    }
    // }

    return true;
  }

  // 验证是否大写字母
  bool isAZ(String str) {
    final reg = RegExp('^[A-Z]+\$');
    return reg.hasMatch(str);
  }

  //model用map做成
  Map<String, dynamic> changeAuthMap(Map<String, dynamic> authInfo) {
    Map<String, dynamic> result = authInfo;
    // 处理-结构
    if (result['id'] == null || result['id'] == '') {
      result.remove('id');
    } else {
      result['id'] = int.parse(result['id'].toString());
    }
    if (result['role_id'] == null || result['role_id'] == '') {
      result.remove('role_id');
    } else {
      result['role_id'] = int.parse(result['role_id'].toString());
    }
    if (result['menu_id'] == null || result['menu_id'] == '') {
      result.remove('menu_id');
    } else {
      result['menu_id'] = int.parse(result['menu_id'].toString());
    }
    return result;
  }

  //初期化表单
  void initForm(AuthMasterModel state) {
    // 权限情报初期化
    state.formInfo = {
      'id': '',
      'role_id': '',
      'role_name': '',
      'menu_id': '',
      'menu_name': '',
      'auth': '',
    };
    //状态初期化
    state.stateFlg = '1';
  }

  //初期化检索条件
  void initSearch(AuthMasterModel state) {
    state.searchInfo = {
      'id': '',
      'role_id': '',
      'role_name': '',
      'menu_id': '',
      'menu_name': '',
      'auth': ''
    };
    state.conditionList = [];
  }

  //初期化ロール名称下拉框
  void initRoleInfo(AuthMasterModel state) async {
    List<dynamic> roleInfoList =
        await SupabaseUtils.getClient().from('mtb_role').select('*');
    state.roleList = [];
    if (roleInfoList.length > 0) {
      for (int i = 0; i < roleInfoList.length; i++) {
        state.roleList.add({
          'id': roleInfoList[i]['id'].toString(),
          'name': roleInfoList[i]['name']
        });
      }
    }
  }

  //初期化ロール名称下拉框
  void initMenuInfo(AuthMasterModel state) async {
    List<dynamic> menuInfoList =
        await SupabaseUtils.getClient().from('mtb_menu').select('*');
    state.menuList = [];
    if (menuInfoList.length > 0) {
      for (int i = 0; i < menuInfoList.length; i++) {
        state.menuList.add({
          'id': menuInfoList[i]['id'].toString(),
          'name': menuInfoList[i]['name']
        });
      }
    }
  }

  //检索前check
  bool seletAuthBeforeCheckEvent(BuildContext context, AuthMasterModel state) {
    //检索条件check
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      // 验证是否全数字
      if (CheckUtils.check_Half_Number_In_10(state.searchInfo['id'])) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.auth_Form_1 +
                WMSLocalizations.i18n(context)!.input_int_in_10_check);
        return false;
      }
    }
    add(SeletAuthEvent());
    return true;
  }

  //自定义方法 - 终
}
