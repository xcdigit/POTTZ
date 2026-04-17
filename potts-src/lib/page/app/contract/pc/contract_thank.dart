import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/model/user.dart';
import 'package:wms/redux/wms_state.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';

/**
 * 内容：サービス解約-表单
 * 作者：王光顺
 * 时间：2023/12/07
 */
class ContractThank extends StatefulWidget {
  const ContractThank({super.key});

  @override
  State<ContractThank> createState() => _InformationSocietyFormtate();
}

class _InformationSocietyFormtate extends State<ContractThank> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          // 标题
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 50, 0, 30),
              child: Text(
                WMSLocalizations.i18n(context)!.contract_text_11,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 24,
                  height: 1.0,
                  color: Color.fromRGBO(44, 167, 176, 1),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          FractionallySizedBox(
            widthFactor: 1,
            child: new Image(
                image: new AssetImage(WMSICons.REGRET_IMAGE),
                width: 686.0,
                height: 400.0),
          ),

          FractionallySizedBox(widthFactor: .2),
          //按钮
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //閉じる按钮
                Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              side: MaterialStateProperty.all(
                                const BorderSide(
                                  width: 1,
                                  color: Color.fromRGBO(44, 167, 176, 1),
                                ),
                              ),
                              minimumSize: MaterialStatePropertyAll(
                                Size(138, 40),
                              ),
                            ),
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .delivery_note_close,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            ),
                            onPressed: () {
                              //恢复迁移元
                              StoreProvider.of<WMSState>(context)
                                  .state
                                  .contractFlag = false;
                              // 持久化状态更新
                              StoreProvider.of<WMSState>(context).state.login =
                                  false;
                              // 持久化状态更新
                              StoreProvider.of<WMSState>(context)
                                  .state
                                  .userInfo = null;
                              // 持久化状态
                              StoreProvider.of<WMSState>(context)
                                  .state
                                  .loginUser = User.empty();
                              // 跳转页面
                              GoRouter.of(context).go("/login");
                            },
                          ),
                        ])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
