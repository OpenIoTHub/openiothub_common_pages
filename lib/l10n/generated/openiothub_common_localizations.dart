import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'openiothub_common_localizations_en.dart';
import 'openiothub_common_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of OpenIoTHubCommonLocalizations
/// returned by `OpenIoTHubCommonLocalizations.of(context)`.
///
/// Applications need to include `OpenIoTHubCommonLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/openiothub_common_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: OpenIoTHubCommonLocalizations.localizationsDelegates,
///   supportedLocales: OpenIoTHubCommonLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the OpenIoTHubCommonLocalizations.supportedLocales
/// property.
abstract class OpenIoTHubCommonLocalizations {
  OpenIoTHubCommonLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static OpenIoTHubCommonLocalizations of(BuildContext context) {
    return Localizations.of<OpenIoTHubCommonLocalizations>(
        context, OpenIoTHubCommonLocalizations)!;
  }

  static const LocalizationsDelegate<OpenIoTHubCommonLocalizations> delegate =
      _OpenIoTHubCommonLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'OpenIoTHub'**
  String get app_title;

  /// No description provided for @click_to_get_wifi_info.
  ///
  /// In en, this message translates to:
  /// **'点击获取WiFi信息'**
  String get click_to_get_wifi_info;

  /// No description provided for @input_wifi_password.
  ///
  /// In en, this message translates to:
  /// **'上面输入wifi密码开始设置设备联网'**
  String get input_wifi_password;

  /// No description provided for @connecting_to_router.
  ///
  /// In en, this message translates to:
  /// **'正在设置设备连接到路由器'**
  String get connecting_to_router;

  /// No description provided for @device_wifi_config.
  ///
  /// In en, this message translates to:
  /// **'设备配网'**
  String get device_wifi_config;

  /// No description provided for @wifi_ssid.
  ///
  /// In en, this message translates to:
  /// **'WiFi名称'**
  String get wifi_ssid;

  /// No description provided for @start_adding_surrounding_smart_devices.
  ///
  /// In en, this message translates to:
  /// **'开始添加周围智能设备'**
  String get start_adding_surrounding_smart_devices;

  /// No description provided for @wifi_info_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'WiFi信息不能为空'**
  String get wifi_info_cant_be_empty;

  /// No description provided for @discovering_device_please_wait.
  ///
  /// In en, this message translates to:
  /// **'正在发现设备，请耐心等待，大概需要一分钟'**
  String get discovering_device_please_wait;

  /// No description provided for @please_input_2p4g_wifi_password.
  ///
  /// In en, this message translates to:
  /// **'输入路由器WIFI(2.4G频率)密码后开始配网'**
  String get please_input_2p4g_wifi_password;

  /// No description provided for @airkiss_device_wifi_config_success.
  ///
  /// In en, this message translates to:
  /// **'附近的AirKiss设备配网任务完成'**
  String get airkiss_device_wifi_config_success;

  /// No description provided for @bind_wechat_success.
  ///
  /// In en, this message translates to:
  /// **'绑定微信成功！'**
  String get bind_wechat_success;

  /// No description provided for @bind_wechat_failed.
  ///
  /// In en, this message translates to:
  /// **'绑定微信失败'**
  String get bind_wechat_failed;

  /// No description provided for @get_wechat_login_info_failed.
  ///
  /// In en, this message translates to:
  /// **'获取微信登录信息失败'**
  String get get_wechat_login_info_failed;

  /// No description provided for @account_and_safety.
  ///
  /// In en, this message translates to:
  /// **'获取微信登录信息失败'**
  String get account_and_safety;

  /// No description provided for @mobile_number.
  ///
  /// In en, this message translates to:
  /// **'获取微信登录信息失败'**
  String get mobile_number;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'用户名'**
  String get username;

  /// No description provided for @user_mobile.
  ///
  /// In en, this message translates to:
  /// **'手机号'**
  String get user_mobile;

  /// No description provided for @user_email.
  ///
  /// In en, this message translates to:
  /// **'邮箱'**
  String get user_email;

  /// No description provided for @modify_password.
  ///
  /// In en, this message translates to:
  /// **'修改密码'**
  String get modify_password;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'密码'**
  String get password;

  /// No description provided for @bind_wechat.
  ///
  /// In en, this message translates to:
  /// **'绑定微信'**
  String get bind_wechat;

  /// No description provided for @no_wechat_installed.
  ///
  /// In en, this message translates to:
  /// **'只有安装了微信才能绑定微信'**
  String get no_wechat_installed;

