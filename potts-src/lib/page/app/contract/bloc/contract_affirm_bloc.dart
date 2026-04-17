import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import 'contract_affirm_model.dart';

/**
 * 内容：サービス解約-BLOC
 * 作者：王光顺
 * 时间：2023/12/07
 * 修正：穆政道
 * 修正时间; 2023/12/15
 */

// 事件
abstract class ContractAffirmEvent {}

// 初始化事件
class InitEvent extends ContractAffirmEvent {
  // 初始化事件
  InitEvent();
}

//登录/修改表单
class UpdateFormEvent extends ContractAffirmEvent {
  // 结构树
  BuildContext context;
  UpdateFormEvent(this.context);
}

// 自定义事件 - 始

// 自定义事件 - 终

class ContractAffirmBloc
    extends Bloc<ContractAffirmEvent, ContractAffirmModel> {
  ContractAffirmBloc(ContractAffirmModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {});

    add(InitEvent());

    //登录/修改表单
    on<UpdateFormEvent>((event, emit) async {
      //check必须输入项目
      List<Map<String, dynamic>> date = await SupabaseUtils.getClient()
          .from('mtb_company')
          .update({'status': 3})
          .eq('id', state.DateList[0]['id'])
          .select('*');
      if (date.length != 0) {
        // 跳转页面
        GoRouter.of(event.context).go('/contract/affirm/thank');
      } else {
        //失败
        WMSCommonBlocUtils.successTextToast(
            WMSLocalizations.i18n(event.context)!.contract_text_1 +
                WMSLocalizations.i18n(event.context)!.update_error);
      }
    });
  }

  //自定义方法 - 终
}
