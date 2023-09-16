import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iot_manager_grpc_api/pb/serverManager.pb.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/commPages/serverInfo.dart';
import 'package:openiothub_constants/constants/Constants.dart';

class ServerPages extends StatefulWidget {
  ServerPages({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  createState() => ServerPagesState();
}

class ServerPagesState extends State<ServerPages> {
  List<ServerInfo> _availableServerList = [];

  @override
  Future<void> initState() async {
    _listMyServers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _availableServerList.map(
      (pair) {
        var listItemContent = Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: Icon(Icons.send_rounded),
              ),
              Expanded(
                  child: Text(
                "${pair.name}(${pair.serverHost})",
                style: Constants.titleTextStyle,
              )),
              Constants.rightArrowIcon
            ],
          ),
        );
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ServerInfoPage(
                serverInfo: pair,
                key: UniqueKey(),
              );
            })).then((value) => _listMyServers());
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
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  //刷新端口列表
                  _listMyServers();
                }),
            IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  //刷新端口列表
                  _addMyServer();
                }),
          ],
        ),
        body: ListView(
          children: divided,
        ));
  }

  void _listMyServers() {
    ServerManager.GetAllMyServers()
        .then((ServerInfoList serverInfoList) => setState(() {
              _availableServerList = serverInfoList.serverInfoList;
            }));
  }

  Future<void> _addMyServer() async {
    // string Uuid = 1;
    TextEditingController _uuid_controller =
        TextEditingController.fromValue(TextEditingValue(text: getOneUUID()));
    // string Name = 2;
    TextEditingController _name_controller = TextEditingController.fromValue(
        TextEditingValue(text: "我自己的server-go服务器"));
    // string ServerHost = 3;
    TextEditingController _server_host_controller =
        TextEditingController.fromValue(
            TextEditingValue(text: "guonei.nat-cloud.com"));
    // string LoginKey = 4;
    TextEditingController _login_key_controller =
        TextEditingController.fromValue(TextEditingValue(text: getOneUUID()));
    // int32 TcpPort = 5;
    TextEditingController _tcp_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: "34320"));
    // int32 KcpPort = 6;
    TextEditingController _kcp_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: "34320"));
    // int32 UdpApiPort = 7;
    TextEditingController _udp_api_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: "34321"));
    // int32 KcpApiPort = 8;
    TextEditingController _kcp_api_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: "34322"));
    // int32 TlsPort = 9;
    TextEditingController _tls_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: "34321"));
    // int32 GrpcPort = 10;
    TextEditingController _grpc_port_controller =
        TextEditingController.fromValue(TextEditingValue(text: "34322"));
    // string Description = 11;
    TextEditingController _description_controller =
        TextEditingController.fromValue(TextEditingValue(text: "我的服务器的描述"));
    // bool IsPublic = 12;
    bool _is_public = false;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return AlertDialog(
                  title: Text("添加自建服务器："),
                  content: ListView(
                    children: <Widget>[
                      TextFormField(
                        controller: _uuid_controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: '服务器uuid',
                          helperText: '跟server-go服务器里面的配置文件一致',
                        ),
                      ),
                      TextFormField(
                        controller: _name_controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: '名称',
                          helperText: '自定义服务器名称',
                        ),
                      ),
                      TextFormField(
                        controller: _server_host_controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: '服务器ip地址或者域名',
                          helperText: '公网server-go服务器的地址',
                        ),
                      ),
                      TextFormField(
                        controller: _login_key_controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'login_key',
                          helperText: '秘钥',
                        ),
                      ),
                      TextFormField(
                        controller: _tcp_port_controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'tcp_port',
                          helperText: 'tcp端口',
                        ),
                      ),
                      TextFormField(
                        controller: _kcp_port_controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'kcp_port',
                          helperText: 'kcp端口',
                        ),
                      ),
                      TextFormField(
                        controller: _udp_api_port_controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'udp_api_port',
                          helperText: '端口',
                        ),
                      ),
                      TextFormField(
                        controller: _kcp_api_port_controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'kcp_api_port',
                          helperText: '端口',
                        ),
                      ),
                      TextFormField(
                        controller: _tls_port_controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'tls_port',
                          helperText: '端口',
                        ),
                      ),
                      TextFormField(
                        controller: _grpc_port_controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'grpc_port',
                          helperText: '端口',
                        ),
                      ),
                      TextFormField(
                        controller: _description_controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: '描述',
                          helperText: '自定义描述信息',
                        ),
                      ),
                      Row(
                        children: [
                          Text("提供给APP所有人使用:"),
                          Switch(
                              value: _is_public,
                              onChanged: (bool newVal) {
                                state(() {
                                  _is_public = newVal;
                                });
                              })
                        ],
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("添加到服务器"),
                      onPressed: () {
                        ServerInfo serverInfo = ServerInfo();
                        serverInfo.uuid = _uuid_controller.text;
                        serverInfo.name = _name_controller.text;
                        serverInfo.serverHost = _server_host_controller.text;
                        serverInfo.loginKey = _login_key_controller.text;
                        serverInfo.tcpPort =
                            int.parse(_tcp_port_controller.text);
                        serverInfo.kcpPort =
                            int.parse(_kcp_port_controller.text);
                        serverInfo.udpApiPort =
                            int.parse(_udp_api_port_controller.text);
                        serverInfo.kcpApiPort =
                            int.parse(_kcp_api_port_controller.text);
                        serverInfo.tlsPort =
                            int.parse(_tls_port_controller.text);
                        serverInfo.grpcPort =
                            int.parse(_grpc_port_controller.text);
                        serverInfo.description = _description_controller.text;
                        serverInfo.isPublic = _is_public;
                        ServerManager.AddServer(serverInfo)
                            .then((value) => Fluttertoast.showToast(
                                msg: "添加服务器(${_name_controller.text})成功!"))
                            .then((value) => Navigator.of(context).pop())
                            .then((value) => _listMyServers());
                      },
                    )
                  ]);
            },
          );
        });
  }
}