  /// No description provided for @unbind_wechat.
  ///
  /// In en, this message translates to:
  /// **'解除微信绑定'**
  String get unbind_wechat;

  /// No description provided for @unbind_wechat_success.
  ///
  /// In en, this message translates to:
  /// **'解绑微信成功！'**
  String get unbind_wechat_success;

  /// No description provided for @unbind_wechat_failed_reason.
  ///
  /// In en, this message translates to:
  /// **'解绑微信失败！原因：'**
  String get unbind_wechat_failed_reason;

  /// No description provided for @cancel_account.
  ///
  /// In en, this message translates to:
  /// **'注销账号'**
  String get cancel_account;

  /// No description provided for @modify.
  ///
  /// In en, this message translates to:
  /// **'修改'**
  String get modify;

  /// No description provided for @please_input_new_value.
  ///
  /// In en, this message translates to:
  /// **'请输入新的'**
  String get please_input_new_value;

  /// No description provided for @new_value.
  ///
  /// In en, this message translates to:
  /// **'新值'**
  String get new_value;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @cancel_my_account.
  ///
  /// In en, this message translates to:
  /// **'删除我的账号'**
  String get cancel_my_account;

  /// No description provided for @cancel_my_account_notify1.
  ///
  /// In en, this message translates to:
  /// **'请注意，确认删除之后删除操作立马生效，且不可恢复！'**
  String get cancel_my_account_notify1;

  /// No description provided for @operation_cannot_be_restored.
  ///
  /// In en, this message translates to:
  /// **'操作不可恢复！'**
  String get operation_cannot_be_restored;

  /// No description provided for @please_input_your_password.
  ///
  /// In en, this message translates to:
  /// **'请输入你的密码'**
  String get please_input_your_password;

  /// No description provided for @current_account_password.
  ///
  /// In en, this message translates to:
  /// **'当前账号的密码'**
  String get current_account_password;

  /// No description provided for @confirm_cancel_account.
  ///
  /// In en, this message translates to:
  /// **'确认删除账号?'**
  String get confirm_cancel_account;

  /// No description provided for @cancel_account_success.
  ///
  /// In en, this message translates to:
  /// **'删除账号成功！'**
  String get cancel_account_success;

  /// No description provided for @cancel_account_failed.
  ///
  /// In en, this message translates to:
  /// **'删除账号失败'**
  String get cancel_account_failed;

  /// No description provided for @wechat_login_failed.
  ///
  /// In en, this message translates to:
  /// **'微信登录失败'**
  String get wechat_login_failed;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'登录'**
  String get login;

  /// No description provided for @please_input_mobile.
  ///
  /// In en, this message translates to:
  /// **'请输入手机号'**
  String get please_input_mobile;

  /// No description provided for @please_input_password.
  ///
  /// In en, this message translates to:
  /// **'请输入用户密码'**
  String get please_input_password;

  /// No description provided for @agree_to_the_user_agreement1.
  ///
  /// In en, this message translates to:
  /// **'请勾选'**
  String get agree_to_the_user_agreement1;

  /// No description provided for @agree_to_the_user_agreement2.
  ///
  /// In en, this message translates to:
  /// **'下述同意隐私政策才可以进行下一步'**
  String get agree_to_the_user_agreement2;

  /// No description provided for @username_and_password_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'用户名与密码不能为空'**
  String get username_and_password_cant_be_empty;

  /// No description provided for @user_registration.
  ///
  /// In en, this message translates to:
  /// **'用户注册'**
  String get user_registration;

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'同意'**
  String get agree;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'隐私政策'**
  String get privacy_policy;

  /// No description provided for @feedback_channels.
  ///
  /// In en, this message translates to:
  /// **'反馈渠道'**
  String get feedback_channels;

  /// No description provided for @get_wechat_qr_code_failed.
  ///
  /// In en, this message translates to:
  /// **'获取微信登陆二维码失败！'**
  String get get_wechat_qr_code_failed;

  /// No description provided for @wechat_scan_qr_code_to_login.
  ///
  /// In en, this message translates to:
  /// **'微信扫码登录！'**
  String get wechat_scan_qr_code_to_login;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'退出'**
  String get exit;

  /// No description provided for @login_failed.
  ///
  /// In en, this message translates to:
  /// **'登录失败'**
  String get login_failed;

