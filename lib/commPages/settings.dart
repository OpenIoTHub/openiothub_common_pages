import 'package:flutter/material.dart';
import 'package:openiothub_constants/constants/Config.dart';

class SmartConfigTool extends StatefulWidget {
  SmartConfigTool({
    Key key,
    this.title,
  }) : super(key: key);
  final String title;

  @override
  _SmartConfigToolState createState() => _SmartConfigToolState();
}

class _SmartConfigToolState extends State<SmartConfigTool> {
//  New
  final TextEditingController _grpcServiceHost = TextEditingController(text: Config.webgRpcIp);
  final TextEditingController _grpcServicePort = TextEditingController(text: Config.webgRpcPort.toString());

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
              mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
          ),
        ));
  }
}
