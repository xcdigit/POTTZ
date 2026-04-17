import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/page/sys/operate_log/bloc/operate_log_model.dart';

import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'package:intl/intl.dart';

/**
 * 内容：操作ログ-BLOC
 * 作者：luxy
 * 时间：2023/11/27
 */
// 事件
abstract class OperateLogEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends OperateLogEvent {
  // 初始化事件
  InitEvent();
}

// 设置检索条件
class SetSearchEvent extends OperateLogEvent {
  // 初始化事件
  String key;
  dynamic searchData;
  int searchId;
  SetSearchEvent(this.searchId, this.key, this.searchData);
}

// 查询检索条件事件
class QuerySearchShipStateEvent extends OperateLogEvent {
  // 出荷指示
  List<String> shipList;
  BuildContext context;
  // 查询出荷指示事件
  QuerySearchShipStateEvent(this.shipList, this.context);
}

//刪除检索条件
class SetSearchListEvent extends OperateLogEvent {
  List<String> conditionList;
  SetSearchListEvent(this.conditionList);
}

// 设置sort字段
class SetSortEvent extends OperateLogEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终
class OperateLogBloc extends WmsTableBloc<OperateLogModel> {
  // 刷新补丁
  @override
  OperateLogModel clone(OperateLogModel src) {
    return OperateLogModel.clone(src);
  }

  OperateLogBloc(OperateLogModel state) : super(state) {
    on<PageQueryEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      if (!state.loadingFlag) {
        state.pageNum = 0;
        // 加载标记
        state.loadingFlag = true;
      }
      // 查询会社事件
      List<dynamic> companyData =
          await SupabaseUtils.getClient().from('mtb_company').select('*');
      // 会社列表
      state.companyList = companyData;
      //操作log列表
      List<dynamic> data = [];
      var query = SupabaseUtils.getClient().from('sys_log').select('*');
      //设置检索条件
      query = setSelectConditions(state, query);
      int roleId = StoreProvider.of<WMSState>(state.context)
          .state
          .loginUser!
          .role_id as int;
      if (roleId == Config.NUMBER_ONE) {
        //超级管理员
        data = await query
            .order(state.sortCol, ascending: state.ascendingFlg)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1);
      } else if (roleId == Config.NUMBER_TWO) {
        //系统管理员
        data = await query
            .eq(
                'company_id',
                StoreProvider.of<WMSState>(state.context)
                    .state
                    .loginUser!
                    .company_id)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1)
            .order(state.sortCol, ascending: state.ascendingFlg);
      } else {
        //普通角色
        data = await query
            .eq(
                'company_id',
                StoreProvider.of<WMSState>(state.context)
                    .state
                    .loginUser!
                    .company_id)
            .eq('create_id',
                StoreProvider.of<WMSState>(state.context).state.loginUser!.id)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1)
            .order(state.sortCol, ascending: state.ascendingFlg);
      }

      // 列表数据清空
      state.records.clear();

      //查询用户名称
      List<dynamic> mtbUserList =
          await SupabaseUtils.getClient().from('mtb_user').select('*');

      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        state.records.add(WmsRecordModel(i, data[i]));
        //查询用户名称
        dynamic user = mtbUserList.firstWhere(
            (user) => user['id'] == data[i]['create_id'],
            orElse: () => null);
        if (user != null) {
          data[i]['user_name'] = user['name'];
        }
        //查询会社名称
        dynamic mtbCompany = companyData.firstWhere(
            (mtbCompany) => mtbCompany['id'] == data[i]['company_id'],
            orElse: () => null);
        if (mtbCompany != null) {
          data[i]['company_name'] = mtbCompany['name'];
        }
        //操作时间转换
        DateTime date = DateTime.parse(data[i]['create_time']);
        String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
        data[i]['create_time'] = time;
      }
      // 总页数
      List<dynamic> count = [];
      var queryCount = SupabaseUtils.getClient().from('sys_log').select('*');
      //设置检索条件
      queryCount = setSelectConditions(state, queryCount);
      if (roleId == Config.NUMBER_ONE) {
        //超级管理员
        count = await queryCount;
      } else if (roleId == Config.NUMBER_TWO) {
        //系统管理员
        count = await queryCount.eq(
            'company_id',
            StoreProvider.of<WMSState>(state.context)
                .state
                .loginUser!
                .company_id);
      } else {
        //普通角色
        count = await queryCount
            .eq(
                'company_id',
                StoreProvider.of<WMSState>(state.context)
                    .state
                    .loginUser!
                    .company_id)
            .eq('create_id',
                StoreProvider.of<WMSState>(state.context).state.loginUser!.id);
      }
      state.total = count.length;
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      add(PageQueryEvent());
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });
    //设置检索条件
    on<SetSearchEvent>((event, emit) async {
      Map<String, dynamic> temp = Map<String, dynamic>();
      if (event.searchData.isNotEmpty) {
        temp[event.key] = event.searchData['name'];
      } else {
        //清除检索内容
        temp[event.key] = '';
      }

      if (event.searchId == 0) {
        //ログレベル
        state.typeKbn = temp;
      } else {
        //会社
        state.company = temp;
        //检索按钮赋值
        if (event.searchData.isNotEmpty) {
          //会社id
          state.companyId = event.searchData['id'];
        }
      }
      emit(clone(state));
    });

    // 检索条件
    on<QuerySearchShipStateEvent>((event, emit) async {
      BotToast.showLoading();
      String searchContent = '';
      String searchTypeKbn = '';
      String searchCompanyName = '';
      for (int i = 0; i < event.shipList.length; i++) {
        List<String> parts = event.shipList[i].split("：");
        String key = parts[0];
        String value = parts[1];
        if (key == WMSLocalizations.i18n(event.context)!.menu_content_99_6_1) {
          searchContent = value;
        } else if (key ==
            WMSLocalizations.i18n(event.context)!.menu_content_99_6_2) {
          searchTypeKbn = value;
        } else if (key ==
            WMSLocalizations.i18n(event.context)!.company_information_2) {
          searchCompanyName = value;
        }
      }
      state.searchContent = searchContent;
      state.searchTypeKbn = searchTypeKbn;
      state.searchCompanyName = searchCompanyName;
      state.loadingFlag = false;
      add(PageQueryEvent());
    });

    // 刪除检索条件
    on<SetSearchListEvent>((event, emit) async {
      state.conditionList = event.conditionList;
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

  //设置检索条件
  PostgrestFilterBuilder setSelectConditions(
      OperateLogModel state, PostgrestFilterBuilder query) {
    var result = query;
    if (state.searchContent != '') {
      String temp = '%' + state.searchContent + '%';
      query = query.like('content', temp);
    }
    if (state.searchTypeKbn != '') {
      query = query.eq('log_type', state.searchTypeKbn);
    }
    if (state.searchCompanyName != '') {
      query = query.eq('company_id', state.companyId);
    }
    return result;
  }
}
