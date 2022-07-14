import 'dart:collection';

import 'package:courses/convienience/random_key.dart';
import 'package:courses/data/names.dart';

class Period {
  String id;
  late String name;
  late DateTime date;

  Period({this.id = '0'});

  Period.fromMap(this.id, Map<String, dynamic> map) {
    name = map.containsKey(FB.period.name) ? map[FB.period.name] : '';
    date = map.containsKey(FB.period.date)
        ? DateTime.fromMicrosecondsSinceEpoch(
            map[FB.period.date].microsecondsSinceEpoch)
        : DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FB.period.name: name,
      FB.period.date: date,
    };
  }
}

class Periods {
  List<Period> periods = [];

  Periods();

  Periods.fromMap(Map<String, dynamic> map) {
    map.forEach((key, value) {
      periods.add(Period.fromMap(key, value));
    });
    periods.sort((a, b) => a.date.compareTo(b.date));
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {};
    for (int i = 0; i < periods.length; i++) {
      if (periods[i].id == '0') {
        periods[i].id = RandomValues.getString(20);
      }
      result[periods[i].id] = periods[i].toMap();
    }
    return result;
  }
}
