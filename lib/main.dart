// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'homePage.dart';
import 'settingPage.dart';
import 'settings.dart';
import 'diaglog.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
String message;
String channelId = "1000";
String channelName = "QRForm";
String channelDescription = "The channel for QR Form notification";

void main (){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'QR Form Scanner',
      home: ChangeNotifierProvider(
        create: (context) => Settings(),
        child: HomeMainApp()
        )
    );
  }
}

class HomeMainApp extends StatefulWidget {

  @override
  _HomeMainAppState createState() => _HomeMainAppState();
}

class _HomeMainAppState extends State<HomeMainApp> {

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload){});
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload){});
  }

      @override
    void didChangeDependencies() {
super.didChangeDependencies();
    // setState(() {
    //    Provider.of<Settings>(context, listen: false).loadSettings();
    // });

}


  int _selectedIndex = 0;
  List<Widget> _pageWidget = <Widget>[
    HomePage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Form Scanner'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_outline),            
            onPressed: (){showAbout(context);},
            )
        ],
      ),
      body: _pageWidget.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings')),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}


sendNotification(var title, var message) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(channelId,
      channelName, channelDescription,
      importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(0, title,
      message, platformChannelSpecifics,
      payload: '');
}


showAbout(BuildContext context) async{
PackageInfo packageInfo = await PackageInfo.fromPlatform();

  showAlertDialog(context,"App Infomation","App : ${packageInfo.appName}\nVersion : ${packageInfo.version}");
}


