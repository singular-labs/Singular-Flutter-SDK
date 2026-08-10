import 'package:example/custom_event.dart';
import 'package:example/deeplink.dart';
import 'package:example/identity.dart';
import 'package:example/revenue.dart';
import 'package:example/skan.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:singular_flutter_sdk/singular.dart';
import 'package:singular_flutter_sdk/singular_config.dart';
import 'package:singular_flutter_sdk/singular_link_params.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must be registered before runApp. Observers are notified in registration
  // order and WidgetsApp registers its own when MaterialApp builds, so
  // anything added later never gets the first look. See _DeepLinkRouteConsumer.
  WidgetsBinding.instance.addObserver(_DeepLinkRouteConsumer());
  await initializeFirebase();
  runApp(MyApp());
}

// Consumes the route information the engine pushes for a deep link.

class _DeepLinkRouteConsumer with WidgetsBindingObserver {
  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) async {
    print('didPushRouteInformation: ${routeInformation.uri}');
    return true;
  }
}

initializeFirebase() async {
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Map<String, dynamic> deeplinkParams = {};

  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final Map<String, dynamic> deeplinkParams = {};

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initPlatformState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
      case AppLifecycleState.hidden:
        break;
    }
  }

  handleFirebaseNotifications() async {
    // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
    if (Platform.isIOS) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        print('apnsToken token data: ${apnsToken}');
      }
    }

    String? token = await FirebaseMessaging.instance.getToken();
    print('fcm token data: ${token}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground message

      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print('Received message in foreground: ${message.notification?.title}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked! ${message.data.toString()}');
      // Handle notification click (when app is in background)
      Singular.handlePushNotification(message.data);
    });

    // Handle notifications when the app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        Singular.handlePushNotification(message.data);
        print('App opened from terminated state: ${message.data.toString()}');
        // Handle notification click
      }
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    handleFirebaseNotifications();

    const apiKey = String.fromEnvironment('SINGULAR_API_KEY', defaultValue: 'API_KEY');
    const secretKey = String.fromEnvironment('SINGULAR_SECRET_KEY', defaultValue: 'API_SECRET');

    SingularConfig config = SingularConfig(apiKey, secretKey);
    config.waitForTrackingAuthorizationWithTimeoutInterval = 60;
    config.skAdNetworkEnabled = true;
    config.clipboardAttribution = true;
    config.limitAdvertisingIdentifiers = true;
    config.singularLinksHandler = (SingularLinkParams params) {
      print('Received deferred deeplink: ');
      deeplinkParams['deeplink'] = params.deeplink;
      deeplinkParams['passthrough'] = params.passthrough;
      deeplinkParams['isDeferred'] = params.isDeferred;
      deeplinkParams['urlParameters'] = params.urlParameters;
    };

    if (Platform.isIOS) {
      config.logLevel = 5;
    } else {
      config.logLevel = 1;
    }
    config.enableLogging = true;
    config.pushNotificationsLinkPaths = [['sng_link']];

    config.withGlobalProperty("key1", "value1", true);
    config.withGlobalProperty("key2", "value2", true);

    config.conversionValueUpdatedCallback = (int conversionValue) {
      print('Received conversionValueUpdatedCallback: ' +
          conversionValue.toString());
    };

    config.conversionValuesUpdatedCallback = (int conversionValue, int coarse, bool lock) {
      print('Received conversionValuesUpdatedCallback: ' +
          conversionValue.toString() + ' coarse: ' + coarse.toString() + ' lock: ' +  (lock ? 'true' : 'false'));
    };

    config.manualSkanConversionManagement = true;
    config.espDomains = ['bit.ly'];
    config.facebookAppId = "FACEBOOK_APP_ID";
    config.deviceAttributionCallback = (Map<String, dynamic> deviceAttributionInfo) {
      print('Received device attribution information: ' + deviceAttributionInfo.toString());
    };

    config.customSdid = "custom-sdid-set-by-developer-123-abc";
    config.didSetSdidCallback = (String sdid) {
      print("did set sdid = " + sdid);
    };

    config.sdidReceivedCallback = (String sdid) {
      print("received sdid = " + sdid);
    };

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
