import 'package:flutter/cupertino.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_grpc_api/proto/manager/publicApi.pb.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GatewayQrPage extends StatefulWidget {
  const GatewayQrPage({super.key});

  @override
  State<GatewayQrPage> createState() => _GatewayQrPageState();
}

class _GatewayQrPageState extends State<GatewayQrPage> {
  JwtQRCodePair? jwtQRCodePair;

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
    return ListView(children: [
      QrImageView(
        data: jwtQRCodePair != null ? jwtQRCodePair!.qRCodeForMobileAdd : "https://iothub.cloud",
        version: QrVersions.auto,
        size: 320,
      ),
      Center(child:Text("使用云亿连APP扫描上述二维码添加本网关"))
    ]);
  }

  Future<void> _generateJwtQRCodePair() async {
    // TODO 先检查本地存储有没有保存的网关配置，如果有则使用旧的启动
    jwtQRCodePair = await PublicApi.GenerateJwtQRCodePair();
    setState(() {});
    await GatewayLoginManager.LoginServerByToken(
        jwtQRCodePair!.gatewayJwt, "127.0.0.1", 55443);
    // TODO 保存网关(网格ID)到本地存储，当前刷新二维码的时候清楚前面的存储保存最新的网关配置
  }
}
