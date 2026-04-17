import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/biz/inbound/inquiry_schedule/bloc/inquiry_schedule_print_model.dart';

import '../../../../../common/utils/supabase_untils.dart';

// 事件
abstract class InquirySchedulePrintEvent {}

// 初始化事件
class InitEvent extends InquirySchedulePrintEvent {
  // 初始化事件
  InitEvent();
}

class InquirySchedulePrintBloc
    extends Bloc<InquirySchedulePrintEvent, InquirySchedulePrintModel> {
  // 刷新补丁
  InquirySchedulePrintModel clone(InquirySchedulePrintModel src) {
    return InquirySchedulePrintModel.clone(src);
  }

  InquirySchedulePrintBloc(InquirySchedulePrintModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 查询会社
      List<dynamic> companyData = await SupabaseUtils.getClient()
          .from('mtb_company')
          .select('*')
          .eq('id', state.companyId);
      // 会社定制
      state.companyCustomize = companyData[0];

      // 入荷预定列表
      List<dynamic> receiveList = [];
      // 入荷预定明细列表
      List<dynamic> receiveDetailList = [];

      // 循环入荷预定ID列表
      for (int i = 0; i < state.receiveIdList.length; i++) {
        // 查询入荷予定
        List<dynamic> receiveData = await SupabaseUtils.getClient()
            .from('dtb_receive')
            .select('*')
            .eq('id', state.receiveIdList[i]);
        // 入荷预定列表
        receiveList.add(receiveData[0]);

        // 查询入荷预定明细
        List<dynamic> receiveDetailData = await SupabaseUtils.getClient().rpc(
            'func_muzd_query_dtb_receive_detail_print',
            params: {'receive_id': state.receiveIdList[i]}).select('*');
        // 入荷预定明细列表
        receiveDetailList.add(receiveDetailData);
      }

      // 入荷预定列表
      state.receiveList = receiveList;
      // 入荷预定明细列表
      state.receiveDetailList = receiveDetailList;

      // 更新
      emit(clone(state));
    });

    add(InitEvent());
  }
}
