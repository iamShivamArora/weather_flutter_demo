import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_weather_demo/util/helper_class.dart';

class NetworkHelper with HelperClass {
  Future<Map<String, dynamic>> callApi(
      BuildContext ctx, http.Response response) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult[0] == ConnectivityResult.mobile ||
        connectivityResult[0] == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    printDataLogs(response.statusCode);

    printDataLogs(response.body);
    try {
      Map<String, dynamic> res = json.decode(response.body);

      if (response.statusCode == 401) {
        String error = res.isEmpty ? "error" : res['message'];
        throw new Exception(error);
      }
      if (res['cod'].toString() != "200") {
        String error = res['message'];
        toast(error);
        // throw new Exception(error);
      }
      return res;
    } catch (error) {
      Navigator.pop(ctx);
      // if (response.statusCode == 401) {
      //   pushToScreenAndClearStack(ctx, LoginScreen());
      // }
      printDataLogs(error);
      throw error;
    }
  }
}