  /// No description provided for @login_after_wechat_bind.
  ///
  /// In en, this message translates to:
  /// **'请现将本微信绑定一个账号再使用微信快捷登录'**
  String get login_after_wechat_bind;

  /// No description provided for @wechat_fast_login_failed.
  ///
  /// In en, this message translates to:
  /// **'微信快捷登录失败'**
  String get wechat_fast_login_failed;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'注册'**
  String get register;

  /// No description provided for @register_success.
  ///
  /// In en, this message translates to:
  /// **'注册成功!请使用注册信息登录!'**
  String get register_success;

  /// No description provided for @register_failed.
  ///
  /// In en, this message translates to:
  /// **'注册失败!请重新注册'**
  String get register_failed;

  /// No description provided for @user_info.
  ///
  /// In en, this message translates to:
  /// **'用户信息'**
  String get user_info;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'退出登录'**
  String get logout;

  /// No description provided for @share_success.
  ///
  /// In en, this message translates to:
  /// **'分享成功！'**
  String get share_success;

  /// No description provided for @share_failed.
  ///
  /// In en, this message translates to:
  /// **'分享失败！'**
  String get share_failed;

  /// No description provided for @as_a_gateway.
  ///
  /// In en, this message translates to:
  /// **'本机作为网关'**
  String get as_a_gateway;

  /// No description provided for @as_a_gateway_description1.
  ///
  /// In en, this message translates to:
  /// **'使用云亿连APP扫描上述二维码添加本网关以访问本网络'**
  String get as_a_gateway_description1;

  /// No description provided for @change_gateway_id.
  ///
  /// In en, this message translates to:
  /// **'更换网关ID'**
  String get change_gateway_id;

  /// No description provided for @go_to_main_menu.
  ///
  /// In en, this message translates to:
  /// **'返回主界面'**
  String get go_to_main_menu;

  /// No description provided for @share_to_wechat.
  ///
  /// In en, this message translates to:
  /// **'分享到微信'**
  String get share_to_wechat;

  /// No description provided for @select_where_to_share.
  ///
  /// In en, this message translates to:
  /// **'选择需方分享的位置'**
  String get select_where_to_share;

  /// No description provided for @openiothub_gateway_share.
  ///
  /// In en, this message translates to:
  /// **'云亿连网关分享'**
  String get openiothub_gateway_share;

  /// No description provided for @openiothub_gateway_share_description.
  ///
  /// In en, this message translates to:
  /// **'使用云亿连扫码二维码添加网关，管理您的所有智能设备和私有云'**
  String get openiothub_gateway_share_description;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'使App名称:'**
  String get app_name;

  /// No description provided for @package_name.
  ///
  /// In en, this message translates to:
  /// **'包名:'**
  String get package_name;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'版本:'**
  String get version;

  /// No description provided for @version_sn.
  ///
  /// In en, this message translates to:
  /// **'版本号:'**
  String get version_sn;

  /// No description provided for @icp_number.
  ///
  /// In en, this message translates to:
  /// **'APP备案号:'**
  String get icp_number;

  /// No description provided for @online_feedback.
  ///
  /// In en, this message translates to:
  /// **'在线反馈'**
  String get online_feedback;

  /// No description provided for @app_info.
  ///
  /// In en, this message translates to:
  /// **'APP信息'**
  String get app_info;

  /// No description provided for @share_app_title.
  ///
  /// In en, this message translates to:
  /// **'云亿连内网穿透和智能家居管理'**
  String get share_app_title;

  /// No description provided for @share_app_description.
  ///
  /// In en, this message translates to:
  /// **'云亿连全平台管理您的所有智能设备和私有云'**
  String get share_app_description;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'分享'**
  String get share;

  /// No description provided for @share_to_where.
  ///
  /// In en, this message translates to:
  /// **'选择需方分享的位置'**
  String get share_to_where;

  /// No description provided for @wechat_not_installed.
  ///
  /// In en, this message translates to:
  /// **'微信未安装'**
  String get wechat_not_installed;

  /// No description provided for @share_on_moments.
  ///
  /// In en, this message translates to:
  /// **'分享到朋友圈'**
  String get share_on_moments;

  /// No description provided for @find_local_gateway_list.
  ///
  /// In en, this message translates to:
  /// **'发现本地网关列表'**
  String get find_local_gateway_list;

  /// No description provided for @manually_create_a_gateway.
  ///
  /// In en, this message translates to:
  /// **'手动创建一个网关？'**
  String get manually_create_a_gateway;

