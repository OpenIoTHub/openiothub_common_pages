import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/user/LoginPage.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/userManager.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_kit/wechat_kit.dart';

class AccountSecurityPage extends StatefulWidget {
  @override
  _AccountSecurityPageState createState() => _AccountSecurityPageState();
}

class _AccountSecurityPageState extends State<AccountSecurityPage> {
  StreamSubscription<WechatResp>? _auth;
  List<Widget> _list = <Widget>[];
  String username = "";
  String usermobile = "";
  String useremail = "";

  Future<void> _listenAuth(WechatResp resp) async {
    if (resp.errorCode == 0 && resp is WechatAuthResp) {
      OperationResponse operationResponse =
          await UserManager.BindWithWechatCode(resp.code!);
      if (operationResponse.code == 0) {
        showToast("绑定微信成功！");
      } else {
        showToast("绑定微信失败:${operationResponse.msg}");
      }
    } else {
      showToast("获取微信登录信息失败:${resp.errorMsg}");
    }
  }

  @override
  void initState() {
    if (_auth == null) {
      _auth = WechatKitPlatform.instance.respStream().listen(_listenAuth);
    }
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("账号与安全"),
        ),
        body: ListView(children: <Widget>[
          ListTile(
              //第一个功能项
              title: Text('用户名：$username'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                _modifyInfo("用户名");
              }),
          ListTile(
              //第一个功能项
              title: Text('手机号：$usermobile'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                _modifyInfo("手机号");
              }),
          ListTile(
              //第一个功能项
              title: Text('邮箱：$useremail'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                _modifyInfo("邮箱");
              }),
          ListTile(
              //第一个功能项
              title: Text('修改密码'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                _modifyInfo("密码");
              }),
          ListTile(
              //绑定微信
              title: Text('绑定微信'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                if (await WechatKitPlatform.instance.isInstalled()) {
                  WechatKitPlatform.instance.auth(
                    scope: <String>[WechatScope.kSNSApiUserInfo],
                    state: 'auth',
                  );
                } else {
                  showToast("只有安装了微信才能绑定微信");
                }
              }),
          ListTile(
              //解绑微信
              title: Text('解除微信绑定'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                UserManager.UnbindWechat()
                    .then((OperationResponse operationResponse) {
                  if (operationResponse.code == 0) {
                    showToast("解绑微信成功！");
                  } else {
                    showToast("解绑微信失败！原因：${operationResponse.msg}");
                  }
                });
              }),
          ListTile(
              //注销账号
              title: Text(
                '注销账号',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                // 删除账号操作，删除账号时需要输入自己的密码进行确认
                _delete_my_account();
              }),
        ]));
  }

  Future<void> _getUserInfo() async {
    bool b = await userSignedIn();
    if (!b) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
    }
    //从网络同步一遍到本地
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserInfo userInfo = await UserManager.GetUserInfo();
    await prefs.setString(SharedPreferencesKey.USER_NAME_KEY, userInfo.name);
    await prefs.setString(SharedPreferencesKey.USER_EMAIL_KEY, userInfo.email);
    await prefs.setString(
        SharedPreferencesKey.USER_MOBILE_KEY, userInfo.mobile);
    await prefs.setString(
        SharedPreferencesKey.USER_AVATAR_KEY, userInfo.avatar);
    if (prefs.containsKey(SharedPreferencesKey.USER_NAME_KEY)) {
      setState(() {
        username = prefs.getString(SharedPreferencesKey.USER_NAME_KEY)!;
      });
    } else {
      setState(() {
        username = "";
      });
    }
    if (prefs.containsKey(SharedPreferencesKey.USER_EMAIL_KEY)) {
      setState(() {
        useremail = prefs.getString(SharedPreferencesKey.USER_EMAIL_KEY)!;
      });
    } else {
      setState(() {
        useremail = "";
      });
    }
    if (prefs.containsKey(SharedPreferencesKey.USER_MOBILE_KEY)) {
      setState(() {
        usermobile = prefs.getString(SharedPreferencesKey.USER_MOBILE_KEY)!;
      });
    } else {
      setState(() {
        usermobile = "";
      });
    }
  }

  Future<void> _modifyInfo(String type) async {
    TextEditingController _new_value_controller =
        TextEditingController.fromValue(TextEditingValue(text: ""));
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("修改：$type"),
                scrollable: true,
                content: SizedBox.expand(
                    child: ListView(
                  children: <Widget>[
                    TextField(
                      controller: _new_value_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '请输入新的$type',
                        helperText: '新值',
                      ),
                      obscureText: type == "密码",
                    ),
                  ],
                )),
                actions: <Widget>[
                  TextButton(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("修改"),
                    onPressed: () async {
                      StringValue stringValue = StringValue();
                      stringValue.value = _new_value_controller.text;
                      switch (type) {
                        case "用户名":
                          OperationResponse operationResponse =
                              await UserManager.UpdateUserNanme(stringValue);
                          break;
                        case "手机号":
                          OperationResponse operationResponse =
                              await UserManager.UpdateUserMobile(stringValue);
                          break;
                        case "邮箱":
                          OperationResponse operationResponse =
                              await UserManager.UpdateUserEmail(stringValue);
                          break;
                        case "密码":
                          OperationResponse operationResponse =
                              await UserManager.UpdateUserPassword(stringValue);
                          break;
                      }
                      Navigator.of(context).pop();
                      _getUserInfo();
                    },
                  )
                ]));
  }

  Future<void> _delete_my_account() async {
    TextEditingController _new_value_controller =
        TextEditingController.fromValue(TextEditingValue(text: ""));
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("删除我的账号"),
                scrollable: true,
                content: SizedBox.expand(
                    child: ListView(
                  children: <Widget>[
                    Text(
                      "请注意，确认删除之后删除操作立马生效，且不可恢复！",
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      "操作不可恢复！",
                      style: TextStyle(color: Colors.red),
                    ),
                    TextField(
                      controller: _new_value_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '请输入你的密码',
                        helperText: '当前账号的密码',
                      ),
                      obscureText: true,
                    ),
                    Text(
                      "操作不可恢复！",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                )),
                actions: <Widget>[
                  TextButton(
                    child: Text("确认删除账号?", style: TextStyle(color: Colors.red)),
                    onPressed: () async {
                      LoginInfo login_info = LoginInfo();
                      login_info.password = _new_value_controller.text;
                      OperationResponse operationResponse =
                          await UserManager.DeleteMyAccount(login_info);
                      if (operationResponse.code == 0) {
                        //删除账号成功
                        showToast("删除账号成功！");
                        Navigator.of(context).pop();
                      } else {
                        showToast("删除账号失败:${operationResponse.msg}");
                      }
                    },
                  ),
                  TextButton(
                    child: Text(
                      "取消",
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]));
  }
}
