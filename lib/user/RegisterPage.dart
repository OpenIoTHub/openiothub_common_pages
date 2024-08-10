import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/userManager.pb.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../utils/goToUrl.dart';

class RegisterPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<RegisterPage> {
  // 是否已经同意隐私政策
  bool _isChecked = false;

//  New
  final TextEditingController _usermobile = TextEditingController(text: "");
  final TextEditingController _userpassword = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("注册"),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TDInput(
                  controller: _usermobile,
                  backgroundColor: Colors.white,
                  leftLabel: "手机号",
                  hintText: '请输入手机号',
                  onChanged: (String v) {},
                ),
                TDInput(
                  controller: _userpassword,
                  backgroundColor: Colors.white,
                  leftLabel: "用户密码",
                  hintText: '请输入用户密码',
                  obscureText: true,
                  onChanged: (String v) {},
                ),
                TDButton(
                    icon: TDIcons.login,
                    text: '注册',
                    size: TDButtonSize.large,
                    type: TDButtonType.outline,
                    shape: TDButtonShape.rectangle,
                    theme: TDButtonTheme.primary,
                    onTap: () async {
                      if (!_isChecked) {
                        showToast("请勾选☑️下述同意隐私政策才可以进行下一步");
                        return;
                      }
                      if (_usermobile.text.isEmpty ||
                          _userpassword.text.isEmpty) {
                        showToast("用户名与密码不能为空");
                        return;
                      }
                      LoginInfo loginInfo = LoginInfo();
                      loginInfo.userMobile = _usermobile.text;
                      loginInfo.password = _userpassword.text;
                      OperationResponse operationResponse =
                          await UserManager.RegisterUserWithUserInfo(loginInfo);
                      if (operationResponse.code == 0) {
                        showToast("注册成功!请使用注册信息登录!${operationResponse.msg}");
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {}
                      } else {
                        showToast("注册失败!请重新注册:${operationResponse.msg}");
                      }
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
              ],
            ),
          ),
        ));
  }
}
