import 'dart:convert';
import '../../models/api/initiate_chimoney.dart';
import 'request_helper/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../navigation/index.dart';

abstract class PayoutService {
  Future<bool> initiateChimoney({required String channelStr});
}

class PayoutServiceImpl extends PayoutService {
  final RequestHelpersImpl requestHelpersImpl;
  final NavigationServiceImpl navigationServiceImpl;
  PayoutServiceImpl(
      {required this.requestHelpersImpl, required this.navigationServiceImpl});
  @override
  Future<bool> initiateChimoney({required String channelStr}) async {
    try {
      String url = 'payouts/chimoney';
      http.Response? res = await requestHelpersImpl.post(url: url, body: {
        "description": "",
        "chimoneys": [
          {
            "valueInUSD": 1,
            "enabledToRedeem": ["airtime", "wallet"],
            "type": "airtime",
            "phone_number": "+2349022416076",
            "country": "Nigeria",
            "spendContext": "mobile"
          }
        ],
        "miniApp": true
      });
      // http.Response? res = await requestHelpersImpl.post(url: url, body: jsonDecode(channelStr));
      if (res?.statusCode == 200) {
        ScaffoldMessenger.of(
                navigationServiceImpl.navigationKey.currentContext!)
            .showSnackBar(
                const SnackBar(content: Text('Transaction successful')));
        // InitiateChimoneyRes initiateChimoneyRes =
        //     initiateChimoneyResFromMap(res!.body);
        return true;
      } else {
        ScaffoldMessenger.of(
                navigationServiceImpl.navigationKey.currentContext!)
            .showSnackBar(SnackBar(
                content: Text(jsonDecode(res!.body)['error'] ??
                    'Failed to make transaction')));
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(navigationServiceImpl.navigationKey.currentContext!)
          .showSnackBar(
              const SnackBar(content: Text('Failed to make transaction')));
      debugPrint(e.toString());
      return false;
    }
  }
}
