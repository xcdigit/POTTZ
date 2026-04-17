import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/storage/local_storage.dart';
import 'package:wms/common/utils/common_utils.dart';
import 'package:wms/redux/wms_state.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import 'contract_model.dart';

/**
 * 内容：サービス解約-BLOC
 * 作者：王光顺
 * 时间：2023/12/07
 */

// 事件
abstract class ContractEvent {}

// 初始化事件
class InitEvent extends ContractEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定检索条件值事件
class SetSearchValueEvent extends ContractEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value);
}

// 选中语言变更事件
class SelectedLanguageChangeEvent extends ContractEvent {
  // 选中语言ID
  int selectedLanguageId;
  // 选中语言变更事件
  SelectedLanguageChangeEvent(this.selectedLanguageId);
}

// 自定义事件 - 终

class ContractBloc extends Bloc<ContractEvent, ContractModel> {
  ContractBloc(ContractModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 自定义事件 - 始

      // 查询多语言信息
      List<Map<String, dynamic>> languageData =
          await SupabaseUtils.getClient().from('mtb_language').select('*');
      // 多语言列表
      state.languageList = languageData;

      // 查询会社情报
      var query = SupabaseUtils.getClient().from('mtb_company').select('*');
      List<dynamic> data = await query.eq('id', state.companyId);
      if (data.length != 0) {
        state.formInfo = data[0];
        if (state.formInfo['status'] == Config.NUMBER_THREE.toString() ||
            state.formInfo['status'] == Config.NUMBER_FOUR.toString()) {
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.context)!
              .company_terminated_cannot_again);
        }
      } else {
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.context)!.company_not_exist);
      }
      // 查询運用会社管理数据
      var queryDate =
          SupabaseUtils.getClient().from('ytb_company_manage').select('*');
      List<dynamic> dataDate =
          await queryDate.eq('company_id', state.companyId);
      if (dataDate.length != 0) {
        state.formDateInfo = dataDate[0];
      }
      // 自定义事件 - 终

      // 刷新补丁
      emit(ContractModel.clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 选中语言变更事件
    on<SelectedLanguageChangeEvent>((event, emit) async {
      // 切换语言
      CommonUtils.changeLocale(
          StoreProvider.of<WMSState>(state.context), event.selectedLanguageId);
      // 本地存储
      LocalStorage.save(Config.LOCALE, event.selectedLanguageId.toString());
      // 选中语言
      state.selectedLanguage = event.selectedLanguageId;
      // 刷新
      emit(ContractModel.clone(state));
      // 关闭弹窗
      Navigator.pop(state.context);
    });

    add(InitEvent());
  }
  //自定义方法 - 始

  //自定义方法 - 终
}
