class Config {
  static const BASE_URL = "http://localhost:8080"; //本地开发用
  // static const BASE_URL = "https://pottz.biz-x.app"; //线上路径
  static const ADMIN_EMAIL = "pottsnoreply@gmail.com"; //todo 超级管理员默认邮箱
  static const PAGE_SIZE = 20;

  /// //////////////////////////////////////常量////////////////////////////////////// ///
  static const USER_NAME_KEY = "user-name";
  static const PW_KEY = "password";
  static const REMEMBER_ME = "remember-me";
  static const AGAIN_PW_KEY = "again-password";
  static const LANGUAGE_SELECT = "language-select";
  static const LANGUAGE_SELECT_NAME = "language-select-name";
  static const REFRESH_LANGUAGE = "refreshLanguageApp";
  static const THEME_COLOR = "theme-color";
  static const LOCALE = "locale";
  //操作log：操作内容拼接常量
  static const OPERATION_TEXT1 = "を";
  static const OPERATION_TEXT2 = "しました";
  static const OPERATION_BUTTON_TEXT1 = "登録";
  static const OPERATION_BUTTON_TEXT2 = "CSV";
  static const OPERATION_BUTTON_TEXT3 = "検品";
  static const OPERATION_BUTTON_TEXT4 = "実行";
  static const OPERATION_BUTTON_TEXT5 = "確認";
  static const OPERATION_BUTTON_TEXT6 = "キャンセル";
  static const OPERATION_BUTTON_TEXT7 = "引当";
  static const OPERATION_BUTTON_TEXT7_1 = "引当解除";
  static const OPERATION_BUTTON_TEXT8 = "確定";
  static const OPERATION_BUTTON_TEXT9 = "取込";
  static const OPERATION_BUTTON_TEXT10 = "出力";
  static const OPERATION_LOGIN = "アカウントログイン";

  //ロール
  // 超级管理员
  static const ROLE_ID_1 = 1;
  // 系统管理员
  static const ROLE_ID_2 = 2;
  // 普通员工
  static const ROLE_ID_3 = 3;

  // 超级管理员
  static const LOGIN_ROLE_1 = "admin";
  // 非超级管理员
  static const LOGIN_ROLE_2 = "user";

  // 赵士淞 - 始
  // 入荷状態
  // 检品待ち
  static const RECEIVE_KBN_WAIT_INSPECT = '1';
  // 入庫待ち
  static const RECEIVE_KBN_WAIT_INBOUND = '2';
  // 入庫中
  static const RECEIVE_KBN_IS_BEING_INBOUND = '3';
  // 入荷確定待ち
  static const RECEIVE_KBN_WAIT_RECEIVE_CONFIRM = '4';
  // 入荷済み
  static const RECEIVE_KBN_RECEIVED = '5';

  // 出荷状態
  // 引当失敗
  static const SHIP_KBN_ASSIGN_FAIL = '0';
  // 引当待ち
  static const SHIP_KBN_WAIT_ASSIGN = '1';
  // 出庫待ち
  static const SHIP_KBN_WAIT_OUTBOUND = '2';
  // 出庫中
  static const SHIP_KBN_IS_BEING_OUTBOUND = '3';
  // 検品待ち
  static const SHIP_KBN_WAIT_INSPECT = '4';
  // 梱包待ち
  static const SHIP_KBN_WAIT_PACKAGING = '5';
  // 出荷確定待ち
  static const SHIP_KBN_WAIT_SHIPMENT_CONFIRM = '6';
  // 出荷済み
  static const SHIP_KBN_SHIPPED = '7';

  // ピッキングリスト出力済
  // ON
  static const PICK_LIST_KBN_1 = '1';
  // OFF
  static const PICK_LIST_KBN_2 = '2';

  // 納品書出力
  // 未出力
  static const PDF_KBN_1 = '1';
  // 出力済
  static const PDF_KBN_2 = '2';
  // 再出力
  static const PDF_KBN_3 = '3';

  // 連携済
  // ON
  static const CSV_KBN_1 = '1';
  // OFF
  static const CSV_KBN_2 = '2';

  // 引当済
  // 引当待ち
  static const LOCK_KBN_0 = '0';
  // 引当済
  static const LOCK_KBN_1 = '1';
  // 引当不足
  static const LOCK_KBN_2 = '2';

  // 出庫済
  // ON
  static const STORE_KBN_1 = '1';
  // OFF
  static const STORE_KBN_2 = '2';

