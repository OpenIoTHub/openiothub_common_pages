import 'package:flutter/material.dart';
import 'package:openiothub_constants/openiothub_constants.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    Key key,
    this.title,
  }) : super(key: key);
  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
//  New
  final TextEditingController _grpcServiceHost = TextEditingController(text: Config.webgRpcIp);
  final TextEditingController _grpcServicePort = TextEditingController(text: Config.webgRpcPort.toString());

  final TextEditingController _iotManagerGrpcServiceHost = TextEditingController(text: Config.iotManagergRpcIp);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: _grpcServiceHost,
                  decoration: InputDecoration(labelText: 'grpc服务的IP或者域名'),
                  onChanged: (String v) {
                    Config.webgRpcIp = v;
                  },
                ),
                TextField(
                  controller: _grpcServicePort,
                  decoration: InputDecoration(labelText: 'grpc服务的端口'),
                  onChanged: (String v) {
                    Config.webgRpcPort = int.parse(v);
                  },
                ),
                TextField(
                  controller: _iotManagerGrpcServiceHost,
                  decoration: InputDecoration(labelText: 'iot-manager grpc服务地址'),
                  onChanged: (String v) {
                    Config.iotManagergRpcIp = v;
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
