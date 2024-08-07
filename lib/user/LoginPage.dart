import 'dart:async';
import 'dart:math';

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
import 'package:dio/dio.dart';

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
  //微信扫码登录随机id
  String? loginFlag;
  late Timer _timer;

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
    _init_timer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
            backgroundColor: Colors.white,
            leftLabel: "手机号",
            hintText: '请输入手机号',
            onChanged: (String v) {},
          ),
        ),
        TDInput(
          controller: _userpassword,
          backgroundColor: Colors.white,
          leftLabel: "用户密码",
          hintText: '请输入用户密码',
          obscureText: true,
          onChanged: (String v) {},
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0), // 设置顶部距离
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    if (_usermobile.text.isEmpty || _userpassword.text.isEmpty) {
                      showToast("用户名与密码不能为空");
                      return;
                    }
                    LoginInfo loginInfo = LoginInfo();
                    loginInfo.userMobile = _usermobile.text;
                    loginInfo.password = _userpassword.text;
                    UserLoginResponse userLoginResponse =
                        await UserManager.LoginWithUserLoginInfo(loginInfo);
                    await _handleLoginResp(userLoginResponse);
                  }),
              Padding(
                padding: const EdgeInsets.only(left: 20.0), // 设置顶部距离
                child: TDButton(
                    icon: TDIcons.user,
                    text: '注册用户',
                    size: TDButtonSize.medium,
                    type: TDButtonType.outline,
                    shape: TDButtonShape.rectangle,
                    theme: TDButtonTheme.defaultTheme,
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterPage()));
                    }),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0), // 设置顶部距离
          child: Row(
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
        )
      ];
    });
  }

  Future<void> _checkWechat() async {
      setState(() {
        // TODO 在pc上使用二维码扫码登录，可以使用网页一套Api
        _list.add(IconButton(
            icon: Icon(
              TDIcons.logo_wechat,
              color: Colors.green,
              size: 45,
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
              // 判断是否安装了微信，安装了微信则打开微信进行登录，否则显示二维码由手机扫描登录
              bool wechatInstalled = false;
              try {
                wechatInstalled = await WechatKitPlatform.instance.isInstalled();
              }on Exception catch (e) {
                wechatInstalled = false;
              }
              if (wechatInstalled) {
                WechatKitPlatform.instance.auth(
                  scope: <String>[WechatScope.kSNSApiUserInfo],
                  state: 'auth',
                );
              }else{
                //显示二维码扫描登录
                loginFlag = generateRandomString(12);
                String qrUrl = await getPicUrl(loginFlag!);
                if (qrUrl=="") {
                  showToast("获取微信登陆二维码失败！");
                  return;
                }
                // 循环获取登录结果
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                        title: Text("微信扫码登录"),
                        content: Image.network(qrUrl),
                        actions: <Widget>[
                          // 分享网关:二维码图片、小程序链接、网页
                          TDButton(
                            icon: TDIcons.fullscreen_exit,
                            text: '退出',
                            size: TDButtonSize.small,
                            type: TDButtonType.outline,
                            shape: TDButtonShape.rectangle,
                            theme: TDButtonTheme.primary,
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ])).then((_)=>{loginFlag = null});
              }
            }));
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

  Future<void> _init_timer() async {
    // 获取扫码登录结果
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (loginFlag !=null && !loginFlag!.isEmpty) {
        String loginRetUrl = "https://${Config.iotManagerHttpIp}/wxLogin/loginOrCreate?clientType=app&loginFlag=$loginFlag";
        final dio = Dio();
        final response = await dio.get(loginRetUrl);
        if (response.data["code"] == 0 &&
            (response.data["data"] as Map<String, dynamic>).containsKey("token") &&
            response.data["data"]["token"] != null &&
            response.data["data"]["token"] != "") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              SharedPreferencesKey.USER_TOKEN_KEY, response.data["data"]["token"]);
          await prefs.setString(
              SharedPreferencesKey.USER_NAME_KEY, response.data["data"]["user"]["nickName"]);
          await prefs.setString(SharedPreferencesKey.USER_EMAIL_KEY,
              response.data["data"]["user"]["email"]);
          await prefs.setString(SharedPreferencesKey.USER_MOBILE_KEY,
              response.data["data"]["user"]["phone"]);
          await prefs.setString(SharedPreferencesKey.USER_AVATAR_KEY,
              response.data["data"]["user"]["headerImg"]);
          Future.delayed(Duration(milliseconds: 500), () {
            UtilApi.SyncConfigWithToken();
          });
          timer.cancel();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }else{
          showToast("请现将本微信绑定一个账号再使用微信快捷登录");
        }
      }
    });
  }
}

String generateRandomString(int length) {
  if (length == 0){
    length = 12;
  }
  const String charset = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
  final Random random = Random();
  String result = '';
  for (var i = 0; i < length; i++) {
    result += charset[random.nextInt(charset.length)];
  }
  return result;
}

Future<String> getPicUrl(String loginFlag) async {
  final dio = Dio();
  late String url;
  String reqUrl = "https://${Config.iotManagerHttpIp}/wxLogin/getLoginPic?loginFlag=$loginFlag";
  final response = await dio.get(reqUrl);
  if (response.data["code"] == 0) {
    String ticket = response.data["data"]["ticket"];
    url = "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=$ticket";
    return url;
  }else{
    return "";
  }
}
