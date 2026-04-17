import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/utils/check_utils.dart';
import '../../../widget/wms_dialog_widget.dart';
import '../../home/bloc/home_menu_bloc.dart';
import '../../home/bloc/home_menu_model.dart';
import '/common/localization/default_localizations.dart';
import '/common/style/wms_style.dart';
import '/widget/wms_flex_button.dart';
import '/widget/wms_input_widget.dart';
import 'login_language.dart';
import 'login_page.dart';

/**
 * 内容：修改密码页面
 * 作者：xiongcy
 * 时间：2023/10/12
 */
class LoginModifyPwdPage extends StatefulWidget {
  static const String sName = "LoginModifyPwd";

  @override
  State createState() {
    return new _LoginModifyPwdPageState();
  }
}

class _LoginModifyPwdPageState extends State<LoginModifyPwdPage>
    with LoginBLoC {
  @override
  Widget build(BuildContext context) {
    /// 触摸收起键盘
    return BlocProvider<HomeMenuBloc>(
      create: (context) =>
          HomeMenuBloc(HomeMenuModel(context, menuInfoList: [])),
      child: new GestureDetector(
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
                  child: Stack(
                    children: [
                      new Container(
                        height: MediaQuery.of(context).size.height, //宽度自适应
                        width: MediaQuery.of(context).size.width, //高度自适应
                        color: WMSColors.cardWhite,
                        child: SingleChildScrollView(
                          child: new Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // 顶部内容
                              Container(
                                height: 100,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: LoginLanguage(),
                                ), // false
                              ),
                              new Padding(padding: new EdgeInsets.all(15.0)),
                              //图片图标
                              new Image(
                                image:
                                    new AssetImage(WMSICons.DEFAULT_USER_ICON),
                                width: 90.0,
                                height: 90.0,
                              ),
                              //英文图标
                              new Image(
                                image: new AssetImage(
                                    WMSICons.DEFAULT_LOFIN_LETTER),
                                width: 90.0,
                                height: 30.0,
                              ),
                              new Padding(padding: new EdgeInsets.all(20.0)),
                              //密码框
                              new Container(
                                margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                width: 400,
                                height: 56,
                                child: new WMSInputWidget(
                                  hintText: WMSLocalizations.i18n(context)!
                                      .login_password_new_hint_text,
                                  onChanged: (String value) {
                                    _password = value;
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
                              new Padding(padding: new EdgeInsets.all(5.0)),
                              //再次输入密码框
                              new Container(
                                margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                width: 400,
                                height: 56,
                                child: new WMSInputWidget(
                                  hintText: WMSLocalizations.i18n(context)!
                                      .login_again_pwd_hint_text,
                                  onChanged: (String value) {
                                    _againPwd = value;
                                  },
                                  controller: againPwController,
                                  obscureText: _eyeagainHidden, //是否隐藏信息
                                  filled: true, //是否填充背景色
                                  //设置背景色，filled 为 true 时生效
                                  fillColor: Color.fromRGBO(245, 245, 245, 1),
                                  border: InputBorder.none, //去除下划线
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() {
                                      _eyeagainHidden = !_eyeagainHidden;
                                    }),
                                    icon: new Image(
                                      image: new AssetImage(_eyeagainHidden
                                          ? WMSICons.DEFAULT_EYE_CLOSE_ICON
                                          : WMSICons.DEFAULT_EYE_OPEN_ICON),
                                      width: 24.0,
                                      height: 24.0,
                                    ),
                                  ),
                                ),
                              ),
                              //提示框
                              new Visibility(
                                visible: _visible,
                                child: new Text(
                                  _showFlag == "_password"
                                      ? WMSLocalizations.i18n(context)!
                                          .login_password_new_hint_text
                                      : (_showFlag == "_password_error")
                                          ? (WMSLocalizations.i18n(context)!
                                                  .login_password_new_hint_text +
                                              WMSLocalizations.i18n(context)!
                                                  .check_password)
                                          : (_showFlag == "_againPwd")
                                              ? WMSLocalizations.i18n(context)!
                                                  .login_again_pwd_hint_text
                                              : WMSLocalizations.i18n(context)!
                                                  .login_pwd_not_again_pwd_hint_text,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              //重设按钮
                              Container(
                                margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                width: 400,
                                height: 56,
                                child: Row(
                                  children: <Widget>[
                                    new Expanded(
                                      child: new WMSFlexButton(
                                        text: _loginFlag
                                            ? 'Loading...'
                                            : WMSLocalizations.i18n(context)!
                                                .login_pwd_reset_hint_text,
                                        color: Color.fromRGBO(
                                            44, 167, 176, 1), //判断
                                        textColor: WMSColors.textWhite,
                                        fontSize: 14,
                                        onPress: () {
                                          confirm(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              new Padding(padding: new EdgeInsets.all(15.0)),
                            ],
                          ),
                        ),
                      ), // 返回
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () {
                            GoRouter.of(context).go("/login");
                          },
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

mixin LoginBLoC on State<LoginModifyPwdPage> {
  final TextEditingController pwController = new TextEditingController();
  final TextEditingController againPwController = new TextEditingController();

  String? _password = "";
  String? _againPwd = "";

  bool _eyeHidden = true;
  bool _eyeagainHidden = true;

  //控制提示信息显示和隐藏
  bool _visible = false;
  //控制提示信息显示哪个
  String _showFlag = "";

  bool _loginFlag = false;

  @override
  void initState() {
    super.initState();
    initParams();
  }

  @override
  void dispose() {
    super.dispose();
    pwController.removeListener(_passwordChange);
    againPwController.removeListener(_againPwdChange);
  }

  _passwordChange() {
    _password = pwController.text;
  }

  _againPwdChange() {
    _againPwd = againPwController.text;
  }

  initParams() async {
    pwController.value = new TextEditingValue(text: _password ?? "");
    againPwController.value = new TextEditingValue(text: _againPwd ?? "");
  }

  confirm(BuildContext context) async {
    if (_password == null || _password == "") {
      setState(() {
        _visible = true;
        _showFlag = "_password";
      });
      return;
    } else if (CheckUtils.check_Password(_password)) {
      setState(() {
        _visible = true;
        _showFlag = "_password_error";
      });
      return;
    } else {
      setState(() {
        _visible = false;
        _loginFlag = true;
      });
    }
    if (_againPwd == null || _againPwd == "") {
      setState(() {
        _visible = true;
        _showFlag = "_againPwd";
      });
      return;
    } else {
      setState(() {
        _visible = false;
      });
    }
    if (_password != _againPwd) {
      setState(() {
        _visible = true;
        _showFlag = "_againAndPwd";
      });
      return;
    } else {
      setState(() {
        _visible = false;
      });
    }
    if (!_visible) {
      // 弹出对话框
      return showDialog<bool>(
        context: context,
        builder: (context) {
          return WMSDiaLogWidget(
            titleText:
                WMSLocalizations.i18n(context)!.login_tip_title_modify_pwd_text,
            contentText:
                WMSLocalizations.i18n(context)!.login_reset_tip_modify_pwd_text,
            buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
            buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
            onPressedLeft: () {
              //关闭对话框并返回true
              Navigator.of(context).pop(true);
            },
            onPressedRight: () {
              //关闭对话框并返回false
              Navigator.of(context).pop(false);
              _confirmButton();
            },
          );
        },
      );
    }
  }

  void _confirmButton() async {
    final supabase = Supabase.instance.client;
    UserAttributes attributes = new UserAttributes();
    attributes.password = _againPwd;
    await supabase.auth
        .updateUser(attributes)
        .then((response) => {
              // ignore: unnecessary_null_comparison
              if (response != null)
                {
                  //accessToken清空
                  new Session(
                      accessToken: '',
                      tokenType: '',
                      user: response.user as User),
                  context.pushReplacementNamed(LoginPage.sName),
                }
              else
                {
                  showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return WMSDiaLogWidget(
                        titleText: WMSLocalizations.i18n(context)!
                            .login_tip_title_modify_pwd_text,
                        contentText: WMSLocalizations.i18n(context)!
                            .login_email_by_forget_pwd_text,
                        buttonLeftFlag: false,
                        buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                        onPressedRight: () {
                          //关闭对话框并返回true
                          Navigator.of(context).pop(true);
                        },
                      );
                    },
                  ),
                }
            })
        .catchError(
          (error) => {
            if (error.toString() ==
                'AuthException(message: Not logged in., statusCode: null)')
              {
                showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return WMSDiaLogWidget(
                      titleText: WMSLocalizations.i18n(context)!
                          .login_tip_title_modify_pwd_text,
                      contentText: WMSLocalizations.i18n(context)!
                          .login_url_failure_modify_pwd_text,
                      buttonLeftFlag: false,
                      buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                      onPressedRight: () {
                        //关闭对话框并返回true
                        Navigator.of(context).pop(true);
                      },
                    );
                  },
                ),
              }
            else if (error.toString() ==
                'AuthException(message: New password should be different from the old password., statusCode: 422)')
              {
                showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return WMSDiaLogWidget(
                      titleText: WMSLocalizations.i18n(context)!
                          .login_tip_title_modify_pwd_text,
                      contentText: WMSLocalizations.i18n(context)!
                          .login_new_pwd_not_old_pwd_text,
                      buttonLeftFlag: false,
                      buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                      onPressedRight: () {
                        //关闭对话框并返回true
                        Navigator.of(context).pop(true);
                      },
                    );
                  },
                ),
              }
            else
              {
                showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return WMSDiaLogWidget(
                      titleText: WMSLocalizations.i18n(context)!
                          .login_tip_title_modify_pwd_text,
                      contentText: WMSLocalizations.i18n(context)!
                          .login_reset_error_modify_pwd_text,
                      buttonLeftFlag: false,
                      buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                      onPressedRight: () {
                        //关闭对话框并返回true
                        Navigator.of(context).pop(true);
                      },
                    );
                  },
                ),
              }
          },
        );
  }
}
