import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AppInfoPage extends StatefulWidget {
  AppInfoPage({Key key}) : super(key: key);

  @override
  _AppInfoPageState createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  //APP名称
  String appName;

  //包名
  String packageName;

  //版本名
  String version;

  //版本号
  String buildNumber;

  @override
  void initState() {
    super.initState();
    _getAppInfo();
  }

  @override
  Widget build(BuildContext context) {
    final List _result = [];
    _result.add("App名称:$appName");
    _result.add("包名:$packageName");
    _result.add("版本:$version");
    _result.add("版本号:$buildNumber");

    final tiles = _result.map(
      (pair) {
        return ListTile(
          title: Text(
            pair,
          ),
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("App信息"),
      ),
      body: ListView(children: divided),
    );
  }

  _getAppInfo() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appName = packageInfo.appName;
        packageName = packageInfo.packageName;
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    });
  }
}
