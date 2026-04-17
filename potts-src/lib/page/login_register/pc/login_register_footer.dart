import 'package:flutter/cupertino.dart';

import '../../../common/localization/default_localizations.dart';
import '../../../common/style/wms_style.dart';

/**
 * 内容：申込-footer
 * 作者：luxy
 * 时间：2024/06/24
 */
// ignore: must_be_immutable
class LoginRegisterFotter extends StatefulWidget {
  // 标记
  bool flag;

  LoginRegisterFotter({super.key, this.flag = false});

  @override
  State<LoginRegisterFotter> createState() => _LoginRegisterFotterState();
}

class _LoginRegisterFotterState extends State<LoginRegisterFotter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 50, 0, 50),
      decoration: BoxDecoration(
        color: Color.fromRGBO(29, 48, 100, 1),
      ),
      height: 190,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Image.asset(
                    WMSICons.HOME_HEAD_REGISTER_LOGO,
                    width: 203,
                    height: 23,
                    fit: BoxFit.contain,
                    repeat: ImageRepeat.noRepeat,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text(
                    WMSLocalizations.i18n(context)!.register_text_3,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.56,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    WMSLocalizations.i18n(context)!.register_text_4,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Text(
                    WMSLocalizations.i18n(context)!.register_text_5,
                    style: TextStyle(
                      color: Color.fromRGBO(146, 152, 158, 1),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.56,
                    ),
                  ),
                ),
              ],
            ),
          ),
          widget.flag
              ? Container(
                  margin: EdgeInsets.fromLTRB(0, 90, 100, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          WMSLocalizations.i18n(context)!.register_table_2,
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            letterSpacing: 1.28,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 50, 0),
                        child: Text(
                          WMSLocalizations.i18n(context)!.register_table_3,
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            letterSpacing: 1.28,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
