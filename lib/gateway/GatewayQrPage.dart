import 'package:flutter/material.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_grpc_api/proto/manager/publicApi.pb.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GatewayQrPage extends StatefulWidget {
  const GatewayQrPage({super.key});

  @override
  State<GatewayQrPage> createState() => _GatewayQrPageState();
}

class _GatewayQrPageState extends State<GatewayQrPage> {
  String qRCodeForMobileAdd = "https://iothub.cloud";

  @override
  void initState() {
    _generateJwtQRCodePair();
    super.initState();
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
          title: Text("作为网关"),
          actions: <Widget>[],
        ),
        body: Container(
          child: ListView(children: [
            Center(
                child: QrImageView(
              data: qRCodeForMobileAdd,
              version: QrVersions.auto,
              size: 320,
            )),
            Center(child: Text("使用云亿连APP扫描上述二维码添加本网关"))
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

  Future<void> _generateJwtQRCodePair() async {
    // TODO 先检查本地存储有没有保存的网关配置，如果有则使用旧的启动
    const Gateway_Jwt_KEY = "GATEWAY_JWT_KEY";
    const QR_Code_For_Mobile_Add_KEY = "QR_Code_For_Mobile_Add";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(Gateway_Jwt_KEY) &&
        prefs.containsKey(QR_Code_For_Mobile_Add_KEY)) {
      var gatewayJwt = prefs.getString(Gateway_Jwt_KEY)!;
      setState(() {
        qRCodeForMobileAdd = prefs.getString(QR_Code_For_Mobile_Add_KEY)!;
      });
      await GatewayLoginManager.LoginServerByToken(
          gatewayJwt, "127.0.0.1", 55443);
    } else {
      JwtQRCodePair? jwtQRCodePair = await PublicApi.GenerateJwtQRCodePair();
      setState(() {
        qRCodeForMobileAdd = jwtQRCodePair.qRCodeForMobileAdd;
      });
      // TODO 保存网关(网格ID)到本地存储，当前刷新二维码的时候清楚前面的存储保存最新的网关配置
      prefs.setString(Gateway_Jwt_KEY, jwtQRCodePair.gatewayJwt);
      prefs.setString(
          QR_Code_For_Mobile_Add_KEY, jwtQRCodePair.qRCodeForMobileAdd);
      await GatewayLoginManager.LoginServerByToken(
          jwtQRCodePair.gatewayJwt, "127.0.0.1", 55443);
    }
  }
}
