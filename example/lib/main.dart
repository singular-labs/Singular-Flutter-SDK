import 'dart:async';

import 'package:example/custom_event.dart';
import 'package:example/identity.dart';
import 'package:example/revenue.dart';
import 'package:example/skan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:singular_flutter_sdk/singular.dart';
import 'package:singular_flutter_sdk/singular_config.dart';
import 'package:singular_flutter_sdk/singular_link_params.dart';

import 'package:example/deeplink.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Map<String, dynamic> deeplinkParams = {};

  MyHomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final Map<String, dynamic> deeplinkParams = {};

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    initPlatformState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    SingularConfig config =
         SingularConfig('API_KEY', 'API_SECRET');
    config.waitForTrackingAuthorizationWithTimeoutInterval = 60;
    config.skAdNetworkEnabled = true;
    config.clipboardAttribution = true;
    config.singularLinksHandler = (SingularLinkParams params) {
      print('Received deferred deeplink: ');
      deeplinkParams['deeplink'] = params.deeplink;
      deeplinkParams['passthrough'] = params.passthrough;
      deeplinkParams['isDeferred'] = params.isDeferred;
    };
    
    config.conversionValueUpdatedCallback = (int conversionValue) {
      print('Received conversionValueUpdatedCallback: ' +
          conversionValue.toString());
    };
    
    config.conversionValuesUpdatedCallback = (int conversionValue, int coarse, bool lock) {
      print('Received conversionValuesUpdatedCallback: ' +
          conversionValue.toString() + ' coarse: ' + coarse.toString() + ' lock: ' +  (lock ? 'true' : 'false'));
    };
    
    config.manualSkanConversionManagement = true;
    Singular.start(config);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            bottom: TabBar(indicatorSize: TabBarIndicatorSize.label, tabs: [
              Tab(text: "Custom Events", icon: Icon(Icons.create_rounded)),
              Tab(text: "Revenue", icon: Icon(Icons.monetization_on)),
              Tab(text: "Identity", icon: Icon(Icons.person)),
              Tab(text: "Deep Links", icon: Icon(Icons.insert_link)),
              Tab(text: "SKAN", icon: Icon(Icons.bar_chart))
            ]),
          ),
          body: TabBarView(children: <Widget>[
            CustomEvent(),
            Revenue(),
            Identity(),
            Deeplink(deeplinkParams),
            Skan()
          ]),
        ));
  }
}