  // 検品済
  // ON
  static const CHECK_KBN_1 = '1';
  // OFF
  static const CHECK_KBN_2 = '2';

  // 梱包済
  // ON
  static const PACKING_KBN_1 = '1';
  // OFF
  static const PACKING_KBN_2 = '2';

  // 出荷確定
  // ON
  static const CONFIRM_KBN_1 = '1';
  // OFF
  static const CONFIRM_KBN_2 = '2';

  // 用户状態
  // 本会員
  static const USER_STATUS_1 = '1';
  // 仮会員
  static const USER_STATUS_2 = '2';
  // 退会
  static const USER_STATUS_3 = '3';
  // 削除
  static const USER_STATUS_4 = '4';

  // 完了状态
  // 未完了
  static const END_KBN_1 = '1';
  // 完了
  static const END_KBN_2 = '2';

  // 差異状态
  // 无差异
  static const DIFF_KBN_1 = '1';
  // 有差异
  static const DIFF_KBN_2 = '2';

  // アクション区分
  // 入庫入力
  static const ACTION_ID_1 = '1';
  // 入庫削除
  static const ACTION_ID_2 = '2';
  // 出庫入力
  static const ACTION_ID_3 = '3';
  // 出庫削除
  static const ACTION_ID_4 = '4';
  // 出荷検品
  static const ACTION_ID_5 = '5';
  // 梱包
  static const ACTION_ID_6 = '6';
  // 出荷確定
  static const ACTION_ID_7 = '7';
  // 出荷確定取消
  static const ACTION_ID_8 = '8';
  // 返品入力
  static const ACTION_ID_9 = '9';
  // 返品削除
  static const ACTION_ID_10 = '10';
  // 在庫移動
  static const ACTION_ID_11 = '11';
  // 在庫調整
  static const ACTION_ID_12 = '12';
  // 棚卸確定
  static const ACTION_ID_13 = '13';
  // 棚卸確定取消
  static const ACTION_ID_14 = '14';
  // 赵士淞 - 终

  //ロケーションマスタ
  //S
  static const LOCATION_KBN_S = 'S';
  //C
  static const LOCATION_KBN_C = 'C';
  //B
  static const LOCATION_KBN_B = 'B';

  // 网页最小宽度限定
  static const WEB_MINI_WIDTH_LIMIT = 1440;

  // 数字常量
  static const NUMBER_NEGATIVE = -1;
  static const NUMBER_ZERO = 0;
  static const NUMBER_ONE = 1;
  static const NUMBER_TWO = 2;
  static const NUMBER_THREE = 3;
  static const NUMBER_FOUR = 4;
  static const NUMBER_FIVE = 5;
  static const NUMBER_SIX = 6;
  static const NUMBER_SEVEN = 7;
  static const NUMBER_EIGHT = 8;
  static const NUMBER_NINE = 9;
  static const NUMBER_TEN = 10;

  // 削除区分
  // 削除済み
  static const DELETE_YES = '1';
  // 未削除
  static const DELETE_NO = '2';

  //採番区分
  //入荷予定番号
  static const WMS_CHANNEL_A = 'A';
  //出荷指示番号
  static const WMS_CHANNEL_B = 'B';

  //会社情報状態
  //1:存続
  static const WMS_COMPANY_STATUS_1 = '1';
  //2：申込
  static const WMS_COMPANY_STATUS_2 = '2';
  //3:退会
  static const WMS_COMPANY_STATUS_3 = '3';

  //会社強制出荷
  //0 : 通常出荷
  static const WMS_COMPANY_FORCED_0 = '0';
  //1 : 強制出荷
  static const WMS_COMPANY_FORCED_1 = '1';

