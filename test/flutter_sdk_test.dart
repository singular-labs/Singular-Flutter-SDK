import 'package:flutter/services.dart';
import 'package:singular_flutter_sdk/singular.dart';
import 'package:singular_flutter_sdk/singular_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('singular-api');

  TestWidgetsFlutterBinding.ensureInitialized();

  late SingularConfig config;

  String selectedMethod = "";

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      String method = methodCall.method;
      switch (method) {
        case "start":
        case "setCustomUserId":
        case "unsetCustomUserId":
        case "setDeviceCustomUserId":
        case "event":
        case "eventWithArgs":
        case "revenue":
        case "revenueWithArgs":
        case "customRevenue":
        case "customRevenueWithAttributes":
        case "trackingOptIn":
        case "trackingUnder13":
        case "stopAllTracking":
        case "resumeAllTracking":
        case "isAllTrackingStopped":
        case "limitDataSharing":
        case "getLimitDataSharing":
        case "clearGlobalProperties":
        case "unsetGlobalProperty":
        case "setGlobalProperty":
        case "getGlobalProperties":
        case "setWrapperNameAndVersion":
        case "setFCMDeviceToken":
          selectedMethod = method;
          break;
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('check start call', () async {
    Singular.start(new SingularConfig("testKey", "testSecret"));
    expect(selectedMethod, 'start');
  });

  test('check event call', () async {
    Singular.event("eventName");
    expect(selectedMethod, 'event');
  });

  test('check eventWithArgs call', () async {
    Singular.eventWithArgs("eventWithArgs", {"key": "value"});
    expect(selectedMethod, 'eventWithArgs');
  });

  test('check setCustomUserId call', () async {
    Singular.setCustomUserId("customUserId");
    expect(selectedMethod, 'setCustomUserId');
  });

  test('check unsetCustomUserId call', () async {
    Singular.unsetCustomUserId();
    expect(selectedMethod, 'unsetCustomUserId');
  });

  test('check trackingOptIn call', () async {
    Singular.trackingOptIn();
    expect(selectedMethod, 'trackingOptIn');
  });

  test('check trackingUnder13 call', () async {
    Singular.trackingUnder13();
    expect(selectedMethod, 'trackingUnder13');
  });

  test('check stopAllTracking call', () async {
    Singular.stopAllTracking();
    expect(selectedMethod, 'stopAllTracking');
  });

  test('check resumeAllTracking call', () async {
    Singular.resumeAllTracking();
    expect(selectedMethod, 'resumeAllTracking');
  });

  test('check isAllTrackingStopped call', () async {
    Singular.isAllTrackingStopped();
    expect(selectedMethod, 'isAllTrackingStopped');
  });

  test('check limitDataSharing call', () async {
    Singular.limitDataSharing(true);
    expect(selectedMethod, 'limitDataSharing');
  });

  test('check getLimitDataSharing call', () async {
    await Singular.getLimitDataSharing();
    expect(selectedMethod, 'getLimitDataSharing');
  });

  test('check clearGlobalProperties call', () async {
    Singular.clearGlobalProperties();
    expect(selectedMethod, 'clearGlobalProperties');
  });

  test('check unsetGlobalProperty call', () async {
    Singular.unsetGlobalProperty("key");
    expect(selectedMethod, 'unsetGlobalProperty');
  });

  test('check setGlobalProperty call', () async {
    Singular.setGlobalProperty("key", "value", false).then((value) {});
    expect(selectedMethod, 'setGlobalProperty');
  });

  test('check getGlobalProperties call', () async {
    Singular.getGlobalProperties().then((value) {});
    expect(selectedMethod, 'getGlobalProperties');
  });

  test('check setFCMDeviceToken call', () async {
    Singular.setFCMDeviceToken("12345");
    expect(selectedMethod, 'setFCMDeviceToken');
  });
}
