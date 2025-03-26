import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/userManager.pb.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:openiothub_common_pages/openiothub_common_pages.dart';

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
          title: Text(OpenIoTHubCommonLocalizations.of(context).register),
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
                  leftLabel: OpenIoTHubCommonLocalizations.of(context).mobile_number,
                  hintText: OpenIoTHubCommonLocalizations.of(context).please_input_mobile,
                  onChanged: (String v) {},
                ),
                TDInput(
                  controller: _userpassword,
                  backgroundColor: Colors.white,
                  leftLabel: OpenIoTHubCommonLocalizations.of(context).password,
                  hintText: OpenIoTHubCommonLocalizations.of(context).please_input_password,
                  obscureText: true,
                  onChanged: (String v) {},
                ),
                TDButton(
                    icon: TDIcons.login,
                    text: OpenIoTHubCommonLocalizations.of(context).register,
                    size: TDButtonSize.large,
                    type: TDButtonType.outline,
                    shape: TDButtonShape.rectangle,
                    theme: TDButtonTheme.primary,
                    onTap: () async {
                      if (!_isChecked) {
                        showToast("${OpenIoTHubCommonLocalizations.of(context).agree_to_the_user_agreement1}☑️${OpenIoTHubCommonLocalizations.of(context).agree_to_the_user_agreement2}");
                        return;
                      }
                      if (_usermobile.text.isEmpty ||
                          _userpassword.text.isEmpty) {
                        showToast(OpenIoTHubCommonLocalizations.of(context).username_and_password_cant_be_empty);
                        return;
                      }
                      LoginInfo loginInfo = LoginInfo();
                      loginInfo.userMobile = _usermobile.text;
                      loginInfo.password = _userpassword.text;
                      OperationResponse operationResponse =
                          await UserManager.RegisterUserWithUserInfo(loginInfo);
                      if (operationResponse.code == 0) {
                        showToast("${OpenIoTHubCommonLocalizations.of(context).register_success}${operationResponse.msg}");
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {}
                      } else {
                        showToast("${OpenIoTHubCommonLocalizations.of(context).register_failed}:${operationResponse.msg}");
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
                    Text(OpenIoTHubCommonLocalizations.of(context).agree),
                    TextButton(
                        child: Text(
                          OpenIoTHubCommonLocalizations.of(context).privacy_policy,
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () async {
                          goToURL(
                              context,
                              "https://docs.iothub.cloud/privacyPolicy/index.html",
                              OpenIoTHubCommonLocalizations.of(context).privacy_policy);
                        }),
                    TextButton(
                        child: Text(
                          OpenIoTHubCommonLocalizations.of(context).feedback_channels,
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
