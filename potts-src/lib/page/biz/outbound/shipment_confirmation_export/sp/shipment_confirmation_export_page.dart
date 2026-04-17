import 'package:flutter/widgets.dart';

/**
 * 内容：出荷確定データ出力 临时页面 该业务没有手机端
 * 作者：穆政道
 * 时间：2023/10/12
 */
class ShipmentConfirmationExportPage extends StatefulWidget {
  const ShipmentConfirmationExportPage({super.key});

  @override
  State<ShipmentConfirmationExportPage> createState() =>
      _ShipmentConfirmationExportPagePageState();
}

class _ShipmentConfirmationExportPagePageState
    extends State<ShipmentConfirmationExportPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
    // return BlocProvider<ShipmentConfirmationExportBloc>(
    //   create: (context) {
    //     return ShipmentConfirmationExportBloc(
    //       ShipmentConfirmationExportModel(),
    //     );
    //   },
    //   child: FractionallySizedBox(
    //     widthFactor: 1,
    //     heightFactor: 1,
    //     child: Container(
    //       padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
    //       child: ListView(
    //         children: [
    //           //   // 头部
    //           //   ShipmentConfirmationExportTitle(),
    //           //   // 檢索
    //           //   ShipmentConfirmationExportQuery(),
    //           //   // 表格
    //           //   ShipmentConfirmationExportTable(),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
