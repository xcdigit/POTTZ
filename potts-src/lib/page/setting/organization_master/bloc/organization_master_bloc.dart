import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/config/config.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/check_utils.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../model/organization.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'organization_master_model.dart';

/**
 * 内容：組織マスタ-BLOC
 * 作者：熊草云
 * 时间：2023/11/29
 */

// 事件
abstract class OrganizationMasterEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends OrganizationMasterEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定表单情报值事件
class SetMessageValueEvent extends OrganizationMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetMessageValueEvent(this.key, this.value);
}

//清除表单
class ClearFormEvent extends OrganizationMasterEvent {
  // 清除表单
  ClearFormEvent();
}

//登录/修改表单
class UpdateFormEvent extends OrganizationMasterEvent {
  // 结构树
  BuildContext context;
  UpdateFormEvent(this.context);
}

// 设定检索条件值事件
class SetSearchValueEvent extends OrganizationMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value);
}

class DeleteSearchValueEvent extends OrganizationMasterEvent {
  int index;
  //设定值事件
  DeleteSearchValueEvent(this.index);
}

//form表单回显
class ShowSelectValueEvent extends OrganizationMasterEvent {
  // Value
  dynamic value;
  //状态flg
  String stateflg;
  ShowSelectValueEvent(this.value, this.stateflg);
}

//清除检索条件
class ClearSelectMessageEvent extends OrganizationMasterEvent {
  ClearSelectMessageEvent();
}

//检索处理
class SelectMessageEvent extends OrganizationMasterEvent {
  // 结构树
  BuildContext context;
  //检索处理
  SelectMessageEvent(this.context);
}

//删除数据
class DeleteMessageDataEvent extends OrganizationMasterEvent {
  // 结构树
  BuildContext context;
  int Id;
  DeleteMessageDataEvent(this.context, this.Id);
}

// 设置当前会社ID
class SetNowCompanyIDEvent extends OrganizationMasterEvent {
  int nowCompanyId;
  SetNowCompanyIDEvent(this.nowCompanyId);
}

// 设置sort字段
class SetSortEvent extends OrganizationMasterEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}
// 自定义事件 - 终

class OrganizationMasterBloc extends WmsTableBloc<OrganizationMasterModel> {
  // 刷新补丁
  @override
  OrganizationMasterModel clone(OrganizationMasterModel src) {
    return OrganizationMasterModel.clone(src);
  }

