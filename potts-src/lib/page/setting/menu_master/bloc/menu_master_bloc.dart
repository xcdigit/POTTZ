import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/utils/check_utils.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../model/menu.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'menu_master_model.dart';

/**
 * 内容：菜单マスタ管理-BLOC
 * 作者：穆政道
 * 时间：2023/10/08
 */
// 事件
abstract class MenuMasterEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends MenuMasterEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定检索条件值事件
class SetSearchValueEvent extends MenuMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value);
}

// 删除检索条件值事件
class DeleteSearchValueEvent extends MenuMasterEvent {
  // index
  int index;

  // 设定值事件
  DeleteSearchValueEvent(this.index);
}

// 设定菜单情报值事件
class SetMenuValueEvent extends MenuMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetMenuValueEvent(this.key, this.value);
}

// 设定下拉框情报值事件
class SetDropdownValueEvent extends MenuMasterEvent {
  // id
  String key;
  // name
  dynamic value;
  // 设定值事件
  SetDropdownValueEvent(this.key, this.value);
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

//显示form数据
class ShowSelectValueEvent extends MenuMasterEvent {
  // Value
  dynamic value;
  //状态flg
  String stateflg;
  ShowSelectValueEvent(this.value, this.stateflg);
}

//检索处理
class SeletMenuEvent extends MenuMasterEvent {
  // 结构树
  BuildContext context;
  //检索处理
  SeletMenuEvent(this.context);
}

//清除检索条件
class ClearSeletMenuEvent extends MenuMasterEvent {
  //检索处理
  ClearSeletMenuEvent();
}

//消除处理
class DeleteMenuEvent extends MenuMasterEvent {
  // 结构树
  BuildContext context;
  //菜单主键
  int menuId;
  //消除处理
  DeleteMenuEvent(this.context, this.menuId);
}

// 设置sort字段
class SetSortEvent extends MenuMasterEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终

class MenuMasterBloc extends WmsTableBloc<MenuMasterModel> {
  // 刷新补丁
  @override
  MenuMasterModel clone(MenuMasterModel src) {
    return MenuMasterModel.clone(src);
  }

  MenuMasterBloc(MenuMasterModel state) : super(state) {
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
      var query = SupabaseUtils.getClient().from('mtb_menu').select('*');
      //设置检索条件
      query = setSelectConditions(state, query);

      List<dynamic> data = await query
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      // 循环菜单数据
      for (int i = 0; i < data.length; i++) {
        // 列表数据增加
        if (data[i]['parent_id'] != null && data[i]['parent_id'] != '') {
          data[i]['parent_name'] =
              getNamefromList(data[i]['parent_id'], state.parentList);
        }
        state.records.add(WmsRecordModel(i, data[i]));
      }

      // 查询总数
      var queryCount = SupabaseUtils.getClient().from('mtb_menu').select(
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
      } else if ('parent_id' == deleteColumn['key']) {
        state.searchInfo['parent_id'] = '';
      } else if ('name' == deleteColumn['key']) {
        state.searchInfo['name'] = '';
      } else if ('path' == deleteColumn['key']) {
        state.searchInfo['path'] = '';
      }

      //删除显示检索条件
      state.conditionList.removeAt(event.index);

      // 更新
      emit(clone(state));
    });

