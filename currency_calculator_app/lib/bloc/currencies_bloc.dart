import 'dart:async';

import 'package:currency_calculator_app/models/available_currencies.dart';

import '../network/api_response.dart';
import '../repository/currency_calculator_repository.dart.dart';

class CurrencyBloc {
  CurrencyCalculatorRepository? _currencyCalculatorRepository;
  StreamController? _currencyListController;
  StreamSink get currencyListSink => _currencyListController!.sink;
  Stream get currencyListStream => _currencyListController!.stream;
  
  CurrencyBloc() {
    _currencyListController = StreamController<ApiResponse<List<Symbol>>>();
    _currencyCalculatorRepository = CurrencyCalculatorRepository();
    fetchCurrencyList();
  }

  fetchCurrencyList() async {
    currencyListSink.add(ApiResponse<List<Symbol>>.loading('Fetching Currencies'));
    try {
      List<Symbol> currencies =
          await _currencyCalculatorRepository!.fetchCurrenciesList();
      currencyListSink.add(ApiResponse<List<Symbol>>.completed(currencies));
    } catch (e) {
      currencyListSink.add(ApiResponse<List<Symbol>>.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _currencyListController?.close();
  }
}
