import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../common/localization/default_localizations.dart';
import '../common/style/wms_style.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: WMSColors.cardWhite,
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          // 顶部内容
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: Color.fromRGBO(44, 167, 176, 1),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 40,
                  top: 15,
                  bottom: 5,
                  child: HomeHeadLogo(),
                ),
              ],
            ),
          ),
          // 占位
          SizedBox(
            height: 30,
          ),
          // 图片图标
          Image(
            image: AssetImage(WMSICons.DEFAULT_ERROR),
            fit: BoxFit.contain,
            repeat: ImageRepeat.noRepeat,
            width: MediaQuery.of(context).size.width,
            height: kIsWeb
                ? 400.0
                : (MediaQuery.of(context).size.height -
                        110 -
                        30 -
                        30 -
                        44 -
                        30 -
                        56) /
                    2,
          ),
          // 占位
          SizedBox(
            height: 30,
          ),
          // 错误文言-“系统错误”
          Container(
            height: 44,
            child: Text(
              textAlign: TextAlign.center,
              WMSLocalizations.i18n(context)!.error_message,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 36,
                color: Color.fromRGBO(181, 181, 181, 1),
              ),
            ),
          ),
          // 占位
          SizedBox(
            height: 30,
          ),
          // 返回按钮
          Container(
            height: 56,
            child: Column(
              children: [
                Container(
                  width: 200,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: WMSColors.textWhite,
                            side: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(44, 167, 176, 1),
                            ),
                          ),
                          onPressed: () {
                            GoRouter.of(context).go('/');
                          },
                          child: Text(
                            WMSLocalizations.i18n(context)!.error_return,
                            style: TextStyle(
                              color: Color.fromRGBO(44, 167, 176, 1),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 首页框架头部LOGO
class HomeHeadLogo extends StatelessWidget {
  const HomeHeadLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      WMSICons.HOME_HEAD_LOGO,
      width: 284,
      height: 90,
      fit: BoxFit.contain,
      repeat: ImageRepeat.noRepeat,
    );
  }
}
