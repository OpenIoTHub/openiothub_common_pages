import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/manager/gatewayManager.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/serverManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/plugins/mdnsService/components.dart';

import 'package:bonsoir/bonsoir.dart';

const utf8encoder = Utf8Encoder();

class FindmDNSClientListPage extends StatefulWidget {
  const FindmDNSClientListPage({Key? key}) : super(key: key);

  @override
  State createState() => _FindmDNSClientListPageState();
}

class _FindmDNSClientListPageState extends State<FindmDNSClientListPage> {
  BonsoirDiscovery? action;
  final Map<String, PortService> _ServiceMap = {};
  // final flutterNsd = FlutterNsd();
  bool initialStart = true;
  bool _scanning = false;

  _FindmDNSClientListPageState();

  @override
  void initState() {
    super.initState();
    startDiscovery();
  }

  Future<void> startDiscovery() async {
    if (_scanning) return;

    setState(() {
      _ServiceMap.clear();
      _scanning = true;
    });

    action = BonsoirDiscovery(type: Config.mdnsGatewayService);
    await action!.ready;
    action!.eventStream?.listen(onEventOccurred);
    await action!.start();
  }

  void onEventOccurred(BonsoirDiscoveryEvent event) {
    if (event.service == null) {
      return;
    }

    BonsoirService oneMdnsService = event.service!;
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
      // services.add(service);
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
      // services.removeWhere((foundService) => foundService.name == service.name);
      // services.add(service);
      setState(() {
        PortService _portService = PortService.create();
        _portService.ip = (oneMdnsService as ResolvedBonsoirService).host!;
        _portService.port = oneMdnsService.port;
        _portService.isLocal = true;
        _portService.info.addAll({
          "name": "${oneMdnsService.name}(${_portService.ip}:${oneMdnsService.port})",
          "model": Gateway.modelName,
          "mac": "mac",
          "id": _portService.ip +
              ":" +
              _portService.port.toString(),
          "author": "Farry",
          "email": "newfarry@126.com",
          "home-page": "https://github.com/OpenIoTHub",
          "firmware-respository": "https://github.com/OpenIoTHub/gateway-go",
          "firmware-version": "version",
        });

        oneMdnsService.attributes.forEach((String key, String value) {
          _portService.info[key] = value;
        });
        print("print _portService:$_portService");
        if (!_ServiceMap.containsKey(_portService.info["id"])) {
          setState(() {
            _ServiceMap[_portService.info["id"]!] = _portService;
          });
        }
      });
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
      // services.removeWhere((foundService) => foundService.name == service.name);
    }
  }

  Future<void> stopDiscovery() async {
    if (!_scanning) return;

    setState(() {
      _ServiceMap.clear();
      _scanning = false;
    });
    action!.stop();
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
                child: Icon(Icons.devices, color: Colors.green,),
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
              return Gateway(
                device: pair,
                key: UniqueKey(),
              );
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
        title: Text(OpenIoTHubCommonLocalizations.of(context).find_local_gateway_list),
        actions: <Widget>[
          // IconButton(
          //     icon: Icon(
          //       Icons.refresh,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       _findClientListBymDNS();
          //     }),
          IconButton(
              icon: Icon(
                Icons.add_circle,
                // color: Colors.white,
              ),
              onPressed: () {
                _addGateway();
              }),
          IconButton(
              icon: Icon(
                Icons.info,
                // color: Colors.white,
              ),
              onPressed: () {
                _gatewayGuide();
              }),
        ],
      ),
      body: ListView(children: divided),
    );
  }

  Future<void> _gatewayGuide() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return GatewayGuidePage(
        key: UniqueKey(),
      );
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
                title: Text(OpenIoTHubCommonLocalizations.of(context).manually_create_a_gateway),
                content: SizedBox.expand(
                    child: ListView(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      Text(OpenIoTHubCommonLocalizations.of(context).manually_create_a_gateway_description1),
                      Text(
                          OpenIoTHubCommonLocalizations.of(context).manually_create_a_gateway_description2),
                      Text(
                        OpenIoTHubCommonLocalizations.of(context).manually_create_a_gateway_description3,
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
                )),
                actions: <Widget>[
                  TextButton(
                    child: Text(OpenIoTHubCommonLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(OpenIoTHubCommonLocalizations.of(context).add),
                    onPressed: () async {
                      // 从服务器自动生成一个网关
                      // TODO 选择服务器
                      GatewayInfo gatewayInfo =
                          await GatewayManager.GenerateOneGatewayWithServerUuid(
                              value!);
                      await _addToMySessionList(gatewayInfo.openIoTHubJwt,
                          gatewayInfo.name, gatewayInfo.description);
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
                      showToast(OpenIoTHubCommonLocalizations.of(context).paste_info);
                      Navigator.of(context).pop();
                    },
                  )
                ]);
          });
        });
  }

  Future _addToMySessionList(String token, name, description) async {
    SessionConfig config = SessionConfig();
    config.token = token;
    config.name = name;
    config.description = description;
    try {
      await SessionApi.createOneSession(config);
      showToast(OpenIoTHubCommonLocalizations.of(context).add_gateway_success);
    } catch (exception) {
      showToast("${OpenIoTHubCommonLocalizations.of(context).login_failed}：${exception}");
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
