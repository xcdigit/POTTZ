import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import '../../home/bloc/home_menu_bloc.dart';
import '../../home/bloc/home_menu_model.dart';
import '../../home/pc/home_head_page.dart';
import '/common/storage/local_storage.dart';
import '/common/config/config.dart';
import '/common/localization/default_localizations.dart';
import '/redux/wms_state.dart';
import '/redux/login_redux.dart';
import '/common/style/wms_style.dart';
import '/widget/wms_flex_button.dart';
import '/widget/wms_input_widget.dart';

class LoginPage extends StatefulWidget {
  static const String sName = "Login";
  @override
  State createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with LoginBLoC {
  @override
  Widget build(BuildContext context) {
    // 赵士淞 - 始
    return BlocProvider<HomeMenuBloc>(
      create: (context) =>
          HomeMenuBloc(HomeMenuModel(context, menuInfoList: [])),
      child:
          // 赵士淞 - 终
          /// 触摸收起键盘
          new GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          body: new Container(
            color: Theme.of(context).primaryColor,
            child: Stack(children: <Widget>[
              new Center(
                ///防止overFlow的现象
                child: SafeArea(
                  ///同时弹出键盘不遮挡
                  child: SingleChildScrollView(
                    child: new Container(
                      height: MediaQuery.of(context).size.height, //宽度自适应
                      width: MediaQuery.of(context).size.width, //高度自适应
                      color: WMSColors.cardWhite,
                      child: new Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // 顶部内容
                          Container(
                            height: 100,
                            child: HomeHeadPage(), // false
                          ),
                          new Padding(padding: new EdgeInsets.all(15.0)),
                          //图片图标
                          new Image(
                            image: new AssetImage(WMSICons.DEFAULT_USER_ICON),
                            width: 90.0,
                            height: 90.0,
                          ),
                          //英文图标
                          new Image(
                            image:
                                new AssetImage(WMSICons.DEFAULT_LOFIN_LETTER),
                            width: 90.0,
                            height: 30.0,
                          ),
                          new Padding(padding: new EdgeInsets.all(15.0)),
                          //用户框
                          new Container(
                            width: 400,
                            height: 56,
                            child: new WMSInputWidget(
                              hintText: WMSLocalizations.i18n(context)!
                                  .login_username_hint_text,
                              onChanged: (String value) {
                                _userName = value;
                              },
                              controller: userController,
                              filled: true, //是否填充背景色
                              //设置背景色，filled 为 true 时生效
                              fillColor: Color.fromRGBO(245, 245, 245, 1),
                              border: InputBorder.none, //去除下划线
                            ),
                          ),
                          new Padding(padding: new EdgeInsets.all(5.0)),
                          //密码框
                          new Container(
                            width: 400,
                            height: 56,
                            child: new WMSInputWidget(
                              hintText: WMSLocalizations.i18n(context)!
                                  .login_password_hint_text,
                              onChanged: (String value) {
                                _password = value;
                              },
                              onSubmitted: (value) {
                                //登录方法
                                loginIn();
                              },
                              controller: pwController,
                              obscureText: _eyeHidden, //是否隐藏信息
                              filled: true, //是否填充背景色
                              //设置背景色，filled 为 true 时生效
                              fillColor: Color.fromRGBO(245, 245, 245, 1),
                              border: InputBorder.none, //去除下划线
                              suffixIcon: IconButton(
                                onPressed: () => setState(() {
                                  _eyeHidden = !_eyeHidden;
                                }),
                                icon: new Image(
                                  image: new AssetImage(_eyeHidden
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
                                new Text(WMSLocalizations.i18n(context)!
                                    .login_remember_me),
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
                          //提示框
                          new Visibility(
                            visible: _visible,
                            child: new Text(
                              _showFlag == "_userName"
                                  ? WMSLocalizations.i18n(context)!
                                      .login_username_hint_text
                                  : WMSLocalizations.i18n(context)!
                                      .login_password_hint_text,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //登录按钮
                          Container(
                            width: 400,
                            height: 56,
                            child: Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new WMSFlexButton(
                                    text: _loginFlag
                                        ? 'Loading...'
                                        : WMSLocalizations.i18n(context)!
                                            .login_text,
                                    color: ((_userName != "" &&
                                                _userName != null) ||
                                            (_password != "" &&
                                                _userName != null))
                                        ? Color.fromRGBO(44, 167, 176, 1)
                                        : Color.fromRGBO(
                                            44, 167, 176, 0.6), //判断
                                    textColor: WMSColors.textWhite,
                                    fontSize: 14,
                                    onPress: loginIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Padding(padding: new EdgeInsets.all(5.0)),
                          Container(
                            width: 400,
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //忘记密码
                                new Container(
                                  height: 56,
                                  child: new Column(
                                    children: [
                                      new TextButton(
                                        onPressed: () {
                                          context.go('/loginForgetPwd');
                                        },
                                        child: new Text(
                                          WMSLocalizations.i18n(context)!
                                              .login_forget_pdw_text,
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                44, 167, 176, 0.6),
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // 续费 - 赵士淞 - 始
                                Container(
                                  height: 56,
                                  child: new Column(
                                    children: [
                                      new TextButton(
                                        onPressed: () {
                                          context.go('/loginRenewal/once');
                                        },
                                        child: new Text(
                                          WMSLocalizations.i18n(context)!
                                              .login_renewal_title,
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                44, 167, 176, 0.6),
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // 续费 - 赵士淞 - 终
                              ],
                            ),
                          ),
                          //没有账户文言
                          new Container(
                            width: 400,
                            height: 92,
                            child: new Column(
                              children: [
                                new Text(
                                  WMSLocalizations.i18n(context)!
                                      .login_register_content_text,
                                  style: TextStyle(
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                    fontSize: 14,
                                  ),
                                ),
                                //注册按钮
                                Container(
                                  width: 400,
                                  height: 56,
                                  child: Row(
                                    children: <Widget>[
                                      new Expanded(
                                        child: new OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor:
                                                WMSColors.textWhite,
                                            side: BorderSide(
                                                width: 1,
                                                color: Color.fromRGBO(
                                                    44, 167, 176, 1)),
                                          ),
                                          onPressed: () {
                                            context
                                                .go('/loginApplication/0/once');
                                          },
                                          child: new Text(
                                            WMSLocalizations.i18n(context)!
                                                .login_register_text,
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
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
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      )
      // 赵士淞 - 始
      ,
    );
    // 赵士淞 - 终
  }
}

mixin LoginBLoC on State<LoginPage> {
  final TextEditingController userController = new TextEditingController();

  final TextEditingController pwController = new TextEditingController();

  String? _userName = "";

  String? _password = "";

  bool _remember = false;

  //控制密码图标切换
  bool _eyeHidden = true;

  //控制提示信息显示和隐藏
  bool _visible = false;
  //控制提示信息显示哪个
  String _showFlag = "";

  // 点击登录按钮判断
  bool _loginFlag = false;
  void handleResult(bool value) {
    setState(() {
      _loginFlag = value;
    });
  }

  @override
  void initState() {
    super.initState();
    initParams();
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

  initParams() async {
    _userName = await LocalStorage.get(Config.USER_NAME_KEY);
    _password = await LocalStorage.get(Config.PW_KEY);
    _remember =
        await LocalStorage.get(Config.REMEMBER_ME) == 'true' ? true : false;
    userController.value = new TextEditingValue(text: _userName ?? "");
    pwController.value = new TextEditingValue(text: _password ?? "");
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
      });
    }
    if (!_visible && !_loginFlag) {
      setState(() {
        _loginFlag = true;
      });

      ///通过 redux 去执行登陆流程
      StoreProvider.of<WMSState>(context).dispatch(LoginAction(context,
          _userName, _password, _remember, Config.LOGIN_ROLE_2, handleResult));
    }
  }
}
