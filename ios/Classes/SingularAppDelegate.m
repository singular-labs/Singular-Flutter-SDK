#import <Foundation/Foundation.h>
#import "SingularAppDelegate.h"
#import "SingularSDK.h"

@implementation SingularAppDelegate

+ (id)shared {
    static SingularAppDelegate *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init {
    if (self = [super init]) {
        self.launchOptions = nil;
        self.userActivity = nil;
        self.openURL = nil;
  }
  return self;
}

- (void)continueUserActivity: (NSUserActivity*_Nullable) userActivity restorationHandler: (void (^_Nullable)(NSArray * _Nullable))restorationHandler;
{
    [SingularAppDelegate shared].userActivity = userActivity;
    [SingularSDK initializeSingular];
}

- (void)handleOpenUrl:(NSURL*_Nullable)url options:(NSDictionary*_Nullable) options {
    [SingularAppDelegate shared].openURL = url;
    [SingularSDK initializeSingular];
}
@end
