import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/localization/default_localizations.dart';
import '../bloc/product_information_bloc.dart';
import '../bloc/product_information_model.dart';

/**
 * 内容：商品情报-トレンド情報
 * 作者：赵士淞
 * 时间：2024/10/28
 */
class ProductInformationTrend extends StatefulWidget {
  const ProductInformationTrend({super.key});

  @override
  State<ProductInformationTrend> createState() =>
      _ProductInformationTrendState();
}

class _ProductInformationTrendState extends State<ProductInformationTrend> {
  final List<Color> colorList = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.blue,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductInformationBloc, ProductInformationModel>(
      builder: (context, state) {
        // 饼图表格列表
        List<Widget> _pieChartTableList(int flag, List<dynamic> data) {
          List<Widget> tableList = [];
          tableList.add(
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromRGBO(156, 156, 156, 1),
                  ),
                ),
              ),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.49,
                    child: Text(
                      flag == 1
                          ? WMSLocalizations.i18n(context)!
                              .trend_information_shipment
                          : flag == 2
                              ? WMSLocalizations.i18n(context)!
                                  .trend_information_entrance
                              : '',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.0,
                        color: Color.fromRGBO(156, 156, 156, 1),
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.49,
                    child: Text(
                      WMSLocalizations.i18n(context)!
                          .home_main_page_table_text5,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.0,
                        color: Color.fromRGBO(156, 156, 156, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          for (int i = 0; i < data.length; i++) {
            var statisticsText = data[i]['statistics'].toString() + '個';
            tableList.add(
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                margin: EdgeInsets.only(
                  bottom: 10,
                ),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.49,
                      child: Text(
                        data[i]['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 1.0,
                          color: Color.fromRGBO(6, 14, 15, 1),
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.49,
                      child: Text(
                        statisticsText,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 1.0,
                          color: Color.fromRGBO(6, 14, 15, 1),
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return tableList;
        }

        // 饼图数据列表
        List<PieChartSectionData> _pieChartSectionList(List<dynamic> data) {
          List<PieChartSectionData> sectionList = [];
          for (int i = 0; i < data.length; i++) {
            sectionList.add(PieChartSectionData(
              value: data[i]['statistics'],
              color: colorList[i],
              title: '',
            ));
          }
          return sectionList;
        }

        // 饼图标题列表
        List<Widget> _pieChartTitleList(List<dynamic> data) {
          List<Widget> titleList = [];
          for (int i = 0; i < data.length; i++) {
            var statisticsText = data[i]['statistics'].toString() + '個';
            titleList.add(
              FractionallySizedBox(
                widthFactor: 0.49,
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 4,
                        ),
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            FractionallySizedBox(
                              widthFactor: 0.1,
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: colorList[i],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.88,
                              child: Text(
                                data[i]['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  height: 1.0,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                  decoration: TextDecoration.none,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            FractionallySizedBox(
                              widthFactor: 0.1,
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.88,
                              child: Text(
                                statisticsText,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  height: 1.0,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                  decoration: TextDecoration.none,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return titleList;
        }

        // 柱图数据列表
        List<BarChartGroupData> _barChartGroupList(List<dynamic> data) {
          List<BarChartGroupData> groupList = [];
          for (int i = 0; i < data.length; i++) {
            groupList.add(BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: data[i]['statistics'],
                  width: 31.5,
                  borderRadius: BorderRadius.circular(0),
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
              ],
            ));
          }
          return groupList;
        }

        // 柱图标题列表
        FlTitlesData _barFlTitlesData() {
          return FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  );
                  Widget text;
                  switch (value.toInt()) {
                    case 0:
                      text = const Text('1月', style: style);
                      break;
                    case 1:
                      text = const Text('2月', style: style);
                      break;
                    case 2:
                      text = const Text('3月', style: style);
                      break;
                    case 3:
                      text = const Text('4月', style: style);
                      break;
                    case 4:
                      text = const Text('5月', style: style);
                      break;
                    case 5:
                      text = const Text('6月', style: style);
                      break;
                    case 6:
                      text = const Text('7月', style: style);
                      break;
                    case 7:
                      text = const Text('8月', style: style);
                      break;
                    case 8:
                      text = const Text('9月', style: style);
                      break;
                    case 9:
                      text = const Text('10月', style: style);
                      break;
                    case 10:
                      text = const Text('11月', style: style);
                      break;
                    case 11:
                      text = const Text('12月', style: style);
                      break;
                    default:
                      text = const Text('', style: style);
                      break;
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: text,
                  );
                },
                reservedSize: 38,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      value.toString() + '個',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          );
        }

        // 柱图选中数据
        BarTouchData _barTouchData() {
          return BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY}個',
                  TextStyle(
                    color: Colors.white,
                  ),
                );
              },
            ),
          );
        }

        // 初始化趋势信息盒子
        List<Widget> _initTrendBox() {
          return [
            FractionallySizedBox(
              widthFactor: 0.49,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Text(
                      WMSLocalizations.i18n(context)!
                          .trend_information_shipment_top_five,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.0,
                        color: Color.fromRGBO(44, 167, 176, 1),
                      ),
                    ),
                  ),
                  Container(
                    height: 307,
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(
                      bottom: 24,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(224, 224, 224, 1),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.49,
                          child: Container(
                            height: 275,
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              children:
                                  _pieChartTableList(1, state.shipmentTopFive),
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.49,
                          child: Container(
                            height: 275,
                            child: Column(
                              children: [
                                Container(
                                  height: 132.5,
                                  margin: EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  child: PieChart(
                                    PieChartData(
                                      sections: _pieChartSectionList(
                                          state.shipmentTopFive),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 132.5,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: _pieChartTitleList(
                                        state.shipmentTopFive),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.49,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Text(
                      WMSLocalizations.i18n(context)!
                          .trend_information_entrance_top_five,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.0,
                        color: Color.fromRGBO(44, 167, 176, 1),
                      ),
                    ),
                  ),
                  Container(
                    height: 307,
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(
                      bottom: 24,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(224, 224, 224, 1),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.49,
                          child: Container(
                            height: 275,
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              children:
                                  _pieChartTableList(2, state.entranceTopFive),
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.49,
                          child: Container(
                            height: 275,
                            child: Column(
                              children: [
                                Container(
                                  height: 132.5,
                                  margin: EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  child: PieChart(
                                    PieChartData(
                                      sections: _pieChartSectionList(
                                          state.entranceTopFive),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 132.5,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: _pieChartTitleList(
                                        state.entranceTopFive),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.49,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Text(
                      WMSLocalizations.i18n(context)!
                          .trend_information_shipment_month,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.0,
                        color: Color.fromRGBO(44, 167, 176, 1),
                      ),
                    ),
                  ),
                  Container(
                    height: 307,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(224, 224, 224, 1),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: BarChart(
                      BarChartData(
                        barGroups: _barChartGroupList(state.shipmentMonth),
                        titlesData: _barFlTitlesData(),
                        barTouchData: _barTouchData(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.49,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Text(
                      WMSLocalizations.i18n(context)!
                          .trend_information_entrance_month,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.0,
                        color: Color.fromRGBO(44, 167, 176, 1),
                      ),
                    ),
                  ),
                  Container(
                    height: 307,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(224, 224, 224, 1),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: BarChart(
                      BarChartData(
                        barGroups: _barChartGroupList(state.entranceMonth),
                        titlesData: _barFlTitlesData(),
                        barTouchData: _barTouchData(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        }

        return Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(224, 224, 224, 1),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceBetween,
            children: _initTrendBox(),
          ),
        );
      },
    );
  }
}
