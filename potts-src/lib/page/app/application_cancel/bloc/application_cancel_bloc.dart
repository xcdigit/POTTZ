import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'application_cancel_model.dart';

/**
 * 内容：解约受付-BLOC
 * 作者：赵士淞
 * 时间：2025/01/08
 */
// 事件
abstract class ApplicationCancelEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends ApplicationCancelEvent {
  // 初始化事件
  InitEvent();
}

// 表格标签下标变更事件
class TableTabIndexChangeEvent extends ApplicationCancelEvent {
  // 标签下标
  int tabIndex;

  // 表格标签下标变更事件
  TableTabIndexChangeEvent(this.tabIndex);
}

// 确认解约事件
class ConfirmCancelEvent extends ApplicationCancelEvent {
  // 解约ID
  int cancelId;

  // 确认解约事件
  ConfirmCancelEvent(this.cancelId);
}

// 保存检索按钮标记事件
class SaveQueryButtonFlag extends ApplicationCancelEvent {
  // 值
  bool value;

  // 保存检索按钮标记事件
  SaveQueryButtonFlag(this.value);
}

// 保存查询：公司事件
class SaveSearchCompanyEvent extends ApplicationCancelEvent {
  // ID值
  int idValue;
  // 名称值
  String nameValue;

  // 保存查询：公司事件
  SaveSearchCompanyEvent(this.idValue, this.nameValue);
}

// 保存查询：用户名称事件
class SaveSearchUserNameEvent extends ApplicationCancelEvent {
  // 值
  String value;

  // 保存查询：用户名称事件
  SaveSearchUserNameEvent(this.value);
}

// 保存查询：用户邮箱事件
class SaveSearchUserEmailEvent extends ApplicationCancelEvent {
  // 值
  String value;

  // 保存查询：用户邮箱事件
  SaveSearchUserEmailEvent(this.value);
}

// 搜索按钮事件
class SearchButtonEvent extends ApplicationCancelEvent {
  // 搜索按钮事件
  SearchButtonEvent();
}

// 重置按钮事件
class ResetButtonEvent extends ApplicationCancelEvent {
  // 重置按钮事件
  ResetButtonEvent();
}

// 保存检索：公司事件
class SaveQueryCompanyEvent extends ApplicationCancelEvent {
  // ID值
  int idValue;
  // 名称值
  String nameValue;

  // 保存检索：公司事件
  SaveQueryCompanyEvent(this.idValue, this.nameValue);
}

// 保存检索：用户名称事件
class SaveQueryUserNameEvent extends ApplicationCancelEvent {
  // 值
  String value;

  // 保存检索：用户名称事件
  SaveQueryUserNameEvent(this.value);
}

// 保存检索：用户邮箱事件
class SaveQueryUserEmailEvent extends ApplicationCancelEvent {
  // 值
  String value;

  // 保存检索：用户邮箱事件
  SaveQueryUserEmailEvent(this.value);
}

// 设置sort字段
class SetSortEvent extends ApplicationCancelEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

class ApplicationCancelBloc extends WmsTableBloc<ApplicationCancelModel> {
  // 刷新补丁
  @override
  ApplicationCancelModel clone(ApplicationCancelModel src) {
    return ApplicationCancelModel.clone(src);
  }

  ApplicationCancelBloc(ApplicationCancelModel state) : super(state) {
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
      List<dynamic> data = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_table_ytb_cancel', params: {
            'p_user_name': state.queryUserName,
            'p_user_email': state.queryUserEmail,
            'p_company_id': state.queryCompanyId == Config.NUMBER_ZERO
                ? null
                : state.queryCompanyId,
          })
          .select('*')
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        // 数据处理
        data[i]['admin_confirm_status_name'] = data[i]
                    ['admin_confirm_status'] ==
                Config.NUMBER_ZERO.toString()
            ? WMSLocalizations.i18n(state.rootContext)!
                .app_cancel_status_not_confirm
            : data[i]['admin_confirm_status'] == Config.NUMBER_ONE.toString()
                ? WMSLocalizations.i18n(state.rootContext)!
                    .app_cancel_status_confirm
                : '';
        data[i]['create_time_format'] =
            data[i]['create_time'].toString().substring(0, 10);
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }

      // 查询出荷指示
      List<dynamic> count = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_table_ytb_cancel', params: {
        'p_user_name': state.queryUserName,
        'p_user_email': state.queryUserEmail,
        'p_company_id': state.queryCompanyId == Config.NUMBER_ZERO
            ? null
            : state.queryCompanyId,
      }).select('*');
      // 总页数
      state.total = count.length;

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询公司数据
      List<Map<String, dynamic>> companyData =
          await SupabaseUtils.getClient().from('mtb_company').select('*');
      // 公司列表
      state.companyList = companyData;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 表格标签下标变更事件
    on<TableTabIndexChangeEvent>((event, emit) async {
      // 表格标签下标
      state.tableTabIndex = event.tabIndex;

      // 更新
      emit(clone(state));
    });

    // 确认解约事件
    on<ConfirmCancelEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 更新解约管理
      await SupabaseUtils.getClient().from('ytb_cancel').update({
        'admin_confirm_status': Config.NUMBER_ONE.toString(),
        'update_id':
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id,
        'update_time': DateTime.now().toString()
      }).eq('id', event.cancelId);
      // 消息提示
      WMSCommonBlocUtils.successTextToast(
          WMSLocalizations.i18n(state.rootContext)!.app_cancel_confirm_finish);

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 保存检索按钮标记事件
    on<SaveQueryButtonFlag>((event, emit) async {
      // 检索按钮标记
      state.queryButtonFlag = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存查询：公司事件
    on<SaveSearchCompanyEvent>((event, emit) async {
      // 查询：公司ID
      state.searchCompanyId = event.idValue;
      // 查询：公司名称
      state.searchCompanyName = event.nameValue;

      // 更新
      emit(clone(state));
    });

    // 保存查询：用户名称事件
    on<SaveSearchUserNameEvent>((event, emit) async {
      // 查询：用户名称
      state.searchUserName = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存查询：用户邮箱事件
    on<SaveSearchUserEmailEvent>((event, emit) async {
      // 查询：用户邮箱
      state.searchUserEmail = event.value;

      // 更新
      emit(clone(state));
    });

    // 搜索按钮事件
    on<SearchButtonEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索按钮标记
      state.queryButtonFlag = false;
      // 查询：公司ID
      state.queryCompanyId = state.searchCompanyId;
      // 查询：公司名称
      state.queryCompanyName = state.searchCompanyName;
      // 查询：用户名称
      state.queryUserName = state.searchUserName;
      // 查询：用户邮箱
      state.queryUserEmail = state.searchUserEmail;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 重置按钮事件
    on<ResetButtonEvent>((event, emit) async {
      // 查询：公司ID
      state.searchCompanyId = Config.NUMBER_ZERO;
      // 查询：公司名称
      state.searchCompanyName = '';
      // 查询：用户名称
      state.searchUserName = '';
      // 查询：用户邮箱
      state.searchUserEmail = '';

      // 更新
      emit(clone(state));
    });

    // 保存检索：公司事件
    on<SaveQueryCompanyEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：公司ID
      state.queryCompanyId = event.idValue;
      // 检索：公司名称
      state.queryCompanyName = event.nameValue;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 保存检索：用户名称事件
    on<SaveQueryUserNameEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：用户名称
      state.queryUserName = event.value;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 保存检索：用户邮箱事件
    on<SaveQueryUserEmailEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：用户邮箱
      state.queryUserEmail = event.value;

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
}
