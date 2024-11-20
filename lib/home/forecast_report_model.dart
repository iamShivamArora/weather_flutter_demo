class ForecastReportModel {
  final String? cod;
  final List<ListClass>? list;

  ForecastReportModel({this.cod, this.list});

  ForecastReportModel.fromJson(Map<String, dynamic> json)
      : cod = json['cod'] as String?,
        list = (json['list'] as List?)
            ?.map((dynamic e) => ListClass.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'cod': cod, 'list': list?.map((e) => e.toJson()).toList()};
}

class ListClass {
  final Main? main;
  final String? dtTxt;

  ListClass({
    this.main,
    this.dtTxt,
  });

  ListClass.fromJson(Map<String, dynamic> json)
      : main = (json['main'] as Map<String, dynamic>?) != null
            ? Main.fromJson(json['main'] as Map<String, dynamic>)
            : null,
        dtTxt = json['dt_txt'] as String?;

  Map<String, dynamic> toJson() => {'main': main?.toJson(), 'dt_txt': dtTxt};
}

class Main {
  final dynamic tempMin;
  final dynamic tempMax;

  Main({
    this.tempMin,
    this.tempMax,
  });

  Main.fromJson(Map<String, dynamic> json)
      : tempMin = json['temp_min'],
        tempMax = json['temp_max'];

  Map<String, dynamic> toJson() => {'temp_min': tempMin, 'temp_max': tempMax};
}
