import 'dart:async';

import 'package:flutter/services.dart';
import 'package:singular_flutter_sdk/singular_ad_data.dart';
import 'package:singular_flutter_sdk/singular_config.dart';
import 'package:singular_flutter_sdk/singular_iap.dart';

const ADMON_REVENUE_EVENT_NAME = '__ADMON_USER_LEVEL_REVENUE__';
const _SDK_NAME = 'Flutter';
const _SDK_VERSION = '1.0.3';

class Singular {
  static const MethodChannel _channel = const MethodChannel('singular-api');

  static void start(SingularConfig config) {
    _setWrapperNameAndVersion(_SDK_NAME, _SDK_VERSION);
    _channel.invokeMethod('start', config.toMap);
  }

  static void event(String eventName) {
    _channel.invokeMethod('event', {'eventName': eventName});
  }

  static void eventWithArgs(String eventName, Map args) {
    _channel
        .invokeMethod('eventWithArgs', {'eventName': eventName, 'args': args});
  }

  static void setCustomUserId(String customUserId) {
    _channel.invokeMethod('setCustomUserId', {'customUserId': customUserId});
  }

  static void unsetCustomUserId() {
    _channel.invokeMethod('unsetCustomUserId');
  }

  static void setDeviceCustomUserId(String customUserId) {
    _channel
        .invokeMethod('setDeviceCustomUserId', {'customUserId': customUserId});
  }

  static void registerDeviceTokenForUninstall(String deviceToken) {
    _channel.invokeMethod(
        'registerDeviceTokenForUninstall', {'deviceToken': deviceToken});
  }

  static void setFCMDeviceToken(String fcmToken) {
    _channel.invokeMethod('setFCMDeviceToken', {'fcmToken': fcmToken});
  }

  static void setGCMDeviceToken(String gcmToken) {
    _channel.invokeMethod('setGCMDeviceToken', {'gcmToken': gcmToken});
  }

// REVENUE

  static void customRevenue(String eventName, String currency, double amount) {
    _channel.invokeMethod('customRevenue',
        {'eventName': eventName, 'currency': currency, 'amount': amount});
  }

  static void customRevenueWithAttributes(
      String eventName, String currency, double amount, Map attributes) {
    _channel.invokeMethod('customRevenueWithAttributes', {
      'eventName': eventName,
      'currency': currency,
      'amount': amount,
      'attributes': attributes
    });
  }

  static void customRevenueWithAllAttributes(
      String eventName,
      String currency,
      double amount,
      String productSKU,
      String productName,
      String productCategory,
      int productQuantity,
      double productPrice) {
    _channel.invokeMethod('customRevenueWithAllAttributes', {
      'eventName': eventName,
      'currency': currency,
      'amount': amount,
      'productSKU': productSKU,
      'productName': productName,
      'productCategory': productCategory,
      'productQuantity': productQuantity,
      'productPrice': productPrice
    });
  }

  static void _setWrapperNameAndVersion(String name, String version) {
    _channel.invokeMethod(
        'setWrapperNameAndVersion', {'name': name, 'version': version});
  }

  /* Global Properties */

  static Future<Map> getGlobalProperties() async {
    final Map globalProperties =
        await _channel.invokeMethod('getGlobalProperties');
    return globalProperties;
  }

  static Future<bool> setGlobalProperty(
      String key, String value, bool overrideExisting) async {
    final bool isGlobalPropertySet = await _channel.invokeMethod(
        'setGlobalProperty',
        {'key': key, 'value': value, 'overrideExisting': overrideExisting});
    return isGlobalPropertySet;
  }

  static void unsetGlobalProperty(String key) {
    _channel.invokeMethod('unsetGlobalProperty', {'key': key});
  }

  static void clearGlobalProperties() {
    _channel.invokeMethod('clearGlobalProperties');
  }

  /* GDPR helpers */

  static void trackingOptIn() {
    _channel.invokeMethod('trackingOptIn');
  }

  static void trackingUnder13() {
    _channel.invokeMethod('trackingUnder13');
  }

  static void stopAllTracking() {
    _channel.invokeMethod('stopAllTracking');
  }

  static void resumeAllTracking() {
    _channel.invokeMethod('resumeAllTracking');
  }

  static Future<bool> isAllTrackingStopped() async {
    final bool isTrackingStopped =
        await _channel.invokeMethod('isAllTrackingStopped');
    return isTrackingStopped;
  }

  static void limitDataSharing(bool shouldLimitDataSharing) {
    _channel.invokeMethod(
        'limitDataSharing', {'limitDataSharing': shouldLimitDataSharing});
  }

  static Future<bool> getLimitDataSharing() async {
    final bool isLimitDataSharing =
        await _channel.invokeMethod('getLimitDataSharing');
    return isLimitDataSharing;
  }

  /* SKAN Methods */

  static void skanRegisterAppForAdNetworkAttribution() {
    _channel.invokeMethod('skanRegisterAppForAdNetworkAttribution');
  }

  static Future<bool> skanUpdateConversionValue(int conversionValue) async {
    final bool isConversionValueUpdated = await _channel.invokeMethod(
        'skanUpdateConversionValue', {'conversionValue': conversionValue});
    return isConversionValueUpdated;
  }

  static Future<num> skanGetConversionValue() async {
    final num conversionValue =
        await _channel.invokeMethod('skanUpdateConversionValue');
    return conversionValue;
  }

  /* IAP Methods */
  static void inAppPurchase(String eventName, SingularIAP purchase) {
    _channel.invokeMethod(
        'eventWithArgs', {'eventName': eventName, 'args': purchase.toMap});
  }

  static void inAppPurchaseWithAttributes(
      String eventName, SingularIAP purchase, Map attributes) {
    _channel.invokeMethod('eventWithArgs', {
      'eventName': eventName,
      'args': {...purchase.toMap, ...attributes}
    });
  }

  static void adRevenue(SingularAdData? adData) {
    if (adData == null || !adData.hasRequiredParams()) {
      return;
    }
    _channel.invokeMethod('eventWithArgs',
        {'eventName': ADMON_REVENUE_EVENT_NAME, 'args': adData});
  }
}
