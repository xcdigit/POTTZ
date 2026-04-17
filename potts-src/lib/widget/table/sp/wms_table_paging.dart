import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/wms_table_bloc.dart';
import '../bloc/wms_table_model.dart';

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
      IconButton(
        onPressed: () {
          // 判断页数
          if (model.pageNum > 0) {
            context.read<T>().add(MoveAdjacentEvent(pageStep: -1));
          }
        },
        icon: Icon(Icons.chevron_left_rounded),
      ),
    );
    // 判断最大页数
    if (maxPage < 5) {
      // 分页列表
      pagingList.addAll(_initPagingSmallNumber(maxPage));
    } else {
      // 判断分页
      if (model.pageNum < 2) {
        // 分页列表
        pagingList.addAll(_initPagingBigNumberLeft(maxPage));
      } else if (model.pageNum > maxPage - 3) {
        // 分页列表
        pagingList.addAll(_initPagingBigNumberRight(maxPage));
      } else {
        // 分页列表
        pagingList.addAll(_initPagingBigNumberCenter(model.pageNum, maxPage));
      }
    }
    // 分页列表
    pagingList.add(
      IconButton(
        onPressed: () {
          // 判断页数
          if (model.pageNum < maxPage - 1) {
            context.read<T>().add(MoveAdjacentEvent(pageStep: 1));
          }
        },
        icon: Icon(Icons.chevron_right_rounded),
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
    for (int i = 0; i < 3; i++) {
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
    for (int i = maxPage - 3; i < maxPage; i++) {
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
    // 分页列表
    pagingList.add(_initPagingItem(pageNum));
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
          decoration: BoxDecoration(
            color: state.pageNum == i ? Color.fromRGBO(44, 167, 176, 1) : null,
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
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 初始化分页省略
  Widget _initPagingOmit() {
    return Container(
      width: 32,
      height: 32,
      child: Center(
        child: Icon(Icons.more_horiz),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, WmsTableModel>(
      builder: (context, state) => Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _initPaging(state),
          ),
        ],
      ),
    );
  }
}
