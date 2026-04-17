import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../common/localization/default_localizations.dart';
import '../bloc/wms_table_bloc.dart';
import '../bloc/wms_table_model.dart';

// 条数列表
const List<int> piecesList = [10, 20, 30, 40, 50, 100];

class WmsPageManger<T extends WmsTableBloc> extends StatefulWidget {
  const WmsPageManger({super.key});

  @override
  State<WmsPageManger<T>> createState() => _WmsPageMangerState<T>();
}

class _WmsPageMangerState<T extends WmsTableBloc>
    extends State<WmsPageManger<T>> {
  // 初始化分页
  List<Widget> _initPaging(WmsTableModel model) {
    // 最大页数
    int maxPage = model.getMaxPage();
    // 分页列表
    List<Widget> pagingList = [];
    // 分页列表
    pagingList.add(
      Container(
        margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
        child: IconButton(
          onPressed: () {
            // 判断页数
            if (model.pageNum > 0) {
              context.read<T>().add(MoveAdjacentEvent(pageStep: -1));
            }
          },
          icon: Icon(Icons.chevron_left_rounded),
        ),
      ),
    );
    // 判断最大页数
    if (maxPage < 7) {
      // 分页列表
      pagingList.addAll(_initPagingSmallNumber(maxPage));
    } else {
      // 判断分页
      if (model.pageNum < 4) {
        // 分页列表
        pagingList.addAll(_initPagingBigNumberLeft(maxPage));
      } else if (model.pageNum > maxPage - 5) {
        // 分页列表
        pagingList.addAll(_initPagingBigNumberRight(maxPage));
      } else {
        // 分页列表
        pagingList.addAll(_initPagingBigNumberCenter(model.pageNum, maxPage));
      }
    }
    // 分页列表
    pagingList.add(
      Container(
        margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
        child: IconButton(
          onPressed: () {
            // 判断页数
            if (model.pageNum < maxPage - 1) {
              context.read<T>().add(MoveAdjacentEvent(pageStep: 1));
            }
          },
          icon: Icon(Icons.chevron_right_rounded),
        ),
      ),
    );
    // 分页列表
    return pagingList;
  }

  // 初始化分页小数字
  List<Widget> _initPagingSmallNumber(int maxPage) {
    List<Widget> pagingList = [];
    // 循环最大页数
    for (int i = 0; i < maxPage; i++) {
      // 分页列表
      pagingList.add(_initPagingItem(i));
    }
    if (maxPage == 0) {
      // 分页列表
      pagingList.add(_initPagingItem(0));
    }
    // 分页列表
    return pagingList;
  }

  // 初始化分页大数字左部
  List<Widget> _initPagingBigNumberLeft(int maxPage) {
    List<Widget> pagingList = [];
    // 循环特定页数
    for (int i = 0; i < 5; i++) {
      // 分页列表
      pagingList.add(_initPagingItem(i));
    }
    // 分页列表
    pagingList.add(_initPagingOmit());
    // 分页列表
    pagingList.add(_initPagingItem(maxPage - 1));
    // 分页列表
    return pagingList;
  }

  // 初始化分页大数字右部
  List<Widget> _initPagingBigNumberRight(int maxPage) {
    List<Widget> pagingList = [];
    // 分页列表
    pagingList.add(_initPagingItem(0));
    // 分页列表
    pagingList.add(_initPagingOmit());
    // 循环特定页数
    for (int i = maxPage - 5; i < maxPage; i++) {
      // 分页列表
      pagingList.add(_initPagingItem(i));
    }
    // 分页列表
    return pagingList;
  }

  // 初始化分页大数字中部
  List<Widget> _initPagingBigNumberCenter(int pageNum, int maxPage) {
    List<Widget> pagingList = [];
    // 分页列表
    pagingList.add(_initPagingItem(0));
    // 分页列表
    pagingList.add(_initPagingOmit());
    // 循环特定页数
    for (int i = pageNum - 1 - 1; i < pageNum + 2; i++) {
      // 分页列表
      pagingList.add(_initPagingItem(i));
    }
    // 分页列表
    pagingList.add(_initPagingOmit());
    // 分页列表
    pagingList.add(_initPagingItem(maxPage - 1));
    // 分页列表
    return pagingList;
  }

  // 初始化分页单个
  Widget _initPagingItem(int i) {
    return GestureDetector(
      onTap: () {
        context.read<T>().add(PageNumSetEvent(i));
      },
      child: BlocBuilder<T, WmsTableModel>(
          builder: (context, state) => Container(
                width: 32,
                height: 32,
                margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                decoration: BoxDecoration(
                  color: state.pageNum == i
                      ? Color.fromRGBO(44, 167, 176, 1)
                      : null,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    (i + 1).toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: state.pageNum == i
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(6, 14, 15, 1),
                    ),
                  ),
                ),
              )),
    );
  }

  // 初始化分页省略
  Widget _initPagingOmit() {
    return Container(
      width: 32,
      height: 32,
      margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Center(
        child: Icon(Icons.more_horiz),
      ),
    );
  }

  // 初始化分条
  List<Widget> _initStriping(int pageSize) {
    // 文本编辑控制器
    final TextEditingController typeAheadController =
        TextEditingController(text: pageSize.toString());
    // 分条列表
    List<Widget> stripingList = [];
    // 分条列表
    stripingList.add(
      Container(
        margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
        child: Center(
          child: Text(
            WMSLocalizations.i18n(context)!.table_striping_text_1,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(6, 14, 15, 1),
            ),
          ),
        ),
      ),
    );
    // 分条列表
    stripingList.add(
      Container(
        width: 100,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(224, 224, 224, 1),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: typeAheadController,
            decoration: InputDecoration(
              enabled: false,
              prefixIcon: Container(
                width: 16,
                height: 24,
              ),
              prefixIconConstraints: BoxConstraints(),
              hintText: '',
              suffixIcon: Container(
                width: 16,
                height: 24,
              ),
              suffixIconConstraints: BoxConstraints(),
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          suggestionsCallback: (_) {
            return piecesList;
          },
          suggestionsBoxDecoration: SuggestionsBoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          itemBuilder: (context, itemData) {
            return Container(
              height: 32,
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromRGBO(196, 196, 196, 1),
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    itemData.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                ),
              ),
            );
          },
          onSuggestionSelected: (suggestion) {
            // 文本编辑控制器
            typeAheadController.text = suggestion.toString();
            context.read<T>().add(PageSizeSetEvent(suggestion));
          },
        ),
      ),
    );
    // 分条列表
    stripingList.add(
      Container(
        margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
        child: Center(
          child: Text(
            WMSLocalizations.i18n(context)!.table_striping_text_2,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(6, 14, 15, 1),
            ),
          ),
        ),
      ),
    );
    // 分条列表
    return stripingList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, WmsTableModel>(
      builder: (context, state) => Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _initPaging(state),
          ),
          Positioned(
            right: 0,
            child: Container(
              height: 32,
              margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                children: _initStriping(state.pageSize),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
