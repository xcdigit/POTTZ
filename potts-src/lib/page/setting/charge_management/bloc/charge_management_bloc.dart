import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/utils/check_utils.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../model/company_manage.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'charge_management_model.dart';

/**
 * 内容：課金法人管理-BLOC
 * 作者：熊草云
 * 时间：2023/09/26
 */
// 事件
abstract class ChargeManagementEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends ChargeManagementEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定检索条件值事件
class SetSearchValueEvent extends ChargeManagementEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value);
}

// 删除检索条件值事件
class DeleteSearchValueEvent extends ChargeManagementEvent {
  // index
  int index;

  // 设定值事件
  DeleteSearchValueEvent(this.index);
}

// 设定表单情报值事件
class SetCompanyValueEvent extends ChargeManagementEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetCompanyValueEvent(this.key, this.value);
}

//设定按钮显示状态
class SetStateFlgValueEvent extends ChargeManagementEvent {
  // flg
  String flg;
  // 设定值事件
  SetStateFlgValueEvent(this.flg);
}

//清除表单
class ClearFormEvent extends ChargeManagementEvent {
  // 清除表单
  ClearFormEvent();
}

//登录/修改表单
class UpdateFormEvent extends ChargeManagementEvent {
  // 结构树
  BuildContext context;
  UpdateFormEvent(this.context);
}

//显示form数据
class ShowSelectValueEvent extends ChargeManagementEvent {
  // Value
  dynamic value;
  //状态flg
  String stateflg;
  ShowSelectValueEvent(this.value, this.stateflg);
}

//检索处理
class SeletCompanyEvent extends ChargeManagementEvent {
  // 结构树
  BuildContext context;
  //检索处理
  SeletCompanyEvent(this.context);
}

//清除检索条件
class ClearSeletCompanyEvent extends ChargeManagementEvent {
  //检索处理
  ClearSeletCompanyEvent();
}

// 设置当前会社ID
class SetNowCompanyIDEvent extends ChargeManagementEvent {
  int nowCompanyId;
  SetNowCompanyIDEvent(this.nowCompanyId);
}

// 设置当前管理员ID
class SetNowUserIDEvent extends ChargeManagementEvent {
  int nowUserId;
  SetNowUserIDEvent(this.nowUserId);
}

// 设置当前管理员列表
class SetNowUserListEvent extends ChargeManagementEvent {
  int companyId;
  SetNowUserListEvent(this.companyId);
}
// 自定义事件 - 终

class ChargeManagementBloc extends WmsTableBloc<ChargeManagementModel> {
  // 刷新补丁
  @override
  ChargeManagementModel clone(ChargeManagementModel src) {
    return ChargeManagementModel.clone(src);
  }