  // 菜单标记 - 始
  static const MENU_FLAG_1 = 100;
  static const MENU_FLAG_2 = 200;
  static const MENU_FLAG_2_1 = 201;
  static const MENU_FLAG_2_2 = 202;
  static const MENU_FLAG_2_3 = 203;
  static const MENU_FLAG_2_4 = 204;
  static const MENU_FLAG_2_5 = 205;
  static const MENU_FLAG_2_6 = 206;
  static const MENU_FLAG_2_7 = 207;
  static const MENU_FLAG_2_8 = 208;
  static const MENU_FLAG_2_9 = 209;
  static const MENU_FLAG_2_10 = 210;
  static const MENU_FLAG_2_11 = 211;
  static const MENU_FLAG_2_12 = 212;
  static const MENU_FLAG_2_13 = 213;
  static const MENU_FLAG_2_14 = 214;
  static const MENU_FLAG_2_15 = 215;
  static const MENU_FLAG_2_16 = 216;
  static const MENU_FLAG_2_17 = 217;
  static const MENU_FLAG_3 = 300;
  static const MENU_FLAG_3_1 = 301;
  static const MENU_FLAG_3_2 = 302;
  static const MENU_FLAG_3_3 = 303;
  static const MENU_FLAG_3_4 = 304;
  static const MENU_FLAG_3_5 = 305;
  static const MENU_FLAG_3_6 = 306;
  static const MENU_FLAG_3_7 = 307;
  static const MENU_FLAG_3_8 = 308;
  static const MENU_FLAG_3_9 = 309;
  static const MENU_FLAG_3_10 = 310;
  static const MENU_FLAG_3_11 = 311;
  static const MENU_FLAG_3_12 = 312;
  static const MENU_FLAG_3_13 = 313;
  static const MENU_FLAG_3_14 = 314;
  static const MENU_FLAG_3_15 = 315;
  static const MENU_FLAG_3_16 = 316;
  static const MENU_FLAG_3_17 = 317;
  static const MENU_FLAG_3_18 = 318;
  static const MENU_FLAG_3_19 = 319;
  static const MENU_FLAG_3_20 = 320;
  static const MENU_FLAG_3_21 = 321;
  static const MENU_FLAG_3_22 = 322;
  static const MENU_FLAG_3_23 = 323;
  static const MENU_FLAG_3_24 = 324;
  static const MENU_FLAG_3_25 = 325;
  static const MENU_FLAG_3_26 = 326;
  static const MENU_FLAG_3_27 = 327;
  static const MENU_FLAG_3_28 = 328;
  static const MENU_FLAG_3_29 = 329;
  static const MENU_FLAG_4 = 400;
  static const MENU_FLAG_4_1 = 401;
  static const MENU_FLAG_4_2 = 402;
  static const MENU_FLAG_4_3 = 403;
  static const MENU_FLAG_4_4 = 404;
  static const MENU_FLAG_4_5 = 405;
  static const MENU_FLAG_4_6 = 406;
  static const MENU_FLAG_4_7 = 407;
  static const MENU_FLAG_4_8 = 408;
  static const MENU_FLAG_4_9 = 409;
  static const MENU_FLAG_4_10 = 410;
  static const MENU_FLAG_4_11 = 411;
  static const MENU_FLAG_4_12 = 412;
  static const MENU_FLAG_4_13 = 413;
  static const MENU_FLAG_4_14 = 414;
  static const MENU_FLAG_4_15 = 415;
  static const MENU_FLAG_4_16 = 416;
  static const MENU_FLAG_4_17 = 417;
  static const MENU_FLAG_4_18 = 418;
  static const MENU_FLAG_4_19 = 419;
  static const MENU_FLAG_4_20 = 420;
  static const MENU_FLAG_5 = 500;
  static const MENU_FLAG_5_1 = 501;
  static const MENU_FLAG_5_2 = 502;
  static const MENU_FLAG_5_3 = 503;
  static const MENU_FLAG_5_4 = 504;
  static const MENU_FLAG_5_5 = 505;
  static const MENU_FLAG_5_6 = 506;
  static const MENU_FLAG_5_7 = 507;
  static const MENU_FLAG_5_8 = 508;
  static const MENU_FLAG_5_9 = 509;
  static const MENU_FLAG_5_10 = 510;
  static const MENU_FLAG_5_11 = 511;
  static const MENU_FLAG_6 = 600;
  static const MENU_FLAG_6_1 = 601;
  static const MENU_FLAG_6_2 = 602;
  static const MENU_FLAG_6_3 = 603;
  static const MENU_FLAG_6_4 = 604;
  static const MENU_FLAG_6_5 = 605;
  static const MENU_FLAG_6_6 = 606;
  static const MENU_FLAG_6_7 = 607;
  static const MENU_FLAG_6_8 = 608;
  static const MENU_FLAG_6_9 = 609;
  static const MENU_FLAG_6_10 = 610;
  static const MENU_FLAG_6_11 = 611;
  static const MENU_FLAG_7 = 700;
  static const MENU_FLAG_7_1 = 701;
  static const MENU_FLAG_7_2 = 702;
  static const MENU_FLAG_7_3 = 703;
  static const MENU_FLAG_8 = 800;
  static const MENU_FLAG_8_1 = 801;
  static const MENU_FLAG_8_2 = 802;
  static const MENU_FLAG_8_3 = 803;
  static const MENU_FLAG_8_4 = 804;
  static const MENU_FLAG_8_5 = 805;
  static const MENU_FLAG_8_6 = 806;
  static const MENU_FLAG_8_7 = 807;
  static const MENU_FLAG_8_8 = 808;
  static const MENU_FLAG_8_9 = 809;
  static const MENU_FLAG_8_10 = 810;
  static const MENU_FLAG_8_11 = 811;
  static const MENU_FLAG_8_12 = 812;
  static const MENU_FLAG_8_13 = 813;
  static const MENU_FLAG_8_14 = 814;
  static const MENU_FLAG_8_15 = 815;
  static const MENU_FLAG_8_16 = 816;
  static const MENU_FLAG_8_17 = 817;
  static const MENU_FLAG_8_18 = 818;
  static const MENU_FLAG_8_19 = 819;
  static const MENU_FLAG_8_20 = 820;
  static const MENU_FLAG_8_21 = 821;
  static const MENU_FLAG_8_22 = 822;
  static const MENU_FLAG_8_23 = 823;
  static const MENU_FLAG_8_24 = 824;
  static const MENU_FLAG_9 = 900;
  static const MENU_FLAG_50 = 5000;
  static const MENU_FLAG_50_1 = 5001;
  static const MENU_FLAG_50_1_1 = 500101;
  static const MENU_FLAG_50_1_2 = 500102;
  static const MENU_FLAG_50_1_3 = 500103;
  static const MENU_FLAG_50_2 = 5002;
  static const MENU_FLAG_50_2_1 = 500201;
  static const MENU_FLAG_60 = 6000;
  static const MENU_FLAG_60_2_5 = 600205;
  static const MENU_FLAG_60_3_11 = 600311;
  static const MENU_FLAG_60_3_26 = 600326;
  static const MENU_FLAG_60_2_12_1 = 60021201;
  static const MENU_FLAG_60_2_12_2 = 60021202;
  static const MENU_FLAG_60_3_21 = 600321;
  static const MENU_FLAG_60_5_9 = 600509;
  static const MENU_FLAG_60_5_11 = 600511;
  static const MENU_FLAG_60_3_5 = 600305;
  static const MENU_FLAG_60_5_2 = 600502;
  static const MENU_FLAG_98 = 9800;
  static const MENU_FLAG_98_1 = 9801;
  static const MENU_FLAG_98_2 = 9802;
  static const MENU_FLAG_98_3 = 9803;
  static const MENU_FLAG_98_4 = 9804;
  static const MENU_FLAG_98_5 = 9805;
  static const MENU_FLAG_98_6 = 9806;
  static const MENU_FLAG_98_7 = 9807;
  static const MENU_FLAG_98_8 = 9808;
  static const MENU_FLAG_98_9 = 9809;
  static const MENU_FLAG_98_10 = 9810;
  static const MENU_FLAG_98_11 = 9811;
  static const MENU_FLAG_98_12 = 9812;
  static const MENU_FLAG_98_13 = 9813;
  static const MENU_FLAG_98_14 = 9814;
  static const MENU_FLAG_98_15 = 9815;
  static const MENU_FLAG_98_16 = 9816;
  static const MENU_FLAG_98_17 = 9817;
  static const MENU_FLAG_98_18 = 9818;
  static const MENU_FLAG_98_19 = 9819;
  static const MENU_FLAG_98_20 = 9820;
  static const MENU_FLAG_98_21 = 9821;
  static const MENU_FLAG_98_22 = 9822;
  static const MENU_FLAG_98_23 = 9823;
  static const MENU_FLAG_98_24 = 9824;
  static const MENU_FLAG_98_25 = 9825;
  static const MENU_FLAG_98_26 = 9826;
  static const MENU_FLAG_60_98_25 = 609825;
  static const MENU_FLAG_99 = 9900;
  static const MENU_FLAG_99_1 = 9901;
  static const MENU_FLAG_99_2 = 9902;
  static const MENU_FLAG_99_3 = 9903;
  static const MENU_FLAG_99_4 = 9904;
  static const MENU_FLAG_99_5 = 9905;
  static const MENU_FLAG_99_6 = 9906;

