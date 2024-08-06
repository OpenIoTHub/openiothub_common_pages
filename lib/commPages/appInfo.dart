import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:openiothub_common_pages/utils/goToUrl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tencent_kit/tencent_kit.dart';
import 'package:wechat_kit/wechat_kit.dart';

class AppInfoPage extends StatefulWidget {
  AppInfoPage({required Key key}) : super(key: key);

  @override
  _AppInfoPageState createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  //APP名称
  String appName = "";

  //包名
  String packageName = "";

  //版本名
  String version = "";

  //版本号
  String buildNumber = "";

  // 微信分享
  late final StreamSubscription<WechatResp> _share;

  // QQ分享
  late final StreamSubscription<TencentResp> _respSubs;
  TencentLoginResp? _loginResp;

  void _listenShareMsg(WechatResp resp) {
    // final String content = 'share: ${resp.errorCode} ${resp.errorMsg}';
    if (resp.errorCode == 0) {
      showToast("分享成功！");
    } else {
      showToast("分享失败！");
    }
  }

  void _listenLogin(TencentResp resp) {
    if (resp is TencentLoginResp) {
      _loginResp = resp;
      final String content = 'login: ${resp.openid} - ${resp.accessToken}';
      showToast('登录:$content');
    } else if (resp is TencentShareMsgResp) {
      // final String content = 'share: ${resp.ret} - ${resp.msg}';
      // showToast('分享:$content');
      if (resp.ret == 0) {
        showToast("分享成功！");
      } else {
        showToast("分享失败！");
      }
    }
  }

  @override
  void initState() {
    _share = WechatKitPlatform.instance.respStream().listen(_listenShareMsg);
    _respSubs = TencentKitPlatform.instance.respStream().listen(_listenLogin);
    super.initState();
    _getAppInfo();
  }

  @override
  void dispose() {
    _share.cancel();
    _respSubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List _result = [];
    _result.add("App名称:$appName");
    _result.add("包名:$packageName");
    _result.add("版本:$version");
    _result.add("版本号:$buildNumber");
    _result.add("APP备案号:皖ICP备2022013511号-2A");

    final tiles = _result.map(
      (pair) {
        return ListTile(
          title: Text(
            pair,
          ),
        );
      },
    );
    List<ListTile> tilesList = tiles.toList();
    tilesList.add(ListTile(
      title: Text(
        "反馈渠道",
        style: TextStyle(color: Colors.green),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//              return Text("${pair.iP}:${pair.port}");
          return FeedbackPage(
            key: UniqueKey(),
          );
        }));
      },
    ));
    tilesList.add(ListTile(
      title: Text(
        "在线反馈",
        style: TextStyle(color: Colors.green),
      ),
      onTap: () {
        launchURL("https://support.qq.com/product/657356");
      },
    ));
    tilesList.add(ListTile(
      title: Text(
        "隐私政策",
        style: TextStyle(color: Colors.green),
      ),
      onTap: () {
        goToURL(context, "https://docs.iothub.cloud/privacyPolicy/index.html",
            "隐私政策");
      },
    ));
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tilesList,
    ).toList();

    return Scaffold(
      appBar: AppBar(title: Text("App信息"), actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.share,
              // color: Colors.white,
            ),
            onPressed: () {
              _shareAction();
            }),
      ]),
      body: ListView(children: divided),
    );
  }

  _getAppInfo() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appName = packageInfo.appName;
        packageName = packageInfo.packageName;
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    });
  }

  _shareAction() async {
    var title = "云亿连内网穿透和智能家居管理";
    var description = "云亿连全平台管理您的所有智能设备和私有云";
    var url = "https://iothub.cloud/download.html";
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("分享"),
                content: Text("选择需方分享的位置"),
                actions: <Widget>[
                  Row(
                    children: [
                      TDButton(
                        icon: TDIcons.logo_wechat,
                        text: '分享到微信',
                        size: TDButtonSize.small,
                        type: TDButtonType.outline,
                        shape: TDButtonShape.rectangle,
                        theme: TDButtonTheme.primary,
                        onTap: () {
                          WechatKitPlatform.instance.shareWebpage(
                            scene: WechatScene.kSession,
                            title: title,
                            description: description,
                            // thumbData:,
                            webpageUrl: url,
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0), // 设置左边距离
                        child: TDButton(
                          icon: TDIcons.logo_wechat,
                          text: '分享到朋友圈',
                          size: TDButtonSize.small,
                          type: TDButtonType.outline,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                          onTap: () {
                            WechatKitPlatform.instance.shareWebpage(
                              scene: WechatScene.kTimeline,
                              title: title,
                              description: description,
                              // thumbData:,
                              webpageUrl: url,
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      TDButton(
                        icon: TDIcons.logo_qq,
                        text: '分享到QQ',
                        size: TDButtonSize.small,
                        type: TDButtonType.outline,
                        shape: TDButtonShape.rectangle,
                        theme: TDButtonTheme.primary,
                        onTap: () {
                          TencentKitPlatform.instance.shareWebpage(
                            scene: TencentScene.kScene_QQ,
                            title: title,
                            summary: description,
                            targetUrl: url,
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0), // 设置左边距离
                        child: TDButton(
                          icon: TDIcons.logo_qq,
                          text: '分享到QQ空间',
                          size: TDButtonSize.small,
                          type: TDButtonType.outline,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                          onTap: () {
                            TencentKitPlatform.instance.shareWebpage(
                              scene: TencentScene.kScene_QZone,
                              title: title,
                              summary: description,
                              targetUrl: url,
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  )
                ]));
  }
}