  OrganizationMasterBloc(OrganizationMasterModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 自定义事件 - 始
      //初期化表单
      initForm(state);

      List companyList = await SupabaseUtils.getClient()
          .from('mtb_company')
          .select('*')
          .eq('status', Config.WMS_COMPANY_STATUS_1);
      state.salesCompanyInfoList = companyList;
      // 加载标记
      state.loadingFlag = false;
      // SP端跳转页面
      if (state.flag_num == '2') {
        add(ShowSelectValueEvent(state.currentParam, "2"));
      } else if (state.flag_num == '0' || state.flag_num == '1') {
        //登录和修正按钮，输入框可以输入
        if (state.currentParam?['id'] != '' &&
            state.currentParam?['id'] != null) {
          add(SetNowCompanyIDEvent(0));
        }
        add(ShowSelectValueEvent(state.currentParam, "1"));
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
        var query =
            SupabaseUtils.getClient().from('mtb_organization').select('*');

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
        var queryCount =
            SupabaseUtils.getClient().from('mtb_organization').select(
                  '*',
                  const FetchOptions(
                    count: CountOption.exact,
                  ),
                );
        //设置检索条件
        queryCount = setSelectConditions(state, queryCount, true);
        final countResult = await queryCount;
        // 总页数
        state.total = countResult.count;
      } else {
        // 查询指示
        var query =
            SupabaseUtils.getClient().from('mtb_organization').select('*');

        query = setSelectConditions(state, query, false);

        List<dynamic> data = await query
            .order(state.sortCol, ascending: state.ascendingFlg)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1);
        // 查询总数
        var queryCount =
            SupabaseUtils.getClient().from('mtb_organization').select(
                  '*',
                  const FetchOptions(
                    count: CountOption.exact,
                  ),
                );
        //设置检索条件
        queryCount = setSelectConditions(state, queryCount, false);
        final countResult = await queryCount;
        // 总页数
        state.total = countResult.count;
        // 取得会社名情报
        List<dynamic> tempCompanyList =
            await SupabaseUtils.getClient().from('mtb_company').select('*');
        state.allCompanyInfoList = tempCompanyList;
        // 循环数据
        // 列表数据清空
        state.records.clear();
        for (int i = 0; i < data.length; i++) {
          data[i]['company_name'] =
              SetCompany(data[i]['company_id'], tempCompanyList);
          state.records.add(WmsRecordModel(i, data[i]));
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
        if (event.value['parent_id'] != null) {
          state.parentID = event.value['parent_id'];
        }
        state.formInfo['parent_id'] = event.value['parent_id'];
        state.companyName = event.value['company_name'];
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
      // 更新
      emit(clone(state));
    });
    // 检索处理
    on<SelectMessageEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //设定显示检索条件
      state.conditionList = [];
      if (state.searchInfo['parent_id'] != '' &&
          state.searchInfo['parent_id'] != null) {
        state.conditionList
            .add({'key': 'parent_id', 'value': state.searchInfo['parent_id']});
      }
      if (state.searchInfo['code'] != '' && state.searchInfo['code'] != null) {
        state.conditionList
            .add({'key': 'code', 'value': state.searchInfo['code']});
      }
      if (state.searchInfo['name'] != '' && state.searchInfo['name'] != null) {
        state.conditionList
            .add({'key': 'name', 'value': state.searchInfo['name']});
      }
      if (state.searchInfo['company_id'] != '' &&
          state.searchInfo['company_id'] != null) {
        state.conditionList.add(
            {'key': 'company_id', 'value': state.searchInfo['company_name']});
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
      if ('parent_id' == deleteColumn['key']) {
        state.searchInfo['parent_id'] = '';
      } else if ('code' == deleteColumn['key']) {
        state.searchInfo['code'] = '';
      } else if ('name' == deleteColumn['key']) {
        state.searchInfo['name'] = '';
      } else if ('company_id' == deleteColumn['key']) {
        state.searchInfo['company_id'] = '';
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
          var data = await SupabaseUtils.getClient()
              .from('mtb_user')
              .select('*')
              .eq('organization_id', event.Id);
          if (state.roleId != 1 && data.length > 0) {
            data = data
                .where((row) => row['company_id'] == state.companyId)
                .toList();
          }
          if (data.length > 0) {
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
                    WMSLocalizations.i18n(event.context)!.delete_error);
            BotToast.closeAllLoading();
            return;
          }

          //判断是否可以删除
          bool checkCompanyResult =
              await checkCompany(event.Id, state.context, false);
          if (!checkCompanyResult) {
            return;
          }

          bool _flag = await isDelete(
            event.Id,
            int.parse(state.roleId.toString()),
            int.parse(state.companyId.toString()),
          );
          if (!_flag) {
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
                    WMSLocalizations.i18n(event.context)!.delete_error);
            BotToast.closeAllLoading();
            return;
          } else {
            await SupabaseUtils.getClient()
                .from('mtb_organization')
                .delete()
                .eq('id', event.Id);
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
                    WMSLocalizations.i18n(event.context)!.delete_success);
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
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

