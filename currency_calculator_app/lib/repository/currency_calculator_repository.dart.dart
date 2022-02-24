
import '../data/app_constants.dart';
import '../models/available_currencies.dart';
import '../models/latest_rates_response.dart';
import '../network/api_base-helper.dart';


class CurrencyCalculatorRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
 final String apiKey = AppConstants.apiAccessKey;

  Future<List<Symbol>> fetchCurrenciesList() async {
    final response = await _helper.get("http://data.fixer.io/api/symbols?access_key=$apiKey");
    return AvailableCurrencies.fromJson(response
    ).symbols;
  }
  
  Future<LatestRatesResponse> fetchLatestRates(base,symbols) async {
    // var body = <String, dynamic>{
    //   'base': base,
    //   'symbols': symbols
    // };
    final response = await _helper.get("http://data.fixer.io/api/latest?access_key=$apiKey&base=$base%symbols=$symbols");
    return  LatestRatesResponse.fromJson(response);
  }
}

