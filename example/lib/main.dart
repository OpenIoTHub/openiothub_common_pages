import 'package:flutter/material.dart';
import 'package:openiothub_common_pages/gateway/GatewayQrPage.dart';
import 'package:openiothub_common_pages/user/LoginPage.dart';
import 'package:openiothub_common_pages/user/RegisterPage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wechat_kit/wechat_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   // This is the theme of your application.
      //   //
      //   // TRY THIS: Try running your application with "flutter run". You'll see
      //   // the application has a blue toolbar. Then, without quitting the app,
      //   // try changing the seedColor in the colorScheme below to Colors.green
      //   // and then invoke "hot reload" (save your changes or press the "hot
      //   // reload" button in a Flutter-supported IDE, or press "r" if you used
      //   // the command line to start the app).
      //   //
      //   // Notice that the counter didn't reset back to zero; the application
      //   // state is not lost during the reload. To reset the state, use hot
      //   // restart instead.
      //   //
      //   // This works for code too, not just values: Most code changes can be
      //   // tested with just a hot reload.
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      // home: GatewayQrPage(key: UniqueKey(),),
      home: LoginPage(),
      // home: RegisterPage(),
    );
  }
}


/*
 * Copyright 2021 Nimrod Dayan nimroddayan.com
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 *
 */

// import 'package:flutter/material.dart';
// import 'dart:async';
//
// import 'package:flutter_nsd/flutter_nsd.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final flutterNsd = FlutterNsd();
//   final services = <NsdServiceInfo>[];
//   bool initialStart = true;
//   bool _scanning = false;
//
//   _MyAppState();
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Try one restart if initial start fails, which happens on hot-restart of
//     // the flutter app.
//     flutterNsd.stream.listen(
//           (NsdServiceInfo service) {
//         setState(() {
//           services.add(service);
//         });
//       },
//       onError: (e) async {
//         if (e is NsdError) {
//           if (e.errorCode == NsdErrorCode.startDiscoveryFailed &&
//               initialStart) {
//             await stopDiscovery();
//           } else if (e.errorCode == NsdErrorCode.discoveryStopped &&
//               initialStart) {
//             initialStart = false;
//             await startDiscovery();
//           }
//         }
//       },
//     );
//   }
//
//   Future<void> startDiscovery() async {
//     if (_scanning) return;
//
//     setState(() {
//       services.clear();
//       _scanning = true;
//     });
//     await flutterNsd.discoverServices('_http._tcp.');
//   }
//
//   Future<void> stopDiscovery() async {
//     if (!_scanning) return;
//
//     setState(() {
//       services.clear();
//       _scanning = false;
//     });
//     flutterNsd.stopDiscovery();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('NSD Example'),
//         ),
//         body: Column(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 ElevatedButton(
//                   child: const Text('Start'),
//                   onPressed: () async => startDiscovery(),
//                 ),
//                 ElevatedButton(
//                   child: const Text('Stop'),
//                   onPressed: () async => stopDiscovery(),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: _buildMainWidget(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMainWidget(BuildContext context) {
//     if (services.isEmpty && _scanning) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     } else if (services.isEmpty && !_scanning) {
//       return const SizedBox.shrink();
//     } else {
//       return ListView.builder(
//         itemBuilder: (context, index) => ListTile(
//           title: Text(services[index].name ?? 'Invalid service name'),
//         ),
//         itemCount: services.length,
//       );
//     }
//   }
// }