  ChargeManagementBloc(ChargeManagementModel state) : super(state) {
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
      var query = SupabaseUtils.getClient()
          .rpc('func_xiongcy_query_table_ytb_company_manage', params: {
        'p_company_name': state.searchInfo['company_name'] == ''
            ? null
            : state.searchInfo['company_name'],
        'p_start_date': state.searchInfo['start_date'] == ''
            ? null
            : state.searchInfo['start_date'],
        'p_end_date': state.searchInfo['end_date'] == ''
            ? null
            : state.searchInfo['end_date'],
        'p_user_name': state.searchInfo['user_name'] == ''
            ? null
            : state.searchInfo['user_name']
      }).select('*');
      // 总页数
      List<dynamic> result = await query;
      state.total = result.length;
      List<dynamic> data = await query.order('id', ascending: false).range(
          state.pageNum * state.pageSize,
          (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      // 循环商品数据
      for (int i = 0; i < data.length; i++) {
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }
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
      if ('company_name' == deleteColumn['key']) {
        state.searchInfo['company_name'] = '';
      } else if ('start_date' == deleteColumn['key']) {
        state.searchInfo['start_date'] = '';
      } else if ('end_date' == deleteColumn['key']) {
        state.searchInfo['end_date'] = '';
      } else if ('user_name' == deleteColumn['key']) {
        state.searchInfo['user_name'] = '';
      }

      //删除显示检索条件
      state.conditionList.removeAt(event.index);

      // 更新
      emit(clone(state));
    });

    // 设定会社情报值事件
    on<SetCompanyValueEvent>((event, emit) async {
      // 会社情报-临时
      Map<String, dynamic> formTemp = Map<String, dynamic>();
      formTemp.addAll(state.formInfo);
      // 判断key
      if (formTemp[event.key] != null) {
        // 会社情报-临时
        formTemp[event.key] = event.value;
      } else {
        // 会社情报-临时
        formTemp.addAll({event.key: event.value});
      }
      // 会社情报-定制
      state.formInfo = formTemp;

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
      Map<String, dynamic> formInfo = changeCompanyMap(state.formInfo);
      // 商品master数据
      List<Map<String, dynamic>> formData;
      CompanyManage companyManage = CompanyManage.fromJson(formInfo);
      //判断登录场合
      if (companyManage.id == null) {
        //填入必须字段
        companyManage.user_id = state.nowUserId;
        companyManage.company_id = state.nowCompanyId;
        companyManage.create_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        companyManage.create_time = DateTime.now().toString();
        companyManage.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        companyManage.update_time = DateTime.now().toString();

        // 赵士淞 - 始
        // 查询课金法人
        List<dynamic> companyManageList = await SupabaseUtils.getClient()
            .from('ytb_company_manage')
            .select()
            .eq('company_id', companyManage.company_id);
        // 判断课金法人数量
        if (companyManageList.length > 0) {
          // 失败提示
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.context)!
              .company_has_records_cannot_add);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        // 赵士淞 - 终

        try {
          BotToast.showLoading();
          // 新增商品
          formData = await SupabaseUtils.getClient()
              .from('ytb_company_manage')
              .insert([companyManage.toJson()]).select('*');
          // 判断商品数据
          if (formData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_98_22 +
                    WMSLocalizations.i18n(event.context)!.create_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_98_22 +
                    WMSLocalizations.i18n(event.context)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_98_22 +
                  WMSLocalizations.i18n(event.context)!.create_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else {
        //修正的场合
        //更新者更新时间
        companyManage.company_id = state.nowCompanyId == null
            ? state.formInfo['company_id']
            : state.nowCompanyId;
        companyManage.user_id = state.nowUserId == null
            ? state.formInfo['user_id']
            : state.nowUserId;
        companyManage.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        companyManage.update_time = DateTime.now().toString();

        // 赵士淞 - 始
        // 查询课金法人
        List<dynamic> companyManageList = await SupabaseUtils.getClient()
            .from('ytb_company_manage')
            .select()
            .eq('company_id', companyManage.company_id);
        // 判断课金法人数量
        if (companyManageList.length > 1 ||
            (companyManageList.length == 1 &&
                companyManageList[0]['id'] != companyManage.id)) {
          // 失败提示
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.context)!
              .company_has_records_cannot_add);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        // 赵士淞 - 终

        try {
          BotToast.showLoading();
          // 修改
          formData = await SupabaseUtils.getClient()
              .from('ytb_company_manage')
              .update(companyManage.toJson())
              .eq('id', companyManage.id)
              .select('*');
          // 判断
          if (formData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_98_22 +
                    WMSLocalizations.i18n(event.context)!.update_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_98_22 +
                    WMSLocalizations.i18n(event.context)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_98_22 +
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
      state.formInfo = {...event.value};
      state.stateFlg = event.stateflg;
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 检索处理
    on<SeletCompanyEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //设定显示检索条件
      state.conditionList = [];
      if (state.searchInfo['company_name'] != '' &&
          state.searchInfo['company_name'] != null) {
        state.conditionList.add(
            {'key': 'company_name', 'value': state.searchInfo['company_name']});
      }
      if (state.searchInfo['start_date'] != '' &&
          state.searchInfo['start_date'] != null) {
        state.conditionList.add(
            {'key': 'start_date', 'value': state.searchInfo['start_date']});
      }
      if (state.searchInfo['end_date'] != '' &&
          state.searchInfo['end_date'] != null) {
        state.conditionList
            .add({'key': 'end_date', 'value': state.searchInfo['end_date']});
      }
      if (state.searchInfo['user_name'] != '' &&
          state.searchInfo['user_name'] != null) {
        state.conditionList
            .add({'key': 'user_name', 'value': state.searchInfo['user_name']});
      }
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    //清除检索条件
    on<ClearSeletCompanyEvent>((event, emit) {
      // 打开加载状态
      BotToast.showLoading();
      //初期化检索条件
      initSearch(state);
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });
    on<SetNowCompanyIDEvent>((event, emit) async {
      state.nowCompanyId = event.nowCompanyId == 0 ? null : event.nowCompanyId;
      emit(clone(state));
    });
    on<SetNowUserIDEvent>((event, emit) async {
      state.nowUserId = event.nowUserId == 0 ? null : event.nowUserId;
      emit(clone(state));
    });
    // 设置当前管理员列表
    on<SetNowUserListEvent>((event, emit) async {
      //设定管理员列表
      if (event.companyId == 0) {
        state.salesUserInfoList = [];
        state.formInfo['user_name'] = '';
      } else {
        List userList = await SupabaseUtils.getClient()
            .from('mtb_user')
            .select('*')
            .eq('status', Config.WMS_COMPANY_STATUS_1)
            // 赵士淞 - 始
            .eq('role_id', Config.ROLE_ID_2)
            // 赵士淞 - 终
            .eq('company_id', event.companyId);
        state.salesUserInfoList = userList;
        if (state.salesUserInfoList.length == 0) {
          state.formInfo['user_name'] = '';
          state.formInfo['company_name'] = '';
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(state.context)!.charge_management_tip_2);
        }
      }

      emit(clone(state));
    });
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      //初期化表单
      initForm(state);
      //初期化检索条件
      initSearch(state);

      //设定会社名列表
      List companyList = await SupabaseUtils.getClient()
          .from('mtb_company')
          .select('*')
          .eq('status', Config.WMS_COMPANY_STATUS_1);
      state.salesCompanyInfoList = companyList;
      // 加载标记
      state.loadingFlag = false;

      // 查询分页数据事件
      add(PageQueryEvent());
    });

    add(InitEvent());
  }
  //自定义方法 - 始
  //检索前check处理
  bool selectCompanyEventBeforeCheck(
      BuildContext context, ChargeManagementModel state) {
    //检索条件check
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      // 验证是否全数字
      if (CheckUtils.check_Half_Number_In_10(state.searchInfo['id'])) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.company_information_1 +
                WMSLocalizations.i18n(context)!.input_int_in_10_check);
        return false;
      }
    }
    add(SeletCompanyEvent(context));
    return true;
  }

