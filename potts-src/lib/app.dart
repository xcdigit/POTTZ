import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '/common/localization/wms_localizations_delegate.dart';
import '/common/style/wms_style.dart';
import '/common/utils/common_utils.dart';
import '/common/utils/supabase_untils.dart';
import '/model/login.dart';
import '/env/env_config.dart';
import '/env/dev.dart';
import '/routes/route.dart';
import '/redux/wms_state.dart';

class FlutterReduxApp extends StatefulWidget {
  @override
  _FlutterReduxAppState createState() => _FlutterReduxAppState();
}

class _FlutterReduxAppState extends State<FlutterReduxApp>
    with HttpErrorListener {
  /// 创建Store，引用 GSYState 中的 appReducer 实现 Reducer 方法
  /// initialState 初始化 State
  final store = new Store<WMSState>(
    appReducer,

    ///拦截器
    middleware: middleware,

    ///初始化数据
    initialState: new WMSState(
      userInfo: Login.empty(),
      login: false,
      themeData: CommonUtils.getThemeData(WMSColors.primarySwatch),
      // 赵士淞 - 始
      locale: Locale('ja', 'JA'),
      // 赵士淞 - 终
    ),
  );

  // 赵士淞 - 始
  Set<PointerDeviceKind> _kTouchLikeDeviceTypes = <PointerDeviceKind>{
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.unknown
  };
  // 赵士淞 - 终

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// 通过 StoreProvider 应用 store
    return new StoreProvider(
      store: store,
      child: new StoreBuilder<WMSState>(builder: (context, store) {
        ///使用 StoreBuilder 获取 store 中的 theme 、locale
        store.state.platformLocale =
            WidgetsBinding.instance.platformDispatcher.locale;
        Widget app = new MaterialApp.router(
          // 赵士淞 - 始
          scrollBehavior: const MaterialScrollBehavior()
              .copyWith(scrollbars: true, dragDevices: _kTouchLikeDeviceTypes),
          // 赵士淞 - 终
          ///多语言实现代理
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            WMSLocalizationsDelegate.delegate,
          ],
          supportedLocales: [store.state.locale ?? store.state.platformLocale!],
          // 语言
          locale: store.state.locale,
          // 主题
          theme: store.state.themeData,
          // 路由
          routerConfig: wmsRouter,
          // 去除Debug标签
          debugShowCheckedModeBanner: false,
          // 初始化BotToast
          builder: BotToastInit(),
        );
        return app;
      }),
    );
  }
}

mixin HttpErrorListener on State<FlutterReduxApp> {
  @override
  void initState() {
    super.initState();
    // SUPABASE初始化
    EnvConfig? envConfig = EnvConfig.fromJson(config);
    SupabaseUtils.initialize(
        envConfig.supabase_url, envConfig.supabase_anon_key);
  }

  @override
  void dispose() {
    super.dispose();
    // SUPABASE释放
    SupabaseUtils.dispose();
  }
}
