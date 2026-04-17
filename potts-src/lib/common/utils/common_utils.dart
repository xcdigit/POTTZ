import 'dart:async';
import 'dart:io';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import '../../bloc/wms_common_bloc_utils.dart';
import '../../model/log.dart';
import '/common/config/config.dart';
import '/common/storage/local_storage.dart';
import '/common/localization/default_localizations.dart';
import '/redux/wms_state.dart';
import '/redux/locale_redux.dart';
import '/redux/theme_redux.dart';
import '/common/style/wms_style.dart';
import '/widget/wms_flex_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';

import 'page_utils.dart';

typedef StringList = List<String>;

class CommonUtils {
  static const double MILLIS_LIMIT = 1000.0;

  static const double SECONDS_LIMIT = 60 * MILLIS_LIMIT;

  static const double MINUTES_LIMIT = 60 * SECONDS_LIMIT;

  static const double HOURS_LIMIT = 24 * MINUTES_LIMIT;

  static const double DAYS_LIMIT = 30 * HOURS_LIMIT;

  static Locale? curLocale;

  static getLocalPath() async {
    Directory? appDir;
    if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getExternalStorageDirectory();
    }

    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      if (statuses[Permission.storage] != PermissionStatus.granted) {
        return null;
      }
    }
    String appDocPath = appDir!.path + "/pottz_wms"; // TODO
    Directory appPath = Directory(appDocPath);
    await appPath.create(recursive: true);
    return appPath;
  }

  static getApplicationDocumentsPath() async {
    Directory appDir;
    if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getApplicationSupportDirectory();
    }
    String appDocPath = appDir.path + "/pottz_wms";
    Directory appPath = Directory(appDocPath);
    await appPath.create(recursive: true);
    return appPath.path;
  }

  static splitFileNameByPath(String path) {
    return path.substring(path.lastIndexOf("/"));
  }

  static getFullName(String? repository_url) {
    if (repository_url != null &&
        repository_url.substring(repository_url.length - 1) == "/") {
      repository_url = repository_url.substring(0, repository_url.length - 1);
    }
    String fullName = '';
    if (repository_url != null) {
      StringList splicurl = repository_url.split("/");
      if (splicurl.length > 2) {
        fullName =
            splicurl[splicurl.length - 2] + "/" + splicurl[splicurl.length - 1];
      }
    }
    return fullName;
  }

  static pushTheme(Store store, int index) {
    ThemeData themeData;
    List<Color> colors = getThemeListColor();
    themeData = getThemeData(colors[index]);
    store.dispatch(new RefreshThemeDataAction(themeData));
  }

  static getThemeData(Color color) {
    return ThemeData(
      primarySwatch: color as MaterialColor?,
      platform: TargetPlatform.android,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarContrastEnforced: true,
          systemStatusBarContrastEnforced: true,
          systemNavigationBarColor: color,
          statusBarColor: color,
          systemNavigationBarDividerColor: color.withAlpha(199),
        ),
      ),
    );
  }

  static showLanguageDialog(BuildContext context) {
    StringList list = [
      WMSLocalizations.i18n(context)!.home_language_default,
      WMSLocalizations.i18n(context)!.home_language_zh,
      WMSLocalizations.i18n(context)!.home_language_en,
      // WMSLocalizations.i18n(context)!.home_language_jp,
    ];
    CommonUtils.showCommitOptionDialog(context, list, (index) {
      CommonUtils.changeLocale(StoreProvider.of<WMSState>(context), index);
      LocalStorage.save(Config.LOCALE, index.toString());
    }, height: 150.0);
  }

  /**
   * 切换语言
   */
  static changeLocale(Store<WMSState> store, int index) {
    Locale? locale = store.state.platformLocale;
    switch (index) {
      // 赵士淞 - 始
      case 2:
        locale = Locale('ja', 'JA');
        break;
      case 3:
        locale = Locale('en', 'US');
        break;
      case 4:
        locale = Locale('zh', 'CH');
        break;
      case 5:
        locale = Locale('zh', 'TW');
        break;
      // 赵士淞 - 终
    }
    curLocale = locale;
    store.dispatch(RefreshLocaleAction(locale));
  }

  static List<Color> getThemeListColor() {
    return [
      WMSColors.primarySwatch,
      Colors.brown,
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.blueGrey,
      Colors.deepOrange,
    ];
  }

  static const IMAGE_END = [".png", ".jpg", ".jpeg", ".gif", ".svg"];

  static isImageEnd(path) {
    bool image = false;
    for (String item in IMAGE_END) {
      if (path.indexOf(item) + item.length == path.length) {
        image = true;
      }
    }
    return image;
  }

  ///列表item dialog
  static Future<Null> showCommitOptionDialog(
    BuildContext context,
    List<String?>? commitMaps,
    ValueChanged<int> onTap, {
    width = 250.0,
    height = 400.0,
    List<Color>? colorList,
  }) {
    return PageUtils.showWMSDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: new Container(
              width: width,
              height: height,
              padding: new EdgeInsets.all(4.0),
              margin: new EdgeInsets.all(20.0),
              decoration: new BoxDecoration(
                color: WMSColors.white,
                //用一个BoxDecoration装饰器提供背景图片
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: new ListView.builder(
                  itemCount: commitMaps?.length ?? 0,
                  itemBuilder: (context, index) {
                    return WMSFlexButton(
                      maxLines: 1,
                      mainAxisAlignment: MainAxisAlignment.start,
                      fontSize: 14.0,
                      color: colorList != null
                          ? colorList[index]
                          : Theme.of(context).primaryColor,
                      text: commitMaps![index],
                      textColor: WMSColors.white,
                      onPress: () {
                        context.pop();
                        onTap(index);
                      },
                    );
                  }),
            ),
          );
        });
  }

  //插入操作履历 sys_log表
  createLogData(
      BuildContext context, String receiveOrShipNo, String flag) async {
    // 操作log
    Map<String, dynamic> data = {};
    switch (flag) {
      case '1':
        //入荷予定入力：登録
        // 操作内容
        data['content'] = '入荷予定入力（NO：' +
            receiveOrShipNo +
            '）' +
            Config.OPERATION_TEXT1 +
            Config.OPERATION_BUTTON_TEXT1 +
            Config.OPERATION_TEXT2;
        // 方法
        data['method'] = 'SaveReceiveFormEvent()';
        break;
      case '2':
        //入荷予定入力：CSV
        // 操作内容
        data['content'] = '入荷予定入力' +
            Config.OPERATION_TEXT1 +
            Config.OPERATION_BUTTON_TEXT2 +
            Config.OPERATION_TEXT2;

        // 方法
        data['method'] = 'ImportCSVFileEvent()';
        break;
      case '3':
        //入荷検品：検品
        // 操作内容
        data['content'] = '入荷検品（NO：' +
            receiveOrShipNo +
            '）' +
            Config.OPERATION_TEXT1 +
            Config.OPERATION_BUTTON_TEXT3 +
            Config.OPERATION_TEXT2;
        // 方法
        data['method'] = 'UpdataGoodsEvent()';
        break;
      case '4':
        //入庫入力：実行
        //因实现方法不同，放在外部会报错，放在ConfirmButtonEvent方法里面
        break;
      case '5':
        //入荷確定：確認
        // 操作内容
        data['content'] = '入荷確定' +
            Config.OPERATION_TEXT1 +
            Config.OPERATION_BUTTON_TEXT5 +
            Config.OPERATION_TEXT2;
        // 方法
        data['method'] = 'foreachUpdateReceiveEvent()';
        break;
      case '6':
        //入荷確定：キャンセル
        // 操作内容
        data['content'] = '入荷確定' +
            Config.OPERATION_TEXT1 +
            Config.OPERATION_BUTTON_TEXT6 +
            Config.OPERATION_TEXT2;
        // 方法
        data['method'] = 'foreachUpdateReceiveEvent()';
        break;
      case '7':
        //入荷確定データ出力：CSV
        // 操作内容
        data['content'] = '入荷確定データ出力' +
            Config.OPERATION_TEXT1 +
            Config.OPERATION_BUTTON_TEXT2 +
            Config.OPERATION_TEXT2;
        // 方法
        data['method'] = 'exportCSVFile()';
        break;
      case '8':
        // 出荷指示入力：登録
        // 操作内容
        data['content'] = '出荷指示入力（NO：' +
            receiveOrShipNo +
            '）' +
            Config.OPERATION_TEXT1 +
            Config.OPERATION_BUTTON_TEXT1 +
            Config.OPERATION_TEXT2;
        // 方法
        data['method'] = 'SaveShipFormEvent()';
        break;
      case '9':
        // 出荷指示入力：CSV
        // 操作内容
        data['content'] = '出荷指示入力' +
            Config.OPERATION_TEXT1 +
            Config.OPERATION_BUTTON_TEXT2 +
            Config.OPERATION_TEXT2;
        // 方法
        data['method'] = 'ImportCSVFileEvent()';
        break;
      case '10':
        // 出荷指示照会：引当
        // 操作内容
        data['content'] = '出荷指示照会（NO：' +
            receiveOrShipNo +
            '）' +
            Config.OPERATION_TEXT1 +
            Config.OPERATION_BUTTON_TEXT7 +
            Config.OPERATION_TEXT2;
        // 方法
        data['method'] = 'ReservationShipLineEvent()';
        break;
      case '11':
        // 欠品伝票照会：引当
        // 操作内容
        data['content'] = '欠品伝票照会（NO：' +
            receiveOrShipNo +
            '）' +
            Config.OPERATION_TEXT1 +
            Config.OPERATION_BUTTON_TEXT7 +
            Config.OPERATION_TEXT2;
        // 方法
        data['method'] = 'ReservationShipLineEvent()';
        break;
      case '12':
        // 出庫入力：実行
        // 操作内容
        data['content'] = '出庫入力（NO：' +
            receiveOrShipNo +
            '）' +
            Config.OPERATION_TEXT1 +
            Config.OPERATION_BUTTON_TEXT4 +
            Config.OPERATION_TEXT2;
        // 方法
        data['method'] = 'updateTableDetails()';
        break;
      case '13':
        // 出荷検品：実行
        //因实现方法不同，放在外部会报错，放在executeEndEvent方法里面
        break;
      case '14':
        // 出荷確定：確認
        // 操作内容
        data['content'] = '出荷確定'
                '）' +
            Config.OPERATION_TEXT1 +
            Config.OPERATION_BUTTON_TEXT5 +
            Config.OPERATION_TEXT2;
        // 方法
        data['method'] = 'foreachUpdateShipEvent()';
        break;
      case '15':
        // 出荷確定：キャンセル
        // 操作内容
        data['content'] = '出荷確定' +
            Config.OPERATION_TEXT1 +
            Config.OPERATION_BUTTON_TEXT6 +
            Config.OPERATION_TEXT2;
        // 方法
        data['method'] = 'foreachUpdateShipEvent()';
        break;
      case '16':
        //出荷確定データ出力：CSV
        // 操作内容
        data['content'] = '出荷確定データ出力' +
            Config.OPERATION_TEXT1 +
            Config.OPERATION_BUTTON_TEXT2 +
            Config.OPERATION_TEXT2;
        // 方法
        data['method'] = 'OutputCSVFileEvent()';
        break;
      case '17':
        // 在庫照会：CSV
        break;
      case '18':
        // 返品入力：実行
        break;
      case '19':
        // 在庫移動入力：実行
        break;
      case '20':
        // 在庫調整入力：実行
        break;
      case '21':
        // 棚卸開始：登録
        break;
      case '22':
        // 実棚明細入力：登録/修正
        break;
      case '23':
        // 棚卸確定：確定
        break;
      case '24':
        // 棚卸確定：キャンセル
        break;
      case '25':
        // 棚卸データ出力：CSV
        break;
      default:
    }

    // ログレベル
    data['log_type'] = 'INFO';

    // 異常詳細
    data['exception_detail'] = '';
    // リクエスト
    final ipv4 = await Ipify.ipv4();
    data['request_ip'] = ipv4.toString();
    // 会社_ID
    data['company_id'] =
        StoreProvider.of<WMSState>(context).state.loginUser?.company_id;
    // 登録日時
    data['create_time'] = DateTime.now().toString();
    // 登録者
    data['create_id'] = StoreProvider.of<WMSState>(context).state.loginUser?.id;

    Log log = Log.fromJson(data);
    //插入操作log数据
    List<Map<String, dynamic>> logData = await SupabaseUtils.getClient()
        .from('sys_log')
        .insert([log.toJson()]).select('*');
    if (logData.length == 0) {
      // 失败提示
      WMSCommonBlocUtils.successTextToast(
          WMSLocalizations.i18n(context)!.home_main_page_text9 +
              WMSLocalizations.i18n(context)!.create_error);
    }
  }

  /**
   * 插入操作履历 sys_log表
   * 
   * context 操作内容
   * method 方法
   * companyId 会社ID
   * userId 用户ID
   * 
   */
  createLogInfo(
      String context, String method, int? companyId, int? userId) async {
    // 操作log
    Map<String, dynamic> data = {};
    try {
      // 操作内容
      data['content'] = context;
      // 方法
      data['method'] = method;

      // ログレベル
      data['log_type'] = 'INFO';

      // 異常詳細
      data['exception_detail'] = '';
      // リクエスト
      final ipv4 = await Ipify.ipv4();
      data['request_ip'] = ipv4.toString();
      // 会社_ID
      data['company_id'] = companyId;
      // 登録日時
      data['create_time'] = DateTime.now().toString();
      // 登録者
      data['create_id'] = userId;

      Log log = Log.fromJson(data);

      //插入操作log数据
      await SupabaseUtils.getClient()
          .from('sys_log')
          .insert([log.toJson()]).select('*');
    } catch (e) {
      print(e);
    }
  }
}
