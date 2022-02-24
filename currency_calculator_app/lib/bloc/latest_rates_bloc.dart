import 'dart:async';

import '../models/latest_rates_response.dart';
import '../network/api_response.dart';
import '../repository/currency_calculator_repository.dart.dart';

class LatestRatesBloc {
  CurrencyCalculatorRepository? _currencyCalculatorRepository;
  StreamController? _latestRateListController;
  StreamSink get latestRateListSink => _latestRateListController!.sink;
  Stream get latestRateListStream => _latestRateListController!.stream;
  
  LatestRatesBloc(base,symbols) {
    _latestRateListController = StreamController<ApiResponse<LatestRatesResponse>>();
    _currencyCalculatorRepository = CurrencyCalculatorRepository();
    fetchLatestRateList(base, symbols);
  }

  fetchLatestRateList(base,symbols) async {
    latestRateListSink.add(ApiResponse.loading('Fetching Latest Rates'));
    try {
      LatestRatesResponse latestRates =
          await _currencyCalculatorRepository!.fetchLatestRates(base,symbols);
      latestRateListSink.add(ApiResponse.completed(latestRates));
    } catch (e) {
      latestRateListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _latestRateListController?.close();
  }
}