  // admin用户菜单 默认前缀999
  static const MENU_FLAG_ADMIN_1 = 999100;
  static const MENU_FLAG_ADMIN_2 = 999200;
  static const MENU_FLAG_ADMIN_2_1 = 999201;
  static const MENU_FLAG_ADMIN_2_2 = 999202;
  static const MENU_FLAG_ADMIN_2_3 = 999203;
  static const MENU_FLAG_ADMIN_3 = 999300;
  static const MENU_FLAG_ADMIN_3_1 = 999301;
  static const MENU_FLAG_ADMIN_3_2 = 999302;
  static const MENU_FLAG_ADMIN_4 = 999400;
  static const MENU_FLAG_ADMIN_4_1 = 999401;
  static const MENU_FLAG_ADMIN_4_2 = 999402;

  // 菜单标记 - 终

  // 页面标记 - 始
  // 首页--------------------------------------------------
  static const PAGE_FLAG_1 = "page_flag_1";
  // アカウント
  static const PAGE_FLAG_50_1 = "page_flag_50_1";
  //新着通知页面   luxy
  static const PAGE_FLAG_50_2 = "page_flag_50_2";
  //新着通知详细页面-sp   luxy
  static const PAGE_FLAG_50_2_1 = "page_flag_50_2_1";
  // 账户编辑页面-sp xcy
  static const PAGE_FLAG_50_1_1 = "page_flag_50_1_1";
  // セキュリティ安全页面-sp xcy
  static const PAGE_FLAG_50_1_2 = "page_flag_50_1_2";
  // ライセンス许可证页面-sp xcy
  static const PAGE_FLAG_50_1_3 = "page_flag_50_1_3";
  //入荷----------------------------------------------------
  // 入荷予定入力  - wgs
  static const PAGE_FLAG_2_1 = "page_flag_2_1";

