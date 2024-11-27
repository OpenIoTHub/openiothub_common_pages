import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_oneshot/flutter_oneshot.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_common_pages/wifiConfig/permission.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class Oneshot extends StatefulWidget {
  Oneshot({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  _OneshotState createState() => _OneshotState();
}

class _OneshotState extends State<Oneshot> {
  bool _privilege_required = false;
  final NetworkInfo _networkInfo = NetworkInfo();

//  New
  final TextEditingController _bssidFilter =
      TextEditingController(text: "点击获取WiFi信息");
  final TextEditingController _ssidFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();

  bool _isLoading = false;

  String? _ssid;
  String? _bssid;
  String? _password;
  String _msg = "上面输入wifi密码开始设置设备联网";

  _OneshotState() {
    _ssidFilter.addListener(_ssidListen);
    _passwordFilter.addListener(_passwordListen);
    _bssidFilter.addListener(_bssidListen);
  }

  void _ssidListen() {
    if (_ssidFilter.text.isEmpty) {
      _ssid = "";
    } else {
      _ssid = _ssidFilter.text;
    }
  }

  void _bssidListen() {
    if (_bssidFilter.text.isEmpty) {
      _bssid = "";
    } else {
      _bssid = _bssidFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: _isLoading
                ? Container(
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            LinearProgressIndicator(
                              value: 0.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.lightBlue),
                            ),
                            Container(
                              height: 60.0,
                            ),
                            Text(
                                "正在设置设备连接到路由器：\n\n${_ssid}(BSSID:${_bssid})\n\n$_msg"),
                          ]),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  )
                : Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(height: 10),
                        GestureDetector(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text("设备配网"),
                                TextField(
                                  controller: _ssidFilter,
                                  decoration:
                                      InputDecoration(labelText: 'WiFi名称'),
                                  readOnly: true,
                                ),
                                TextField(
                                  controller: _bssidFilter,
                                  decoration:
                                      InputDecoration(labelText: 'BSSID'),
                                  readOnly: true,
                                ),
                              ]),
                          onTap: () async {
                            await requestPermission();
                            await _updateConnectionStatus();
                          },
                        ),
                        Container(
                          child: TextField(
                            controller: _passwordFilter,
                            decoration: InputDecoration(labelText: '输入WiFi密码'),
                            obscureText: true,
                          ),
                        ),
                        TextButton(
                          child: _privilege_required
                              ? Text('开始添加周围智能设备')
                              : Text('获取网络和位置权限以获取WiFi信息'),
                          onPressed: () async {
                            if (_ssid == null || _password == null) {
                              showToast("WiFi信息不能为空");
                              return;
                            }
                            setState(() {
                              _isLoading = true;
                              _msg = "正在发现设备，请耐心等待，大概需要一分钟";
                            });
                            //由于微信AirKiss配网和汉枫SmartLink都是使用本地的UDP端口10000进行监听所以，先进行AirKiss然后进行SmartLink
                            await _configureWiFi();
                          },
                        ),
                        Container(height: 10),
                        Text(_msg),
                      ],
                    ))));
  }

  Future<void> _updateConnectionStatus() async {
    String? wifiName, wifiBSSID;

    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        // Request permissions as recommended by the plugin documentation:
        // https://github.com/fluttercommunity/plus_plugins/tree/main/packages/network_info_plus/network_info_plus
        if (await Permission.locationWhenInUse.request().isGranted) {
          wifiName = await _networkInfo.getWifiName();
        } else {
          wifiName = 'Unauthorized to get Wifi Name';
        }
      } else {
        wifiName = await _networkInfo.getWifiName();
      }
    } on PlatformException catch (e) {
      wifiName = 'Failed to get Wifi Name';
    }

    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        // Request permissions as recommended by the plugin documentation:
        // https://github.com/fluttercommunity/plus_plugins/tree/main/packages/network_info_plus/network_info_plus
        if (await Permission.locationWhenInUse.request().isGranted) {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        } else {
          wifiBSSID = 'Unauthorized to get Wifi BSSID';
        }
      } else {
        wifiName = await _networkInfo.getWifiName();
      }
    } on PlatformException catch (e) {
      wifiBSSID = 'Failed to get Wifi BSSID';
    }

    setState(() {
      _ssidFilter.text = wifiName!;
      _bssidFilter.text = wifiBSSID!;

      _msg = "输入路由器WIFI(2.4G频率)密码后开始配网";
    });
  }

  Future<void> _configureWiFi() async {
    String output = "Unknown";
    try {
      await FlutterOneshot.start(_ssid!, _password!, 20).then((v) {
        setState(() {
          _isLoading = false;
          _msg = "附近的OneShot设备配网任务完成";
        });
      });
    } on PlatformException catch (e) {
      output = "Failed to configure: '${e.message}'.";
      setState(() {
        _isLoading = false;
        _msg = output;
      });
    }
  }
}