  //check必须输入项目
  bool checkMustInputColumn(
      Map<String, dynamic> formInfo, BuildContext context) {
    if (formInfo['company_name'] == null || formInfo['company_name'] == '') {
      //会社名
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_2 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['start_date'] == null || formInfo['start_date'] == '') {
      //運用開始日
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.account_license_start +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['end_date'] == null || formInfo['end_date'] == '') {
      //運用終了日
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.account_license_end +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['user_name'] == null || formInfo['user_name'] == '') {
      //管理员
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.charge_management_form_1 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    }
    //運用開始日
    String date1 = formInfo['start_date'].toString().replaceAll("/", "-");
    //運用終了日
    String date2 = formInfo['end_date'].toString().replaceAll("/", "-");
    //日期转换
    DateTime startDate = DateTime.parse(date1);
    DateTime endDate = DateTime.parse(date2);
    // 比较两个日期
    if (startDate.isAfter(endDate)) {
      //運用終了日不能大于運用開始日
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
          .account_license_start_less_end_message);
      return false;
    }
    return true;
  }

  //model用map做成
  Map<String, dynamic> changeCompanyMap(Map<String, dynamic> formInfo) {
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
  void initForm(ChargeManagementModel state) {
    // 会社情报初期化
    state.formInfo = {
      'id': '',
      'company_name': '',
      'start_date': '',
      'end_date': '',
      'user_name': '',
      'note': '',
    };
    //状态初期化
    state.stateFlg = '1';
    state.salesUserInfoList = [];
  }

  //初期化检索条件
  void initSearch(ChargeManagementModel state) {
    state.searchInfo = {
      'company_name': '',
      'start_date': '',
      'end_date': '',
      'user_name': ''
    };
    state.conditionList = [];
  }

  //取得list中name
  String getNamefromList(String id, List<Map<String, dynamic>> nameList) {
    String name = '';
    if (nameList.isNotEmpty) {
      for (Map<String, dynamic> item in nameList) {
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
