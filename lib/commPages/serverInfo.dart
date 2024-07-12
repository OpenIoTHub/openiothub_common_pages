import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_grpc_api/proto/manager/serverManager.pb.dart';

class ServerInfoPage extends StatefulWidget {
  ServerInfoPage({required Key key, required this.serverInfo})
      : super(key: key);

  final ServerInfo serverInfo;

  @override
  _ServerInfoPageState createState() => _ServerInfoPageState();
}

class _ServerInfoPageState extends State<ServerInfoPage> {
  bool _is_public = false;

  @override
  void initState() {
    _is_public = widget.serverInfo.isPublic;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // string Uuid = 1;
    // TextEditingController _uuid_controller = TextEditingController.fromValue(
    //     TextEditingValue(text: widget.serverInfo.uuid));
    // string Name = 2;
    TextEditingController _name_controller = TextEditingController.fromValue(
        TextEditingValue(text: widget.serverInfo.name));
    // string ServerHost = 3;
    TextEditingController _server_host_controller =
        TextEditingController.fromValue(
            TextEditingValue(text: widget.serverInfo.serverHost));
    // string LoginKey = 4;
    TextEditingController _login_key_controller =
        TextEditingController.fromValue(
            TextEditingValue(text: widget.serverInfo.loginKey));
    // int32 TcpPort = 5;
    TextEditingController _tcp_port_controller =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.tcpPort}"));
    // int32 KcpPort = 6;
    TextEditingController _kcp_port_controller =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.kcpPort}"));
    // int32 UdpApiPort = 7;
    TextEditingController _udp_api_port_controller =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.udpApiPort}"));
    // int32 KcpApiPort = 8;
    TextEditingController _kcp_api_port_controller =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.kcpApiPort}"));
    // int32 TlsPort = 9;
    TextEditingController _tls_port_controller =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.tlsPort}"));
    // int32 GrpcPort = 10;
    TextEditingController _grpc_port_controller =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.grpcPort}"));
    // string Description = 11;
    TextEditingController _description_controller =
        TextEditingController.fromValue(
            TextEditingValue(text: "${widget.serverInfo.description}"));
    // bool IsPublic = 12;

    List<Widget> tiles = <Widget>[
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
                setState(() {
                  _is_public = newVal;
                });
              })
        ],
      ),
      TextButton(
          onPressed: () {
            ServerInfo serverInfo = ServerInfo();
            serverInfo.uuid = widget.serverInfo.uuid;
            serverInfo.name = _name_controller.text;
            serverInfo.serverHost = _server_host_controller.text;
            serverInfo.loginKey = _login_key_controller.text;
            serverInfo.tcpPort = int.parse(_tcp_port_controller.text);
            serverInfo.kcpPort = int.parse(_kcp_port_controller.text);
            serverInfo.udpApiPort = int.parse(_udp_api_port_controller.text);
            serverInfo.kcpApiPort = int.parse(_kcp_api_port_controller.text);
            serverInfo.tlsPort = int.parse(_tls_port_controller.text);
            serverInfo.grpcPort = int.parse(_grpc_port_controller.text);
            serverInfo.description = _description_controller.text;
            serverInfo.isPublic = _is_public;
            ServerManager.UpdateServer(serverInfo)
                .then((value) => showToast("更新成功！"));
          },
          child: Text("确认修改")),
    ];
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(title: Text("服务器信息"), actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              ServerManager.DelServer(widget.serverInfo)
                  .then((value) => showToast("删除成功！"))
                  .then((value) => Navigator.of(context).pop());
            }),
      ]),
      body: ListView(children: divided),
    );
  }
}
