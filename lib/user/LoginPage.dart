import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/commPages/feedback.dart';
import 'package:openiothub_common_pages/user/RegisterPage.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/manager/userManager.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
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
    _initList().then((value) => _checkWechat());
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
    setState(() {
      _list = <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0), // 设置顶部距离
          child: TDInput(
            controller: _usermobile,
            leftLabel: "手机号",
            hintText: '请输入手机号',
            onChanged: (String v) {},
          ),
        ),
        TDInput(
          controller: _userpassword,
          leftLabel: "用户密码",
          hintText: '请输入用户密码',
          obscureText: true,
          onChanged: (String v) {},
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0), // 设置顶部距离
          child: Row(
            children: [
              TDButton(
                  icon: TDIcons.login,
                  text: '登陆',
                  size: TDButtonSize.medium,
                  type: TDButtonType.outline,
                  shape: TDButtonShape.rectangle,
                  theme: TDButtonTheme.primary,
                  onTap: () async {
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
              TDButton(
                  icon: TDIcons.user,
                  text: '注册用户',
                  size: TDButtonSize.medium,
                  type: TDButtonType.outline,
                  shape: TDButtonShape.rectangle,
                  theme: TDButtonTheme.light,
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterPage()));
                  }),
            ],
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: _isChecked,
              onChanged: (bool? newValue) {
                setState(() {
                  _isChecked = newValue!;
                  _initList().then((value) => _checkWechat());
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
    });
  }

  Future<void> _checkWechat() async {
    if (await WechatKitPlatform.instance.isInstalled()) {
      setState(() {
        // TODO 在pc上使用二维码扫码登录，可以使用网页一套Api
        _list.add(IconButton(
            icon: Icon(
              TDIcons.logo_wechat,
              color: Colors.green,
              size: 60,
            ),
            style: ButtonStyle(
              fixedSize: const WidgetStatePropertyAll<Size>(Size(70, 70)),
            ),
            onPressed: () async {
              // 只有同意隐私政策才可以进行下一步
              if (!_isChecked) {
                showToast("请勾选☑️下述同意隐私政策才可以进行下一步");
                return;
              }
              WechatKitPlatform.instance.auth(
                scope: <String>[WechatScope.kSNSApiUserInfo],
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
      showToast(
          "登录失败:code:${userLoginResponse.code},message:${userLoginResponse.msg}");
    }
  }
}
