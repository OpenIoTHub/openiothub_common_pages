import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/commPages/feedback.dart';
import 'package:openiothub_common_pages/user/RegisterPage.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/manager/userManager.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_kit/wechat_kit.dart';

import '../utils/goToUrl.dart';

class LoginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LoginPage> {
  // 是否已经同意隐私政策
  bool _isChecked = false;
  StreamSubscription<WechatResp>? _auth;
  List<Widget> _list = <Widget>[];

//  New
  final TextEditingController _usermobile = TextEditingController(text: "");
  final TextEditingController _userpassword = TextEditingController(text: "");

  Future<void> _listenAuth(WechatResp resp) async {
    if (resp.errorCode == 0 && resp is WechatAuthResp) {
      UserLoginResponse userLoginResponse =
          await UserManager.LoginWithWechatCode(resp.code!);
      await _handleLoginResp(userLoginResponse);
    } else {
      showToast("微信登录失败:${resp.errorMsg}");
    }
  }

  @override
  void initState() {
    if (_auth == null) {
      _auth = WechatKitPlatform.instance.respStream().listen(_listenAuth);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _initList();
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
            // 只有同意隐私政策才可以进行下一步
            if (!_isChecked) {
              showToast("请勾选☑️下述同意隐私政策才可以进行下一步");
              return;
            }
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
          Checkbox(
            value: _isChecked,
            onChanged: (bool? newValue) {
              setState(() {
                _isChecked = newValue!;
              });
            },
            activeColor: Colors.green, // 选中时的颜色
            checkColor: Colors.white, // 选中标记的颜色
          ),
          Text("同意"),
          TextButton(
              // TODO 勾选才可以下一步
              child: Text(
                '隐私政策',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                goToURL(
                    context,
                    "https://docs.iothub.cloud/privacyPolicy/index.html",
                    "隐私政策");
              }),
          TextButton(
              child: Text(
                '反馈渠道',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FeedbackPage(
                          key: UniqueKey(),
                        )));
              }),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    ];
    if (await WechatKitPlatform.instance.isInstalled()) {
      _list.add(IconButton(
          icon: Image.asset(
            'assets/images/wechat.png',
            package: "openiothub_common_pages",
          ),
          style: ButtonStyle(
            fixedSize: const MaterialStatePropertyAll<Size>(Size(60, 60)),
          ),
          onPressed: () async {
            // 只有同意隐私政策才可以进行下一步
            if (!_isChecked) {
              showToast("请勾选☑️上述同意隐私政策才可以进行下一步");
              return;
            }
            WechatKitPlatform.instance.auth(
              scope: <String>[WechatScope.kSNSApiUserInfo],
              state: 'auth',
            );
          }));
    }
    setState(() {

    });
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
      showToast(
          "登录失败:code:${userLoginResponse.code},message:${userLoginResponse.msg}");
    }
  }
}
