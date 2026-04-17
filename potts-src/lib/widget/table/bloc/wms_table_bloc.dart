import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/widget/table/bloc/wms_table_model.dart';

import '../../../db/model/filter_criteria.dart';

abstract class TableListEvent {}

class PageQueryEvent extends TableListEvent {
  PageQueryEvent();
}

class MoveAdjacentEvent extends TableListEvent {
  int pageStep;
  MoveAdjacentEvent({this.pageStep = 1});
}

class PageNumSetEvent extends TableListEvent {
  int pageNum;
  PageNumSetEvent(this.pageNum);
}

class PageSizeSetEvent extends TableListEvent {
  int pageSize;
  PageSizeSetEvent(this.pageSize);
}

class RecordCheckEvent extends TableListEvent {
  bool checked;
  int index;
  RecordCheckEvent(this.checked, this.index);
}

class RecordCheckAllEvent extends TableListEvent {
  bool checked;
  RecordCheckAllEvent(this.checked);
}

class MatchAppendEvent extends TableListEvent {
  String name;
  dynamic value;
  MatchAppendEvent(this.name, this.value);
}

class MatchClearEvent extends TableListEvent {
  MatchClearEvent();
}

class FilterAppendEvent extends TableListEvent {
  FilterCriteria criteria;
  FilterAppendEvent(this.criteria);
}

class FilterClearEvent extends TableListEvent {
  FilterClearEvent();
}

abstract class WmsTableBloc<S extends WmsTableModel>
    extends Bloc<TableListEvent, S> {
  S clone(S src);

  WmsTableBloc(S state) : super(state) {
    on<MatchAppendEvent>((event, emit) async {
      state.matchCriteria![event.name] = event.value;
      emit(state);
    });
    on<MatchClearEvent>((event, emit) async {
      state.matchCriteria!.clear();
      emit(state);
    });
    on<FilterAppendEvent>((event, emit) async {
      state.filterCriteria!.add(event.criteria);
      emit(state);
    });
    on<FilterClearEvent>((event, emit) async {
      state.filterCriteria!.clear();
      emit(state);
    });
    on<MoveAdjacentEvent>((event, emit) async {
      state.pageNum = state.pageNum + event.pageStep;
      emit(state);
      add(PageQueryEvent());
    });
    on<PageNumSetEvent>((event, emit) async {
      if (state.pageNum != event.pageNum) {
        state.pageNum = event.pageNum;
        emit(state);
        add(PageQueryEvent());
      }
    });
    on<PageSizeSetEvent>((event, emit) async {
      if (state.pageSize != event.pageSize) {
        state.pageNum = 0;
        state.pageSize = event.pageSize;
        emit(state);
        add(PageQueryEvent());
      }
    });
    on<RecordCheckAllEvent>((event, emit) async {
      state.records.forEach((element) {
        element.checked = event.checked;
      });
      emit(clone(state)); // 刷新补丁
    });
  }
}