  /// No description provided for @manually_create_a_gateway_description1.
  ///
  /// In en, this message translates to:
  /// **'安装的网关可以本页面发现'**
  String get manually_create_a_gateway_description1;

  /// No description provided for @manually_create_a_gateway_description2.
  ///
  /// In en, this message translates to:
  /// **'自动生成一个网关信息，回头拿着token填写到网关配置文件即可，适合于手机无法同局域网发现网关的情况'**
  String get manually_create_a_gateway_description2;

  /// No description provided for @manually_create_a_gateway_description3.
  ///
  /// In en, this message translates to:
  /// **'从下面选择网关需要连接的服务器:'**
  String get manually_create_a_gateway_description3;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'添加'**
  String get add;

  /// No description provided for @paste_info.
  ///
  /// In en, this message translates to:
  /// **'网关的id与token已经复制到剪切板，请将剪切板的配置填写到网关的配置文件中'**
  String get paste_info;

  /// No description provided for @add_gateway_success.
  ///
  /// In en, this message translates to:
  /// **'网关的id与token已经复制到剪切板，请将剪切板的配置填写到网关的配置文件中'**
  String get add_gateway_success;

  /// No description provided for @gateway_install_guide.
  ///
  /// In en, this message translates to:
  /// **'网关安装指南'**
  String get gateway_install_guide;

  /// No description provided for @gateway_install_guide_content1.
  ///
  /// In en, this message translates to:
  /// **'这里介绍怎样安装一个自己的网关'**
  String get gateway_install_guide_content1;

  /// No description provided for @gateway_install_guide_content2.
  ///
  /// In en, this message translates to:
  /// **'首先，你需要将网关安装到你需要访问的局域网持续运行'**
  String get gateway_install_guide_content2;

  /// No description provided for @gateway_install_guide_content3.
  ///
  /// In en, this message translates to:
  /// **'第一次的时候，将本APP也接入网关所在的局域网'**
  String get gateway_install_guide_content3;

  /// No description provided for @gateway_install_guide_content4.
  ///
  /// In en, this message translates to:
  /// **'APP在局域网搜索并配置添加网关一次后'**
  String get gateway_install_guide_content4;

  /// No description provided for @gateway_install_guide_content5.
  ///
  /// In en, this message translates to:
  /// **'以后只要网关在线手机客户端都可以访问'**
  String get gateway_install_guide_content5;

  /// No description provided for @gateway_install_guide_content6.
  ///
  /// In en, this message translates to:
  /// **'这里介绍如何在你所需要访问的网络安装网关'**
  String get gateway_install_guide_content6;

  /// No description provided for @gateway_install_guide_content7.
  ///
  /// In en, this message translates to:
  /// **'查看网关的开源地址'**
  String get gateway_install_guide_content7;

  /// No description provided for @gateway_install_guide_content8.
  ///
  /// In en, this message translates to:
  /// **'openwrt路由器snapshot源安装：opkg install gateway-go'**
  String get gateway_install_guide_content8;

  /// No description provided for @gateway_install_guide_content9.
  ///
  /// In en, this message translates to:
  /// **'MacOS使用homebrew安装：brew install gateway-go'**
  String get gateway_install_guide_content9;

  /// No description provided for @gateway_install_guide_content10.
  ///
  /// In en, this message translates to:
  /// **'Linux使用snapcraft安装：sudo snap install gateway-go'**
  String get gateway_install_guide_content10;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'名称'**
  String get name;

  /// No description provided for @define_server_name.
  ///
  /// In en, this message translates to:
  /// **'自定义服务器名称'**
  String get define_server_name;

  /// No description provided for @define_server_ip_or_domain.
  ///
  /// In en, this message translates to:
  /// **'服务器ip地址或者域名'**
  String get define_server_ip_or_domain;

  /// No description provided for @define_server_addr.
  ///
  /// In en, this message translates to:
  /// **'公网server-go服务器的地址'**
  String get define_server_addr;

  /// No description provided for @define_server_key.
  ///
  /// In en, this message translates to:
  /// **'秘钥'**
  String get define_server_key;

  /// No description provided for @define_server_tcp_port.
  ///
  /// In en, this message translates to:
  /// **'tcp端口'**
  String get define_server_tcp_port;

  /// No description provided for @define_server_kcp_port.
  ///
  /// In en, this message translates to:
  /// **'kcp端口'**
  String get define_server_kcp_port;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'端口'**
  String get port;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'描述'**
  String get description;

