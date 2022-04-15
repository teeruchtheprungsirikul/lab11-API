import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lab11_api/ExchangeRate.dart';
import 'package:lab11_api/MoneyBox.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ExchangeRate  _dataFromAPI;
  @override
  void initState() {
    super.initState();
    getExchangeRate();
  }

  Future<ExchangeRate> getExchangeRate() async {
    var url = "https://open.er-api.com/v6/latest/USD";
    var response = await http.get(Uri.parse(url));
    _dataFromAPI = exchangeRateFromJson(response.body);
    //String json = exchangeRateToJson(_dataFromAPI);
    return _dataFromAPI;
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('อัตราแลกเปลี่ยนสกุล'),
      ),
      body: FutureBuilder(
        future: getExchangeRate(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var result = snapshot.data;
            double money = 1;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  MoneyBox("USD", money, Colors.green, 156),
                  SizedBox(height: 5),
                  MoneyBox("THB", money * result.rates["THB"], Colors.red, 100),
                  SizedBox(height: 5),
                  MoneyBox("JPY", money * result.rates["JPY"], Colors.orange, 100),
                  SizedBox(height: 5),
                  MoneyBox("KPW", money * result.rates["JPY"], Colors.purple, 100),
                ],
              ),
            );
          }
          return LinearProgressIndicator();
        },
      ),
    );
  }
}
