import 'package:currency_calculator_app/bloc/currencies_bloc.dart';
import 'package:currency_calculator_app/bloc/latest_rates_bloc.dart';
import 'package:currency_calculator_app/data/app_colors.dart';
import 'package:currency_calculator_app/data/app_strings.dart';
import 'package:currency_calculator_app/models/available_currencies.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency  Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _baseCurrencyTextEditingController =
      TextEditingController();
  TextEditingController _currencyTextEditingController =
      TextEditingController();
  final String _baseCurrency='PLN';
  final String _currency = 'PLN';
  bool isLoading = false;
  String time = DateFormat("HH:mm").format(DateTime.now().toUtc());
  late CurrencyBloc _currencyBloc;
  late LatestRatesBloc _latestRatesBloc;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: []);
    _currencyBloc.fetchCurrencyList();
    _baseCurrencyTextEditingController =
        TextEditingController(text: widget.key.toString());
    _currencyTextEditingController =
        TextEditingController(text: widget.key.toString());

    isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    _baseCurrencyTextEditingController.dispose();
    _currencyTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {/* Write listener code here */},
          child: const Icon(
            Icons.format_align_left_rounded,
            color: AppColors.green, // add custom icons also
          ),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  AppStrings.signUp,
                  style: TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      fontSize: 16),
                ),
              )),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 50, 20),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      child: RichText(
                        text: const TextSpan(
                            text: AppStrings.currencyCalculator,
                            style: TextStyle(
                                color: AppColors.blue,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                                height: 1.3),
                            children: <TextSpan>[
                              TextSpan(
                                text: '.',
                                style: TextStyle(
                                    color: AppColors.green,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900),
                              )
                            ]),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 30,
                ),
                FractionallySizedBox(
                  child: TextFormField(
                    cursorColor: AppColors.blue,
                    controller: _baseCurrencyTextEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      suffixText: _baseCurrency,
                      contentPadding: const EdgeInsets.all(15),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.blue,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 30,
                ),
                FractionallySizedBox(
                  child: TextFormField(
                    cursorColor: AppColors.blue,
                    controller: _currencyTextEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      suffixText: _currency,
                      contentPadding: const EdgeInsets.all(15),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.blue,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 20,
                ),
                FractionallySizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width / 3,
                        child: TextFormField(
                          cursorColor: AppColors.blue,
                          controller: _currencyTextEditingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: false,
                            suffixText: _currency,
                            contentPadding: const EdgeInsets.all(15),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.grey,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.grey,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                          ),
                          onTap: () async {
                            StreamBuilder(
                              stream: _currencyBloc.currencyListStream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return Container();

                                return DropdownButton(
                                  hint: const Text("Currency"),
                                  value: snapshot.data,
                                  items: _currencyBloc
                                      .fetchCurrencyList()
                                      .map((item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Row(children: <Widget>[
                                        Text(item),
                                      ]),
                                    );
                                  }).toList(),
                                  onChanged: _currencyBloc.fetchCurrencyList(),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        child: Icon(Icons.compare_arrows_rounded),
                      ),
                      SizedBox(
                        width: width / 3,
                        child: TextFormField(
                          cursorColor: AppColors.blue,
                          controller: _currencyTextEditingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: false,
                            suffixText: _currency,
                            contentPadding: const EdgeInsets.all(15),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.grey,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.grey,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 20,
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      primary: Colors.white,
                    ),
                    onPressed: () async {
                      // appBloc!.add(KycEvent(
                      //     userId: userData.id.toString(),
                      //     email: emailController.text,
                      //     birthday: birthdayController.text,
                      // ));
                    },
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            AppStrings.convert,
                            style: TextStyle(fontSize: 20.0, letterSpacing: 1),
                          ),
                  ),
                ),
                SizedBox(
                  height: height / 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => _showChart(context),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                AppStrings.exchangeRateText + " $time" + " UTC",
                            style: const TextStyle(
                                color: AppColors.blue,
                                decoration: TextDecoration.underline),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0, top: 0.0),
                              child: Icon(
                                Icons.info,
                                color: Colors.grey[300],
                                size: 28.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChart(BuildContext ctx) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        elevation: 5,
        context: ctx,
        builder: (ctx) => Container(
              decoration: const BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              child: Padding(
                padding: EdgeInsets.only(
                    top: 15,
                    left: 15,
                    right: 15,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 45),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      height: double.infinity,
                      child: LineChart(
                        LineChartData(
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(spots: [
                                const FlSpot(0, 1),
                                const FlSpot(1, 3),
                                const FlSpot(2, 10),
                                const FlSpot(3, 7),
                                const FlSpot(4, 12),
                                const FlSpot(5, 13),
                                const FlSpot(6, 17),
                                const FlSpot(7, 15),
                                const FlSpot(8, 20)
                              ])
                            ]),
                      ),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Center(
                          child: Text(
                            AppStrings.rateAlertText,
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline),
                            textAlign: TextAlign.center,
                          ),
                        ))
                  ],
                ),
              ),
            ));
  }
}