  /// No description provided for @define_description.
  ///
  /// In en, this message translates to:
  /// **'自定义描述信息'**
  String get define_description;

  /// No description provided for @for_everyone_to_use.
  ///
  /// In en, this message translates to:
  /// **'提供给APP所有人使用:'**
  String get for_everyone_to_use;

  /// No description provided for @update_success.
  ///
  /// In en, this message translates to:
  /// **'更新成功！'**
  String get update_success;

  /// No description provided for @confirm_modify.
  ///
  /// In en, this message translates to:
  /// **'确认修改'**
  String get confirm_modify;

  /// No description provided for @server_info.
  ///
  /// In en, this message translates to:
  /// **'服务器信息'**
  String get server_info;

  /// No description provided for @delete_success.
  ///
  /// In en, this message translates to:
  /// **'删除成功！'**
  String get delete_success;

  /// No description provided for @grpc_server_addr.
  ///
  /// In en, this message translates to:
  /// **'grpc服务的地址'**
  String get grpc_server_addr;

  /// No description provided for @grpc_server_ip_or_domain.
  ///
  /// In en, this message translates to:
  /// **'请输入grpc服务的IP或者域名'**
  String get grpc_server_ip_or_domain;

  /// No description provided for @grpc_service_port.
  ///
  /// In en, this message translates to:
  /// **'grpc服务的端口'**
  String get grpc_service_port;

  /// No description provided for @input_grpc_service_port.
  ///
  /// In en, this message translates to:
  /// **'请输入grpc服务的端口'**
  String get input_grpc_service_port;

  /// No description provided for @iot_manager_addr.
  ///
  /// In en, this message translates to:
  /// **'iot-manager地址'**
  String get iot_manager_addr;

  /// No description provided for @input_iot_manager_addr.
  ///
  /// In en, this message translates to:
  /// **'请输入iot-manager grpc服务地址'**
  String get input_iot_manager_addr;

  /// No description provided for @activate_front_desk_service.
  ///
  /// In en, this message translates to:
  /// **'开启前台服务'**
  String get activate_front_desk_service;

  /// No description provided for @my_server_description_example.
  ///
  /// In en, this message translates to:
  /// **'我自己的server-go服务器'**
  String get my_server_description_example;

  /// No description provided for @server_go_addr_example.
  ///
  /// In en, this message translates to:
  /// **'guonei.servers.iothub.cloud'**
  String get server_go_addr_example;

  /// No description provided for @my_server_description.
  ///
  /// In en, this message translates to:
  /// **'我的服务器的描述'**
  String get my_server_description;

  /// No description provided for @add_self_hosted_server.
  ///
  /// In en, this message translates to:
  /// **'添加自建服务器：'**
  String get add_self_hosted_server;

  /// No description provided for @server_uuid.
  ///
  /// In en, this message translates to:
  /// **'服务器uuid'**
  String get server_uuid;

  /// No description provided for @as_config_file.
  ///
  /// In en, this message translates to:
  /// **'跟server-go服务器里面的配置文件一致'**
  String get as_config_file;

  /// No description provided for @add_to_server.
  ///
  /// In en, this message translates to:
  /// **'添加到服务器'**
  String get add_to_server;

  /// No description provided for @add_server.
  ///
  /// In en, this message translates to:
  /// **'添加服务器'**
  String get add_server;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'成功!'**
  String get success;
}

class _OpenIoTHubCommonLocalizationsDelegate
    extends LocalizationsDelegate<OpenIoTHubCommonLocalizations> {
  const _OpenIoTHubCommonLocalizationsDelegate();

  @override
  Future<OpenIoTHubCommonLocalizations> load(Locale locale) {
    return SynchronousFuture<OpenIoTHubCommonLocalizations>(
        lookupOpenIoTHubCommonLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_OpenIoTHubCommonLocalizationsDelegate old) => false;
}

OpenIoTHubCommonLocalizations lookupOpenIoTHubCommonLocalizations(
    Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return OpenIoTHubCommonLocalizationsZhHans();
          case 'Hant':
            return OpenIoTHubCommonLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return OpenIoTHubCommonLocalizationsZhCn();
          case 'TW':
            return OpenIoTHubCommonLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return OpenIoTHubCommonLocalizationsEn();
    case 'zh':
      return OpenIoTHubCommonLocalizationsZh();
  }

  throw FlutterError(
      'OpenIoTHubCommonLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
