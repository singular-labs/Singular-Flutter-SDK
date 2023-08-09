#import <Singular/Singular.h>
#import <Singular/SingularConfig.h>
#import <Singular/SingularLinkParams.h>
#import "SingularAppDelegate.h"
#import "SingularConstants.h"
#import "SingularSDK.h"

@implementation SingularSDK

static NSURL *tempOpenUrl;
static FlutterMethodChannel *channel;
static NSDictionary *configDict;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    channel = [FlutterMethodChannel methodChannelWithName:@"singular-api" binaryMessenger:[registrar messenger]];

    SingularSDK *instance = [[SingularSDK alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([START isEqualToString:call.method]) {
        [self start:call withResult:result];
    } else if ([EVENT isEqualToString:call.method]) {
        [self event:call withResult:result];
    } else if ([EVENT_WITH_ARGS isEqualToString:call.method]) {
        [self eventWithArgs:call withResult:result];
    } else if ([SET_CUSTOM_USER_ID isEqualToString:call.method]) {
        [self setCustomUserId:call withResult:result];
    } else if ([UNSET_CUSTOM_USER_ID isEqualToString:call.method]) {
        [Singular unsetCustomUserId];
    } else if ([SET_DEVICE_CUSTOM_USER_ID isEqualToString:call.method]) {
        [self setDeviceCustomUserId:call withResult:result];
    } else if ([REGISTER_DEVICE_TOKEN_FOR_UNINSTALL isEqualToString:call.method]) {
        [self registerDeviceTokenForUninstall:call withResult:result];
    } else if ([CUSTOM_REVENUE isEqualToString:call.method]) {
        [self customRevenue:call withResult:result];
    } else if ([CUSTOM_REVENUE_WITH_ATTRIBUTES isEqualToString:call.method]) {
        [self customRevenueWithAttributes:call withResult:result];
    } else if ([CUSTOM_REVENUE_WITH_ALL_ATTRIBUTES isEqualToString:call.method]) {
        [self customRevenueWithAllAttributes:call withResult:result];
    } else if ([SET_WRAPPER_NAME_AND_VERSION isEqualToString:call.method]) {
        [self setWrapperNameAndVersion:call withResult:result];
    } else if ([GET_GLOBAL_PROPERTIES isEqualToString:call.method]) {
        result([Singular getGlobalProperties]);
    } else if ([SET_GLOBAL_PROPERTY isEqualToString:call.method]) {
        [self setGlobalProperty:call withResult:result];
    } else if ([UNSET_GLOBAL_PROPERTY isEqualToString:call.method]) {
        [self unsetGlobalProperty:call withResult:result];
    } else if ([CLEAR_GLOBAL_PROPERTIES isEqualToString:call.method]) {
        [Singular clearGlobalProperties];
    } else if ([TRACKING_OPT_IN isEqualToString:call.method]) {
        [Singular trackingOptIn];
    } else if ([TRACKING_UNDER13 isEqualToString:call.method]) {
        [Singular trackingUnder13];
    } else if ([STOP_ALL_TRACKING isEqualToString:call.method]) {
        [Singular stopAllTracking];
    } else if ([RESUME_ALL_TRACKING isEqualToString:call.method]) {
        [Singular resumeAllTracking];
    } else if ([IS_ALL_TRACKING_STOPPED isEqualToString:call.method]) {
        result(@([Singular isAllTrackingStopped]));
    } else if ([LIMIT_DATA_SHARING isEqualToString:call.method]) {
        [self limitDataSharing:call withResult:result];
    } else if ([GET_LIMIT_DATA_SHARING isEqualToString:call.method]) {
        result(@([Singular getLimitDataSharing]));
    } else if ([SKAN_REGISTER_APP_FOR_AD_ATTRIBUTION isEqualToString:call.method]) {
        [Singular skanRegisterAppForAdNetworkAttribution];
    } else if ([SKAN_UPDATE_CONVERSION_VALUE isEqualToString:call.method]) {
        [self skanUpdateConversionValue:call withResult:result];
    } else if ([SKAN_UPDATE_CONVERSION_VALUES isEqualToString:call.method]) {
        [self skanUpdateConversionValues:call withResult:result];
    } else if ([SKAN_GET_CONVERSION_VALUE isEqualToString:call.method]) {
        [self skanGetConversionValue:call withResult:result];
    } else if ([CREATE_REFERRER_SHORT_LINK isEqualToString:call.method]) {
        [self createReferrerShortLink:call withResult:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

+ (void)initializeSingular {
    [SingularSDK initSDK];
}

+ (void)initSDK {
    if (configDict == nil) {
        return;
    }

    NSString *apiKey = configDict[@"apiKey"];
    NSString *secretKey = configDict[@"secretKey"];
    BOOL skAdNetworkEnabled = [configDict[@"skAdNetworkEnabled"] boolValue];
    BOOL clipboardAttribution = [configDict[@"clipboardAttribution"] boolValue];
    BOOL manualSkanConversionManagement = [configDict[@"manualSkanConversionManagement"] boolValue];
    int waitForTrackingAuthorizationWithTimeoutInterval = [configDict[@"waitForTrackingAuthorizationWithTimeoutInterval"] intValue];
    float shortLinkResolveTimeOut = [configDict[@"shortLinkResolveTimeOut"] floatValue];
    NSString *customUserId = configDict[@"customUserId"];

    SingularConfig *config = [[SingularConfig alloc] initWithApiKey:apiKey andSecret:secretKey];
    config.skAdNetworkEnabled = skAdNetworkEnabled;
    config.clipboardAttribution = clipboardAttribution;
    config.manualSkanConversionManagement = manualSkanConversionManagement;
    config.waitForTrackingAuthorizationWithTimeoutInterval = waitForTrackingAuthorizationWithTimeoutInterval;
    config.shortLinkResolveTimeOut = shortLinkResolveTimeOut;
    NSArray *props = configDict[@"globalProperties"];

    if (props != nil) {
        for (NSDictionary *prop in props) {
            NSString *key = [prop objectForKey:@"key"];
            NSString *value = [prop objectForKey:@"value"];
            BOOL overrideExisting = [[prop objectForKey:@"overrideExisting"]boolValue];
            [config setGlobalProperty:key withValue:value overrideExisting:overrideExisting];
        }
    }

    if (customUserId) {
        [Singular setCustomUserId:customUserId];
    }

    NSNumber *limitDataSharing = configDict[@"limitDataSharing"];

    if (![limitDataSharing isEqual:[NSNull null]]) {
        [Singular limitDataSharing:[limitDataSharing boolValue]];
    }

    NSNumber *sessionTimeout = configDict[@"sessionTimeout"];

    if (sessionTimeout >= 0) {
        [Singular setSessionTimeout:[sessionTimeout intValue]];
    }

    config.singularLinksHandler = ^(SingularLinkParams *params) {
        NSMutableDictionary *linkParams = [[NSMutableDictionary alloc] init];
        [linkParams setValue:[params getDeepLink] forKey:@"deeplink"];
        [linkParams setValue:[params getPassthrough] forKey:@"passthrough"];
        [linkParams setValue:@([params isDeferred]) forKey:@"isDeferred"];
        [linkParams setValue:([params getUrlParameters] ? [params getUrlParameters] : @{ }) forKey:@"urlParameters"];

        [channel invokeMethod:@"singularLinksHandlerName" arguments:linkParams];
    };

    if ([SingularAppDelegate shared].launchOptions != nil) {
        config.launchOptions = [SingularAppDelegate shared].launchOptions;
    } else if ([SingularAppDelegate shared].userActivity != nil) {
        config.userActivity = [SingularAppDelegate shared].userActivity;
    } else if ([SingularAppDelegate shared].openURL != nil) {
        config.openUrl = [SingularAppDelegate shared].openURL;
    } else {
        NSLog(@"everything is null");
    }

    config.conversionValueUpdatedCallback = ^(NSInteger conversionValue) {
        NSString *conversionValueUpdatedCallback = configDict[@"conversionValueUpdatedCallback"];

        if (conversionValueUpdatedCallback != nil) {
            [channel invokeMethod:@"conversionValueUpdatedCallbackName" arguments:@(conversionValue)];
        }
    };

    config.conversionValuesUpdatedCallback = ^(NSNumber *conversionValue, NSNumber *coarse, BOOL lock) {
        NSString *conversionValuesUpdatedCallback = configDict[@"conversionValuesUpdatedCallback"];

        if (conversionValuesUpdatedCallback != nil) {
            NSMutableDictionary *updatedConversionValues = [[NSMutableDictionary alloc] init];
            [updatedConversionValues setValue:(conversionValue != nil) ? @([conversionValue integerValue]) : @(-1) forKey:@"conversionValue"];
            [updatedConversionValues setValue:(coarse != nil) ? @([coarse integerValue]) : @(-1) forKey:@"coarse"];
            [updatedConversionValues setValue:@(lock) forKey:@"lock"];

            [channel invokeMethod:@"conversionValuesUpdatedCallbackName" arguments:updatedConversionValues];
        }
    };
    [Singular start:config];
}

- (void)start:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    configDict = call.arguments;
    [SingularSDK initSDK];
}

- (void)event:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *eventName =  call.arguments[@"eventName"];

    [Singular event:eventName];
}

- (void)eventWithArgs:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *eventName =  call.arguments[@"eventName"];
    NSDictionary *args = call.arguments[@"args"];

    [Singular event:eventName withArgs:args];
}

- (void)setCustomUserId:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *customUserId = call.arguments[@"customUserId"];

    [Singular setCustomUserId:customUserId];
}

