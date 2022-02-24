// To parse this JSON data, do
//
//     final latestRatesResponse = latestRatesResponseFromJson(jsonString);

import 'dart:convert';

LatestRatesResponse latestRatesResponseFromJson(String str) => LatestRatesResponse.fromJson(json.decode(str));

String latestRatesResponseToJson(LatestRatesResponse data) => json.encode(data.toJson());

class LatestRatesResponse {
    LatestRatesResponse({
        required this.success,
        required this.timestamp,
        required this.base,
        required this.date,
        required this.rates,
    });

    final bool success;
    final int timestamp;
    final String base;
    final DateTime date;
    final List<Rate> rates;

    factory LatestRatesResponse.fromJson(Map<String, dynamic> json) => LatestRatesResponse(
        success: json["success"],
        timestamp: json["timestamp"],
        base: json["base"],
        date: DateTime.parse(json["date"]),
        rates: List<Rate>.from(json["rates"].map((x) => Rate.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "timestamp": timestamp,
        "base": base,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "rates": List<dynamic>.from(rates.map((x) => x.toJson())),
    };
}

class Rate {
    Rate({
        required this.symbol,
    });

    final String symbol;

    factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        symbol: json["Symbol"],
    );

    Map<String, dynamic> toJson() => {
        "Symbol": symbol,
    };
}
