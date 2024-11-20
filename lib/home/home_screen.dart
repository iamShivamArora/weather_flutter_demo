import 'package:country_state_city/models/city.dart';
import 'package:country_state_city/utils/city_utils.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_demo/home/forecast_report_model.dart';
import 'package:open_weather_demo/home/home_view_model.dart';
import 'package:open_weather_demo/home/weather_report_model.dart';
import 'package:open_weather_demo/util/helper_class.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with HelperClass {
  @override
  Widget build(BuildContext context) {
    var homeViewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Weather Report",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<WeatherReportModel>(
          future: homeViewModel.getWeatherReport(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () async {
                              homeViewModel.searchController.clear();
                              homeViewModel.changeAddressList(null, true);
                              final cities = await getCountryCities(
                                  snapshot.data!.sys.country);

                              pickerDialog(
                                  context, cities, homeViewModel.controller);
                            },
                            child: TextField(
                              controller: homeViewModel.controller,
                              enabled: false,
                              textInputAction: TextInputAction.done,
                              decoration:
                                  InputDecoration(labelText: "Search City"),
                              style: TextStyle(fontSize: 14),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        dataWidget("Place ", snapshot.data!.name),
                        dataWidget("Current Weather ",
                            snapshot.data!.weather.first.main),
                        dataWidget("Min Temperature ",
                            snapshot.data!.main.tempMin.toString()),
                        dataWidget("Max Temperature ",
                            snapshot.data!.main.tempMax.toString()),
                        dataWidget("Humidity ",
                            snapshot.data!.main.humidity.toString()),
                        dataWidget("Visibility ",
                            snapshot.data!.visibility.toString()),
                        dataWidget("Wind Speed ",
                            snapshot.data!.wind.speed.toString()),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Forecast",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                        FutureBuilder<ForecastReportModel>(
                            future: homeViewModel.getForecastReport(context),
                            builder: (context, snapshotForeCast) {
                              if (snapshotForeCast.hasData) {
                                return Container(
                                  padding: EdgeInsets.only(bottom: 30),
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          snapshotForeCast.data!.list!.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(snapshotForeCast
                                                  .data!.list![index].dtTxt ??
                                              ""),
                                          subtitle: Text("Min Temp - " +
                                              snapshotForeCast.data!
                                                  .list![index].main!.tempMin
                                                  .toString() +
                                              "\n" +
                                              "Max Temp - " +
                                              snapshotForeCast.data!
                                                  .list![index].main!.tempMax
                                                  .toString()),
                                        );
                                      }),
                                );
                              } else if (snapshotForeCast.hasError) {
                                return Text(snapshotForeCast.error.toString());
                              }
                              return Center(child: CircularProgressIndicator());
                            }),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: snapshot.error
                          .toString()
                          .toLowerCase()
                          .contains("denied permissions")
                      ? Column(
                          children: [
                            FilledButton(
                                onPressed: () {
                                  homeViewModel.getWeatherReport(context);
                                  homeViewModel.notifyListeners();
                                },
                                child: Text("Retry")),
                            SizedBox(
                              height: 20,
                            ),
                            Text(snapshot.error.toString()),
                          ],
                        )
                      : Text(snapshot.error.toString()));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget dataWidget(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  pickerDialog(context, List<City> city, TextEditingController controller) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          var homeViewModelChange = context.watch<HomeViewModel>();
          return Dialog(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.all(10),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 25),
                  child: Text(
                    "Search Address",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: homeViewModelChange.searchController,
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (value) async {
                    if (homeViewModelChange.searchController.text.isEmpty) {
                      homeViewModelChange.changeAddressList(null, true);
                    } else {
                      List<City> list = [];
                      for (var item in city) {
                        if (item.name.toLowerCase().contains(homeViewModelChange
                            .searchController.text
                            .toString()
                            .toLowerCase())) {
                          list.add(item);
                        }
                      }
                      Future.delayed(Duration(milliseconds: 200), () async {
                        homeViewModelChange.changeAddressList(list, false);
                        // print('Result: ${predictions}');
                      });
                    }
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      hintText: "Search City",
                      hintStyle: TextStyle(color: Colors.black)),
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: homeViewModelChange.addressList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            popToBackScreen(context);
                            controller.text =
                                homeViewModelChange.addressList[index].name;
                            homeViewModelChange.changeLatLng(
                                homeViewModelChange.addressList[index].latitude
                                    .toString(),
                                homeViewModelChange.addressList[index].longitude
                                    .toString());

                            setState(() {});
                          },
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  homeViewModelChange.addressList[index].name,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Container(
                                color: Colors.lightBlue,
                                width: double.infinity,
                                height: 1,
                              )
                            ],
                          ),
                        );
                      }),
                )
              ]),
            ),
          );
        });
  }
}
