import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpjs_pro_plugin/fpjs_pro_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel(FpjsProPlugin.channelName);
  const testApiKey = 'test_api_key';
  const testVisitorId = 'test_visitor_id';
  const requestId = 'test_request_id';
  const linkedId = 'test_linked_id';
  const confidence = 0.09;
  const extendedResultAsJson = {'visitorId': testVisitorId};
  final extendedResultAsJsonString = jsonEncode(extendedResultAsJson);
  const getVisitorDataResponse = {
    "requestId": "test_request_id",
    "visitorId": "test_visitor_id",
    "confidenceScore": {"score": 0.09}
  };

  TestWidgetsFlutterBinding.ensureInitialized();

  group('Should throw if called before initialization', () {
    test('getDeviceId', () async {
      expect(() => FpjsProPlugin.getDeviceId(), throwsException);
    });

    test('getFingerprint', () async {
      expect(() => FpjsProPlugin.getFingerprint(), throwsException);
    });
  });

  group('getDeviceId', () {
    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'getDeviceId') {
          return testVisitorId;
        }
        return null;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('should return visitor id when called without tags', () async {
      await FpjsProPlugin.initFpjs();
      final result = await FpjsProPlugin.getDeviceId();
      expect(result, testVisitorId);
    });

    test('should return visitor id when called with tags', () async {
      await FpjsProPlugin.initFpjs();
      final result = await FpjsProPlugin.getDeviceId(
          tags: {'sessionId': DateTime.now().millisecondsSinceEpoch});
      expect(result, testVisitorId);
    });

    test('should return visitor id when called with linkedId', () async {
      await FpjsProPlugin.initFpjs();
      final result = await FpjsProPlugin.getDeviceId(linkedId: linkedId);
      expect(result, testVisitorId);
    });
  });

  group('getVisitorData', () {
    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'getVisitorData') {
          return [requestId, confidence, extendedResultAsJsonString];
        }
        return null;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });
  });
}
