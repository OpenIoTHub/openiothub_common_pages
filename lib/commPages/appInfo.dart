import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wechat_kit/wechat_kit.dart';

class AppInfoPage extends StatefulWidget {
  AppInfoPage({required Key key}) : super(key: key);

  @override
  _AppInfoPageState createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  //APP名称
  late String appName;

  //包名
  late String packageName;

  //版本名
  late String version;

  //版本号
  late String buildNumber;

  late StreamSubscription<WechatSdkResp> _share;

  void _listenShareMsg(WechatSdkResp resp) {
    final String content = 'share: ${resp.errorCode} ${resp.errorMsg}';
    if (resp.errorCode == 0) {
      Fluttertoast.showToast(msg: "分享成功！");
    } else {
      Fluttertoast.showToast(msg: "分享失败！");
    }
  }

  @override
  void initState() {
    _share = Wechat.instance.shareMsgResp().listen(_listenShareMsg);
    super.initState();
    _getAppInfo();
  }

  @override
  void dispose() {
    _share.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List _result = [];
    _result.add("App名称:$appName");
    _result.add("包名:$packageName");
    _result.add("版本:$version");
    _result.add("版本号:$buildNumber");

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
        "隐私政策",
        style: TextStyle(color: Colors.green),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return PrivacyPolicyPage(
            key: UniqueKey(),
          );
        }));
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
              color: Colors.white,
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
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("分享到微信"),
                content: Text("选择需方分享的位置"),
                actions: <Widget>[
                  TextButton(
                    child: Text("分享到个人"),
                    onPressed: () {
                      Wechat.instance.shareWebpage(
                        scene: WechatScene.SESSION,
                        title: "欢迎使用云易连！",
                        description: "云易连管理您的所有智能设备和私有云",
                        // thumbData:,
                        webpageUrl: 'https://github.com/OpenIoTHub',
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("分享到朋友圈"),
                    onPressed: () {
                      Wechat.instance.shareWebpage(
                        scene: WechatScene.TIMELINE,
                        title: "欢迎使用云易连！",
                        description: "云易连管理您的所有智能设备和私有云",
                        // thumbData:,
                        webpageUrl: 'https://github.com/OpenIoTHub',
                      );
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }
}
