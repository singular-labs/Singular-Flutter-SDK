#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "SingularSDK.h"
#import "SingularAppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    NSLog(@"didFinishLaunchingWithOptions");
    
    // Override point for customization after application launch.
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
        NSLog(@"requestTrackingAuthorizationWithCompletionHandler");
    }];
    [SingularAppDelegate shared].launchOptions = launchOptions;
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler{
    NSLog(@"continueUserActivity");
    [[SingularAppDelegate shared] continueUserActivity:userActivity restorationHandler:restorationHandler];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [[SingularAppDelegate shared] handleOpenUrl:url options:options];
    return YES;
}

@end
