import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iot_manager_grpc_api/pb/gatewayManager.pb.dart';
import 'package:iot_manager_grpc_api/pb/serverManager.pb.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/pb/service.pb.dart';
import 'package:openiothub_grpc_api/pb/service.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/components.dart';

class FindmDNSClientListPage extends StatefulWidget {
  FindmDNSClientListPage({required Key key}) : super(key: key);

  @override
  _FindmDNSClientListPageState createState() => _FindmDNSClientListPageState();
}

class _FindmDNSClientListPageState extends State<FindmDNSClientListPage> {
  Map<String, PortService> _ServiceMap = {};
  final MDnsClient _mdns = MDnsClient(rawDatagramSocketFactory:
      (dynamic host, int port, {bool reuseAddress = false, bool reusePort = false, int ttl = 1}) {
    return RawDatagramSocket.bind(host, port,
        reuseAddress: true, reusePort: false, ttl: ttl);
  });

  @override
  void initState() {
    super.initState();
    _mdns.start();
    _findClientListBymDNS();
  }

  @override
  void dispose() {
    super.dispose();
    _mdns.stop();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _ServiceMap.values.map(
      (pair) {
        var listItemContent = Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: Icon(Icons.devices),
              ),
              Expanded(
                  child: Text(
                '${pair.ip}:${pair.port}',
                style: Constants.titleTextStyle,
              )),
              Constants.rightArrowIcon
            ],
          ),
        );
        return InkWell(
          onTap: () {
            //直接打开内置web浏览器浏览页面
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//              return Text("${pair.iP}:${pair.port}");
              return Gateway(device: pair, key: UniqueKey(),);
            }));
          },
          child: listItemContent,
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("发现本地网关列表"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _findClientListBymDNS();
              }),
          IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
              onPressed: () {
                _addGateway();
              }),
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () {
                _gatewayGuide();
              }),
        ],
      ),
      body: ListView(children: divided),
    );
  }

  void _findClientListBymDNS() async {
    print("====_findClientListBymDNS");
    _ServiceMap.clear();
    // try {
    await for (PtrResourceRecord ptr in _mdns.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer(
            Config.mdnsGatewayService + ".local"))) {
      await for (SrvResourceRecord srv in _mdns.lookup<SrvResourceRecord>(
          ResourceRecordQuery.service(ptr.domainName))) {
        print(srv);
        PortService _portService = PortService.create();
        _portService.isLocal = true;
        _portService.ip = "127.0.0.1";
        _portService.port = 80;
        _portService.info.addAll({
          "name": "网关",
          "model": Gateway.modelName,
          "mac": "mac",
          "id": "id",
          "author": "Farry",
          "email": "newfarry@126.com",
          "home-page": "https://github.com/OpenIoTHub",
          "firmware-respository": "https://github.com/OpenIoTHub/gateway-go",
          "firmware-version": "version",
        });
        await _mdns
            .lookup<TxtResourceRecord>(ResourceRecordQuery.text(ptr.domainName))
            .forEach((TxtResourceRecord text) {
          List<String> _txts = text.text.split("\n");
          print(_txts.length);
          print(_txts);
          _txts.forEach((String txt) {
            List<String> _kv = txt.split("=");
            print("_kv:");
            print(_kv);
            _portService.info[_kv.first] = _kv.last;
            //  TODO value 为空是否需要添加？
          });
        });
        await for (IPAddressResourceRecord ip
            in _mdns.lookup<IPAddressResourceRecord>(
                ResourceRecordQuery.addressIPv4(srv.target))) {
          print(ip);
          print('Service instance found at '
              '${srv.target}:${srv.port} with ${ip.address}.');
          _portService.ip = ip.address.address;
          _portService.port = srv.port;
          _portService.isLocal = true;
          break;
        }
        print("_portService:");
        print(_portService);
        if (!_ServiceMap.containsKey(_portService.info["id"])) {
          setState(() {
            _ServiceMap[_portService.info["id"]!] = _portService;
          });
        }
      }
    }
    _mdns.stop();
  }

  void onDiscoveryStarted() {
    print("Discovery started");
  }

  void onDiscoveryStopped() {
    print("Discovery stopped");
  }

  Future<void> _gatewayGuide() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return GatewayGuidePage(key: UniqueKey(),);
    }));
  }

  Future<void> _addGateway() async {
    List<DropdownMenuItem<String>> l = await _listAvailableServer();
    String? value = l.first.value;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return AlertDialog(
                title: Text("手动创建一个网关？"),
                content: ListView(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      Text("安装的网关可以本页面发现"),
                      Text(
                          "自动生成一个网关信息，回头拿着token填写到网关配置文件即可，适合于手机无法同局域网发现网关的情况"),
                      Text(
                        "从下面选择网关需要连接的服务器:",
                        style: TextStyle(
                          color: Colors.amber,
                        ),
                      ),
                      DropdownButton<String>(
                        value: value,
                        onChanged: (String? newVal) {
                          state(() {
                            value = newVal;
                          });
                        },
                        items: l,
                      ),
                    ],
                  ).toList(),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("添加"),
                    onPressed: () async {
                      // 从服务器自动生成一个网关
                      // TODO 选择服务器
                      GatewayInfo gatewayInfo =
                          await GatewayManager.GenerateOneGatewayWithServerUuid(
                              value!);
                      await _addToMySessionList(
                          gatewayInfo.openIoTHubJwt, gatewayInfo.name);
                      String uuid = gatewayInfo.gatewayUuid;
                      String gatewayJwt = gatewayInfo.gatewayJwt;
                      String data = '''
gatewayuuid: ${getOneUUID()}
logconfig:
  enablestdout: true
  logfilepath: ""
loginwithtokenmap:
  $uuid: $gatewayJwt
''';
                      Clipboard.setData(ClipboardData(text: data));
                      Fluttertoast.showToast(
                          msg: "网关的id与token已经复制到剪切板，请将剪切板的配置填写到网关的配置文件中");
                      Navigator.of(context).pop();
                    },
                  )
                ]);
          });
        });
  }

  Future _addToMySessionList(String token, name) async {
    SessionConfig config = SessionConfig();
    config.token = token;
    config.description = name;
    try {
      await SessionApi.createOneSession(config);
      Fluttertoast.showToast(msg: "添加网关成功！");
    } catch (exception) {
      Fluttertoast.showToast(msg: "登录失败：${exception}");
    }
  }

  Future<List<DropdownMenuItem<String>>> _listAvailableServer() async {
    ServerInfoList serverInfoList = await ServerManager.GetAllServer();
    List<DropdownMenuItem<String>> l = [];
    serverInfoList.serverInfoList.forEach((ServerInfo v) {
      l.add(DropdownMenuItem<String>(
        value: v.uuid,
        child: Text(
          "${v.name}(${v.serverHost}",
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      ));
    });
    return l;
  }
}
