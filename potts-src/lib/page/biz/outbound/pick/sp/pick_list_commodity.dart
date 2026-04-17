import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../common/localization/default_localizations.dart';
import '../../../../../widget/wms_date_widget.dart';
import '../bloc/pick_list_bloc.dart';
import '../bloc/pick_list_model.dart';
import 'pick_list_datasheet.dart';

/**
 * 内容：ピッキングリスト(シングル)
 * 作者：王光顺
 * 时间：2023/08/17
 * 作者：赵士淞
 * 时间：2023/11/08
 */
class PickListCommodityPage extends StatefulWidget {
  static const String sName = "Commodity";

  const PickListCommodityPage({super.key});

  @override
  State<PickListCommodityPage> createState() => _PickListCommodityPageState();
}

class _PickListCommodityPageState extends State<PickListCommodityPage> {
  //
  // List<bool> _checkValue = [false, true, false];
  int _checkValueInt = 1;

  //
  DateFormat format = DateFormat("yyyy/MM/dd");

  // 用于追踪按钮状态
  bool buttonPressed = false;

  // 检索日期
  String _selectedDate =
      DateTime.now().toIso8601String().substring(0, 10).replaceAll('-', '/');

  // 检索出力状态条件
  List<dynamic> list = ['2'];

  // 搜索
  bool search = false;

  //
  FocusNode searchFocusNode = FocusNode();

  // 判断悬停
  bool buttonHovered = false;

  // 检索
  bool valueFromChild = false;

  // 检索条件盒子内容
  List<String> boxFromChild = [];

  //
  List<String> textList = [];

  // 检索条件
  List<String> conditionList = ['1', '2', 'c'];

  // 明细
  bool valueFromdata = false;

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {
      setState(() {
        search = searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  void updateValue(bool value) {
    setState(() {
      valueFromChild = value;
      buttonPressed = false;
    });
  }

  void updateBox(List<String> value) {
    setState(() {
      boxFromChild = value;
    });
  }

  void upData(bool value) {
    setState(() {
      valueFromdata = value;
      buttonPressed = false;
      valueFromChild = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PickListBloc>(
      create: (context) {
        return PickListBloc(
          // 赵士淞 - 测试修复 2023/11/16 - 始
          PickListModel(rootContext: context),
          // 赵士淞 - 测试修复 2023/11/16 - 终
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          top: valueFromdata ? 10 : 30,
          left: 20,
          right: 20,
        ),
        child: ListView(
          children: [
            if (!valueFromdata) BuildData(),
            if (!valueFromdata)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(WMSLocalizations.i18n(context)!.delivery_note_12),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 48,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        BuildCheck(
                          WMSLocalizations.i18n(context)!.delivery_note_22,
                          0,
                        ),
                        BuildCheck(
                          WMSLocalizations.i18n(context)!.delivery_note_4,
                          1,
                        ),
                        BuildCheck(
                          WMSLocalizations.i18n(context)!.delivery_note_5,
                          2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (!valueFromdata)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  BuildButtom(
                    WMSLocalizations.i18n(context)!.delivery_note_24,
                    _selectedDate,
                    list,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            Stack(
              children: [
                // 一览数据表部分
                Stack(
                  children: <Widget>[
                    PickListDataSheetPage(
                      search: valueFromChild,
                      onData: upData,
                    ),
                  ],
                ),
                // 是否显示检索条件小框组件
                Visibility(
                  visible: valueFromChild,
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.only(
                      top: 50,
                    ),
                    padding: EdgeInsets.only(
                      left: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!.delivery_note_11,
                          style: TextStyle(
                            color: Color.fromARGB(255, 41, 143, 255),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        for (int i = 0; i < boxFromChild.length; i++)
                          SearchCriteria(i),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 复选框
  Expanded BuildCheck(String text, int index) {
    return Expanded(
      flex: 1,
      child: Row(
        children: [
          Transform.scale(
            scale: 0.8,
            child: Checkbox(
              fillColor: MaterialStateColor.resolveWith(
                (states) => Color.fromARGB(255, 61, 174, 182),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              value: _checkValueInt == index,
              onChanged: (value) {
                setState(() {
                  _checkValueInt = index;
                  if (value == true) {
                    if (index == 0) {
                      list = ['1', '2'];
                    } else if (index == 2) {
                      list = ['1'];
                    } else if (index == 1) {
                      list = ['2'];
                    }
                  }
                });
              },
            ),
          ),
          Text(text)
        ],
      ),
    );
  }

  // 日期
  Widget BuildData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(WMSLocalizations.i18n(context)!.delivery_note_16 +
                "（" +
                WMSLocalizations.i18n(context)!.pink_list_64 +
                "）"),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        WMSDateWidget(
          text: _selectedDate,
          dateCallBack: (value) {
            setState(() {
              _selectedDate = value;
            });
          },
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  // 检索条件小框组件
  Container SearchCriteria(index) {
    return Container(
      margin: EdgeInsets.only(
        right: 10,
      ),
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      height: 25,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: Colors.black12,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            boxFromChild[index],
            style: TextStyle(
              color: Colors.black12,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                boxFromChild.removeAt(index);
              });
            },
            child: Text(
              'x',
              style: TextStyle(
                color: Colors.black12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 输入框
  Expanded BuildInput(String text) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text),
          Container(
            constraints: BoxConstraints(
              maxHeight: 30,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black12,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 15,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 底部检索和解除按钮
  Widget BuildButtom(String text, String data, List<dynamic> list) {
    return BlocBuilder<PickListBloc, PickListModel>(
      builder: (context, state) {
        return FractionallySizedBox(
          widthFactor: 1,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1,
                color: Color.fromARGB(255, 61, 174, 182),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: OutlinedButton(
              onPressed: () {
                if (data == '') {
                  data = DateTime.now()
                      .toIso8601String()
                      .substring(0, 10)
                      .replaceAll('-', '/');
                }
                state.time = data;
                context
                    .read<PickListBloc>()
                    .add(PickListQueryEvent(data, list));
                currentIndex = 0;
              },
              child: Text(
                text,
                style: TextStyle(
                  color: Color.fromARGB(255, 61, 174, 182),
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                side: MaterialStateProperty.all(
                  BorderSide.none,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 检索条件内部数据
  Container buildCondition(int index) {
    return Container(
      margin: EdgeInsets.only(
        right: 10,
      ),
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      height: 25,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: Colors.black12,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            conditionList[index],
            style: TextStyle(
              color: Colors.black12,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                conditionList.removeAt(index);
              });
            },
            child: Text(
              'x',
              style: TextStyle(
                color: Colors.black12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
