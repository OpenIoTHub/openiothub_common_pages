import 'dart:async';

import 'package:airkiss/airkiss.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class Airkiss extends StatefulWidget {
  Airkiss({Key key, this.title, this.needCallBack}) : super(key: key);

  final String title;
  final bool needCallBack;

  @override
  _AirkissState createState() => _AirkissState();
}

class _AirkissState extends State<Airkiss> {
  final int _smartConfigTypeNumber = 1;
  int _smartConfigRemainNumber;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

//  New
  final TextEditingController _bssidFilter = TextEditingController();
  final TextEditingController _ssidFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();

  bool _isLoading = false;

  String _ssid = "";
  String _bssid = "";
  String _password = "";
  String _msg = "上面输入wifi密码开始设置设备联网";

  _AirkissState() {
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
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    await requestPermission();
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    _updateConnectionStatus(result);
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
                              value: _smartConfigTypeNumber ==
                                      _smartConfigRemainNumber
                                  ? 0.1
                                  : (_smartConfigTypeNumber -
                                          _smartConfigRemainNumber) /
                                      _smartConfigTypeNumber,
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
                        Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                              Text("设备配网"),
                              TextField(
                                controller: _ssidFilter,
                                decoration: InputDecoration(labelText: 'ssid'),
                              ),
                              TextField(
                                controller: _bssidFilter,
                                decoration: InputDecoration(labelText: 'bssid'),
                              ),
                            ])),
                        Container(
                          child: TextField(
                            controller: _passwordFilter,
                            decoration: InputDecoration(labelText: 'Wifi密码'),
                            obscureText: true,
                          ),
                        ),
                        TextButton(
                          child: Text('开始添加周围智能设备'),
                          onPressed: () async {
                            setState(() {
                              _smartConfigRemainNumber = _smartConfigTypeNumber;
                              _isLoading = true;
                              _msg = "正在发现设备，请耐心等待，大概需要一分钟";
                            });
                            //由于微信AirKiss配网和汉枫SmartLink都是使用本地的UDP端口10000进行监听所以，先进行AirKiss然后进行SmartLink
                            await _configureAirKiss().then((v) {
                              _checkResult();
                              if (v) {
                                setState(() {
                                  _isLoading = false;
                                });
                                if (widget.needCallBack) {
                                  Navigator.of(context).pop();
                                }
                                return;
                              }
                            });
                            if (widget.needCallBack) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                        Container(height: 10),
                        Text(_msg),
                      ],
                    ))));
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        String wifiName, wifiBSSID, wifiIP;

        try {
          wifiName = await WifiInfo().getWifiName();
        } on PlatformException catch (e) {
          print(e.toString());
          wifiName = "Failed to get Wifi Name";
        }

        try {
          wifiBSSID = await WifiInfo().getWifiBSSID();
        } on PlatformException catch (e) {
          print(e.toString());
          wifiBSSID = "Failed to get Wifi BSSID";
        }

        try {
          wifiIP = await WifiInfo().getWifiIP();
        } on PlatformException catch (e) {
          print(e.toString());
          wifiIP = "Failed to get Wifi IP";
        }

        setState(() {
          _ssidFilter.text = wifiName;
          _bssidFilter.text = wifiBSSID;

          _msg = "输入路由器WIFI(2.4G频率)密码后开始配网";
        });
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        Fluttertoast.showToast(msg: "请将手机连接到智能设备需要连接的wifi路由器上");
        break;
      default:
        break;
    }
  }

  Future<bool> requestPermission() async {
    // 申请权限
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([
      PermissionGroup.location,
    ]);
    // 申请结果
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.granted) {
      return true;
    } else {
//      提示失败！
      return false;
    }
  }

  Future<bool> _configureAirKiss() async {
    String output = "Unknown";
    try {
      AirkissOption option = AirkissOption();
      option.timegap = 1000;
      option.trycount = 20;
      AirkissConfig ac = AirkissConfig(option: option);
      AirkissResult v = await ac.config(_ssid, _password);
      setState(() {
        _msg =
            "附近的AirKiss设备配网任务完成${v.toString()}，\n当前剩下：${_smartConfigRemainNumber - 1}种设备的配网任务";
      });
      if (v != null) {
        return true;
      }
    } on PlatformException catch (e) {
      output = "Failed to configure: '${e.message}'.";
      setState(() {
        _msg = output;
      });
    }
    return false;
  }

  Future<void> _checkResult() async {
    _smartConfigRemainNumber--;
    if (_smartConfigRemainNumber == 0) {
      setState(() {
        _isLoading = false;
        _msg = "全部设备发现完成";
      });
    }
  }
}
