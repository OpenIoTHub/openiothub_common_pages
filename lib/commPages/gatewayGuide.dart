import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GatewayGuidePage extends StatefulWidget {
  const GatewayGuidePage({required Key key}) : super(key: key);

  @override
  _GatewayGuidePageState createState() => _GatewayGuidePageState();
}

class _GatewayGuidePageState extends State<GatewayGuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("网关安装指南"),
        actions: <Widget>[],
      ),
      body: ListView(
        children: [
          Text(
            "这里介绍怎样安装一个自己的网关",
            style: TextStyle(fontSize: 23),
          ),
          Text("首先，你需要将网关安装到你需要访问的局域网持续运行"),
          Text("第一次的时候，将本APP也接入网关所在的局域网"),
          Text("APP在局域网搜索并配置添加网关一次后"),
          Text("以后只要网关在线手机客户端都可以访问"),
          Text(
            "这里介绍如何在你所需要访问的网络安装网关",
            style: TextStyle(fontSize: 23),
          ),
          TextButton(
              onPressed: () {
                _launchURL("https://github.com/OpenIoTHub/gateway-go/releases");
              },
              child: Text("查看网关的开源地址")),
          Text("openwrt路由器snapshot源安装：opkg install gateway-go"),
          Text("MacOS使用homebrew安装：brew install gateway-go"),
          Text("Linux使用snapcraft安装：sudo snap install gateway-go"),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