  //入荷予定照会 luxy
  static const PAGE_FLAG_2_5 = "page_flag_2_5";
  static const PAGE_FLAG_60_2_5 = "page_flag_60_2_5";

  // 入荷检品 - xcy
  static const PAGE_FLAG_2_4 = "page_flag_2_4";

  // 入庫入力 - xcy
  static const PAGE_FLAG_2_3 = "page_flag_2_3";

  //入庫照会页面  - wgs
  static const PAGE_FLAG_2_7 = "page_flag_2_7";

  // 入荷確定
  static const PAGE_FLAG_2_12 = "page_flag_2_12";
  static const PAGE_FLAG_60_2_12_1 = "page_flag_60_2_12_1";
  static const PAGE_FLAG_60_2_12_2 = "page_flag_60_2_12_2";

  //入荷確定データ出力 -cuihr
  static const PAGE_FLAG_2_16 = "page_flag_2_16";

  // 出荷----------------------------------------------------
  // 出荷指示入力
  static const PAGE_FLAG_3_1 = "page_flag_3_1";

  // 出荷指示照会  - xcy
  static const PAGE_FLAG_3_5 = "page_flag_3_5";
  static const PAGE_FLAG_60_3_5 = "page_flag_60_3_5";

  //欠品伝票照会 luxy
  static const PAGE_FLAG_3_11 = "page_flag_3_11";
  static const PAGE_FLAG_60_3_11 = "page_flag_60_3_11";

  // 挑货单页面  - wgs
  static const PAGE_FLAG_3_8 = "page_flag_3_8";
  static const PAGE_FLAG_60_3_8 = "page_flag_60_3_8";
  // 出庫入力
  static const PAGE_FLAG_3_12 = "page_flag_3_12";

  // 出庫照会页面  - wgs
  static const PAGE_FLAG_3_16 = "page_flag_3_16";

  // 纳品书一览页面  - xcy
  static const PAGE_FLAG_3_21 = "page_flag_3_21";
  static const PAGE_FLAG_60_3_21 = "page_flag_60_3_21";

  // 出荷检品 - xcy
  static const PAGE_FLAG_3_13 = "page_flag_3_13";

  // 出荷确定  - cuihr
  static const PAGE_FLAG_3_26 = "page_flag_3_26";
  static const PAGE_FLAG_60_3_26 = "page_flag_60_3_26";

  // 出荷確定データ出力
  static const PAGE_FLAG_3_28 = "page_flag_3_28";

  // 在庫----------------------------------------------------

