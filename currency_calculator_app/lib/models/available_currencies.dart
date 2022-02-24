// To parse this JSON data, do
//
//     final availableCurrencies = availableCurrenciesFromJson(jsonString);

import 'dart:convert';

AvailableCurrencies availableCurrenciesFromJson(String str) => AvailableCurrencies.fromJson(json.decode(str));

String availableCurrenciesToJson(AvailableCurrencies data) => json.encode(data.toJson());

class AvailableCurrencies {
    AvailableCurrencies({
        required this.success,
        required this.symbols,
    });

    final bool success;
    final List<Symbol> symbols;

    factory AvailableCurrencies.fromJson(Map<String, dynamic> json) => AvailableCurrencies(
        success: json["success"],
        symbols: List<Symbol>.from(json["symbols"].map((x) => Symbol.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "symbols": List<dynamic>.from(symbols.map((x) => x.toJson())),
    };
}

class Symbol {
    Symbol({
        required this.symbol,
    });

    final String symbol;

    factory Symbol.fromJson(Map<String, dynamic> json) => Symbol(
        symbol: json["symbol"],
    );

    Map<String, dynamic> toJson() => {
        "symbol": symbol,
    };
}