        // 根据组织代码查询组织数据
        var organizationCodeData = await SupabaseUtils.getClient()
            .from('mtb_organization')
            .select('*')
            .eq('code', state.formInfo['code']);
        if (organizationCodeData.length > 1 ||
            (organizationCodeData.length == 1 &&
                organizationCodeData[0]['id'] != state.formInfo['id'])) {
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.organization_master_tip_8);
          return;
        }

        //model用map做成
        Map<String, dynamic> formInfo = changeMessageMap(state.formInfo);
        // 商品master数据
        List<Map<String, dynamic>> formData;
        formInfo['parent_id'] =
            (formInfo['parent_id'] == '' || formInfo['parent_id'] == null)
                ? null
                : int.parse(formInfo['parent_id'].toString());
        //会社管理员身份进行登录/修改
        if (state.roleId != 1) {
          Organization message = Organization.fromJson(formInfo);
          if (message.id == null) {
            // 登录
            BotToast.showLoading();
            if (state.formInfo['parent_id'] != null &&
                state.formInfo['parent_id'] != '') {
              int parentId = int.parse(state.formInfo['parent_id'].toString());
              int companyId = int.parse(state.companyId.toString());
              bool checkParentResult = await checkParentIdResult(
                  0, parentId, state.context, false, companyId);
              if (!checkParentResult) {
                state.formInfo['parent_id'] = '';
                // 更新
                emit(clone(state));
                return;
              }
            }
            //填入必须字段
            message.company_id = state.companyId;
            message.create_id =
                StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
            message.create_time = DateTime.now().toString();
            message.update_id =
                StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
            message.update_time = DateTime.now().toString();

            try {
              // 新增
              formData = await SupabaseUtils.getClient()
                  .from('mtb_organization')
                  .insert([message.toJson()]).select('*');
              // 判断商品数据
              if (formData.length != 0) {
                // 成功提示
                WMSCommonBlocUtils.successTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
                        WMSLocalizations.i18n(event.context)!.create_success);
              } else {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
                        WMSLocalizations.i18n(event.context)!.create_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
                      WMSLocalizations.i18n(event.context)!.create_error);

              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          } else {
            //修正的场合
            //更新者更新时间
            // check parent_id
            BotToast.showLoading();
            if (state.formInfo['parent_id'] != null &&
                state.formInfo['parent_id'] != '') {
              int mid = int.parse(state.formInfo['id'].toString());
              int parentId = int.parse(state.formInfo['parent_id'].toString());
              int companyId = int.parse(state.companyId.toString());
              bool checkParentResult = await checkParentIdResult(
                  mid, parentId, state.context, true, companyId);
              if (!checkParentResult) {
                state.formInfo['parent_id'] = state.startparentID;
                // 更新
                emit(clone(state));
                return;
              }
            }
            message.update_id =
                StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
            message.update_time = DateTime.now().toString();
            try {
              // 修改
              formData = await SupabaseUtils.getClient()
                  .from('mtb_organization')
                  .update(message.toJson())
                  .eq('id', message.id)
                  .select('*');
              if (formData.length != 0) {
                // 成功提示
                WMSCommonBlocUtils.successTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
                        WMSLocalizations.i18n(event.context)!.update_success);
              } else {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
                        WMSLocalizations.i18n(event.context)!.update_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
                      WMSLocalizations.i18n(event.context)!.update_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          }
        } else {
          BotToast.showLoading();
          //admin管理员身份进行登录/修改
          Organization message = Organization.fromJson(formInfo);
          if (message.id == null) {
            if (state.formInfo['parent_id'] != null &&
                state.formInfo['parent_id'] != '') {
              int parentId = int.parse(state.formInfo['parent_id'].toString());
              int companyId = int.parse(state.nowCompanyId.toString());
              bool checkParentResult = await checkParentIdResult(
                  0, parentId, state.context, false, companyId);
              if (!checkParentResult) {
                state.formInfo['parent_id'] = '';
                // 更新
                emit(clone(state));
                return;
              }
            }
            message.company_id = state.nowCompanyId;
            message.create_id =
                StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
            message.create_time = DateTime.now().toString();
            message.update_id =
                StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
            message.update_time = DateTime.now().toString();
            try {
              // 新增
              formData = await SupabaseUtils.getClient()
                  .from('mtb_organization')
                  .insert([message.toJson()]).select('*');
              // 判断数据
              if (formData.length != 0) {
                // 成功提示
                WMSCommonBlocUtils.successTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
                        WMSLocalizations.i18n(event.context)!.create_success);
              } else {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
                        WMSLocalizations.i18n(event.context)!.create_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
                      WMSLocalizations.i18n(event.context)!.create_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          } else {
            //修正的场合
            // check parent_id
            BotToast.showLoading();
            if (state.formInfo['parent_id'] != null &&
                state.formInfo['parent_id'] != '') {
              if (state.parentID == state.formInfo['parent_id']) {
                if (state.nowCompanyId != null &&
                    state.nowCompanyId != state.formInfo['company_id']) {
                  // 失败提示
                  WMSCommonBlocUtils.errorTextToast(
                      WMSLocalizations.i18n(event.context)!
                          .organization_master_tip_4);
                  state.formInfo['company_name'] = state.companyName;
                  state.nowCompanyId = state.formInfo['company_id'];
                  // 关闭加载
                  BotToast.closeAllLoading();
                  emit(clone(state));
                  return;
                }
              }
              int mid = int.parse(state.formInfo['id'].toString());
              int parentId = int.parse(state.formInfo['parent_id'].toString());
              int companyId = int.parse(state.nowCompanyId == null
                  ? state.formInfo['company_id'].toString()
                  : state.nowCompanyId.toString());
              bool checkParentResult = await checkParentIdResult(
                  mid, parentId, state.context, true, companyId);

              if (!checkParentResult) {
                state.formInfo['parent_id'] = state.startparentID;
                // 更新
                emit(clone(state));
                return;
              }
            } else if (state.nowCompanyId != null &&
                state.nowCompanyId != state.formInfo['company_id']) {
              int mid = int.parse(state.formInfo['id'].toString());

              //修改会社名时 判断 是否有子
              bool checkCompanyResult =
                  await checkCompany(mid, state.context, true);
              if (!checkCompanyResult) {
                state.formInfo['company_name'] = state.companyName;
                state.nowCompanyId = state.formInfo['company_id'];
                // 更新
                emit(clone(state));
                return;
              }
            }
            //更新者更新时间
            message.company_id = state.nowCompanyId == null
                ? state.formInfo['company_id']
                : state.nowCompanyId;
            message.update_id =
                StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
            message.update_time = DateTime.now().toString();
            try {
              // 修改
              formData = await SupabaseUtils.getClient()
                  .from('mtb_organization')
                  .update(message.toJson())
                  .eq('id', message.id)
                  .select('*');

              if (formData.length != 0) {
                // 成功提示
                WMSCommonBlocUtils.successTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
                        WMSLocalizations.i18n(event.context)!.update_success);
              } else {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
                        WMSLocalizations.i18n(event.context)!.update_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_5 +
                      WMSLocalizations.i18n(event.context)!.update_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
            state.nowCompanyId = null;
          }
        }
        // 返回上一页
        GoRouter.of(state.context).pop('refresh return');

        // 加载标记
        state.loadingFlag = false;
        // 查询分页数据事件
        add(PageQueryEvent());
      },
    );
    on<SetNowCompanyIDEvent>((event, emit) async {
      state.nowCompanyId = event.nowCompanyId == 0 ? null : event.nowCompanyId;
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
  //自定义方法 - 始
  //检索前check处理
  bool selectMessageEventBeforeCheck(
      BuildContext context, OrganizationMasterModel state) {
    //检索条件check
    if (state.searchInfo['parent_id'] != null &&
        state.searchInfo['parent_id'] != '' &&
        CheckUtils.check_Half_Number_In_10(
            state.searchInfo['parent_id'].toString())) {
      // 親ID
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(context)!.organization_master_form_1 +
              WMSLocalizations.i18n(context)!.input_int_in_10_check);
      return false;
    } else if (state.searchInfo['code'] != null &&
        state.searchInfo['code'] != '' &&
        CheckUtils.check_Half_Alphanumeric(state.searchInfo['code'])) {
      // 組織コード
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(context)!.organization_master_form_2 +
              WMSLocalizations.i18n(context)!.input_letter_and_number_check);
      return false;
    }
    add(SelectMessageEvent(context));
    return true;
  }

  //check必须输入项目
  bool checkMustInputColumn(
      Map<String, dynamic> formInfo, BuildContext context) {
    if (formInfo['parent_id'] != null &&
        formInfo['parent_id'] != '' &&
        CheckUtils.check_Half_Number_In_10(formInfo['parent_id'])) {
      // 親ID
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(context)!.organization_master_form_1 +
              WMSLocalizations.i18n(context)!.check_half_width_numbers_in_10);
      return false;
    } else if (formInfo['code'] == null || formInfo['code'] == '') {
      // 組織コード
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.organization_master_form_2 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Alphanumeric(formInfo['code'])) {
      // 組織コード
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.organization_master_form_2 +
              WMSLocalizations.i18n(context)!.check_half_width_alphanumeric);
      return false;
    } else if (formInfo['name'] == null || formInfo['name'] == '') {
      // 組織名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.organization_master_form_3 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
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
    return true;
  }

  // 判断输入的亲节点是否可设置为当前id的亲节点
  Future<bool> checkParentIdResult(
      int mid, int parentId, context, bool flag, int companyId) async {
    List<dynamic> formData = await SupabaseUtils.getClient()
        .from('mtb_organization')
        .select('*')
        .eq('id', parentId)
        .eq('company_id', companyId);
    if (formData.length == 0) {
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(context)!.organization_master_form_1 +
              WMSLocalizations.i18n(context)!.organization_master_tip_1);
      BotToast.closeAllLoading();
      return false;
    } else {
      // 判断上一代是否还有上级
      if (formData[0]['parent_id'] != null && formData[0]['parent_id'] != '') {
        // 获取上二代
        List<dynamic> formData2 = await SupabaseUtils.getClient()
            .from('mtb_organization')
            .select('*')
            .eq('id', formData[0]['parent_id'])
            .eq('company_id', companyId);
        if (formData2.length == 0) {
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(context)!.organization_master_form_1 +
                  WMSLocalizations.i18n(context)!.organization_master_tip_1);
          BotToast.closeAllLoading();
          return false;
        } else {
          if (formData2[0]['parent_id'] != null &&
              formData2[0]['parent_id'] != '') {
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(context)!.organization_master_tip_9);
            BotToast.closeAllLoading();
            return false;
          }
        }
      }
    }

    if (flag) {
      if (formData.length > 0) {
        if (formData[0]['id'] == mid) {
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(context)!.organization_master_tip_2);
          BotToast.closeAllLoading();
          return false;
        }
        bool _flag =
            await isParentOfAnyChild(mid, parentId, companyId, context);
        if (!_flag) {
          return false;
        }
      }
    }
    return true;
  }

  // 判断当前数据是否有子
  Future<bool> checkCompany(int mid, context, bool flg) async {
    List<dynamic> formData = await SupabaseUtils.getClient()
        .from('mtb_organization')
        .select('*')
        .eq('parent_id', mid);
    if (formData.length > 0) {
      if (flg) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.organization_master_tip_6);
      } else {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.organization_master_tip_7);
      }
      BotToast.closeAllLoading();
      return false;
    }
    return true;
  }

  // 判断父节点是否是自己的子节点
  Future<bool> isParentOfAnyChild(
      dynamic nodeId, dynamic parentId, dynamic companyId, context) async {
    List<dynamic> data;
    data = await SupabaseUtils.getClient()
        .from('mtb_organization')
        .select('*')
        .eq('parent_id', nodeId)
        .eq('company_id', companyId);
    for (int i = 0; i < data.length; i++) {
      if (data[i]['id'] == parentId) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.organization_master_tip_3);
        BotToast.closeAllLoading();
        return false;
      }
      bool _flag =
          await isParentOfAnyChild(data[i]['id'], parentId, companyId, context);
      if (!_flag) {
        return false;
      }
    }
    return true;
  }

  // 判断当前选择的数据是否可以删除
  Future<bool> isDelete(int mid, int roleId, int companyId) async {
    var data;
    data = await SupabaseUtils.getClient()
        .from('mtb_organization')
        .select('*')
        .eq('parent_id', mid);
    if (roleId != 1 && data.length > 0) {
      data = data.where((row) => row['company_id'] == companyId).toList();
    }
    for (int i = 0; i < data.length; i++) {
      var dataChild = await SupabaseUtils.getClient()
          .from('mtb_user')
          .select('*')
          .eq('organization_id', data[i]['id']);
      if (roleId != 1 && dataChild.length > 0) {
        dataChild =
            dataChild.where((row) => row['company_id'] == companyId).toList();
      }
      if (dataChild.length > 0) {
        return false;
      } else {
        bool _flag = await isDelete(data[i]['id'], roleId, companyId);
        if (!_flag) {
          return false;
        }
      }
    }
    return true;
  }

  String SetCompany(int companyId, List<dynamic> companyList) {
    String result = '';
    if (companyList.length > 0) {
      dynamic mtbCompany = companyList.firstWhere(
          (mtbCompany) => mtbCompany['id'] == companyId,
          orElse: () => null);
      if (mtbCompany != null) {
        result = mtbCompany['name'];
      }
    }
    return result;
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
  void initForm(OrganizationMasterModel state) {
    // 会社情报初期化
    state.formInfo = {
      'id': '',
      'parent_id': '',
      'code': '',
      'name': '',
      'company_name': '',
      'content': ''
    };
    //状态初期化
    state.stateFlg = '1';
  }

  //初期化检索条件
  void initSearch(OrganizationMasterModel state) {
    state.searchInfo = {
      'parent_id': '',
      'code': '',
      'name': '',
      'company_id': '',
      'company_name': ''
    };
    state.conditionList = [];
  }

  //设定检索条件
  PostgrestFilterBuilder setSelectConditions(
      OrganizationMasterModel state, PostgrestFilterBuilder query, bool flag) {
    //会社管理员的场合
    if (flag) {
      query = query.eq('company_id', state.companyId);
    } else {
      //超级管理员的场合
      if (state.searchInfo['company_id'] != '' &&
          state.searchInfo['company_id'] != null) {
        query = query.eq('company_id', state.searchInfo['company_id']);
      }
    }

    if (state.searchInfo['parent_id'] != '' &&
        state.searchInfo['parent_id'] != null) {
      query = query.eq(
          'parent_id', int.parse(state.searchInfo['parent_id'].toString()));
    }
    if (state.searchInfo['code'] != '' && state.searchInfo['code'] != null) {
      query = query.eq('code', state.searchInfo['code'].toString());
    }
    if (state.searchInfo['name'] != '' && state.searchInfo['name'] != null) {
      String nameShotTemp = '%' + state.searchInfo['name'] + '%';
      query = query.like('name', nameShotTemp.toString());
    }
    var result = query;
    return result;
  }
}