  //在庫照会页面  - wgs
  static const PAGE_FLAG_4_1 = "page_flag_4_1";

  //受払照会 luxy
  static const PAGE_FLAG_4_10 = "page_flag_4_10";

  //返品入力页面  - wgs
  static const PAGE_FLAG_4_4 = "page_flag_4_4";

  // 在庫移動入力 - xcy
  static const PAGE_FLAG_4_13 = "page_flag_4_13";

  // 在庫移動照会 - 画面 - zhangbr
  static const PAGE_FLAG_4_16 = "page_flag_4_16";

  //在库调整入力
  static const PAGE_FLAG_4_17 = 'page_flag_4_17';

  // 在庫調整照会 - 画面 - zhangbr
  static const PAGE_FLAG_4_18 = "page_flag_4_18";

  // 棚卸----------------------------------------------------
  // 棚卸開始 - xcy
  static const PAGE_FLAG_5_1 = "page_flag_5_1";

  //実棚明細入力  - wgs
  static const PAGE_FLAG_5_2 = "page_flag_5_2";
  static const PAGE_FLAG_60_5_2 = "page_flag_60_5_2";

  // 棚卸確定 - zhangbr
  static const PAGE_FLAG_5_11 = "page_flag_5_11";

  // 棚卸照会 - xcy
  static const PAGE_FLAG_5_9 = "page_flag_5_9";
  static const PAGE_FLAG_60_5_9 = "page_flag_60_5_9";

  //棚卸データ出力 -wgs
  static const PAGE_FLAG_5_3 = "page_flag_5_3";

  // 商品マスタ管理 xcy
  static const PAGE_FLAG_8_4 = "page_flag_8_4";

  //返品照会 -wgs
  static const PAGE_FLAG_4_8 = "page_flag_4_8";

  // メニューマスタ - xcy
  static const PAGE_FLAG_98_5 = "page_flag_98_5";

  // 会社情報マスタ管理 -wgs
  static const PAGE_FLAG_8_1 = "page_flag_8_1";

  //荷主マスタ管理 -wgs
  static const PAGE_FLAG_8_3 = "page_flag_8_3";

  //メッセージマスタ xcy
  static const PAGE_FLAG_98_11 = "page_flag_98_11";

  //得意先マスタ管理 -wgs
  static const PAGE_FLAG_8_6 = "page_flag_8_6";

  //配送業者マスタ管理 -cuihr
  static const PAGE_FLAG_8_7 = "page_flag_8_7";

  //倉庫マスタ -wgs
  static const PAGE_FLAG_8_19 = "page_flag_8_19";

  //基本設定 -wgs
  static const PAGE_FLAG_99_2 = "page_flag_99_2";

  //ロールマスタ -cuihr
  static const PAGE_FLAG_8_22 = "page_flag_8_22";

  // ロケーションマスタ管理 - xiongcy
  static const PAGE_FLAG_8_16 = "page_flag_8_16";

  // 納入先マスタ管理 - zhangbr
  static const PAGE_FLAG_8_23 = "page_flag_8_23";

  // 営業日マスタ管理 - zhaoss
  static const PAGE_FLAG_8_24 = "page_flag_8_24";

  //仕入先マスタ -cuihr
  static const PAGE_FLAG_8_10 = "page_flag_8_10";

  // カレンダーマスタ管理 - xiongcy
  static const PAGE_FLAG_8_21 = "page_flag_8_21";

  // 商品情报
  static const PAGE_FLAG_9 = "page_flag_9";

  // 設定----------------------------------------------------
  // 権限マスタ - zhangbr
  static const PAGE_FLAG_98_8 = "page_flag_98_8";

  // 操作ログ  -luxy
  static const PAGE_FLAG_99_6 = "page_flag_99_6";

  // 課金法人管理 - xiongcy
  static const PAGE_FLAG_98_22 = "page_flag_98_22";
  // ライセンス管理 - wgs
  static const PAGE_FLAG_98_23 = "page_flag_98_23";

  // ユーザーライセンス管理 - xiongcy
  static const PAGE_FLAG_98_24 = "page_flag_98_24";

  // 申込受付 - cuihr
  static const PAGE_FLAG_98_25 = "page_flag_98_25";
  static const PAGE_FLAG_60_98_25 = "page_flag_60_98_25";
  // 解约受付 - zhaoss
  static const PAGE_FLAG_98_26 = "page_flag_98_26";
  // 页面标记 - 终
}