    // 设定メニュー情报值事件
    on<SetMenuValueEvent>((event, emit) async {
      // メニュー情报-临时
      Map<String, dynamic> formTemp = Map<String, dynamic>();
      formTemp.addAll(state.formInfo);
      // 判断key
      if (formTemp[event.key] != null) {
        // メニュー情报-临时
        formTemp[event.key] = event.value;
      } else {
        // メニュー情报-临时
        formTemp.addAll({event.key: event.value});
      }
      // メニュー情报-定制
      state.formInfo = formTemp;

      // 更新
      emit(clone(state));
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
      // 菜单master数据
      List<Map<String, dynamic>> formData;
      Menu menu = Menu.fromJson(formInfo);
      //判断登录场合
      if (menu.id == null) {
        //填入必须字段
        menu.create_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        menu.create_time = DateTime.now().toString();
        menu.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        menu.update_time = DateTime.now().toString();
        try {
          BotToast.showLoading();
          // 新增菜单
          formData = await SupabaseUtils.getClient()
              .from('mtb_menu')
              .insert([menu.toJson()]).select('*');
          // 判断菜单数据
          if (formData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.menu_master +
                    WMSLocalizations.i18n(event.context)!.create_success);
            //初期化父菜单list
            await initParent(state);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_master +
                    WMSLocalizations.i18n(event.context)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_master +
                  WMSLocalizations.i18n(event.context)!.create_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else {
        //修正的场合
        //更新者更新时间
        menu.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        menu.update_time = DateTime.now().toString();
        try {
          BotToast.showLoading();
          // 修改菜单情报
          formData = await SupabaseUtils.getClient()
              .from('mtb_menu')
              .update(menu.toJson())
              .eq('id', menu.id)
              .select('*');
          // 判断菜单数据
          if (formData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.menu_master +
                    WMSLocalizations.i18n(event.context)!.update_success);
            //初期化父菜单list
            await initParent(state);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_master +
                    WMSLocalizations.i18n(event.context)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_master +
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
    on<SeletMenuEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //设定显示检索条件
      state.conditionList = [];
      if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
        state.conditionList.add({'key': 'id', 'value': state.searchInfo['id']});
      }
      if (state.searchInfo['parent_id'] != '' &&
          state.searchInfo['parent_id'] != null) {
        state.conditionList
            .add({'key': 'parent_id', 'value': state.searchInfo['parent_id']});
      }
      if (state.searchInfo['name'] != '' && state.searchInfo['name'] != null) {
        state.conditionList
            .add({'key': 'name', 'value': state.searchInfo['name']});
      }
      if (state.searchInfo['path'] != '' && state.searchInfo['path'] != null) {
        state.conditionList
            .add({'key': 'path', 'value': state.searchInfo['path']});
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

        // 赵士淞 - 始
        // 查询菜单
        List<dynamic> childMenuList = await SupabaseUtils.getClient()
            .from('mtb_menu')
            .select('*')
            .eq('parent_id', event.menuId);
        // 判断菜单长度
        if (childMenuList.length > 0) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_have_child_not_delete);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        // 赵士淞 - 终

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

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 自定义事件 - 始
      //初期化表单
      initForm(state);

      //初期化检索条件
      initSearch(state);

      //初期化父菜单list
      await initParent(state);

      // 自定义事件 - 终
      // 加载标记
      state.loadingFlag = false;
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
  //检索前check处理
  bool seletMenuEventBeforeCheck(BuildContext context, MenuMasterModel state) {
    //检索条件check
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      // 验证是否全数字
      if (CheckUtils.check_Half_Number_In_10(state.searchInfo['id'])) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.menu_master_form_1 +
                WMSLocalizations.i18n(context)!.input_int_in_10_check);
        return false;
      }
    }
    if (state.searchInfo['parent_id'] != '' &&
        state.searchInfo['parent_id'] != null) {
      // 验证是否全数字
      if (CheckUtils.check_Half_Number_In_10(state.searchInfo['parent_id'])) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.menu_master_form_2 +
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
    if (formInfo['name'] == null || formInfo['name'] == '') {
      //メニュー名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.menu_master_form_3 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    }
    if (formInfo['path'] == null || formInfo['path'] == '') {
      //メニューパス
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.menu_master_form_5 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Alphanumeric_Symbol(formInfo['path'])) {
      //半角英数及び符号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.menu_master_form_5 +
              WMSLocalizations.i18n(context)!
                  .check_half_width_alphanumeric_with_symbol);
      return false;
    }

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
    if (result['parent_id'] == null || result['parent_id'] == '') {
      result.remove('parent_id');
    } else {
      result['parent_id'] = int.parse(result['parent_id'].toString());
    }
    return result;
  }

  //初期化表单
  void initForm(MenuMasterModel state) {
    // メニュー情报初期化
    state.formInfo = {
      'id': '',
      'parent_id': '',
      'parent_name': '',
      'name': '',
      'description': '',
      'path': ''
    };
    //状态初期化
    state.stateFlg = '1';
  }

  //初期化检索条件
  void initSearch(MenuMasterModel state) {
    state.searchInfo = {'id': '', 'parent_id': '', 'name': '', 'path': ''};
    state.conditionList = [];
  }

  //初期化父菜单list
  Future<void> initParent(MenuMasterModel state) async {
    //父菜单检索
    List<dynamic> parentData = await SupabaseUtils.getClient()
        .from('mtb_menu')
        .select('*')
        .is_('parent_id', null);

    state.parentList = parentData;
  }

  //设定检索条件
  PostgrestFilterBuilder setSelectConditions(
      MenuMasterModel state, PostgrestFilterBuilder query) {
    var result = query;
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      query = query.eq('id', int.parse(state.searchInfo['id'].toString()));
    }
    if (state.searchInfo['parent_id'] != '' &&
        state.searchInfo['parent_id'] != null) {
      query = query.eq(
          'parent_id', int.parse(state.searchInfo['parent_id'].toString()));
    }
    if (state.searchInfo['name'] != '' && state.searchInfo['name'] != null) {
      String nameTemp = '%' + state.searchInfo['name'] + '%';
      query = query.like('name', nameTemp.toString());
    }
    if (state.searchInfo['path'] != '' && state.searchInfo['path'] != null) {
      String pathTemp = '%' + state.searchInfo['path'] + '%';
      query = query.like('path', pathTemp.toString());
    }
    return result;
  }

  //取得list中name
  String getNamefromList(int id, List<dynamic> nameList) {
    String name = '';
    if (nameList.isNotEmpty) {
      for (dynamic item in nameList) {
        if (item['id'] == id) {
          name = item['name'];
          break;
        }
      }
    }
    return name;
  }

  //自定义方法 - 终
}
