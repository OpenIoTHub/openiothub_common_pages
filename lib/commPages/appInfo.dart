import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:wechat_kit/wechat_kit.dart';

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as image;

class AppInfoPage extends StatefulWidget {
  AppInfoPage({Key key}) : super(key: key);

  @override
  _AppInfoPageState createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  //APP名称
  String appName;

  //包名
  String packageName;

  //版本名
  String version;

  //版本号
  String buildNumber;

  StreamSubscription<WechatSdkResp> _share;

  void _listenShareMsg(WechatSdkResp resp) {
    final String content = 'share: ${resp.errorCode} ${resp.errorMsg}';
    if (resp.errorCode == 0) {
      Fluttertoast.showToast(
          msg: "分享成功！");
    }else{
      Fluttertoast.showToast(
          msg: "分享失败！");
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
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
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
    final File file = await DefaultCacheManager().getSingleFile(
        'http://yunyilian.oss-cn-shanghai.aliyuncs.com/icon-32.png');
    final image.Image thumbnail =
    image.decodeImage(file.readAsBytesSync());
    Uint8List thumbData = thumbnail.getBytes();
    if (thumbData.length > 32 * 1024) {
      thumbData = Uint8List.fromList(image.encodeJpg(thumbnail,
          quality: 100 * 32 * 1024 ~/ thumbData.length));
    }
    Wechat.instance.shareWebpage(
      scene: WechatScene.TIMELINE,
      title:"欢迎使用云易连！",
      description:"云易连管理您的所有智能设备和私有云",
      thumbData:thumbData,
      // thumbData:,
      webpageUrl: 'https://github.com/OpenIoTHub',
    );
  }
}