- (void)setDeviceCustomUserId:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *customUserId = call.arguments[@"customUserId"];

    [Singular setDeviceCustomUserId:customUserId];
}

- (void)registerDeviceTokenForUninstall:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *deviceToken = call.arguments[@"deviceToken"];

    [Singular registerDeviceTokenForUninstall:[deviceToken dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)customRevenue:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *eventName =  call.arguments[@"eventName"];
    NSString *currency =  call.arguments[@"currency"];
    double amount = [call.arguments[@"amount"] doubleValue];

    [Singular customRevenue:eventName currency:currency amount:amount];
}

- (void)customRevenueWithAttributes:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *eventName =  call.arguments[@"eventName"];
    NSString *currency =  call.arguments[@"currency"];
    double amount = [call.arguments[@"amount"] doubleValue];
    NSDictionary *attributes = call.arguments[@"attributes"];

    [Singular customRevenue:eventName currency:currency amount:amount withAttributes:attributes];
}

- (void)customRevenueWithAllAttributes:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *eventName =  call.arguments[@"eventName"];
    NSString *currency =  call.arguments[@"currency"];
    double amount = [call.arguments[@"amount"] doubleValue];
    NSString *productSKU = call.arguments[@"productSKU"];
    NSString *productName = call.arguments[@"productName"];
    NSString *productCategory = call.arguments[@"productCategory"];
    int productQuantity = [call.arguments[@"productQuantity"] intValue];
    double productPrice = [call.arguments[@"productPrice"] doubleValue];

    [Singular customRevenue:eventName currency:currency amount:amount productSKU:productSKU productName:productName productCategory:productCategory productQuantity:productQuantity productPrice:productPrice];
}

