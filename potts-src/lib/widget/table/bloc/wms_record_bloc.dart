import 'package:flutter_bloc/flutter_bloc.dart';

import 'wms_record_model.dart';

abstract class RecordEvent {}

class CheckRecordEvent extends RecordEvent {
  bool checked;
  CheckRecordEvent(this.checked);
}

class WmsRecordBloc extends Bloc<RecordEvent, WmsRecordModel> {
  WmsRecordBloc(WmsRecordModel state) : super(state) {
    on<CheckRecordEvent>((event, emit) async {
      state.checked = event.checked;
      WmsRecordModel dest =
          WmsRecordModel(state.index, state.data, checked: state.checked);
      emit(dest);
    });
  }
}
