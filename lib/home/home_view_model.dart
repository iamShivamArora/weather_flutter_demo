import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_state_city/models/city.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:open_weather_demo/home/weather_report_model.dart';
import 'package:open_weather_demo/util/constants.dart';
import 'package:open_weather_demo/util/helper_class.dart';

import '../network/network_helper.dart';
import 'forecast_report_model.dart';

class HomeViewModel extends ChangeNotifier with HelperClass {
  var controller = TextEditingController();
  var searchController = TextEditingController();

  var lat = "";
  var lng = "";

  changeLatLng(String latValue, String lngValue) {
    lat = latValue;
    lng = lngValue;
    notifyListeners();
  }

  List<City> addressList = [];

  changeAddressList(List<City>? list, bool isClear) {
    addressList.clear();
    if (!isClear) {
      printDataLogs("changechange");
      printDataLogs(list);
      addressList.addAll(list!);
    }

    notifyListeners();
  }

  Future<WeatherReportModel> getWeatherReport(ctx) async {
    try {
      Position locationData = await locationGet();

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (!(connectivityResult[0] == ConnectivityResult.mobile ||
          connectivityResult[0] == ConnectivityResult.wifi)) {
        throw new Exception('NO INTERNET CONNECTION');
      }
      var baseurl = dotenv.env['BaseUrl'];
      var apiKey = dotenv.env['AppId'];
      var url = lat.isEmpty
          ? "$baseurl${Constants.weather}?lat=${locationData.latitude.toString()}"
              "&lon=${locationData.longitude.toString()}&appid=$apiKey"
          : "$baseurl${Constants.weather}?lat=$lat"
              "&lon=$lng&appid=$apiKey";

      printDataLogs(url);

      var response = await http.get(Uri.parse(url));

      Map<String, dynamic> value = await NetworkHelper().callApi(ctx, response);

      var res = WeatherReportModel.fromJson(value);
      if (value['cod'] == 200) {
        printDataLogs('success');
      }
      return res;
    } catch (e) {
      printDataLogs(e);

      toast(notInternetMsg(e.toString().contains('Exception:')
          ? e.toString().replaceFirst(RegExp('Exception:'), '')
          : e.toString()));

      throw e;
    }
  }

  Future<ForecastReportModel> getForecastReport(ctx) async {
    try {
      Position locationData = await locationGet();

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (!(connectivityResult[0] == ConnectivityResult.mobile ||
          connectivityResult[0] == ConnectivityResult.wifi)) {
        throw new Exception('NO INTERNET CONNECTION');
      }

      var baseurl = dotenv.env['BaseUrl'];
      var apiKey = dotenv.env['AppId'];

      var url = lat.isEmpty
          ? "$baseurl${Constants.forecast}?lat=${locationData.latitude.toString()}"
              "&lon=${locationData.longitude.toString()}&appid=$apiKey"
          : "$baseurl${Constants.forecast}?lat=$lat"
              "&lon=$lng&appid=$apiKey";

      printDataLogs(url);

      var response = await http.get(Uri.parse(url));

      Map<String, dynamic> value = await NetworkHelper().callApi(ctx, response);

      var res = ForecastReportModel.fromJson(value);
      if (value['cod'].toString() == "200") {
        printDataLogs('success');
      }
      return res;
    } catch (e) {
      printDataLogs(e);

      toast(notInternetMsg(e.toString().contains('Exception:')
          ? e.toString().replaceFirst(RegExp('Exception:'), '')
          : e.toString()));

      throw e;
    }
  }

  Future<Position> locationGet() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } else if (permission == LocationPermission.denied) {
      printDataLogs("permission");
      printDataLogs(permission);
      await Geolocator.requestPermission();
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } else {
      await Geolocator.requestPermission();
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }
  }
}
