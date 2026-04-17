import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/page/home/bloc/home_menu_model.dart';
import 'package:wms/widget/wms_dialog_widget.dart';
import '../../../bloc/wms_common_bloc_utils.dart';
import '../../home/bloc/home_menu_bloc.dart';
import '../../home/pc/home_head_page.dart';
import '/common/localization/default_localizations.dart';
import '/common/style/wms_style.dart';
import '/widget/wms_flex_button.dart';
import '/widget/wms_input_widget.dart';

/**
 * 内容：忘记密码页面
 * 作者：luxy
 * 时间：2023/07/27
 */
class LoginForgetPwdPage extends StatefulWidget {
  static const String sName = "LoginForgetPwd";
  @override
  State createState() {
    return new _LoginForgetPwdPageState();
  }
}

class _LoginForgetPwdPageState extends State<LoginForgetPwdPage>
    with LoginBLoC {
  late bool focusNode1;

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
                  child: SingleChildScrollView(
                    child: new Container(
                      height: MediaQuery.of(context).size.height, //宽度自适应
                      width: MediaQuery.of(context).size.width, //高度自适应
                      color: WMSColors.cardWhite,
                      child: new Column(
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
                          new Padding(padding: new EdgeInsets.all(20.0)),
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
                          //提示框
                          new Visibility(
                            visible: _visible,
                            child: new Text(
                              WMSLocalizations.i18n(context)!
                                  .login_username_hint_text,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //发送按钮
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
                                            .login_confirm_text,
                                    color: Color.fromRGBO(44, 167, 176, 1), //判断
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

mixin LoginBLoC on State<LoginForgetPwdPage> {
  final TextEditingController userController = new TextEditingController();

  String? _userName = "";
  //控制提示信息显示和隐藏
  bool _visible = false;
  bool _loginFlag = false;
  @override
  void initState() {
    super.initState();
    initParams();
  }

  @override
  void dispose() {
    super.dispose();
    userController.removeListener(_usernameChange);
  }

  _usernameChange() {
    _userName = userController.text;
  }

  initParams() async {
    userController.value = new TextEditingValue(text: _userName ?? "");
  }

  confirm(BuildContext context) async {
    if (_userName == null || _userName == "") {
      setState(() {
        _visible = true;
      });
      return;
    } else {
      //判断邮箱是否存在
      List<dynamic> data = await SupabaseUtils.getClient()
          .from('mtb_user')
          .select('*')
          .eq('email', _userName);
      if (data.length == 0) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(WMSLocalizations.i18n(context)!
            .login_email_by_forget_error_pwd_text);
        setState(() {
          _visible = false;
        });
        return;
      }
      setState(() {
        _visible = false;
        _loginFlag = true;
      });
    }
    final supabase = Supabase.instance.client;
    //线上打包发布需要更改此路径
    var url = Config.BASE_URL + '/loginModifyPwd';
    await supabase.auth
        .resetPasswordForEmail(
      _userName!,
      redirectTo: url,
    )
        .then((value) {
      showDialog<bool>(
        context: context,
        builder: (context) {
          return WMSDiaLogWidget(
            titleText:
                WMSLocalizations.i18n(context)!.login_tip_title_modify_pwd_text,
            contentText:
                WMSLocalizations.i18n(context)!.login_email_by_forget_pwd_text,
            buttonLeftFlag: false,
            buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
            onPressedRight: () {
              setState(() {
                _loginFlag = false;
              });
              //关闭对话框并返回true
              Navigator.of(context).pop(true);
            },
          );
        },
      );
    }).onError((error, stackTrace) {
      setState(() {
        _loginFlag = false;
      });
      // 失败提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(context)!.login_email_by_forget_fail_pwd_text);
    });
    setState(() {
      _loginFlag = false;
    });
  }
}
