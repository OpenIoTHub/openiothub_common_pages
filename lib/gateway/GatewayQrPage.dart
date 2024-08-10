import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/manager/publicApi.pb.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:wechat_kit/wechat_kit.dart';

class GatewayQrPage extends StatefulWidget {
  const GatewayQrPage({super.key});

  @override
  State<GatewayQrPage> createState() => _GatewayQrPageState();
}

class _GatewayQrPageState extends State<GatewayQrPage> {
  String qRCodeForMobileAdd = "https://iothub.cloud";

  StreamSubscription<WechatResp>? _share;

  void _listenShareMsg(WechatResp resp) {
    // final String content = 'share: ${resp.errorCode} ${resp.errorMsg}';
    if (resp.errorCode == 0) {
      showToast("分享成功！");
    } else {
      showToast("分享失败！");
    }
  }

  @override
  void initState() {
    _generateJwtQRCodePair(false);
    if (_share == null && (Platform.isAndroid || Platform.isIOS)) {
      _share = WechatKitPlatform.instance.respStream().listen(_listenShareMsg);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_share != null && (Platform.isAndroid || Platform.isIOS)) {
      _share!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Text("data");
    // return QrImageView(
    //   data: jwtQRCodePair != null ? jwtQRCodePair!.qRCodeForMobileAdd : "https://iothub.cloud",
    //   version: QrVersions.auto,
    //   size: 320,
    // );
    return Scaffold(
        appBar: AppBar(
          title: Text("本机作为网关"),
          actions: <Widget>[
            //   TODO 以图片或者小程序方式分享给其他人
            IconButton(
                icon: Icon(
                  Icons.share,
                  // color: Colors.white,
                ),
                onPressed: () {
                  _shareAction();
                }),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: ListView(children: [
            Center(
                child: QrImageView(
                    data: qRCodeForMobileAdd,
                    version: QrVersions.auto,
                    size: 320,
                    // backgroundColor: Colors.orangeAccent,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Colors.yellow,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Colors.orange,
                    ))),
            Center(
                child: Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Text("使用云亿连APP扫描上述二维码添加本网关以访问本网络"),
            )),
            Center(
                child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: TextButton(
                child: Text("更换网关ID"),
                onPressed: () {
                  _generateJwtQRCodePair(true);
                },
              ),
            )),
            // Center(child: Padding(padding:EdgeInsets.fromLTRB(0, 15, 0, 0) ,child: TextButton(child: Text("返回主界面"), onPressed: (){Navigator.of(context).pop();},),))
            Center(
                child: Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: TDButton(
                icon: TDIcons.backward,
                text: '返回主界面',
                size: TDButtonSize.small,
                type: TDButtonType.outline,
                shape: TDButtonShape.rectangle,
                theme: TDButtonTheme.primary,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ))
          ]),
        ));
    // return ListView(children: [
    //   QrImageView(
    //     data: jwtQRCodePair != null
    //         ? jwtQRCodePair!.qRCodeForMobileAdd
    //         : "https://iothub.cloud",
    //     version: QrVersions.auto,
    //     size: 320,
    //   ),
    //   Center(child: Text("使用云亿连APP扫描上述二维码添加本网关"))
    // ]);
  }

  Future<void> _generateJwtQRCodePair(bool is_change_gateway_uuid) async {
    // TODO 先检查本地存储有没有保存的网关配置，如果有则使用旧的启动
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(SharedPreferencesKey.Gateway_Jwt_KEY) &&
        prefs.containsKey(SharedPreferencesKey.QR_Code_For_Mobile_Add_KEY) &&
        !is_change_gateway_uuid) {
      var gatewayJwt = prefs.getString(SharedPreferencesKey.Gateway_Jwt_KEY)!;
      setState(() {
        qRCodeForMobileAdd =
            prefs.getString(SharedPreferencesKey.QR_Code_For_Mobile_Add_KEY)!;
      });
      await GatewayLoginManager.LoginServerByToken(
          gatewayJwt, Config.gatewayGrpcIp, Config.gatewayGrpcPort);
    } else {
      JwtQRCodePair? jwtQRCodePair = await PublicApi.GenerateJwtQRCodePair();
      setState(() {
        qRCodeForMobileAdd = jwtQRCodePair.qRCodeForMobileAdd;
      });
      // TODO 保存网关(网格ID)到本地存储，当前刷新二维码的时候清楚前面的存储保存最新的网关配置
      prefs.setString(
          SharedPreferencesKey.Gateway_Jwt_KEY, jwtQRCodePair.gatewayJwt);
      prefs.setString(SharedPreferencesKey.QR_Code_For_Mobile_Add_KEY,
          jwtQRCodePair.qRCodeForMobileAdd);
      await GatewayLoginManager.LoginServerByToken(jwtQRCodePair.gatewayJwt,
          Config.gatewayGrpcIp, Config.gatewayGrpcPort);
    }
  }

  // 分享网关
  _shareAction() async {
    Uri? uri = Uri.tryParse(qRCodeForMobileAdd);
    String id = uri!.queryParameters["id"]!;
    String url =
        "https://api.iot-manager.iothub.cloud/v1/displayGatewayQRCodeById?id=$id";
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("分享到微信"),
                content: Text("选择需方分享的位置"),
                actions: <Widget>[
                  // 分享网关:二维码图片、小程序链接、网页
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
                        title: "云亿连网关分享",
                        description: "使用云亿连扫码二维码添加网关，管理您的所有智能设备和私有云",
                        // thumbData:,
                        webpageUrl: url,
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                  // TextButton(
                  //   child: Text("分享到朋友圈"),
                  //   onPressed: () {
                  //     WechatKitPlatform.instance.shareWebpage(
                  //       scene: WechatScene.kTimeline,
                  //       title: "云亿连网关分享",
                  //       description: "通过云亿连网关管理您的所有智能设备和私有云",
                  //       // thumbData:,
                  //       webpageUrl: qRCodeForMobileAdd,
                  //     );
                  //     Navigator.of(context).pop();
                  //   },
                  // )
                ]));
  }
}
