import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../../common/style/wms_style.dart';
import '../../../../../redux/wms_state.dart';
import '../../warehouse/bloc/warehouse_bloc.dart';
import '../../warehouse/bloc/warehouse_model.dart';
import './datasheet.dart';
import '/common/localization/default_localizations.dart';
import 'retrieval.dart';

/**
 * 内容：納品書-文件
 * 作者：王光顺
 * 时间：2023/11/02
 */

class CommodityPage extends StatefulWidget {
  static const String sName = "Commodity";
  const CommodityPage({super.key});

  @override
  State<CommodityPage> createState() => _CommodityPageState();
}

class _CommodityPageState extends State<CommodityPage> {
  // 搜索
  bool search = false;
  // 判断悬停
  bool buttonHovered = false;
  FocusNode searchFocusNode = FocusNode();
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

  // 检索条件框
  bool buttonPressed = false; // 用于追踪检索按钮状态
  void upsearchButton(bool value) {
    setState(() {
      buttonPressed = value;
    });
  }

  // 检索
  bool valueFromChild = false;
  void updateValue(bool value) {
    setState(() {
      valueFromChild = value;
      buttonPressed = false;
    });
  }

  //检索条件盒子内容
  List<String> boxFromChild = [];

  void updateBox(List<String> value) {
    setState(() {
      boxFromChild = value;
    });
  }

// 明细
  bool valueFromdata = false;
  void upData(bool value) {
    setState(() {
      valueFromdata = value;
      buttonPressed = false;
      valueFromChild = false;
    });
  }

  // 获取输入的值
  final TextEditingController _textEditingController = TextEditingController();
  List<String> textList = [];
  void _handleSubmitted(String value) {
    String inputValue = value.trim();
    textList.insert(0, inputValue);
    // 如果 TextList 的大小超过五个值，则删除最后一个值
    if (textList.length > 5) {
      textList.removeLast();
    }
    setState(() {
      buttonPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //获取当前登录用户会社ID
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    return BlocProvider<WarehouseBloc>(create: (context) {
      return WarehouseBloc(
        WarehouseModel(
          companyId: companyId,
          context: context,
        ),
      );
    }, child:
        BlocBuilder<WarehouseBloc, WarehouseModel>(builder: (context, state) {
      return ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                Stack(
                  children: [
                    // 一览数据表部分
                    Column(
                      children: [
                        RetrievalPage(
                            buttonPressed: buttonPressed,
                            onValueChanged: updateValue,
                            onBoxChanged: updateBox,
                            onbottomChanged: upsearchButton),
                        SizedBox(height: 80),
                        DataSheetPage(search: valueFromChild, onData: upData),
                      ],
                    ),
                    // 搜索框部分
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 48,
                            child: MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  buttonHovered = true; // 鼠标进入，按钮悬停状态为 true
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  buttonHovered = false; // 鼠标离开，按钮悬停状态为 false
                                });
                              },
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(
                                    () {
                                      buttonPressed =
                                          !buttonPressed; // 更新按钮状态为按下
                                      valueFromChild = false;
                                    },
                                  );
                                },
                                icon: ColorFiltered(
                                  colorFilter: buttonPressed
                                      ? ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn)
                                      : buttonHovered
                                          ? ColorFilter.mode(
                                              Colors.white, BlendMode.srcIn)
                                          : ColorFilter.mode(
                                              Color.fromRGBO(0, 122, 255, 1),
                                              BlendMode.srcIn),
                                  child: Image.asset(
                                      WMSICons.WAREHOUSE_MENU_ICON,
                                      height: 18),
                                ),
                                label: Text(''),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: buttonPressed
                                      ? Color.fromRGBO(0, 122, 255, 1)
                                      : buttonHovered
                                          ? Color.fromRGBO(0, 122, 255, .6)
                                          : Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 24),
                          Expanded(
                            flex: 1,
                            child: Container(
                              // width: 320,
                              child: Column(
                                children: [
                                  Container(
                                    height: 48,
                                    padding: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: search
                                            ? Color.fromRGBO(0, 122, 255, 1)
                                            : Colors.black12,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Image.asset(
                                            WMSICons.WAREHOUSE_SEARCH_ICON,
                                            height: 16),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextField(
                                            controller: _textEditingController,
                                            onSubmitted: (value) {
                                              //设置为第一检索
                                              state.keyword = value;
                                              // 在这里处理回车事件
                                              context.read<WarehouseBloc>().add(
                                                  QueryShipEvent(
                                                      ['1', '2', '3'],
                                                      [],
                                                      '',
                                                      value));

                                              _handleSubmitted(value);
                                            },
                                            focusNode: searchFocusNode,
                                            onTap: () {
                                              setState(() {
                                                search = true;
                                              });
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                search = value.isNotEmpty;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              hintText: WMSLocalizations.i18n(
                                                      context)!
                                                  .delivery_note_2,
                                              hintStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 122, 255, 1),
                                                  fontSize: 15),
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 点击搜索框触发事件
                                  Visibility(
                                      visible: search,
                                      child: buildText(49.0 * textList.length))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );
    }));
  }

  // 历史记录
  Container buildText(double text_height) {
    return Container(
      height: text_height,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(5)),
      child: ListView(
        children: [
          for (int i = 0; i < textList.length; i++)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black12, // 设置边框颜色
                    width: 1, // 设置边框宽度
                  ),
                ),
              ),
              child: TextButton(
                onPressed: () {
                  _textEditingController.text = textList[i];
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(textList[i]),
                ),
              ),
            )
        ],
      ),
    );
  }
}
