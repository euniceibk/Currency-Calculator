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
    currencyListSink.add(ApiResponse.loading('Fetching Currencies'));
    try {
      List<Symbol> currencies =
          await _currencyCalculatorRepository!.fetchCurrenciesList();
      currencyListSink.add(ApiResponse.completed(currencies));
    } catch (e) {
      currencyListSink.add(ApiResponse.error(e.toString()));
      print(currencyListStream);
    }
  }

  dispose() {
    _currencyListController?.close();
  }
}
