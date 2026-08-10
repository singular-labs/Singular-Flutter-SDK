
# singular_flutter_sdk

A Flutter plugin for Singular SDK.

---

### Table of content

- [Basic Integration](#basic-integration)
- [Tracking Events](#tracking-events)
- [Tracking Revenues](#tracking-revenues)
- [Implementing Deeplinks](#implementing-deeplinks)
- [Adding SKAdNetwork Support](#skadnetwork-support)
- [Tracking Uninstalls](#tracking-uninstalls)

---

### Supported Platforms

- Android
- iOS

---

### This plugin is built for

- iOS SingularSDK **v12.13.0**

- Android SingularSDK **v12.16.0**

---

## <a id="basic-integration"> Basic Integration 

You can add Singular Plugin to your Flutter app by adding following to your `pubspec.yaml` file:

```yaml
dependencies:
  singular_flutter_sdk: ^1.9.0
```

Then navigate to your project in the terminal and run:

```
flutter packages get
```

**iOS dependency managers**

The iOS plugin supports both CocoaPods and Swift Package Manager, so no extra
setup is required either way. CocoaPods supports iOS 12 and above; Swift Package
Manager requires iOS 13, the minimum Flutter itself declares for that path.


Before you initialize the Singular SDK, you have to create a SingularConfig object. The object contains your API key and API secret for the Singular SDK. Optionally, you can add settings to enable various SDK features.

*Example:*
```dart
import 'package:singular_flutter_sdk/singular.dart';
import 'package:singular_flutter_sdk/singular_config.dart';

SingularConfig config = new SingularConfig('API_KEY', 'API_SECRET');
config.customUserId = "test@test.com";
Singular.start(config);
```

## <a id="tracking-events"> Tracking Events

You can send events to Singular using the event and eventWithArgs methods.

*Example:*
```dart
Singular.event(eventName);

Singular.eventWithArgs(eventName, {"level-up":"5"});
```

## <a id="tracking-revenues">  Tracking Revenues

Report a custom event to Singular

*Example:*
```dart
Singular.customRevenue("MyCustomRevenue", "USD", 5.50);
```

Report an IAP event to Singular

*Example:*
```dart
import 'package:singular_flutter_sdk/singular_iap.dart';

 singularPurchase = new SingularIOSIAP(
   product.price,
   product.currencyCode,
   purchase.productId,
   purchase.purchaseId,
   purchase.verificationData.serverVerificationData
 );

 singularPurchase = new SingularAndroidIAP(
   product.price,
   product.currencyCode,
   purchase.singature,
   purchase.verificationData.serverVerificationData
 );

Singular.inAppPurchase(eventName, singularPurchase);

```

## <a id="implementing-deeplinks">  Implementing Deeplinks


To enable Singular Links in iOS and in Android, see [Singular Links Prerequisites.](https://support.singular.net/hc/en-us/articles/360031371451-Singular-Links-Prerequisites)


**Handling Singular Links**

The Singular SDK provides a handler mechanism to read the details of the tracking link that led to the app being opened.

*Example:*
```dart
SingularConfig config = new SingularConfig('API_KEY', 'API_SECRET');
config.singularLinksHandler = (SingularLinkParams params) {
    String deeplink = params.deeplink;
    String passthrough = params.passthrough;
    bool isDeferred = params.isDeferred;
    Map urlParameters = params.urlParameters;
    // Add your code here to handle the deep link
});
Singular.init(config);
```
**iOS Prerequisites**

If your app uses the `UIApplicationDelegate` lifecycle, add the following to your AppDelegate.
If your app uses the scene lifecycle (your `Info.plist` contains a `UIApplicationSceneManifest`), add the same calls to your SceneDelegate instead — see [SceneDelegate](#scene-delegate) below.

*Objective-C:*
  
In the project’s AppDelegate.m, add the following:

```objectivec
// Top of the AppDelegate.m
#import <singular_flutter_sdk/SingularAppDelegate.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  [GeneratedPluginRegistrant registerWithRegistry:self];

  [SingularAppDelegate shared].launchOptions = launchOptions;
  return [super application:application didFinishLaunchingWithOptions:launchOptions];

  }

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {

  [[SingularAppDelegate shared] continueUserActivity:userActivity restorationHandler:restorationHandler];
  return [super application:application continueUserActivity:userActivity restorationHandler:restorationHandler];

  }

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

    [[SingularAppDelegate shared] handleOpenUrl:url options:options];
    return [super application:app openURL:url options:options];

  }
```
  
*Swift:*
```swift  
import singular_flutter_sdk

override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let singularAppDelegate = SingularAppDelegate.shared() {
        singularAppDelegate.launchOptions = launchOptions
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}
    
override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let singularAppDelegate = SingularAppDelegate.shared() {
            singularAppDelegate.continueUserActivity(userActivity, restorationHandler:nil)
        }
        return super.application(application, continue:userActivity,
                                 restorationHandler: restorationHandler);
}
    
override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if let singularAppDelegate = SingularAppDelegate.shared() {
        singularAppDelegate.handleOpen(url, options: options)
    }
    return super.application(app, open: url, options: options)
}
    
```

**<a id="scene-delegate"> iOS Prerequisites — SceneDelegate**

Under the scene lifecycle the deep link callbacks move from the AppDelegate to the SceneDelegate, so the same Singular calls go there instead. Note that a link that launched the app arrives in `connectionOptions`, not in `launchOptions`.

*Swift:*

```swift
import singular_flutter_sdk

override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    if let userActivity = connectionOptions.userActivities.first {
        SingularAppDelegate.shared()?.userActivity = userActivity
    } else if let urlContext = connectionOptions.urlContexts.first {
        SingularAppDelegate.shared()?.openURL = urlContext.url
    }
    super.scene(scene, willConnectTo: session, options: connectionOptions)
}

override func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    SingularAppDelegate.shared()?.continueUserActivity(userActivity, restorationHandler: nil)
    super.scene(scene, continue: userActivity)
}

override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
        SingularAppDelegate.shared()?.handleOpen(url, options: nil)
    }
    super.scene(scene, openURLContexts: URLContexts)
}
```

*Objective-C:*

```objectivec
// Top of the SceneDelegate.m
#import "SingularAppDelegate.h"

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {

    NSUserActivity *userActivity = connectionOptions.userActivities.anyObject;
    UIOpenURLContext *urlContext = connectionOptions.URLContexts.anyObject;

    if (userActivity) {
        [SingularAppDelegate shared].userActivity = userActivity;
    } else if (urlContext) {
        [SingularAppDelegate shared].openURL = urlContext.URL;
    }
    [super scene:scene willConnectToSession:session options:connectionOptions];
}

- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity {

    [[SingularAppDelegate shared] continueUserActivity:userActivity restorationHandler:nil];
    [super scene:scene continueUserActivity:userActivity];
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {

    [[SingularAppDelegate shared] handleOpenUrl:URLContexts.anyObject.URL options:nil];
    [super scene:scene openURLContexts:URLContexts];
}
```

The snippets above assume your scene delegate subclasses `FlutterSceneDelegate`. If it implements `UIWindowSceneDelegate` directly, use the same bodies without the `override` / `super` calls.

**Android Prerequisites**

*Java:*  
  
In the project’s MainActivity.java, add the following:

```java

import com.singular.flutter_sdk.SingularBridge;

@Override
protected void onNewIntent(@NonNull Intent intent) {
  super.onNewIntent(intent);
  SingularBridge.onNewIntent(intent);
}
```
 
*Kotlin:*
  
```java

import com.singular.flutter_sdk.SingularBridge;

override fun onNewIntent(intent: Intent) {
  super.onNewIntent(intent)
  SingularBridge.onNewIntent(intent);
}
```


## <a id="skadnetwork-support">  Adding SKAdNetwork Support

Starting with version 1.0.15 of the Singular Flutter SDK, `skAdNetworkEnabled` is enabled by default.
To manually enable SKAdNetwork tracking for your app, turn on the skAdNetworkEnabled configuration option before initializing Singular:

*Example:*
```dart
SingularConfig config = new SingularConfig('API_KEY', 'API_SECRET');
config.skAdNetworkEnabled = true;
config.manualSkanConversionManagement = true; // Enable manual conversion value updates
config.conversionValueUpdatedCallback = (int conversionValue) {
     print('Received conversionValueUpdatedCallback: ' + conversionValue.toString());
};
Singular.init(config);
```

**Retrieving the Conversion Value**

```dart
Singular.skanGetConversionValue().then((conversionValue) {
     print('conversion value: ' + conversionValue.toString());
});
```

## <a id="tracking-uninstalls"> Tracking Uninstalls

Send Singular the APNS/FCM token in order to let it track app uninstalls.

*Example:*
```dart
//iOS
  Singular.registerDeviceTokenForUninstall(apnsToken);

//Android
  Singular.registerDeviceTokenForUninstall(fcmToken);
```

---

## Developing this plugin

Clone the repository into a directory named `singular_flutter_sdk`:

```
git clone git@github.com:singular-labs/Singular-Flutter-SDK.git singular_flutter_sdk
```

The directory name matters. Flutter passes the plugin to Swift Package Manager
using the name of the directory it lives in, and Swift Package Manager requires
that name to match the pub package name. Cloning into the repository's default
directory name (`Singular-Flutter-SDK`) makes `example/` fail to build with:

```
unable to override package 'singular_flutter_sdk' because its identity
'singular-flutter-sdk' doesn't match override's identity (directory name)
'singular_flutter_sdk'
```

This affects only this repository's own `example/` app. Apps that depend on the
published package are unaffected, since pub resolves it into a correctly named
directory.

When bumping the native iOS SDK, update the version in **both**
`ios/singular_flutter_sdk.podspec` and `ios/singular_flutter_sdk/Package.swift`.