- (void)createReferrerShortLink:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *baseLink =  call.arguments[@"baseLink"];
    NSString *referrerName =  call.arguments[@"referrerName"];
    NSString *referrerId =  call.arguments[@"referrerId"];
    NSDictionary *args = call.arguments[@"args"];

    [Singular createReferrerShortLink:baseLink
                         referrerName:referrerName
                           referrerId:referrerId
                    passthroughParams:args
                    completionHandler:^(NSString *data, NSError *error) {
        NSMutableDictionary *linkParams = [[NSMutableDictionary alloc] init];

        if (data != nil) {
            [linkParams setValue:data
                          forKey:@"data"];
        }

        if (error != nil) {
            [linkParams setValue:error.description
                          forKey:@"error"];
        }

        [channel invokeMethod:@"shortLinkCallbackName"
                    arguments:linkParams];
    }];
}

- (void)setWrapperNameAndVersion:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *wrapperName =  call.arguments[@"name"];
    NSString *version =  call.arguments[@"version"];

    [Singular setWrapperName:wrapperName andVersion:version];
}

- (void)setGlobalProperty:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *key =  call.arguments[@"key"];
    NSString *value =  call.arguments[@"value"];
    BOOL overrideExisting =  [call.arguments[@"overrideExisting"] boolValue];

    result(@([Singular setGlobalProperty:key andValue:value overrideExisting:overrideExisting]));
}

- (void)unsetGlobalProperty:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *key =  call.arguments[@"key"];

    [Singular unsetGlobalProperty:key];
}

- (void)limitDataSharing:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    BOOL shouldLimitDataSharing =  [call.arguments[@"limitDataSharing"] boolValue];

    [Singular limitDataSharing:shouldLimitDataSharing];
}

- (void)skanUpdateConversionValue:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *conversionValue =  call.arguments[@"conversionValue"];

    if ([self isFieldValid:conversionValue]) {
        result(@([Singular skanUpdateConversionValue:[conversionValue integerValue]]));
    }
}

- (void)skanUpdateConversionValues:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *conversionValue =  call.arguments[@"conversionValue"];
    NSString *coarse =  call.arguments[@"coarse"];
    BOOL lock =  [call.arguments[@"lock"] boolValue];

    [Singular skanUpdateConversionValue:[conversionValue integerValue] coarse:[coarse integerValue] lock:lock];
}

- (void)skanGetConversionValue:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    result([Singular skanGetConversionValue]);
}

- (BOOL)isFieldValid:(NSObject *)field {
    if (field == nil) {
        return NO;
    }

    // Check if its an instance of the singleton NSNull.
    if ([field isKindOfClass:[NSNull class]]) {
        return NO;
    }

    // If field can be converted to a string, check if it has any content.
    NSString *str = [NSString stringWithFormat:@"%@", field];

    if (str != nil) {
        if ([str length] == 0) {
            return NO;
        }
    }

    return YES;
}

@end
