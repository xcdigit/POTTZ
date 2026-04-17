import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../db/user/user_provider.dart';
// import '../widget/diff_scale_text.dart';
import '/redux/wms_state.dart';
import '/common/style/wms_style.dart';
import 'home_main/pc/home_main_page.dart';
import '../page/login/sp/login_page.dart'
    if (dart.library.html) '../page/login/pc/login_page.dart';

class WelcomePage extends StatefulWidget {
  static final String sName = "/";

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool hadInit = false;
  UserDbProvider _userDbProvider = UserDbProvider();

  String text = "";
  double fontSize = 76;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (hadInit) {
      return;
    }
    hadInit = true;

    ///防止多次进入
    Store<WMSState> store = StoreProvider.of(context);

    new Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        text = "Welcome"; // TODO 多语言
        fontSize = 60;
      });
    });

    new Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
      _userDbProvider.getUserData(store.state.userInfo).then((res) {
        if (res != null) {
          context.goNamed(HomeMainPage.sName);
        } else {
          context.goNamed(LoginPage.sName);
        }
        return true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<WMSState>(
      builder: (context, store) {
        return Material(
          child: new Container(
            color: WMSColors.white,
            // child: Stack(
            //   children: <Widget>[
            //     Align(
            //       alignment: Alignment(0.0, 0.3),
            //       child: DiffScaleText(
            //         text: text,
            //         textStyle: GoogleFonts.akronim().copyWith(
            //           color: WMSColors.primaryDarkValue,
            //           fontSize: fontSize,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                child: kIsWeb
                    ? Image.asset(
                        WMSICons.HOME_HEAD_LOGO_BLACK,
                        width: 426,
                        height: 135,
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.noRepeat,
                      )
                    : Image.asset(
                        WMSICons.DEFAULT_USER_ICON,
                        width: 172.5,
                        height: 178.5,
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.noRepeat,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
