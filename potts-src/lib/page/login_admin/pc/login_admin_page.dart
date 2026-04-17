import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../../common/storage/local_storage.dart';
import '../../../common/style/wms_style.dart';
import '../../../redux/login_redux.dart';
import '../../../redux/wms_state.dart';
import '../../../widget/wms_flex_button.dart';
import '../../../widget/wms_input_widget.dart';
import '../../home/bloc/home_menu_bloc.dart';
import '../../home/bloc/home_menu_model.dart';
import '../../home/pc/home_head_page.dart';

class LoginAdminPage extends StatefulWidget {
  static const String sName = "LoginAdmin";

  @override
  State createState() {
    return new _LoginAdminPageState();
  }
}

class _LoginAdminPageState extends State<LoginAdminPage> with LoginBLoC {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeMenuBloc>(
      create: (context) =>
          HomeMenuBloc(HomeMenuModel(context, menuInfoList: [])),
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: WMSColors.cardWhite,
          child: Column(
            children: [
              Container(
                height: 100,
                child: HomeHeadPage(),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
              ),
              Image(
                image: AssetImage(WMSICons.DEFAULT_USER_ICON),
                width: 90.0,
                height: 90.0,
              ),
              Image(
                image: AssetImage(WMSICons.DEFAULT_LOFIN_LETTER),
                width: 90.0,
                height: 30.0,
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Text(
                "管理者専用",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
              ),
              Container(
                width: 400,
                height: 56,
                child: WMSInputWidget(
                  hintText:
                      WMSLocalizations.i18n(context)!.login_username_hint_text,
                  onChanged: (String value) {
                    _userName = value;
                  },
                  controller: userController,
                  filled: true,
                  fillColor: Color.fromRGBO(245, 245, 245, 1),
                  border: InputBorder.none,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Container(
                width: 400,
                height: 56,
                child: WMSInputWidget(
                  hintText:
                      WMSLocalizations.i18n(context)!.login_password_hint_text,
                  onChanged: (String value) {
                    _password = value;
                  },
                  onSubmitted: (value) {
                    loginIn();
                  },
                  controller: pwController,
                  obscureText: _eyeHidden,
                  filled: true,
                  fillColor: Color.fromRGBO(245, 245, 245, 1),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      _eyeHidden = !_eyeHidden;
                    }),
                    icon: Image(
                      image: AssetImage(_eyeHidden
                          ? WMSICons.DEFAULT_EYE_CLOSE_ICON
                          : WMSICons.DEFAULT_EYE_OPEN_ICON),
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                ),
              ),
              // 记住我
              new Container(
                width: 400,
                height: 56,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Text(WMSLocalizations.i18n(context)!.login_remember_me),
                    new Switch(
                      value: _remember,
                      onChanged: (value) {
                        setState(() {
                          _remember = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _visible,
                child: Text(
                  _showFlag == "_userName"
                      ? WMSLocalizations.i18n(context)!.login_username_hint_text
                      : WMSLocalizations.i18n(context)!
                          .login_password_hint_text,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                width: 400,
                height: 56,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: WMSFlexButton(
                        text: _loginFlag
                            ? 'Loading...'
                            : WMSLocalizations.i18n(context)!.login_text,
                        color: ((_userName != "" && _userName != null) ||
                                (_password != "" && _userName != null))
                            ? Color.fromRGBO(44, 167, 176, 1)
                            : Color.fromRGBO(44, 167, 176, 0.6),
                        textColor: WMSColors.textWhite,
                        fontSize: 14,
                        onPress: loginIn,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Container(
                width: 400,
                height: 56,
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        context.go('/loginForgetPwd');
                      },
                      child: Text(
                        WMSLocalizations.i18n(context)!.login_forget_pdw_text,
                        style: TextStyle(
                          color: Color.fromRGBO(44, 167, 176, 0.6),
                          decoration: TextDecoration.underline,
                        ),
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
}

mixin LoginBLoC on State<LoginAdminPage> {
  String? _userName = "";

  String? _password = "";

  bool _remember = false;

  final TextEditingController userController = new TextEditingController();

  final TextEditingController pwController = new TextEditingController();

  bool _visible = false;

  String _showFlag = "";

  bool _loginFlag = false;

  bool _eyeHidden = true;

  @override
  void initState() {
    super.initState();
    initParams();
  }

  initParams() async {
    _userName = await LocalStorage.get(Config.USER_NAME_KEY);
    _password = await LocalStorage.get(Config.PW_KEY);
    _remember =
        await LocalStorage.get(Config.REMEMBER_ME) == 'true' ? true : false;
    userController.value = TextEditingValue(text: _userName ?? "");
    pwController.value = TextEditingValue(text: _password ?? "");
  }

  @override
  void dispose() {
    super.dispose();
    userController.removeListener(_usernameChange);
    pwController.removeListener(_passwordChange);
  }

  _usernameChange() {
    _userName = userController.text;
  }

  _passwordChange() {
    _password = pwController.text;
  }

  loginIn() async {
    if (_userName == null || _userName == "") {
      setState(() {
        _visible = true;
        _showFlag = "_userName";
      });
      return;
    } else {
      setState(() {
        _visible = false;
      });
    }
    if (_password == null || _password == "") {
      setState(() {
        _visible = true;
        _showFlag = "_password";
      });
      return;
    } else {
      setState(() {
        _visible = false;
        _loginFlag = true;
      });
    }
    if (!_visible) {
      StoreProvider.of<WMSState>(context).dispatch(LoginAction(context,
          _userName, _password, _remember, Config.LOGIN_ROLE_1, handleResult));
    }
  }

  void handleResult(bool value) {
    setState(() {
      _loginFlag = value;
    });
  }
}
