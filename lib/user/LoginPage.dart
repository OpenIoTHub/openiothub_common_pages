import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iot_manager_grpc_api/pb/userManager.pb.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/commPages/feedback.dart';
import 'package:openiothub_common_pages/commPages/privacyPolicy.dart';
import 'package:openiothub_common_pages/user/RegisterPage.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_kit/wechat_kit.dart';

class LoginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LoginPage> {
  late StreamSubscription<WechatAuthResp> _auth;
  List<Widget> _list = <Widget>[];

//  New
  final TextEditingController _usermobile = TextEditingController(text: "");
  final TextEditingController _userpassword = TextEditingController(text: "");

  Future<void> _listenAuth(WechatAuthResp resp) async {
    if (resp.errorCode == 0) {
      UserLoginResponse userLoginResponse =
          await UserManager.LoginWithWechatCode(resp.code!);
      await _handleLoginResp(userLoginResponse);
    } else {
      Fluttertoast.showToast(msg: "微信登录失败:${resp.errorMsg}");
    }
  }

  @override
  void initState() {
    if (_auth == null) {
      _auth = Wechat.instance.authResp().listen(_listenAuth);
    }
    _initList();
    super.initState();
    _checkWechat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("登录"),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _list,
            ),
          ),
        ));
  }

  Future<void> _initList() async {
    _list = <Widget>[
      TextField(
        controller: _usermobile,
        decoration: InputDecoration(labelText: '手机号'),
        onChanged: (String v) {},
      ),
      TextField(
        controller: _userpassword,
        decoration: InputDecoration(labelText: '用户密码'),
        obscureText: true,
        onChanged: (String v) {},
      ),
      TextButton(
          child: Text('登录'),
          onPressed: () async {
            LoginInfo loginInfo = LoginInfo();
            loginInfo.userMobile = _usermobile.text;
            loginInfo.password = _userpassword.text;
            UserLoginResponse userLoginResponse =
                await UserManager.LoginWithUserLoginInfo(loginInfo);
            await _handleLoginResp(userLoginResponse);
          }),
      TextButton(
          child: Text('注册用户'),
          onPressed: () async {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => RegisterPage()));
          }),
      Row(
        children: [
          TextButton(
              child: Text('隐私政策', style: TextStyle(color: Colors.red),),
              onPressed: () async {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PrivacyPolicyPage(key: UniqueKey(),)));
              }),
          TextButton(
              child: Text('反馈渠道', style: TextStyle(color: Colors.green),),
              onPressed: () async {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FeedbackPage(key: UniqueKey(),)));
              }),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    ];
  }

  Future<void> _checkWechat() async {
    if (await Wechat.instance.isInstalled()) {
      setState(() {
        _list.add(IconButton(
            icon: Image.asset(
              'assets/images/wechat.png',
              package: "openiothub_common_pages",
            ),
            onPressed: () async {
              Wechat.instance.auth(
                scope: <String>[WechatScope.SNSAPI_USERINFO],
                state: 'auth',
              );
            }));
      });
    }
  }

  Future<void> _handleLoginResp(UserLoginResponse userLoginResponse) async {
    if (userLoginResponse.code == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          SharedPreferencesKey.USER_TOKEN_KEY, userLoginResponse.token);
      await prefs.setString(
          SharedPreferencesKey.USER_NAME_KEY, userLoginResponse.userInfo.name);
      await prefs.setString(SharedPreferencesKey.USER_EMAIL_KEY,
          userLoginResponse.userInfo.email);
      await prefs.setString(SharedPreferencesKey.USER_MOBILE_KEY,
          userLoginResponse.userInfo.mobile);
      await prefs.setString(SharedPreferencesKey.USER_AVATAR_KEY,
          userLoginResponse.userInfo.avatar);
      Future.delayed(Duration(milliseconds: 500), () {
        UtilApi.SyncConfigWithToken();
      });
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(msg: "登录失败:${userLoginResponse.msg}");
    }
  }
}
