import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/userManager.pb.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';

class RegisterPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<RegisterPage> {
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
                    child: Text('注册'),
                    onPressed: () async {
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
                    TextButton(
                        child: Text(
                          '隐私政策',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PrivacyPolicyPage(
                                    key: UniqueKey(),
                                  )));
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
