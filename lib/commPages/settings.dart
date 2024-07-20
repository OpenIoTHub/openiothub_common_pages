import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    required Key key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool foreground = false;

//  New
  final TextEditingController _grpcServiceHost =
      TextEditingController(text: Config.webgRpcIp);
  final TextEditingController _grpcServicePort =
      TextEditingController(text: Config.webgRpcPort.toString());

  final TextEditingController _iotManagerGrpcServiceHost =
      TextEditingController(text: Config.iotManagerGrpcIp);

  @override
  Widget build(BuildContext context) {
    List<Widget> listView = <Widget>[
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
          Config.iotManagerGrpcIp = v;
        },
      ),
    ];
    if (Platform.isAndroid) {
      listView.add(ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("开启前台服务", style: Constants.titleTextStyle),
          ],
        ),
        trailing: Switch(
          onChanged: (bool newValue) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool("foreground", newValue);
            setState(() {
              foreground = newValue;
            });
          },
          value: foreground,
          activeColor: Colors.green,
          inactiveThumbColor: Colors.red,
        ),
      ));
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: listView,
            ),
          ),
        ));
  }

  @override
  void initState() {
    _initConfig();
    super.initState();
  }

  Future<void> _initConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await prefs.containsKey("foreground")) {
      setState(() async {
        foreground = (await prefs.getBool("foreground"))!;
      });
    } else {
      prefs.setBool("foreground", false);
    }
  }
}
