
#pragma mark - events

#define START @"start"
#define EVENT @"event"
#define EVENT_WITH_ARGS @"eventWithArgs"

#pragma mark - custom user id

#define SET_CUSTOM_USER_ID @"setCustomUserId"
#define UNSET_CUSTOM_USER_ID @"unsetCustomUserId"
#define SET_DEVICE_CUSTOM_USER_ID @"setDeviceCustomUserId"

#pragma mark - device token

#define REGISTER_DEVICE_TOKEN_FOR_UNINSTALL @"registerDeviceTokenForUninstall"

#pragma mark - custom revenue

#define CUSTOM_REVENUE @"customRevenue"
#define CUSTOM_REVENUE_WITH_ATTRIBUTES @"customRevenueWithAttributes"
#define CUSTOM_REVENUE_WITH_ALL_ATTRIBUTES @"customRevenueWithAllAttributes"

#pragma mark - sdk version

#define SET_WRAPPER_NAME_AND_VERSION @"setWrapperNameAndVersion"

#pragma mark - global Properties

#define GET_GLOBAL_PROPERTIES @"getGlobalProperties"
#define SET_GLOBAL_PROPERTY @"setGlobalProperty"
#define UNSET_GLOBAL_PROPERTY @"unsetGlobalProperty"
#define CLEAR_GLOBAL_PROPERTIES @"clearGlobalProperties"

#pragma mark - tracking

#define TRACKING_OPT_IN @"trackingOptIn"
#define TRACKING_UNDER13 @"trackingUnder13"
#define STOP_ALL_TRACKING @"stopAllTracking"
#define RESUME_ALL_TRACKING @"resumeAllTracking"
#define IS_ALL_TRACKING_STOPPED @"isAllTrackingStopped"

#pragma mark - data sharing

#define LIMIT_DATA_SHARING @"limitDataSharing"
#define GET_LIMIT_DATA_SHARING @"getLimitDataSharing"

#pragma mark - SKAN

#define SKAN_REGISTER_APP_FOR_AD_ATTRIBUTION @"skanRegisterAppForAdNetworkAttribution"
#define SKAN_UPDATE_CONVERSION_VALUE @"skanUpdateConversionValue"
#define SKAN_UPDATE_CONVERSION_VALUES @"skanUpdateConversionValues"
#define SKAN_GET_CONVERSION_VALUE @"skanGetConversionValue"

#pragma mark - referrer short link

#define CREATE_REFERRER_SHORT_LINK @"createReferrerShortLink"

#pragma mark - push Notifications

#define HANDLE_PUSH_NOTIFICATION @"handlePushNotification"
